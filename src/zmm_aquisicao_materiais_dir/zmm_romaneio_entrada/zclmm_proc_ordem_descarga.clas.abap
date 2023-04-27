class ZCLMM_PROC_ORDEM_DESCARGA definition
  public
  final
  create public .

public section.

  data GV_PDF_FILE type XSTRING .
  data GT_RETURN type BAPIRET2_T .
  data GT_OTF type TSFOTF .

    "! Responsável por imprimir o formulário
    "! @parameter it_key_rom        | Nº Documento NF
    "! @parameter is_parameters | Parâmetros
    "! @parameter et_return | Mensagens de retorno
  methods IMPRIME_PDF
    importing
      !IT_KEY_ROM type ZCTGMM_ROMANEIO_KEY
      !IS_PARAMETERS type ZC_SD_NF_IMP_MASSA_PRINTER
    exporting
      !ET_RETURN type BAPIRET2_T .
    "! Responsável por gerenciar o tipo de documento solicitado
    "! @parameter it_key_rom        | Nº Documento NF
    "! @parameter et_pdf            | Tabela de valores
    "! @parameter et_otf            | Tabela OTF
    "! @parameter ev_filename       | Nome do arquivo
    "! @parameter ev_filesize       | Tamanho do arquivo
    "! @parameter ev_file           | Binário do arquivo
    "! @parameter et_return         | Mensagens de retorno
  methods GERA_PDF
    importing
      !IT_KEY_ROM type ZCTGMM_ROMANEIO_KEY
    exporting
      !ET_PDF type TLINE_T
      !ET_OTF type TSFOTF
      !EV_FILENAME type STRING
      !EV_FILESIZE type INT4
      !EV_FILE type XSTRING
      !ET_RETURN type BAPIRET2_T .
    "! Recupera o formulário MDF-E do documento solicitado
    "! @parameter it_key_rom        | Chave para processamento
    "! @parameter iv_romaneio       | Romaneio
    "! @parameter et_lines | Tabela de valores
    "! @parameter et_otf | Tabela OTF
    "! @parameter ev_filesize | Tamanho do arquivo
    "! @parameter ev_file | Binário do arquivo
    "! @parameter et_return | Mensagens de retorno
  methods GERA_PDF_ROMANEIO
    importing
      !IT_KEY_ROM type ZCTGMM_ROMANEIO_KEY
      !IV_ROMANEIO type ZE_ROMANEIO
    exporting
      !ET_LINES type TLINE_T
      !ET_OTF type TSFOTF
      !EV_FILESIZE type INT4
      !EV_FILE type XSTRING
      !ET_RETURN type BAPIRET2_T .
    "! Adiciona mensagens
    "! @parameter io_context |Objeto com o conteudo
    "! @parameter it_return  |Tabela com as mensagens
    "! @parameter ro_message_container | Retorna objeto preecnhido
  methods ADD_MESSAGE_TO_CONTAINER
    importing
      !IO_CONTEXT type ref to /IWBEP/IF_MGW_CONTEXT
      !IT_RETURN type BAPIRET2_T optional
    returning
      value(RO_MESSAGE_CONTAINER) type ref to /IWBEP/IF_MESSAGE_CONTAINER .
  methods SET_FILTER_STR
    importing
      !IV_FILTER_STRING type STRING
    exporting
      !ET_FILTER_SELECT_OPTIONS type /IWBEP/T_MGW_SELECT_OPTION .
    "! Preenche mensagens
    "! @parameter rv_message |Retorna mensagens
  methods FILL_MESSAGE
    returning
      value(RV_MESSAGE) type BAPI_MSG .
  methods STATUS_ANDAMNT
    importing
      !IT_KEY_ROM type ZCTGMM_ROMANEIO_KEY .
  PROTECTED SECTION.
  PRIVATE SECTION.


ENDCLASS.



