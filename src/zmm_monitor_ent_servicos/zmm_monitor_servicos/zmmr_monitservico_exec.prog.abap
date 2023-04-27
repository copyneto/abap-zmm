***********************************************************************
*** © 3corações ***
***********************************************************************
*** *
*** DESCRIÇÃO: Execução JOB - Monitor Serviço (Miro)
*** AUTOR : Enio R. Jesus - Meta
*** FUNCIONAL: Cassiano - Meta
*** DATA : 16/09/2022
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES *
***-------------------------------------------------------------------*
*** DATA    | AUTOR             | DESCRIÇÃO *
***-------------------------------------------------------------------*
*** 15/09/22| ENIO R. JESUS     | Desenvolvimento Inicial             *
***********************************************************************

REPORT zmmr_monitservico_exec.
DATA gt_return TYPE TABLE OF bapiret2.

INITIALIZATION.

  SELECT
     empresa,
     filial,
     lifnr,
     nrnf
    FROM zi_mm_monit_serv_header
   WHERE flagerro = @abap_false
     AND miro  IS INITIAL
     AND valid IS INITIAL
    INTO TABLE @DATA(lt_notas).

  LOOP AT lt_notas ASSIGNING FIELD-SYMBOL(<fs_data>).
    DATA(go_monit_servico) = NEW zclmm_lanc_servicos( ).
    go_monit_servico->registrar_fatura(
      EXPORTING
        is_key    = CORRESPONDING #( <fs_data> )
        iv_job    = abap_true
      IMPORTING
        et_return = DATA(gt_return_aux)
    ).

    APPEND LINES OF gt_return_aux TO gt_return.
  ENDLOOP.

  LOOP AT gt_return INTO DATA(gs_return).
    MESSAGE ID gs_return-id TYPE gs_return-type NUMBER gs_return-number WITH gs_return-message_v1 gs_return-message_v2 gs_return-message_v3 gs_return-message_v4 INTO DATA(gv_msg).
    WRITE: / gv_msg.
  ENDLOOP.
