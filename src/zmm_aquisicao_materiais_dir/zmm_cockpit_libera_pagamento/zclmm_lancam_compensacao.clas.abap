class ZCLMM_LANCAM_COMPENSACAO definition
  public
  final
  create public .

public section.

  constants GC_TCODE type SY-TCODE value 'FB05' ##NO_TEXT.
  constants GC_SGFUNCT type RFIPI-SGFUNCT value 'C' ##NO_TEXT.

  class-methods CONV_AMOUNT
    importing
      !IV_AMOUNT type WRBTR
    returning
      value(RV_CONV_AMOUNT) type CHAR20 .
  class-methods CONV_DATE
    importing
      !IV_DATUM type DATUM
    returning
      value(RV_DATE) type CHAR10 .
  class-methods GET_MSG_TEXT
    importing
      !IS_MENSAGEM type BAPIRET2
    returning
      value(RV_MSG_TEXT) type BAPIRET2-MESSAGE .
  methods SET_HEADER_DATA
    importing
      !IS_HEADER type ZSMM_LANCAM_COMP_HEADER_DATA .
  methods SET_ITEM_DATA
    importing
      !IT_ITEM type ZCTGMM_LANCAM_COMP_ITEM_DATA .
  methods SET_DOCUMENTS
    importing
      !IT_DOCUMENTS type ZCTGMM_LANCAM_COMP_DOCUMENTS .
  methods CLEAR_DOCUMENTS
    exporting
      !EV_BELNR type BELNR_D
      !EV_GJAHR type GJAHR
      !EV_BUKRS type BUKRS
    returning
      value(RT_RETURN) type BAPIRET2_T .
  methods CONSTRUCTOR
    importing
      !IV_AUGVL type T041A-AUGLV .
  PROTECTED SECTION.
private section.

  data LS_HEADER type ZSMM_LANCAM_COMP_HEADER_DATA .
  data LT_ITEM type ZCTGMM_LANCAM_COMP_ITEM_DATA .
  data LT_DOCUMENTS type ZCTGMM_LANCAM_COMP_DOCUMENTS .
  data LT_FTPOST type FEB_T_FTPOST .
  data LT_FTCLEAR type FEB_T_FTCLEAR .
  data LV_AUGVL type T041A-AUGLV .
  constants GC_ID type MSGID value 'ZMM_COCKPIT_LIB' ##NO_TEXT.
  constants GC_SUCESS type MSGTY value 'S' ##NO_TEXT.

  methods SET_VALUE_FTPOST
    importing
      !IV_TYPE type STYPE_PI
      !IV_SCREEN type COUNT_PI
      !IV_FIELD type BDC_FNAM
      !IV_VALUE type ANY .
  methods MOUNT_HEADER .
  methods MOUNT_ITEM .
  methods MOUNT_CLEARING_DOCUMENTS .
ENDCLASS.



