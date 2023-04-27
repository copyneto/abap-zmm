***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Processo Compra SAGA WMS                               *
*** AUTOR    : Flavia Nunes – META                                    *
*** FUNCIONAL: Fábio Delgado – META                                   *
*** DATA     : 03/03/2022                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR        | DESCRIÇÃO                              *
***-------------------------------------------------------------------*
***           |              |                                        *
***********************************************************************
*&---------------------------------------------------------------------*
*& Include          ZMMI_PROCESSO_COMPRA
*&---------------------------------------------------------------------*

IF  es_status-stepstatus NE gc_stepstat-error
AND es_status-stepstatus NE gc_stepstat-tecerr
AND es_status-stepstatus NE gc_stepstat-errtemp.

  CALL FUNCTION 'ZFMMM_SAGA_GRC_INB'
    DESTINATION 'NONE'
    STARTING NEW TASK 'MM_SEND_SAGA'
    EXPORTING
      iv_action = abap_true
      is_header = is_header
      it_assign = ct_assign.

ENDIF.
