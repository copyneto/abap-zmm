class ZCLMM_GESTAOTERCEIROS_REC definition
  public
  final
  create public .

public section.

  methods EXECUTE
    importing
      !IO_INPUT type ZCLMM_MT_REQUISICAO_COMPRA1 .
protected section.
private section.

  types:
    tt_item       TYPE TABLE OF bapimereqitemimp .
  types:
    tt_itemx      TYPE TABLE OF bapimereqitemx .
  types:
    tt_account    TYPE TABLE OF bapimereqaccount .
  types:
    tt_accountx   TYPE TABLE OF bapimereqaccountx .
  types:
    tt_headertext TYPE TABLE OF bapimereqheadtext .

  data GS_LISTA type ZCLMM_DT_REQUISICAO_COMPRA1 .
  constants GC_TYPE type BSART value 'NB' ##NO_TEXT.
  constants GC_TRACKINGNO type BEDNR value 'BAIXA COMP' ##NO_TEXT.
  constants GC_QUANTITY type BAMNG value 1 ##NO_TEXT.
  constants GC_TEXT_FORM type TDFORMAT value 'B1' ##NO_TEXT.
  constants GC_TYPE_E type BAPI_MTYPE value 'E' ##NO_TEXT.
  constants GC_TYPE_S type BAPI_MTYPE value 'S' ##NO_TEXT.

  methods PROCESSAR
    importing
      !IO_INPUT type ZCLMM_DT_REQUISICAO_COMPRA1 .
  methods HEADER
    exporting
      !ES_HEADER type BAPIMEREQHEADER
      !ES_HEADERX type BAPIMEREQHEADERX .
  methods ITEM
    exporting
      !ET_ITEM type TT_ITEM
      !ET_ITEMX type TT_ITEMX .
  methods ACCOUNT
    exporting
      !ET_ACCOUNT type TT_ACCOUNT
      !ET_ACCOUNTX type TT_ACCOUNTX .
  methods HEADERTEXT
    exporting
      !ET_TEXT type TT_HEADERTEXT .
  methods BAPI_CREATE
    importing
      !IS_HEADER type BAPIMEREQHEADER
      !IS_HEADERX type BAPIMEREQHEADERX
    changing
      !CT_ITEM type TT_ITEM
      !CT_ITEMX type TT_ITEMX
      !CT_ACCOUNT type TT_ACCOUNT
      !CT_ACCOUNTX type TT_ACCOUNTX
      !CT_TEXT type TT_HEADERTEXT .
  methods ENVIAR_RESPOSTA
    importing
      !IV_REQUISICAO type BANFN optional
      !IV_TIPO_MSG type BAPI_MTYPE
      !IV_TEXT_MSG type BAPI_MSG .
  methods LOG
    importing
      !IV_REQUISICAO type BANFN .
ENDCLASS.



