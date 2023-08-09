***********************************************************************
***                      © 3corações                                ***
***********************************************************************
*** DESCRIÇÃO: Lançamento de Conhecimento de Transporte               *
*** AUTOR : Luiz Carlos Timbó                                         *
*** FUNCIONAL: Leandro Oliveira                                       *
*** DATA : 21.07.2023                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA       | AUTOR              | DESCRIÇÃO                       *
***-------------------------------------------------------------------*
***            |                    |                                 *
***********************************************************************
REPORT zmm_lanca_conhecimento.

CLASS lcl_main DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      open_file CHANGING cv_file TYPE string.

    METHODS:
      start_process IMPORTING iv_file TYPE string.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_fileline,
             doc_date     TYPE char10,
             pstng_date   TYPE char10,
             comp_code    TYPE char4,
             gross_amount TYPE char28,
             header_txt   TYPE bktxt,
             item_text    TYPE sgtxt,
             j_1bnftype   TYPE char2,
             po_number    TYPE char10,
             po_item      TYPE numc5,
             item_amount  TYPE char28,
             quantity     TYPE char28,
             authcod      TYPE j_1bnfeauthcode,
             authdate     TYPE char10,
             authtime     TYPE char8,
             acckey       TYPE char44,
           END OF ty_fileline,
           ty_fileline_itab TYPE TABLE OF ty_fileline.
    TYPES: BEGIN OF ty_input,
             bldat        TYPE bldat,
             budat        TYPE budat,
             bukrs        TYPE bukrs,
             gross_amount TYPE bapi_rmwwr,
             xblnr        TYPE xblnr,
             bktxt        TYPE bktxt,
             sgtxt        TYPE sgtxt,
             j_1bnftype   TYPE j_1bnftype,
             ebeln        TYPE ebeln,
             ebelp        TYPE ebelp,
             item_amount  TYPE bapiwrbtr,
             quantity     TYPE menge_d,
             authcod      TYPE j_1bnfeauthcode,
             authdate     TYPE j_1bauthdate,
             authtime     TYPE j_1bauthtime,
             acckey       TYPE j_1b_nfe_access_key_dtel44,
           END OF ty_input.
    TYPES: BEGIN OF ty_result,
             numerador TYPE value_kk,
             ebeln     TYPE ebeln,
             ebelp     TYPE ebelp,
             refkey    TYPE j_1brefkey,
             bapiret   TYPE bapiret2_t,
           END OF ty_result.

    CONSTANTS gc_extension_xlsx TYPE string VALUE 'XLSX'.

    DATA gt_result TYPE TABLE OF ty_result.

    METHODS:
      read_file IMPORTING iv_file TYPE string
                EXPORTING et_itab TYPE ty_fileline_itab,
      convert_date IMPORTING iv_date        TYPE char10
                   RETURNING VALUE(rv_date) TYPE d,
      convert_value IMPORTING iv_value        TYPE char28
                    RETURNING VALUE(rv_value) TYPE hr_betrg,
      convert_hour IMPORTING iv_hour        TYPE char8
                   RETURNING VALUE(rv_hour) TYPE erzet,
      create_miro IMPORTING iv_numerador TYPE value_kk
                            is_data      TYPE ty_input,
      print_result.
ENDCLASS.

PARAMETERS p_file TYPE string OBLIGATORY.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  lcl_main=>open_file( CHANGING cv_file = p_file ).

START-OF-SELECTION.
  DATA(lr_main) = NEW lcl_main( ).
  lr_main->start_process( p_file ).

