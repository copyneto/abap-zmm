CLASS zclmm_ret_cancela DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: tt_item  TYPE STANDARD TABLE OF ueban WITH DEFAULT KEY,
           tt_lines TYPE STANDARD TABLE OF tline  WITH DEFAULT KEY.

    TYPES: BEGIN OF ty_purchasereqnitem,
             PurchaseRequisition     TYPE C_PurchaseReqnItem-PurchaseRequisition,
             PurchaseRequisitionItem TYPE C_PurchaseReqnItem-PurchaseRequisitionItem,
           END OF ty_purchasereqnitem.

    "! Start the process
    METHODS execute
      IMPORTING
        !is_canc TYPE zclmm_mt_cancelar_item_requisi
      RAISING
        zcxmm_erro_interface_mes .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF gc_values,
        tp              TYPE c2 VALUE '4',
        cd              TYPE c  VALUE 'R',
        erro            TYPE c  VALUE 'E',
        s               TYPE c  VALUE 'S',
        c               TYPE c  VALUE 'C',
        u               TYPE c  VALUE 'U',
        error           TYPE string   VALUE 'Erro' ##NO_TEXT,
        classe          TYPE string   VALUE 'ZMM_PRE_PEDIDO',
        zmm_req_compras TYPE string   VALUE 'ZMM_REQ_COMPRAS',
        msgno10         TYPE symsgno  VALUE '010',
        msgno11         TYPE symsgno  VALUE '011',
        objeto          TYPE balobj_d VALUE 'ZCANCELAREQ',
        subobjeto       TYPE balsubobj VALUE 'REQUISICAO',
        v9              TYPE symsgno  VALUE '009',
      END OF gc_values .

    DATA: gs_canc   TYPE zclmm_mt_cancelar_item_requisi,
          gt_return TYPE STANDARD TABLE OF bapiret2.

    "! Validate the records
    METHODS validate
      RAISING
        zcxmm_erro_interface_mes .
    "! Execute the bapi release
    METHODS bapi_release
      IMPORTING
        !iv_frgc1 TYPE frgco
      RAISING
        zcxmm_erro_interface_mes .
    "! Commit work
    METHODS commit .
    "! Call the interface 23
    METHODS interface23
      EXPORTING
        !ev_ret TYPE string .
    "! Handle the return table
    METHODS table_ret
      EXPORTING
        !ev_ret TYPE string .
    "! Call the interface 04
    METHODS interface04
      IMPORTING
        !iv_ret TYPE string
      RAISING
        zcxmm_erro_interface_mes .
    "! Return error raising
    METHODS error_raise
      IMPORTING
        !is_ret TYPE scx_t100key
      RAISING
        zcxmm_erro_interface_mes .
    METHODS change_req
      IMPORTING
        is_req TYPE ty_purchasereqnitem
      RAISING
        zcxmm_erro_interface_mes .
    METHODS fill_data
      IMPORTING
        is_req   TYPE ty_purchasereqnitem
      EXPORTING
        et_yeban TYPE tt_item
        et_xeban TYPE tt_item.
    METHODS get_text_tab
      IMPORTING
        iv_string        TYPE string
      RETURNING
        VALUE(rt_result) TYPE tt_lines.
    METHODS save_log
      IMPORTING
        iv_purchase TYPE vdm_purchaserequisition
        it_item     TYPE tt_item
        it_msgs     TYPE bapiret2_tab.

ENDCLASS.



