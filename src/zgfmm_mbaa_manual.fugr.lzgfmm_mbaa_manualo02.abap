*&---------------------------------------------------------------------*
*&  Include           LMBAA_MANUALO02
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
*  SET TITLEBAR 'xxx'.

ENDMODULE.                 " STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  MESSAGES_OUTPUT  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE messages_output OUTPUT.
  FIELD-SYMBOLS: <ls_message> TYPE bapiret2.

  IF gt_messages IS NOT INITIAL.
    CALL FUNCTION 'MESSAGES_INITIALIZE'.

    LOOP AT gt_messages ASSIGNING <ls_message>.
      CALL FUNCTION 'MESSAGE_STORE'
        EXPORTING
          arbgb  = <ls_message>-id
          msgty  = <ls_message>-type
          msgv1  = <ls_message>-message_v1
          msgv2  = <ls_message>-message_v2
          msgv3  = <ls_message>-message_v3
          msgv4  = <ls_message>-message_v4
          txtnr  = <ls_message>-number
        EXCEPTIONS
          OTHERS = 0.
    ENDLOOP.

    CALL FUNCTION 'MESSAGES_STOP'
      EXCEPTIONS
        OTHERS = 0.

    CALL FUNCTION 'MESSAGES_SHOW'
      EXPORTING
        object     = space
        show_linno = space
      EXCEPTIONS
        OTHERS     = 0.
  ENDIF.

ENDMODULE.                 " MESSAGES_OUTPUT  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  ACCOUNTING_DATA_CHG_FIELD_VAL  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE accounting_data_chg_field_val OUTPUT.
  LOOP AT gt_accounting_lines INTO gs_accounting_line.
*   calculate the current total distributed entry-quantity on account level
    gv_actual_distributed = gv_actual_distributed + gs_accounting_line-quantity.
  ENDLOOP.
ENDMODULE.                 " ACCOUNTING_DATA_CHG_FIELD_VAL  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  INITIALIZE_GLOBAL_DATA  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE initialize_global_data OUTPUT.
  CLEAR gv_actual_distributed.
ENDMODULE.                 " INITIALIZE_GLOBAL_DATA  OUTPUT