CLASS lcl_main IMPLEMENTATION.
  METHOD open_file.
    DATA: lt_file_table TYPE filetable,
          lv_rc         TYPE i.

    CALL METHOD cl_gui_frontend_services=>file_open_dialog
      EXPORTING
        default_extension       = gc_extension_xlsx
      CHANGING
        file_table              = lt_file_table
        rc                      = lv_rc
      EXCEPTIONS
        file_open_dialog_failed = 1
        cntl_error              = 2
        error_no_gui            = 3
        not_supported_by_gui    = 4
        OTHERS                  = 5.
    IF sy-subrc NE 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ELSE.
      TRY.
          cv_file = lt_file_table[ 1 ]-filename.
        CATCH cx_sy_itab_line_not_found.
      ENDTRY.
    ENDIF.
  ENDMETHOD.
  METHOD start_process.
    DATA: lt_input      TYPE TABLE OF ty_input,
          lt_lancamento TYPE TABLE OF ztmm_lanca_con.

    "Ler arquivo.
    read_file( EXPORTING iv_file = iv_file
               IMPORTING et_itab = DATA(lt_data) ).

    lt_input = VALUE #( FOR ls_data IN lt_data ( bldat = convert_date( ls_data-doc_date )
                                                 budat = convert_date( ls_data-pstng_date )
                                                 bukrs = ls_data-comp_code
                                                 gross_amount = convert_value( ls_data-gross_amount )
                                                 xblnr = ls_data-acckey+25(9) && '-' && ls_data-acckey+22(3)
                                                 bktxt = ls_data-header_txt
                                                 sgtxt = ls_data-item_text
                                                 j_1bnftype = ls_data-j_1bnftype
                                                 ebeln = ls_data-po_number
                                                 ebelp = ls_data-po_item
                                                 item_amount = convert_value( ls_data-item_amount )
                                                 quantity = convert_value( ls_data-quantity )
                                                 authcod  = ls_data-authcod
                                                 authdate = convert_date( ls_data-authdate )
                                                 authtime = convert_hour( ls_data-authtime )
                                                 acckey = ls_data-acckey ) ).

    lt_lancamento = VALUE #( FOR ls_input IN lt_input ( CORRESPONDING #( ls_input ) ) ).
    MODIFY ztmm_lanca_con FROM TABLE lt_lancamento[].
    COMMIT WORK AND WAIT.

    "Salvar dados.
    LOOP AT lt_input ASSIGNING FIELD-SYMBOL(<fs_input>).
      create_miro( iv_numerador = sy-tabix
                   is_data      = <fs_input> ).
    ENDLOOP.

    "Exibir processamento.
    print_result( ).

    MESSAGE 'Fim do processamento.' TYPE 'S'.
  ENDMETHOD.
  METHOD read_file.
    DATA lt_raw TYPE truxs_t_text_data.
    DATA(lv_filename) = CONV localfile( iv_file ).

    CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
      EXPORTING
*       I_FIELD_SEPERATOR    =
        i_line_header        = abap_true
        i_tab_raw_data       = lt_raw
        i_filename           = lv_filename
      TABLES
        i_tab_converted_data = et_itab
      EXCEPTIONS
        conversion_failed    = 1
        OTHERS               = 2.
    IF sy-subrc <> 0.
      CLEAR et_itab.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDMETHOD.
  METHOD convert_date.
    DATA(lv_data) = iv_date.
    TRANSLATE lv_data USING '. '.
    TRANSLATE lv_data USING '/ '.
    CONDENSE lv_data NO-GAPS.
    rv_date = lv_data+4(4) && lv_data+2(2) && lv_data(2).
  ENDMETHOD.
  METHOD convert_value.
    DATA(lv_value) = iv_value.
    TRANSLATE lv_value USING '. '.
    TRANSLATE lv_value USING ',.'.
    CONDENSE lv_value NO-GAPS.
    rv_value = lv_value.
  ENDMETHOD.
  METHOD convert_hour.
    DATA(lv_hour) = iv_hour.
    TRANSLATE lv_hour USING '. '.
    TRANSLATE lv_hour USING ': '.
    CONDENSE lv_hour NO-GAPS.
    rv_hour = lv_hour.
  ENDMETHOD.
  METHOD create_miro.
    DATA: ls_headerdata    TYPE bapi_incinv_create_header,
          lt_itemdata      TYPE tcm_bapi_incinv_create_item_t,
          lt_return        TYPE bapiret2_t,
          lv_invoicenumber TYPE bapi_incinv_fld-inv_doc_no,
          lv_fiscalyear    TYPE bapi_incinv_fld-fisc_year.

    APPEND VALUE #( numerador = iv_numerador ebeln = is_data-ebeln ebelp = is_data-ebelp ) TO gt_result ASSIGNING FIELD-SYMBOL(<fs_result>).

    SELECT SINGLE ekpo~ebeln, ekpo~ebelp, ekko~zterm, ekpo~mwskz, ekpo~txjcd
      FROM ekpo INNER JOIN ekko ON ekko~ebeln = ekpo~ebeln
      WHERE ekpo~ebeln EQ @is_data-ebeln
        AND ekpo~ebelp EQ @is_data-ebelp
      INTO @DATA(ls_ekpo).
    IF sy-subrc IS NOT INITIAL.
      APPEND VALUE #( type = 'E' message = 'Pedido não encontrado.' ) TO <fs_result>-bapiret.
      RETURN.
    ENDIF.

    ls_headerdata-invoice_ind  = abap_true.
    ls_headerdata-doc_type     = 'RE'.
    ls_headerdata-doc_date     = is_data-bldat.
    ls_headerdata-pstng_date   = is_data-budat.
    ls_headerdata-comp_code    = is_data-bukrs.
    ls_headerdata-currency     = 'BRL'.
    ls_headerdata-gross_amount = is_data-gross_amount.
    ls_headerdata-calc_tax_ind = abap_true.
    ls_headerdata-pmnttrms     = ls_ekpo-zterm.
    ls_headerdata-ref_doc_no   = is_data-xblnr.
    ls_headerdata-header_txt   = is_data-bktxt.
    ls_headerdata-item_text    = is_data-sgtxt.
    ls_headerdata-j_1bnftype   = is_data-j_1bnftype.

    APPEND VALUE #( invoice_doc_item = '000001'
                    po_number        = is_data-ebeln
                    po_item          = is_data-ebelp
                    tax_code         = ls_ekpo-mwskz
                    taxjurcode       = ls_ekpo-txjcd
                    item_amount      = is_data-item_amount
                    quantity         = is_data-quantity
                    po_unit          = 'UN' ) TO lt_itemdata.

    "Exporta a chave de acesso, para o correto processamento do ENHANCEMENT ZEIMM_TRATATIVA_CFOP_SERVICO
    EXPORT gko_acckey = is_data-acckey TO MEMORY ID zcltm_gko_process=>gc_memory_id-acckey.

    CALL FUNCTION 'BAPI_INCOMINGINVOICE_CREATE1'
      EXPORTING
        headerdata       = ls_headerdata
