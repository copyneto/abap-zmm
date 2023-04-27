***********************************************************************
***                           © 3corações                           ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: deposito fechado - Reprocessar Criação de Pedido       *
*** AUTOR : Carlos Adriano  – Meta                                    *
*** FUNCIONAL: Alcides Ponciano  – Meta                               *
*** DATA :  12.12.2022                                                *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA | AUTOR | DESCRIÇÃO                                          *
***-------------------------------------------------------------------*
***      |       |                                                    *
***********************************************************************
REPORT zmmr_dep_fec_reproc_pedido.

DATA: gv_proc TYPE char1.

SELECTION-SCREEN BEGIN OF BLOCK block WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_msg TYPE char1 AS CHECKBOX.
  PARAMETERS: p_retmsg TYPE char1 AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK block.

START-OF-SELECTION.
  PERFORM f_vez_processamento CHANGING gv_proc.

  IF gv_proc IS NOT INITIAL.
    EXIT.
  ENDIF.

  IF p_msg IS NOT INITIAL.
    DATA(lt_mensagens) = NEW zclmm_dep_fec_reproc_pedido( )->executar( ).
    IF p_retmsg IS NOT INITIAL.
      cl_rmsl_message=>display( lt_mensagens ).
    ENDIF.
  ENDIF.

*&---------------------------------------------------------------------*
*& Form F_VEZ_PROCESSAMENTO
*&---------------------------------------------------------------------*
FORM f_vez_processamento CHANGING cv_proc TYPE char1.

  DATA: ls_return TYPE bapiret2.

  DATA: lv_jobname  TYPE tbtcp-jobname,
        lv_jobcount TYPE tbtcp-jobcount,
        lv_strtdate TYPE tbtco-strtdate,
        lv_strttime TYPE tbtco-strttime.

  DATA(go_job) = NEW zclmm_valida_job_exec( ).

  DATA(lv_exec) = go_job->valida_exec( EXPORTING iv_program_exec = sy-cprog
                                       IMPORTING ev_jobname      = lv_jobname
                                                 ev_jobcount     = lv_jobcount
                                                 ev_strtdate     = lv_strtdate
                                                 ev_strttime     = lv_strttime
                                                 es_return       = ls_return ).

  IF lv_exec EQ abap_false.
    IF ls_return IS NOT INITIAL.
      MESSAGE ID ls_return-id TYPE 'S' NUMBER ls_return-number WITH ls_return-message_v1
                                                                    ls_return-message_v2
                                                                    ls_return-message_v3
                                                                    ls_return-message_v4
                                                                    DISPLAY LIKE 'E'.
    ELSE.
      MESSAGE s044(zmm_deposito_fechado) WITH lv_jobname
                                              lv_jobcount
                                              lv_strtdate
                                              lv_strttime
                                              DISPLAY LIKE 'E'.
    ENDIF.

    cv_proc = abap_true.
  ENDIF.
ENDFORM.