CLASS zclmm_ret_cancela IMPLEMENTATION.


  METHOD execute.

    gs_canc = is_canc.

    me->validate(  ).

  ENDMETHOD.


  METHOD validate.

    DATA: ls_req TYPE ty_purchasereqnitem.

    SELECT SINGLE
      PurchaseRequisition,
      PurchaseRequisitionItem
    FROM C_PurchaseReqnItem
    INTO @ls_req
    WHERE
      PurchaseRequisition EQ @gs_canc-mt_cancelar_item_requisicao-banfn AND
      PurchaseRequisitionItem EQ @gs_canc-mt_cancelar_item_requisicao-bnfpo.

    IF sy-subrc EQ 0.
      me->change_req( EXPORTING is_req = ls_req ).
    ENDIF.

  ENDMETHOD.


  METHOD bapi_release.

    TRY.

        CALL FUNCTION 'BAPI_REQUISITION_RESET_RELEASE'
          EXPORTING
            number   = gs_canc-mt_cancelar_item_requisicao-banfn
            item     = CONV bnfpo( gs_canc-mt_cancelar_item_requisicao-bnfpo )
            rel_code = iv_frgc1
          TABLES
            return   = gt_return.

        IF line_exists( gt_return[ type = gc_values-erro ] ). "#EC CI_STDSEQ

          me->interface23( IMPORTING ev_ret = DATA(ls_erro) ).
          me->interface04( ls_erro ).

        ELSE.
          me->commit(  ).
        ENDIF.

      CATCH zcxmm_erro_interface_mes.

        me->error_raise( is_ret = VALUE scx_t100key( msgid = gc_values-classe msgno = gc_values-msgno10 ) ).

    ENDTRY.

  ENDMETHOD.


  METHOD commit.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.

  ENDMETHOD.


  METHOD interface23.

    DATA: lt_controle_int TYPE STANDARD TABLE OF ztmm_control_int.

    me->table_ret( IMPORTING ev_ret = DATA(lv_return) ).

    lt_controle_int = VALUE #( BASE lt_controle_int (
          tp_processo   = gc_values-tp
          categoria_doc = gc_values-cd
          doc_sap       = gs_canc-mt_cancelar_item_requisicao-banfn
          item_doc      = gs_canc-mt_cancelar_item_requisicao-bnfpo
          dt_integracao = sy-datum
          log           = lv_return ) ).


    IF lt_controle_int IS NOT INITIAL.

      MODIFY ztmm_control_int FROM  TABLE lt_controle_int.

      IF sy-subrc EQ 0.
        COMMIT WORK.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD table_ret.

    ev_ret = REDUCE #( INIT lv_text TYPE string FOR ls_ret2 IN gt_return NEXT lv_text = lv_text && | | && ls_ret2-message ).

  ENDMETHOD.


  METHOD interface04.

    TRY.

        NEW zco_si_enviar_requisicao_compr(  )->si_enviar_requisicao_compra_ou(
         EXPORTING
             output = VALUE zmt_requisicao_compra( mt_requisicao_compra-purchase_requisition = gs_canc-mt_cancelar_item_requisicao-banfn
                                                   mt_requisicao_compra-c_purchase_reqn_item = VALUE zdt_requisicao_compra_c_pu_tab( ( nome_atributo             = iv_ret
                                                                                                                                       valor_atributo            = gc_values-error ) ) )

        ).

        COMMIT WORK.

      CATCH cx_ai_system_fault.

        me->error_raise( is_ret = VALUE scx_t100key( msgid = gc_values-classe msgno = gc_values-msgno11 ) ).

    ENDTRY.

  ENDMETHOD.


  METHOD error_raise.

    RAISE EXCEPTION TYPE zcxmm_erro_interface_mes
      EXPORTING
        textid = VALUE #( msgid = is_ret-msgid
                          msgno = is_ret-msgno
                          ).

  ENDMETHOD.


  METHOD change_req.

    DATA: lt_xebkn TYPE STANDARD TABLE OF uebkn,
          lt_yebkn TYPE STANDARD TABLE OF uebkn.

    me->fill_data(
    EXPORTING
        is_req   = is_req
    IMPORTING
        et_yeban    = DATA(lt_yeban)
        et_xeban   = DATA(lt_xeban)
     ).

    CALL FUNCTION 'ME_UPDATE_REQUISITION'
      TABLES
        xeban = lt_xeban
        xebkn = lt_xebkn
        yeban = lt_yeban
        yebkn = lt_yebkn.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.

    WAIT UP TO '0.2' SECONDS.

    SELECT COUNT( * ) FROM eban
    WHERE banfn     = @is_req-purchaserequisition
      AND bnfpo     = @is_req-purchaserequisitionitem
      AND zz1_statu = @gc_values-c.

    IF sy-subrc NE 0.

      me->interface23( IMPORTING ev_ret = DATA(ls_erro) ).
      me->interface04( ls_erro ).

    ELSE.

      me->save_log(
        EXPORTING
          it_item     = lt_xeban
          it_msgs     = gt_return
          iv_purchase = is_req-purchaserequisition ).

    ENDIF.

  ENDMETHOD.


  METHOD fill_data.

    DATA: lt_flines TYPE STANDARD TABLE OF tline.

    SELECT * FROM eban
    INTO TABLE @et_yeban
    WHERE banfn     = @is_req-purchaserequisition
      AND bnfpo     = @is_req-purchaserequisitionitem.

    CHECK et_yeban IS NOT INITIAL.

    et_xeban = et_yeban.

    et_xeban[ 1 ]-loekz     = abap_true.
    et_xeban[ 1 ]-zz1_statu = gc_values-c.
    et_xeban[ 1 ]-kz        = gc_values-u.

    IF gs_canc-mt_cancelar_item_requisicao-justificativa IS NOT INITIAL.

      lt_flines = get_text_tab( gs_canc-mt_cancelar_item_requisicao-justificativa ).

      CALL FUNCTION 'CREATE_TEXT'
        EXPORTING
          fid         = 'B05'
          flanguage   = 'P'
          fname       = CONV tdobname( is_req-purchaserequisition && is_req-purchaserequisitionitem )
          fobject     = 'EBAN'
          save_direct = abap_true
          fformat     = '*'
        TABLES
          flines      = lt_flines
        EXCEPTIONS
          no_init     = 1
          no_save     = 2
          OTHERS      = 3.

      IF sy-subrc NE 0.
        RETURN.
      ELSE.
        me->commit(  ).
      ENDIF.

    ENDIF.


  ENDMETHOD.


  METHOD get_text_tab.

    DATA: lt_text TYPE tdtab_c132 .

    CALL FUNCTION 'CRM_BSP_ERP_SPLIT_STRING_TABLE'
      EXPORTING
        iv_string = iv_string
      IMPORTING
        et_text   = lt_text.

    IF lt_text IS NOT INITIAL.
      rt_result = VALUE #( FOR ls_text IN lt_text ( tdline  = ls_text ) ).
    ENDIF.

  ENDMETHOD.


  METHOD save_log.

    CHECK it_item IS NOT INITIAL.

    SELECT PurchaseRequisition, PurchaseRequisitionItem, ProcessOrder FROM i_purreqnacctassgmtapi01
    FOR ALL ENTRIES IN @it_item
    WHERE PurchaseRequisition = @iv_purchase
      AND PurchaseRequisitionItem = @it_item-bnfpo
      AND ProcessOrder IS NOT INITIAL
    INTO TABLE @DATA(lt_eban).

    IF lt_eban IS NOT INITIAL.

      DATA(lt_msgs) = it_msgs.

      DO lines( lt_eban ) TIMES.

        APPEND INITIAL LINE TO lt_msgs ASSIGNING FIELD-SYMBOL(<fs_mgs>).

        DATA(ls_itab) = VALUE #( lt_eban[ sy-index ] OPTIONAL ).

        <fs_mgs> = VALUE bapiret2( id         = gc_values-zmm_req_compras
                                   type       = gc_values-s
                                   number     = gc_values-v9
                                   message_v1 = ls_itab-PurchaseRequisition
                                   message_v2 = ls_itab-PurchaseRequisitionItem
                                   message_v3 = ls_itab-ProcessOrder ).

      ENDDO.

      CALL FUNCTION 'ZFMCA_LOG_MSG_ADD'
        STARTING NEW TASK 'SAVE_LOG'
        EXPORTING
          is_log  = VALUE bal_s_log(
                          aluser    = sy-uname
                          alprog    = sy-repid
                          object    = gc_values-objeto
                          subobject = gc_values-subobjeto
                          extnumber = sy-timlo )
          it_msgs = lt_msgs.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