CLASS ZCLMM_LANCAM_COMPENSACAO IMPLEMENTATION.


  METHOD clear_documents.

    DATA: lt_fttax  TYPE re_t_ex_fttax,
          lt_blntab TYPE re_t_ex_blntab.

    DATA ls_mensagem TYPE bapiret2.
    DATA lv_mode(1)  TYPE c VALUE 'N'.


    CALL FUNCTION 'POSTING_INTERFACE_START'
      EXPORTING
        i_function         = 'C'
        i_mode             = lv_mode
        i_user             = sy-uname
      EXCEPTIONS
        client_incorrect   = 1
        function_invalid   = 2
        group_name_missing = 3
        mode_invalid       = 4
        update_invalid     = 5
        OTHERS             = 6.

    IF sy-subrc IS NOT INITIAL.
      "Erro ao iniciar compensação dos documentos
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO ls_mensagem-message.
      APPEND ls_mensagem TO rt_return.
      RETURN.
    ENDIF.

    mount_header( ).

    mount_item( ).

    mount_clearing_documents( ).

    CALL FUNCTION 'POSTING_INTERFACE_CLEARING'
      EXPORTING
        i_auglv                    = lv_augvl
        i_tcode                    = gc_tcode
        i_sgfunct                  = gc_sgfunct
        i_no_auth                  = abap_true
      IMPORTING
        e_msgid                    = ls_mensagem-id
        e_msgno                    = ls_mensagem-number
        e_msgty                    = ls_mensagem-type
        e_msgv1                    = ls_mensagem-message_v1
        e_msgv2                    = ls_mensagem-message_v2
        e_msgv3                    = ls_mensagem-message_v3
        e_msgv4                    = ls_mensagem-message_v4
      TABLES
        t_blntab                   = lt_blntab
        t_ftclear                  = lt_ftclear
        t_ftpost                   = lt_ftpost
        t_fttax                    = lt_fttax
      EXCEPTIONS
        clearing_procedure_invalid = 1
        clearing_procedure_missing = 2
        table_t041a_empty          = 3
        transaction_code_invalid   = 4
        amount_format_error        = 5
        too_many_line_items        = 6
        company_code_invalid       = 7
        screen_not_found           = 8
        no_authorization           = 9
        OTHERS                     = 10.

    IF sy-subrc  IS NOT INITIAL OR ls_mensagem-type = 'E' OR
       lt_blntab IS INITIAL.

      IF ls_mensagem IS INITIAL.
        ls_mensagem-id         = sy-msgid.
        ls_mensagem-number     = sy-msgno.
        ls_mensagem-type       = sy-msgty.
        ls_mensagem-message_v1 = sy-msgv1.
        ls_mensagem-message_v2 = sy-msgv2.
        ls_mensagem-message_v3 = sy-msgv3.
        ls_mensagem-message_v4 = sy-msgv4.
      ENDIF.

    ELSE.

      TRY.
          DATA(ls_blntab) = lt_blntab[ 1 ].
          ev_belnr               = ls_blntab-belnr.
          ev_gjahr               = ls_blntab-gjahr.
          ev_bukrs               = ls_blntab-bukrs.
          ls_mensagem-id         = gc_id.
          ls_mensagem-number     = 013.
          ls_mensagem-type       = gc_sucess.
          ls_mensagem-message_v1 = ls_blntab-belnr.
          ls_mensagem-message_v2 = ls_blntab-gjahr.
          ls_mensagem-message_v3 = ls_blntab-bukrs.

        CATCH cx_sy_itab_line_not_found.
      ENDTRY.

    ENDIF.

    IF ls_mensagem IS NOT INITIAL.

      ls_mensagem-message = get_msg_text( ls_mensagem ).
      APPEND ls_mensagem TO rt_return.

    ENDIF.

  ENDMETHOD.


  METHOD constructor.
    lv_augvl = iv_augvl.
  ENDMETHOD.


  METHOD conv_amount.
    WRITE iv_amount TO rv_conv_amount CURRENCY 'BRL'.
    CONDENSE rv_conv_amount NO-GAPS.
  ENDMETHOD.


  METHOD conv_date.
    WRITE iv_datum TO rv_date.
  ENDMETHOD.


  METHOD get_msg_text.
    MESSAGE ID     is_mensagem-id
            TYPE   is_mensagem-type
            NUMBER is_mensagem-number
            WITH   is_mensagem-message_v1
                   is_mensagem-message_v2
                   is_mensagem-message_v3
                   is_mensagem-message_v4
            INTO   rv_msg_text.
  ENDMETHOD.


  METHOD mount_clearing_documents.

    "Estruturas
    DATA ls_ftclear LIKE LINE OF lt_ftclear.

    "Field Symbols
    FIELD-SYMBOLS <fs_s_document> LIKE LINE OF lt_documents.


    LOOP AT lt_documents ASSIGNING <fs_s_document>.

      ls_ftclear-agkoa = <fs_s_document>-koart. "Account Type
      ls_ftclear-xnops = abap_true.             "Indicator: Select only open items which are not special G/L?
      ls_ftclear-selfd = 'BELNR'.               "Selection Field
      ls_ftclear-agums = <fs_s_document>-agums. "Códigos de razão especial que vai ser selecionado
      ls_ftclear-agbuk = <fs_s_document>-bukrs. "Company code
      ls_ftclear-agkon = <fs_s_document>-hkont. "Account
      CONCATENATE <fs_s_document>-belnr
                  <fs_s_document>-gjahr
                  <fs_s_document>-buzei
             INTO ls_ftclear-selvon.

      ls_ftclear-selbis = ls_ftclear-selvon.
      APPEND ls_ftclear TO lt_ftclear.

    ENDLOOP.

  ENDMETHOD.


  METHOD mount_header.

    DATA lv_value TYPE bdc_fval.


    FREE lv_value.
    lv_value = conv_date( ls_header-bldat ).

    "Data do documento
    set_value_ftpost( iv_type   = 'K'
                      iv_screen = 1
                      iv_field  = 'BKPF-BLDAT'
                      iv_value  = lv_value ).

    FREE lv_value.
    lv_value = conv_date( ls_header-budat ).

    "Data do lançamento
    set_value_ftpost( iv_type   = 'K'
                      iv_screen = 1
                      iv_field  = 'BKPF-BUDAT'
                      iv_value  = lv_value ).

    FREE lv_value.
    lv_value = ls_header-blart.

    "Tipo do Documento
    set_value_ftpost( iv_type   = 'K'
                      iv_screen = 1
                      iv_field  = 'BKPF-BLART'
                      iv_value  = lv_value ).

    FREE lv_value.
    lv_value = ls_header-bukrs.

    "Empresa
    set_value_ftpost( iv_type   = 'K'
                      iv_screen = 1
                      iv_field  = 'BKPF-BUKRS'
                      iv_value  = lv_value ).

    FREE lv_value.
    lv_value = ls_header-waers.

    "Moeda
    set_value_ftpost( iv_type   = 'K'
                      iv_screen = 1
                      iv_field  = 'BKPF-WAERS'
                      iv_value  = lv_value ).

    FREE lv_value.
    lv_value = ls_header-bktxt.

    "Texto do Documento
    set_value_ftpost( iv_type   = 'K'
                      iv_screen = 1
                      iv_field  = 'BKPF-BKTXT'
                      iv_value  = lv_value ).

    FREE lv_value.
    lv_value = ls_header-xblnr.

    "Texto do Documento
    set_value_ftpost( iv_type   = 'K'
                      iv_screen = 1
                      iv_field  = 'BKPF-XBLNR'
                      iv_value  = lv_value ).

    FREE lv_value.
    lv_value = ls_header-monat.

    "Texto do Documento
    set_value_ftpost( iv_type   = 'K'
                      iv_screen = 1
                      iv_field  = 'BKPF-MONAT'
                      iv_value  = lv_value ).

  ENDMETHOD.


  METHOD mount_item.

    DATA lv_tela  TYPE ftpost-count.
    DATA lv_value TYPE bdc_fval.

    FIELD-SYMBOLS <fs_s_item> LIKE LINE OF lt_item.


    SORT lt_item ASCENDING BY buzei.

    LOOP AT lt_item ASSIGNING <fs_s_item>.

      lv_tela = <fs_s_item>-buzei.

      IF <fs_s_item>-zfbdt IS NOT INITIAL.

        FREE lv_value.
        lv_value = conv_date( <fs_s_item>-zfbdt ).

        "Data de vencimento
        set_value_ftpost( iv_type   = 'P'
                          iv_screen = lv_tela
                          iv_field  = 'BSEG-ZFBDT'
                          iv_value  = lv_value ).

      ENDIF.

      FREE lv_value.
      lv_value = <fs_s_item>-bschl.

      "Chave de Lançamento
      set_value_ftpost( iv_type   = 'P'
                        iv_screen = lv_tela
                        iv_field  = 'RF05A-NEWBS'
                        iv_value  = lv_value ).

      FREE lv_value.
      lv_value = <fs_s_item>-bupla.

      "Local de negócios
      set_value_ftpost( iv_type   = 'P'
                        iv_screen = lv_tela
                        iv_field  = 'BSEG-BUPLA'
                        iv_value  = lv_value ).

      IF <fs_s_item>-zlsch IS NOT INITIAL.

        FREE lv_value.
        lv_value = <fs_s_item>-zlsch.

        "Forma de pagamento
        set_value_ftpost( iv_type   = 'P'
                          iv_screen = lv_tela
                          iv_field  = 'BSEG-ZLSCH'
                          iv_value  = lv_value ).

      ENDIF.

      IF <fs_s_item>-zterm IS NOT INITIAL.

        FREE lv_value.
        lv_value = <fs_s_item>-zterm.

        "Condição de Pagamento
        set_value_ftpost( iv_type   = 'P'
                          iv_screen = lv_tela
                          iv_field  = 'BSEG-ZTERM'
                          iv_value  = lv_value ).

      ENDIF.

      FREE lv_value.
      lv_value = <fs_s_item>-hkont.

      "Conta
      set_value_ftpost( iv_type   = 'P'
                          iv_screen = lv_tela
                          iv_field  = 'BSEG-HKONT'
                          iv_value  = lv_value ).

      FREE lv_value.
      lv_value = conv_amount( <fs_s_item>-wrbtr ).

      "Valor
      set_value_ftpost( iv_type   = 'P'
                        iv_screen = lv_tela
                        iv_field  = 'BSEG-WRBTR'
                        iv_value  = lv_value ).

      FREE lv_value.
      lv_value = <fs_s_item>-zuonr.

      "Campo Atribuição
      set_value_ftpost( iv_type   = 'P'
                        iv_screen = lv_tela
                        iv_field  = 'BSEG-ZUONR'
                        iv_value  = lv_value ).

      FREE lv_value.
      lv_value = <fs_s_item>-sgtxt.

      "Texto
      set_value_ftpost( iv_type   = 'P'
                        iv_screen = lv_tela
                        iv_field  = 'BSEG-SGTXT'
                        iv_value  = lv_value ).

      IF <fs_s_item>-xref2 IS NOT INITIAL.

        FREE lv_value.
        lv_value = <fs_s_item>-xref2.

        "Chave de referência 2
        set_value_ftpost( iv_type   = 'P'
                          iv_screen = lv_tela
                          iv_field  = 'BSEG-XREF2'
                          iv_value  = lv_value ).

      ENDIF.


      IF <fs_s_item>-gsber IS NOT INITIAL.

        FREE lv_value.
        lv_value = <fs_s_item>-gsber.

        "Centro de Lucro
        set_value_ftpost( iv_type   = 'P'
                          iv_screen = lv_tela
                          iv_field  = 'COBL-GSBER'
                          iv_value  = lv_value ).
      ENDIF.

      IF <fs_s_item>-prctr IS NOT INITIAL.

        FREE lv_value.
        lv_value = <fs_s_item>-prctr.

        "Centro de Lucro
        set_value_ftpost( iv_type   = 'P'
                          iv_screen = lv_tela
                          iv_field  = 'COBL-PRCTR'
                          iv_value  = lv_value ).
      ENDIF.

      IF <fs_s_item>-kostl IS NOT INITIAL.

        FREE lv_value.
        lv_value = <fs_s_item>-kostl.

        "Centro de Custo
        set_value_ftpost( iv_type   = 'P'
                          iv_screen = lv_tela
                          iv_field  = 'COBL-KOSTL'
                          iv_value  = lv_value ).
      ENDIF.

      IF <fs_s_item>-augtx IS NOT INITIAL.

        FREE lv_value.
        lv_value = <fs_s_item>-kostl.

        "Texto da compensação
        set_value_ftpost( iv_type   = 'P'
                          iv_screen = lv_tela
                          iv_field  = 'RF05A-AUGTX'
                          iv_value  = lv_value ).
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD set_documents.
    lt_documents = it_documents.
  ENDMETHOD.


  METHOD set_header_data.
    ls_header = is_header.
  ENDMETHOD.


  METHOD set_item_data.
    lt_item = it_item.
  ENDMETHOD.


  METHOD set_value_ftpost.

    FIELD-SYMBOLS <fs_s_ftpost> LIKE LINE OF lt_ftpost.

    APPEND INITIAL LINE TO lt_ftpost ASSIGNING <fs_s_ftpost>.

    <fs_s_ftpost>-stype = iv_type.
    <fs_s_ftpost>-count = iv_screen.
    <fs_s_ftpost>-fnam  = iv_field.

    TRY.
        <fs_s_ftpost>-fval  = iv_value.
      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
