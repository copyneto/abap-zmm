CLASS zclmm_flh_reg_servico DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS create_frs
      IMPORTING
        !is_frs       TYPE zsmm_crat_frs
      EXPORTING
        !ev_folhaserv TYPE mmpur_ses_serviceentrysheet .
    METHODS change_frs
      IMPORTING
        !is_frs        TYPE zsmm_chang_frs
        !iv_sheet_me   TYPE char10
      EXPORTING
        !ev_frs_nfound TYPE boolean
      RAISING
        cx_mmpur_ses_missing_auth .
    METHODS delete_frs
      IMPORTING
        !is_sheet TYPE zclmm_mt_folha_registro_servic.
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS: gc_104  TYPE int4 VALUE '104',
               gc_113    TYPE int4 VALUE '113',
               gc_109  TYPE int4 VALUE '109',
               gc_erro TYPE string VALUE 'ERRO GERAÇÃO FRS SAP',
               gc_e    TYPE char1 VALUE 'E'.

    TYPES: tt_folha TYPE STANDARD TABLE OF ztmm_me_folha WITH DEFAULT KEY.

    METHODS return_status_create
      IMPORTING
        !is_frs    TYPE zsmm_status_frs
        !iv_sucess TYPE boolean
        !iv_frsid  TYPE char10.
    METHODS save_error
      IMPORTING
        !is_frs_log TYPE zsmm_status_frs .
    METHODS get_account
      IMPORTING
        !is_frs          TYPE zsmm_crat_frs
      RETURNING
        VALUE(rt_result) TYPE mmpur_ses_upl_acc_ass_tty.
    METHODS save_sheet
      IMPORTING
        !is_folha TYPE zclmm_dt_mensagem_status_frs .
    METHODS get_erro
      IMPORTING
                it_ret            TYPE bapiret2_tab
      RETURNING VALUE(rv_message) TYPE string.
ENDCLASS.



CLASS ZCLMM_FLH_REG_SERVICO IMPLEMENTATION.


  METHOD create_frs.

    DATA: lt_header  TYPE mmpur_ses_upl_header_tty,
          lt_item    TYPE mmpur_ses_upl_item_tty,
          lt_account TYPE mmpur_ses_upl_acc_ass_tty.

    DATA: ls_frs       TYPE zsmm_status_frs,
          ls_dt_fields TYPE mmpur_ses_upl_additional_data.

    DATA: lv_sucess TYPE char1.

    CONSTANTS: lc_indexador TYPE char10 VALUE '1'.

    DATA(lv_item) = ( 10 * is_frs-purchaseorderitem ).

    lt_header = VALUE #( BASE lt_header ( serviceentrysheet     = 1
                                          serviceentrysheetname = is_frs-serviceentrysheetname
                                          purchaseorder         = is_frs-purchaseorder
                                          postingdate           = is_frs-postingdate ) ).

    lt_item = VALUE #( BASE lt_item ( serviceentrysheet      = 1
                                      serviceentrysheetitem  = lv_item
                                      purchaseorderitem      = lv_item
                                      serviceperformancedate = is_frs-serviceperformancedate
                                      confirmedquantity      = is_frs-confirmedquantity ) ).