CLASS ZCLMM_PROC_ORDEM_DESCARGA IMPLEMENTATION.


  METHOD add_message_to_container.
    ro_message_container = io_context->get_message_container( ).

    IF it_return IS SUPPLIED AND it_return IS NOT INITIAL.

      LOOP AT it_return INTO DATA(ls_return).

        IF ls_return-id     IS NOT INITIAL AND
           ls_return-type   IS NOT INITIAL.

          MESSAGE ID ls_return-id
             TYPE ls_return-type
           NUMBER ls_return-number
            WITH ls_return-message_v1
                 ls_return-message_v2
                 ls_return-message_v3
                 ls_return-message_v4
            INTO DATA(lv_dummy).

          ro_message_container->add_message_text_only(
                  EXPORTING iv_msg_type               = ls_return-type
                            iv_msg_text               = CONV #( fill_message( ) )
                            iv_add_to_response_header = abap_false ).

        ELSE.
          ro_message_container->add_message_text_only(
                  EXPORTING iv_msg_type               = ls_return-type
                            iv_msg_text               =  ls_return-message
                            iv_add_to_response_header = abap_false ).
        ENDIF.

      ENDLOOP.

    ELSE.
      ro_message_container->add_message_text_only(
              EXPORTING iv_msg_type               = sy-msgty
                        iv_msg_text               = CONV #( fill_message( ) )
                        iv_add_to_response_header = abap_true ).
    ENDIF.

  ENDMETHOD.


  METHOD fill_message.

    MESSAGE ID sy-msgid
      TYPE sy-msgty
    NUMBER sy-msgno
      INTO rv_message
      WITH sy-msgv1
           sy-msgv2
           sy-msgv3
           sy-msgv4.
  ENDMETHOD.


  METHOD gera_pdf.

    DATA: lt_return  TYPE bapiret2_t,
          lv_docnum  TYPE j_1bdocnum,
          lv_doctype TYPE ze_doctype_pdf.

    FREE: et_pdf, ev_filename, ev_filesize, ev_file, et_return.

    " Nome do arquivo
    read table it_key_rom into data(ls_key_rom) index 1.

    DATA(lv_romaneio) = ls_key_rom-romaneio.

    ev_filename = |{ lv_romaneio }_{ sy-datum }{ sy-uzeit }.pdf|.

* ----------------------------------------------------------------------
* Recupera PDF do tipo solicitado
* ----------------------------------------------------------------------
    me->gera_pdf_romaneio( EXPORTING it_key_rom   = it_key_rom
                                     iv_romaneio  = lv_romaneio
                         IMPORTING et_lines    = et_pdf
                                   et_otf      = et_otf
                                   ev_filesize = ev_filesize
                                   ev_file     = ev_file
                                   et_return   = lt_return ).

    IF ev_file IS INITIAL.

      IF lt_return IS INITIAL.
        " Romaneio &1: Formulário não encontrado.
        et_return[] =  VALUE #( BASE et_return ( type       = gc_msg_error
                                                 id         = gc_msg_class
                                                 number     = gc_msg_form_no
                                                 message_v1 = lv_romaneio ) ).
      ELSE.
        APPEND LINES OF lt_return[] TO et_return[].
      ENDIF.

    ELSE.

      " Doc &1: Formulário &2 gerado.
      et_return[] =  VALUE #( BASE et_return ( type       = gc_msg_sucess
                                               id         = gc_msg_class
                                               number     = gc_msg_for_ger
                                               message_v1 = lv_romaneio ) ).

    ENDIF.

  ENDMETHOD.


  METHOD gera_pdf_romaneio.

    FREE: et_lines[],
          ev_filesize,
          ev_file,
          et_return.

      CALL FUNCTION 'ZFMMM_GET_ROMANEIO_PDF'
        EXPORTING
          it_key_rom           = it_key_rom
        IMPORTING
          ev_file              = ev_file
          ev_filesize          = ev_filesize
          et_lines             = et_lines
        TABLES
          et_otf               = et_otf
        EXCEPTIONS
          erro_get_form        = 1
          conversion_exception = 2
          OTHERS               = 3.
      IF sy-subrc <> 0.
        et_return[] =  VALUE #( BASE et_return ( type       = gc_msg_warnig
                                                 id         = gc_msg_class
                                                 number     = gc_msg_ger_for
                                                 message_v1 = iv_romaneio ) ).
      ENDIF.

  ENDMETHOD.


  METHOD imprime_pdf.
    CONSTANTS lc_locl TYPE string VALUE 'LOCL' ##NO_TEXT.
    CONSTANTS lc_lp01 TYPE string VALUE 'LP01' ##NO_TEXT.

    DATA: lt_return_form  TYPE bapiret2_t,
          lv_spoolid      TYPE rspoid,
          ls_printoptions TYPE itcpo,
          lt_otf          TYPE tsfotf.
    FREE: et_return.

    " Nome do arquivo
    read table it_key_rom into data(ls_key_rom) index 1.

    DATA(lv_romaneio) = ls_key_rom-romaneio.

