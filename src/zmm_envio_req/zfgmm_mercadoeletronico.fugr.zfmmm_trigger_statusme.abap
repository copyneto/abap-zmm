FUNCTION zfmmm_trigger_statusme.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_STATUS) TYPE  MEPROCSTATE
*"     VALUE(IS_PEDIDO_ME) TYPE  ZTMM_PEDIDO_ME
*"     VALUE(IS_SIBFLPORB) TYPE  SIBFLPORB OPTIONAL
*"     VALUE(IS_CONTRATO) TYPE  ZTMM_ME_CONTRATO OPTIONAL
*"     VALUE(IS_PROCESSO) TYPE  CHAR1
*"----------------------------------------------------------------------
  CONSTANTS: BEGIN OF lc_values,
               released               TYPE swc_elem VALUE 'RELEASED',
               v1                     TYPE c VALUE '1',
               v2                     TYPE c VALUE '2',
               v3                     TYPE c VALUE '3',
               l                      TYPE eloek VALUE 'L',
               v105                   TYPE char3 VALUE '105',
               po_aprov               TYPE c LENGTH 2 VALUE '05',
               po_rejei               TYPE c LENGTH 2 VALUE '08',
               variant                TYPE swr_stavar VALUE '0000',
               cl_mm_pur_wf_object_po TYPE sibftypeid  VALUE 'CL_MM_PUR_WF_OBJECT_PO',
               cl                     TYPE sibfcatid VALUE 'CL',
               attach_comment_objects TYPE swc_elem VALUE '_ATTACH_COMMENT_OBJECTS',
             END OF lc_values.


  DATA: lt_objcont          TYPE STANDARD TABLE OF soli,
        lt_worklist         TYPE STANDARD TABLE OF swr_wihdr,
        lt_swr_cont         TYPE STANDARD TABLE OF swr_cont,
        lt_simple_container TYPE STANDARD TABLE OF swr_cont,
        ls_texto            TYPE string.

  CASE is_processo.

    WHEN lc_values-v1.

      CALL FUNCTION 'SAP_WAPI_WORKITEMS_TO_OBJECT'
        EXPORTING
          object_por               = VALUE sibflporb( instid = is_pedido_me-ebeln typeid = lc_values-cl_mm_pur_wf_object_po catid = lc_values-cl )
          top_level_items          = abap_true
          selection_status_variant = lc_values-variant
        TABLES
          worklist                 = lt_worklist.

      IF lt_worklist IS NOT INITIAL.

        CALL FUNCTION 'SAP_WAPI_READ_CONTAINER'
          EXPORTING
            workitem_id              = VALUE #( lt_worklist[ 1 ]-wi_id OPTIONAL )
            language                 = sy-langu
            buffered_access          = abap_true
          TABLES
            subcontainer_bor_objects = lt_swr_cont
            simple_container         = lt_simple_container.


        IF lt_swr_cont IS NOT INITIAL.

          DATA(lv_value) = VALUE #( lt_swr_cont[ element = lc_values-attach_comment_objects  ]-value OPTIONAL ).

          IF lv_value IS NOT INITIAL.

            SHIFT lv_value LEFT DELETING LEADING space.

            CALL FUNCTION 'SO_NOTE_READ'
              EXPORTING
                folder_id               = VALUE soodk( objtp = lv_value+10(3) objyr = lv_value+13(2) objno = lv_value+15(12) )
                object_id               = VALUE soodk( objtp = lv_value+27(3) objyr = lv_value+30(2) objno = lv_value+32(12) )
              TABLES
                objcont                 = lt_objcont
              EXCEPTIONS
                active_user_not_exist   = 1
                communication_failure   = 2
                folder_no_authorization = 3
                folder_not_exist        = 4
                object_not_exist        = 5
                owner_not_exist         = 6
                substitute_not_active   = 7
                substitute_not_defined  = 8
                system_failure          = 9
                x_error                 = 10
                OTHERS                  = 11.

            IF sy-subrc EQ 0.

              CONCATENATE LINES OF lt_objcont INTO ls_texto SEPARATED BY space.

            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.

      TRY.

          NEW zclmm_co_si_processar_status_p(  )->si_processar_status_pre_pedido(
              EXPORTING
              output = VALUE zclmm_mt_mensagem_status_pre_p( mt_mensagem_status_pre_pedido-ebeln   = is_pedido_me-ebeln
                                                             mt_mensagem_status_pre_pedido-ref_1   = is_pedido_me-ped_me
                                                             mt_mensagem_status_pre_pedido-vendor  = is_pedido_me-lifnr
                                                             mt_mensagem_status_pre_pedido-status  = COND #( WHEN iv_status EQ lc_values-po_aprov THEN 1 ELSE lc_values-v105 )
                                                             mt_mensagem_status_pre_pedido-obs_erp = ls_texto )
           ).

        CATCH cx_ai_system_fault.
      ENDTRY.

    WHEN lc_values-v2.

      TRY.

          NEW zclmm_co_si_processar_mensage1(  )->si_processar_mensagem_status_c(
              EXPORTING
              output = VALUE zclmm_mt_contrato_compra_stat1(
                              mt_contrato_compra_status-ebeln        = is_contrato-doc_sap
                              mt_contrato_compra_status-ihrez        = is_contrato-doc_me
                              mt_contrato_compra_status-lifnr        = is_contrato-lifnr
                              mt_contrato_compra_status-status       = COND #( WHEN iv_status EQ lc_values-po_aprov THEN 1 ELSE lc_values-v105 )
                              mt_contrato_compra_status-motivorecusa = space ) ).

          IF sy-subrc EQ 0.

            DELETE FROM ztmm_me_contrato WHERE doc_sap  = is_contrato-doc_sap
                                           AND item_doc = is_contrato-doc_me.

            COMMIT WORK.
          ENDIF.

        CATCH cx_ai_system_fault .
      ENDTRY.

  ENDCASE.

ENDFUNCTION.