*    lt_account = me->get_account( is_frs ).

    ls_dt_fields-import_id = lc_indexador.

    CALL FUNCTION 'ZMM_PUR_SES_CREATE_BG'
      EXPORTING
        is_data_fields        = ls_dt_fields
      IMPORTING
        ev_ses                = ev_folhaserv
      TABLES
        it_header             = lt_header
        it_item               = lt_item
        it_account_assignment = lt_account.

    IF ev_folhaserv IS NOT INITIAL.
      lv_sucess = abap_true.
    ELSE.
      lv_sucess = space.
    ENDIF.

    ls_frs-serviceentrysheet = ev_folhaserv.
    ls_frs-purchaseorder     = is_frs-purchaseorder.
    ls_frs-purchaseorderitem = is_frs-purchaseorderitem.

    me->return_status_create(  EXPORTING is_frs    = ls_frs
                                         iv_sucess = lv_sucess
                                         iv_frsid  = is_frs-serviceentrysheet ).

    IF lv_sucess IS INITIAL.
      me->save_error( EXPORTING is_frs_log = ls_frs ).
    ENDIF.

  ENDMETHOD.


  METHOD change_frs.

    DATA: lt_items       TYPE mmpur_ses_item_tty,
          lt_accountings TYPE mmpur_ses_itm_ac_tty.

    DATA: ls_header TYPE mmpur_ses_header.

    CHECK is_frs-serviceentrysheet IS NOT INITIAL.

    CALL FUNCTION 'MM_PUR_READ_SES_SINGLE'
      EXPORTING
        iv_serviceentrysheet  = is_frs-serviceentrysheet
        iv_auth_02_change     = abap_true
        iv_auth_03_display    = space
        iv_auth_06_delete     = space
        iv_auth_37_accept     = space
        iv_auth_74_revoke     = space
      IMPORTING
        es_header             = ls_header
        et_items              = lt_items
        et_accountings        = lt_accountings
      EXCEPTIONS
        authorisation_missing = 1
        OTHERS                = 2.

    IF sy-subrc EQ 0.

      SORT: lt_items       BY referencepurchaseorder
                              referencepurchaseorderitem,
            lt_accountings BY serviceentrysheet
                              serviceentrysheetitem.

      READ TABLE lt_items ASSIGNING FIELD-SYMBOL(<fs_items>)
                                        WITH KEY referencepurchaseorder     = is_frs-purchaseorder
                                                 referencepurchaseorderitem = ( is_frs-purchaseorderitem * 10 )
                                                 BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        " *********
        " Header
        " *********
        ls_header-serviceentrysheet      = is_frs-serviceentrysheet.
        ls_header-name                   = is_frs-serviceentrysheetname.
        ls_header-referencepurchaseorder = is_frs-purchaseorder.
        ls_header-postingdate            = is_frs-postingdate.

        " *********
        " Item
        " *********
        <fs_items>-serviceentrysheet          = is_frs-serviceentrysheet.
        <fs_items>-referencepurchaseorderitem = ( 10 * is_frs-purchaseorderitem ).
        <fs_items>-performancedate            = is_frs-serviceperformancedate.
        <fs_items>-quantity                   = is_frs-confirmedquantity.
        <fs_items>-netamount                  = ( is_frs-confirmedquantity * <fs_items>-netprice ).

        " *********
        " Account
        " *********
        READ TABLE lt_accountings ASSIGNING FIELD-SYMBOL(<fs_acc>)
                                          WITH KEY serviceentrysheet     = is_frs-serviceentrysheet
                                                   serviceentrysheetitem = ( is_frs-purchaseorderitem * 10 )
                                                   BINARY SEARCH.

        IF sy-subrc EQ 0.

          <fs_acc>-menge = is_frs-confirmedquantity.
          <fs_acc>-netwr = <fs_items>-netamount.

        ENDIF.

        TRY.

            cl_mm_pur_ses_helper=>get_instance( )->ses_post_document(
                EXPORTING
                    is_ses_header_data      = ls_header
                    it_ses_items_data       = lt_items
                    it_ses_accountings_data = lt_accountings ).

            TRY.

                NEW zclmm_co_si_processar_mensagem( )->si_processar_mensagem_status_f(
                  EXPORTING
                    output = VALUE zclmm_mt_mensagem_status_frs(
                                        mt_mensagem_status_frs-serviceentrysheet = is_frs-serviceentrysheet
                                        mt_mensagem_status_frs-ebeln             = is_frs-purchaseorder
                                        mt_mensagem_status_frs-ebelp             = is_frs-purchaseorderitem
                                        mt_mensagem_status_frs-frsid             = iv_sheet_me
                                        mt_mensagem_status_frs-status            = COND #( WHEN sy-subrc EQ 0 THEN gc_104 ELSE gc_109 )
                                        mt_mensagem_status_frs-obserp            = COND #( WHEN sy-subrc NE 0 THEN gc_erro )
                                         ) ).

                COMMIT WORK.

              CATCH cx_ai_system_fault.
            ENDTRY.

          CATCH cx_mmpur_ses_missing_auth INTO DATA(lr_missing_auth).
            RAISE EXCEPTION TYPE cx_mmpur_ses_missing_auth EXPORTING message = lr_missing_auth->message.
        ENDTRY.

      ENDIF.

    ELSE.
      ev_frs_nfound = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD delete_frs.

    DATA: ls_sheet_u TYPE mmpur_ses_header.

    CHECK is_sheet IS NOT INITIAL.

    ls_sheet_u = VALUE mmpur_ses_header(
        serviceentrysheet      = is_sheet-mt_folha_registro_servico-service_sheet_sap
        deletioncode           = abap_true
        referencepurchaseorder = is_sheet-mt_folha_registro_servico-purchase_order
     ).

    IF ls_sheet_u IS NOT INITIAL.

      CALL FUNCTION 'MM_PUR_UPDATE_SES'
        EXPORTING
          serviceentrysheet_u = ls_sheet_u.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

      DATA(lv_ok) = abap_true.

    ENDIF.


    TRY.

        NEW zclmm_co_si_processar_mensagem( )->si_processar_mensagem_status_f(
          EXPORTING
            output = VALUE zclmm_mt_mensagem_status_frs(
                                mt_mensagem_status_frs-serviceentrysheet = is_sheet-mt_folha_registro_servico-service_sheet_sap
                                mt_mensagem_status_frs-ebeln             = is_sheet-mt_folha_registro_servico-purchase_order
                                mt_mensagem_status_frs-ebelp             = CONV i( is_sheet-mt_folha_registro_servico-purchase_order_item )
                                mt_mensagem_status_frs-frsid             = is_sheet-mt_folha_registro_servico-service_entry_sheet
                                mt_mensagem_status_frs-status            = COND #( WHEN lv_ok EQ abap_true THEN gc_113 ELSE gc_109 ) ) ).

        COMMIT WORK.

      CATCH cx_ai_system_fault.
    ENDTRY.

  ENDMETHOD.


  METHOD return_status_create.

    DATA: ls_return TYPE zclmm_mt_mensagem_status_frs.

    ls_return-mt_mensagem_status_frs-serviceentrysheet = is_frs-serviceentrysheet.
    ls_return-mt_mensagem_status_frs-ebeln             = is_frs-purchaseorder.
    ls_return-mt_mensagem_status_frs-ebelp             = is_frs-purchaseorderitem.
    ls_return-mt_mensagem_status_frs-frsid             = iv_frsid.

    IF iv_sucess IS NOT INITIAL.
      ls_return-mt_mensagem_status_frs-status = gc_104.
      ls_return-mt_mensagem_status_frs-obserp = TEXT-t01.

      me->save_sheet( ls_return-mt_mensagem_status_frs ).
    ELSE.
      ls_return-mt_mensagem_status_frs-status = gc_109.
      ls_return-mt_mensagem_status_frs-obserp = TEXT-t02.
    ENDIF.

    TRY.

        DATA(lo_proc_status) = NEW zclmm_co_si_processar_mensagem( ).

        CALL METHOD lo_proc_status->si_processar_mensagem_status_f
          EXPORTING
            output = ls_return.

        COMMIT WORK.

      CATCH cx_ai_system_fault.
    ENDTRY.

  ENDMETHOD.


  METHOD save_error.

    DATA: ls_envio_req TYPE ztmm_control_int.

    CONSTANTS: lc_tp_frs  TYPE ze_tp_proc VALUE '12',
               lc_cat_doc TYPE bstyp      VALUE 'S'.

    ls_envio_req-tp_processo   = lc_tp_frs.
    ls_envio_req-categoria_doc = lc_cat_doc.
    ls_envio_req-doc_sap       = is_frs_log-purchaseorder.
    ls_envio_req-item_doc      = is_frs_log-purchaseorderitem.
*    ls_envio_req-id_me    = .
    ls_envio_req-dt_integracao = sy-datum.
    ls_envio_req-log           = TEXT-t02.

    MODIFY ztmm_control_int FROM ls_envio_req.

    IF sy-subrc IS INITIAL.
      COMMIT WORK.
    ENDIF.

  ENDMETHOD.


  METHOD get_account.

    DATA(lv_item) = 10 * is_frs-purchaseorderitem.

    SELECT glaccount, accountassignmentnumber, costcenter, multipleacctassgmtdistrpercent, wbselementinternalid
       FROM i_purordaccountassignmentapi01
    WHERE purchaseorder     = @is_frs-purchaseorder
      AND purchaseorderitem = @lv_item
      INTO TABLE @DATA(lt_acc).

    IF sy-subrc EQ 0.

      rt_result = VALUE #( FOR ls_acc IN lt_acc (
        serviceentrysheet      = 1
        serviceentrysheetitem  = lv_item
        glaccount              = ls_acc-glaccount
        accountassignment      = ls_acc-accountassignmentnumber
        costcenter             = ls_acc-costcenter
        quantity               = is_frs-confirmedquantity
        multipleacctassgmtdistrpercent = ls_acc-multipleacctassgmtdistrpercent
        wbselementinternalid = ls_acc-wbselementinternalid
      ) ).

    ENDIF.

  ENDMETHOD.


  METHOD save_sheet.

    DATA(ls_folha) = VALUE ztmm_me_folha(
                        doc_sap           = is_folha-ebeln
                        item_doc          = is_folha-ebelp
                        serviceentrysheet = is_folha-serviceentrysheet
                        frsid             = is_folha-frsid  ).

    IF ls_folha IS NOT INITIAL.

      MODIFY ztmm_me_folha FROM ls_folha.

      IF sy-subrc EQ 0.
        COMMIT WORK.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD get_erro.

    LOOP AT it_ret ASSIGNING FIELD-SYMBOL(<fs_ret>).
      CONCATENATE <fs_ret>-message rv_message INTO rv_message SEPARATED BY space.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
