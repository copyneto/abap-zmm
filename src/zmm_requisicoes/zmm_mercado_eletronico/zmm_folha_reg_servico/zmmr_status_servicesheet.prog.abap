***********************************************************************
***                      © 3Corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Enviar status folha de serviço ME                      *
*** AUTOR    : Emilio Matheus- META                                   *
*** FUNCIONAL: Monica                                                 *
*** DATA     : 01/09/2022                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR        | DESCRIÇÃO                              *
***-------------------------------------------------------------------*
***           |              |                                        *
***********************************************************************
*&---------------------------------------------------------------------*
*& Report ZMMR_STATUS_SERVICESHEET
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmmr_status_servicesheet.

CONSTANTS: gc_30 TYPE mmpur_ses_approval_status  VALUE '30',
           gc_40 TYPE mmpur_ses_approval_status  VALUE '40'.

DATA: lt_save TYPE STANDARD TABLE OF ztmm_me_folha.

START-OF-SELECTION.

  SELECT approvalstatus,b~* FROM I_ServiceEntrySheetAPI01 AS a
     INNER JOIN ztmm_me_folha AS b
     ON a~ServiceEntrySheet = b~serviceentrysheet
     WHERE approvalstatus = @gc_30
        OR approvalstatus = @gc_40
     INTO TABLE @DATA(lt_folha).

  IF sy-subrc EQ 0.

    LOOP AT lt_folha ASSIGNING FIELD-SYMBOL(<fs_folha>).

      TRY.

          NEW zclmm_co_si_processar_mensagem( )->si_processar_mensagem_status_f(
            EXPORTING
                output = VALUE zclmm_mt_mensagem_status_frs(
                                mt_mensagem_status_frs-ebeln             = <fs_folha>-b-doc_sap
                                mt_mensagem_status_frs-ebelp             = <fs_folha>-b-item_doc
                                mt_mensagem_status_frs-serviceentrysheet = <fs_folha>-b-serviceentrysheet
                                mt_mensagem_status_frs-frsid             = <fs_folha>-b-frsid
                                mt_mensagem_status_frs-status            = COND #( WHEN <fs_folha>-ApprovalStatus EQ gc_30 THEN 1 ELSE 105 )
                                mt_mensagem_status_frs-obserp            = space ) ).

          IF sy-subrc EQ 0.
            APPEND <fs_folha>-b TO lt_save.
          ENDIF.

        CATCH cx_ai_system_fault .
      ENDTRY.

    ENDLOOP.

    IF lt_save IS NOT INITIAL.

      DELETE  ztmm_me_folha FROM TABLE lt_save.

      IF sy-subrc EQ 0.
        COMMIT WORK.
      ENDIF.

    ENDIF.

  ENDIF.