CLASS ZCLMM_GESTAOTERCEIROS_REC IMPLEMENTATION.


  METHOD account.

    CONSTANTS: lc_serial TYPE c LENGTH 2 VALUE '01'.

    LOOP AT gs_lista-praccount ASSIGNING FIELD-SYMBOL(<fs_account>).

      et_account = VALUE #( BASE et_account (
         preq_item   = ( sy-tabix * 10 )
         serial_no   = lc_serial
         gl_account  = <fs_account>-gl_account
         costcenter  = <fs_account>-costcenter
         orderid     = <fs_account>-orderid
         wbs_element = <fs_account>-wbs_element
      ) ).

      et_accountx = VALUE #( BASE et_accountx (
         preq_item   = ( sy-tabix * 10 )
         serial_no   = lc_serial
         gl_account  = abap_true
         costcenter  = COND #( WHEN <fs_account>-costcenter IS NOT INITIAL THEN abap_true )
         orderid     = COND #( WHEN <fs_account>-orderid IS NOT INITIAL THEN abap_true )
         wbs_element = COND #( WHEN <fs_account>-wbs_element IS NOT INITIAL THEN abap_true )
      ) ).

    ENDLOOP.

  ENDMETHOD.


  METHOD bapi_create.

    DATA: lv_doc_ret TYPE banfn,
          lv_msg_s   TYPE bapi_msg,
          lt_return  TYPE STANDARD TABLE OF bapiret2.

    CALL FUNCTION 'BAPI_PR_CREATE'
      EXPORTING
        prheader      = is_header
        prheaderx     = is_headerx
      IMPORTING
        number        = lv_doc_ret
      TABLES
        return        = lt_return
        pritem        = ct_item
        pritemx       = ct_itemx
        praccount     = ct_account
        praccountx    = ct_accountx
        prheadertext  = ct_text
      EXCEPTIONS
        error_message = 1
        OTHERS        = 2.

    IF sy-subrc IS INITIAL.

      IF line_exists( lt_return[ type = gc_type_e ] ). "#EC CI_STDSEQ

        DELETE lt_return WHERE type <> gc_type_e. "#EC CI_STDSEQ

        DATA(lv_msg_e) = value #( lt_return[ 2 ]-message OPTIONAL ).

        me->enviar_resposta( EXPORTING iv_tipo_msg = gc_type_e iv_text_msg = lv_msg_e ).

      ELSE.

        lv_msg_s = TEXT-001. "Requisição criada com sucesso.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.

        me->enviar_resposta( EXPORTING iv_requisicao = lv_doc_ret iv_tipo_msg = gc_type_s iv_text_msg = lv_msg_s ).

        me->log( EXPORTING iv_requisicao = lv_doc_ret ).

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD enviar_resposta.

    DATA: lv_output TYPE zclmm_mt_retorno_requisicao_co.

    TRY.
        DATA(lo_ret) = NEW zclmm_co_si_enviar_requisicao( ).

        lv_output-mt_retorno_requisicao_compras = VALUE #(
              idsol    = gs_lista-idsol
              banfn    = iv_requisicao
              msgtyp   = iv_tipo_msg
              msgtx    = iv_text_msg
        ).

        lo_ret->si_enviar_requisicao_compras_o( output = lv_output ).

      CATCH cx_ai_system_fault.

    ENDTRY.

  ENDMETHOD.


  METHOD execute.

    me->processar(  EXPORTING io_input = io_input-mt_requisicao_compra ).

  ENDMETHOD.


  METHOD header.

    es_header-pr_type  = gc_type.
    es_headerx-pr_type = abap_true.

  ENDMETHOD.


  METHOD headertext.

    et_text = VALUE #( BASE et_text (
            text_form = gc_text_form
            text_line = gs_lista-text_line
        ) ).

  ENDMETHOD.


  METHOD item.

    CONSTANTS: lc_purch_org TYPE c LENGTH 4 VALUE 'OC01',
               lc_servico   TYPE c LENGTH 4 VALUE 'SERV'.

    DATA: lt_mara_aux TYPE TABLE OF mara,
          ls_mara     TYPE mara,

          lv_matnr    TYPE c LENGTH 18,
          lv_serv     TYPE abap_bool.

    LOOP AT gs_lista-pritem ASSIGNING FIELD-SYMBOL(<fs_item_aux>).

      lv_matnr = |{ <fs_item_aux>-material ALPHA = IN }|.
      ls_mara-matnr = lv_matnr.

      APPEND ls_mara TO lt_mara_aux.

    ENDLOOP.

    IF lt_mara_aux[] IS NOT INITIAL.

      SELECT matnr
        FROM mara
        INTO TABLE @DATA(lt_mara)
        FOR ALL ENTRIES IN @lt_mara_aux
        WHERE matnr EQ @lt_mara_aux-matnr
          AND mtart EQ @lc_servico.

      IF sy-subrc IS INITIAL.

        SORT lt_mara BY matnr.

      ENDIF.

    ENDIF.

    LOOP AT gs_lista-pritem ASSIGNING FIELD-SYMBOL(<fs_item>).

      IF line_exists( lt_mara[ matnr = <fs_item>-material ] ). "#EC CI_STDSEQ
        lv_serv = abap_true.
      ELSE.
        lv_serv = abap_false.
      ENDIF.

      et_item = VALUE #( BASE et_item (
          preq_item   = ( sy-tabix * 10 )
          preq_name   = <fs_item>-preq_name
          material    = <fs_item>-material
          plant       = <fs_item>-plant
          trackingno  = gc_trackingno
          quantity    = gc_quantity
          preq_date   = sy-datum
          deliv_date  = sy-datum
          preq_price  = <fs_item>-preq_price
          acctasscat  = <fs_item>-acctasscat
          purch_org   = lc_purch_org
          startdate   = COND dats( WHEN lv_serv = abap_true THEN <fs_item>-startdate ELSE abap_false )
          enddate     = COND dats( WHEN lv_serv = abap_true THEN <fs_item>-enddate   ELSE abap_false )
          gr_ind      = COND dats( WHEN lv_serv = abap_true THEN abap_false          ELSE abap_true )
         ) ).

      et_itemx = VALUE #( BASE et_itemx (
          preq_item   = ( sy-tabix * 10 )
          preq_name   = abap_true
          material    = abap_true
          plant       = abap_true
          trackingno  = abap_true
          quantity    = abap_true
          preq_date   = abap_true
          deliv_date  = abap_true
          preq_price  = abap_true
          acctasscat  = abap_true
          purch_org   = lc_purch_org
          startdate   = COND abap_bool( WHEN lv_serv = abap_true  THEN abap_true )
          enddate     = COND abap_bool( WHEN lv_serv = abap_true  THEN abap_true )
          gr_ind      = abap_true
         ) ).

    ENDLOOP.

  ENDMETHOD.


  METHOD log.

    INSERT INTO ztmm_fluig_rc VALUES @( VALUE #(
      banfn = iv_requisicao
      idsol = gs_lista-idsol
    ) ).

  ENDMETHOD.


  METHOD processar.

    DATA: lt_item       TYPE TABLE OF bapimereqitemimp,
          lt_itemx      TYPE TABLE OF bapimereqitemx,
          ls_header     TYPE bapimereqheader,
          ls_headerx    TYPE bapimereqheaderx,
          lt_account    TYPE TABLE OF bapimereqaccount,
          lt_accountx   TYPE TABLE OF bapimereqaccountx,
          lt_headertext TYPE TABLE OF bapimereqheadtext.

    gs_lista = io_input.

    me->header( IMPORTING es_header = ls_header es_headerx = ls_headerx ).

    IF ls_header IS NOT INITIAL.

      me->item( IMPORTING et_item = lt_item et_itemx = lt_itemx ).

      IF lt_item IS NOT INITIAL.

        me->account( IMPORTING et_account = lt_account et_accountx = lt_accountx ).
        me->headertext( IMPORTING et_text = lt_headertext ).

        me->bapi_create(
        EXPORTING
            is_header   = ls_header
            is_headerx  = ls_headerx
        CHANGING
            ct_item     = lt_item
            ct_itemx    = lt_itemx
            ct_account  = lt_account
            ct_accountx = lt_accountx
            ct_text     = lt_headertext
        ).

      ENDIF.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