* ----------------------------------------------------------------------
* Recupera impressora padrão do usuário
* ----------------------------------------------------------------------
    IF is_parameters-printer IS INITIAL.

      SELECT SINGLE spld
        FROM usr01
        INTO @DATA(lv_dest)
        WHERE bname = @sy-uname.

      IF sy-subrc NE 0 OR lv_dest IS INITIAL.
        lv_dest = lc_locl.
      ENDIF.

* ----------------------------------------------------------------------
* Verifica se impressora solicita existe
* ----------------------------------------------------------------------
    ELSE.

      SELECT SINGLE padest
        FROM tsp03
        INTO @lv_dest
        WHERE padest  = @is_parameters-printer.

      IF sy-subrc NE 0.

        " Impressora &1 não existe.
        et_return[] =  VALUE #( BASE et_return ( type       = gc_msg_error
                                                 id         = gc_msg_class
                                                 number     = gc_msg_imp_nex
                                                 message_v1 = is_parameters-printer ) ).
        RETURN.
      ENDIF.
    ENDIF.

    DO 4 TIMES.

* ----------------------------------------------------------------------
* Recupera formulário
* ----------------------------------------------------------------------
      me->gera_pdf( EXPORTING it_key_rom     = it_key_rom
                    IMPORTING et_otf         = lt_otf
                              ev_file        = DATA(lv_file)
                              et_return      = DATA(lt_return) ).

      IF lv_file IS INITIAL.
        INSERT LINES OF lt_return[] INTO TABLE lt_return_form[].
        CONTINUE.
      ENDIF.

* ----------------------------------------------------------------------
* Imprime formulário
* ----------------------------------------------------------------------

      IF lv_dest NE lc_lp01.

        ls_printoptions-tddest        = lv_dest.
        ls_printoptions-tdnewid       = abap_true.

        CALL FUNCTION 'PRINT_OTF'
          EXPORTING
            printoptions = ls_printoptions
          IMPORTING
            otf_printer  = lv_dest
            spoolid      = lv_spoolid
          TABLES
            otf          = lt_otf.


        IF lv_spoolid IS INITIAL.
          et_return[] =  VALUE #( BASE et_return ( type       = sy-msgty
                                                   id         = sy-msgid
                                                   number     = sy-msgno
                                                   message_v1 = sy-msgv1
                                                   message_v2 = sy-msgv2
                                                   message_v3 = sy-msgv3
                                                   message_v4 = sy-msgv4 ) ).
          CONTINUE.
        ENDIF.

      ELSE.


        CALL FUNCTION 'ADS_CREATE_PDF_SPOOLJOB'
          EXPORTING
            dest              = lv_dest
            pages             = 1
            pdf_data          = lv_file
            immediate_print   = abap_true
          IMPORTING
            spoolid           = lv_spoolid
          EXCEPTIONS
            no_data           = 1
            not_pdf           = 2
            wrong_devtype     = 3
            operation_failed  = 4
            cannot_write_file = 5
            device_missing    = 6
            no_such_device    = 7
            OTHERS            = 8.

        IF sy-subrc <> 0.
          et_return[] =  VALUE #( BASE et_return ( type       = sy-msgty
                                                   id         = sy-msgid
                                                   number     = sy-msgno
                                                   message_v1 = sy-msgv1
                                                   message_v2 = sy-msgv2
                                                   message_v3 = sy-msgv3
                                                   message_v4 = sy-msgv4 ) ).
          CONTINUE.
        ENDIF.
      ENDIF.


      " Doc &1: Form. &2 impresso no spool &3.
      et_return[] =  VALUE #( BASE et_return ( type       = gc_msg_sucess
                                               id         = gc_msg_class
                                               number     = gc_msg_imp_suc
                                               message_v1 = lv_romaneio
                                               message_v2 = lv_spoolid ) ).


    ENDDO.

    " Caso nenhum documento impresso, mostrar todos os erros
    IF et_return IS INITIAL.
      INSERT LINES OF lt_return_form[] INTO TABLE et_return[].
    ENDIF.

  ENDMETHOD.


  METHOD set_filter_str.

    DATA:
      lt_filter_string          TYPE TABLE OF string,
      lt_key_value              TYPE /iwbep/t_mgw_name_value_pair,
      lv_input                  TYPE string,
      lv_name                   TYPE string,
      lv_doctype                TYPE string,
      lv_value                  TYPE string,
      lv_value2                 TYPE string,
      lv_sign                   TYPE string,
      lv_sign2                  TYPE string,

      lt_filter_select_options  TYPE TABLE OF /iwbep/s_mgw_select_option,
      ls_filter_select_options  TYPE /iwbep/s_mgw_select_option,
      lt_select_options         TYPE /iwbep/t_cod_select_options,
      ls_select_options         TYPE /iwbep/s_cod_select_option,
      lt_filter_select_options2 TYPE /iwbep/t_mgw_select_option,
      ls_filter_select_options2 TYPE /iwbep/s_mgw_select_option.

    FIELD-SYMBOLS:
      <fs_range_tab>     LIKE LINE OF lt_filter_select_options,
      <fs_select_option> TYPE /iwbep/s_cod_select_option,
      <fs_key_value>     LIKE LINE OF lt_key_value.