*       ADDRESSDATA      =
*       INVOICESTATUS    = '5'
      IMPORTING
        invoicedocnumber = lv_invoicenumber
        fiscalyear       = lv_fiscalyear
      TABLES
        itemdata         = lt_itemdata
        return           = lt_return.

    " Limpa memória
    FREE MEMORY ID zcltm_gko_process=>gc_memory_id-acckey.

    IF line_exists( lt_return[ type = 'E' ] ) OR line_exists( lt_return[ type = 'A' ] ).
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      APPEND LINES OF lt_return TO <fs_result>-bapiret.
    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.
      <fs_result>-refkey = CONV j_1brefkey( |{ lv_invoicenumber }{ lv_fiscalyear }| ).
      APPEND VALUE #( type = 'S' message = 'Documento gerado.' ) TO <fs_result>-bapiret.
    ENDIF.
  ENDMETHOD.
  METHOD print_result.
    TYPES: BEGIN OF ty_output,
             numerador TYPE value_kk,
             ebeln     TYPE ebeln,
             ebelp     TYPE ebelp,
             refkey    TYPE j_1brefkey.
             INCLUDE   TYPE bapiret2.
    TYPES: END OF ty_output.
    DATA lt_output TYPE TABLE OF ty_output.

    CHECK gt_result[] IS NOT INITIAL.

    LOOP AT gt_result ASSIGNING FIELD-SYMBOL(<fs_result>).
      LOOP AT <fs_result>-bapiret ASSIGNING FIELD-SYMBOL(<fs_message>).
        DATA(ls_output) = CORRESPONDING ty_output( <fs_message> ).
        ls_output-numerador = <fs_result>-numerador.
        ls_output-ebeln     = <fs_result>-ebeln.
        ls_output-ebelp     = <fs_result>-ebelp.
        ls_output-refkey    = <fs_result>-refkey.
        APPEND ls_output TO lt_output.
      ENDLOOP.
    ENDLOOP.
    TRY .
        cl_salv_table=>factory( IMPORTING r_salv_table = DATA(lr_table)
                                CHANGING t_table = lt_output ).
      CATCH: cx_salv_not_found cx_salv_msg.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        RETURN.
    ENDTRY.
    lr_table->get_functions( )->set_all( abap_true ).
    lr_table->get_columns( )->set_optimize( abap_true ).
    lr_table->display( ).
  ENDMETHOD.
ENDCLASS.
