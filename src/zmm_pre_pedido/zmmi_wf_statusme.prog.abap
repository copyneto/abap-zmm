*&---------------------------------------------------------------------*
*& Include          ZMMI_WF_STATUSME
*&---------------------------------------------------------------------*

CONSTANTS: gc_1 TYPE char1 VALUE '1', " Purchase Order
           gc_2 TYPE char1 VALUE '2', " Contract
           gc_3 TYPE char1 VALUE '3'. " Sheet

DATA: ls_pedido TYPE zclmm_dt_cancelar_pedido.

" Trigger M.E Pass/Fail interface

IF im_ekko-procstat EQ lc_po_aprov OR
   im_ekko-procstat EQ lc_po_rejei.

  IMPORT tab TO ls_pedido
      FROM  DATABASE indx(xy)
      CLIENT sy-mandt
      ID 'ZMM_CANCELA'.

  IF ls_pedido IS NOT INITIAL. " Não disparar via cancelamento de pedido - ME

    IF sy-uname EQ 'SAP_WFRT'. " Pedido cancelado via ME - Workflow dispara automaticamente
      DELETE FROM DATABASE indx(xy) CLIENT sy-mandt ID 'ZMM_CANCELA'.
      RETURN.
    ENDIF.

    IF ls_pedido-purchaseorder EQ im_ekko-ebeln.
      RETURN.
    ENDIF.

  ENDIF.

  " Purchase Order
  SELECT SINGLE * FROM ztmm_pedido_me
  INTO @DATA(ls_pedido_me)
  WHERE ebeln EQ @im_ekko-ebeln.

  IF sy-subrc EQ 0.


    CALL FUNCTION 'ZFMMM_TRIGGER_STATUSME'
      STARTING NEW TASK 'UPDATE'
      DESTINATION 'NONE'
      EXPORTING
        iv_status    = im_ekko-procstat
        is_pedido_me = ls_pedido_me
        is_processo  = gc_1.

  ELSE.

    " Contract
    SELECT SINGLE * FROM ztmm_me_contrato
      WHERE doc_sap EQ @im_ekko-ebeln
      INTO @DATA(ls_contrato).

    IF sy-subrc EQ 0.

      CALL FUNCTION 'ZFMMM_TRIGGER_STATUSME'
        STARTING NEW TASK 'UPDATE'
        DESTINATION 'NONE'
        EXPORTING
          iv_status   = im_ekko-procstat
          is_contrato = ls_contrato
          is_processo = gc_2.

    ENDIF.

  ENDIF.

ENDIF.