*******************************************************************************
    IF iv_filter_string IS NOT INITIAL.
      lv_input = iv_filter_string.

* *--- get rid of )( & ' and make AND's uppercase
      REPLACE ALL OCCURRENCES OF ')' IN lv_input WITH ''.
      REPLACE ALL OCCURRENCES OF '(' IN lv_input WITH ''.
      REPLACE ALL OCCURRENCES OF `'` IN lv_input WITH ''.
      REPLACE ALL OCCURRENCES OF ' and ' IN lv_input WITH ' AND '.
      REPLACE ALL OCCURRENCES OF ' or ' IN lv_input WITH ' OR '.
      REPLACE ALL OCCURRENCES OF ' eq ' IN lv_input WITH ' EQ '.
      SPLIT lv_input AT 'AND' INTO TABLE lt_filter_string.

* *--- build a table of key value pairs based on filter string
      LOOP AT lt_filter_string ASSIGNING FIELD-SYMBOL(<fs_filter_string>).
        CLEAR: ls_select_options, ls_filter_select_options, lt_select_options.
        APPEND INITIAL LINE TO lt_key_value ASSIGNING <fs_key_value>.

        CONDENSE <fs_filter_string>.
*       Split at space, then split into 3 parts
        SPLIT <fs_filter_string> AT ' ' INTO lv_name lv_sign lv_value  .
        TRANSLATE lv_sign TO UPPER CASE.
        ls_select_options-sign = 'I'.
        ls_select_options-option = lv_sign.
        ls_select_options-low = lv_value.
        APPEND ls_select_options TO lt_select_options. CLEAR:ls_select_options.
        ls_filter_select_options-property = lv_name.
        ls_filter_select_options-select_options = lt_select_options.

        APPEND ls_filter_select_options TO lt_filter_select_options.
        CLEAR: ls_filter_select_options.
      ENDLOOP.
      CLEAR: ls_select_options, ls_filter_select_options, lt_select_options.
    ENDIF.

    et_filter_select_options = lt_filter_select_options.

  ENDMETHOD.


  METHOD status_andamnt.

    CHECK it_key_rom[] IS NOT INITIAL.

    READ TABLE it_key_rom ASSIGNING FIELD-SYMBOL(<fs_key_rom>) INDEX 1.
    IF sy-subrc IS INITIAL.

      CALL FUNCTION 'ZFMMM_ROMAN_STATUS_ANDMT'
        STARTING NEW TASK 'MM_ROMAN_STATUS'
        EXPORTING
          iv_romaneio = <fs_key_rom>-romaneio.

*      SELECT doc_uuid_h,
*             status_ordem
*        FROM ztmm_romaneio_in
*       WHERE sequence = @<fs_key_rom>-romaneio
*        INTO @DATA(ls_romaneio)
*       UP TO 1 ROWS.
*      ENDSELECT.
*
*      IF sy-subrc IS INITIAL.
*
*        IF ls_romaneio-status_ordem EQ '0'
*        OR ls_romaneio-status_ordem EQ '1'.
*          UPDATE ztmm_romaneio_in SET status_ordem = '2'
*                                WHERE doc_uuid_h = ls_romaneio-doc_uuid_h.
*        ENDIF.
*      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
