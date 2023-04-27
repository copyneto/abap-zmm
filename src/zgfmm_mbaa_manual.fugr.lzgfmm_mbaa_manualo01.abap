*&---------------------------------------------------------------------*
*&  Include           LMBAA_MANUALO01
*&---------------------------------------------------------------------*

*&SPWIZARD: OUTPUT MODULE FOR TC 'ACCOUNTING_DATA'. DO NOT CHANGE THIS L
*&SPWIZARD: UPDATE LINES FOR EQUIVALENT SCROLLBAR
MODULE accounting_data_change_tc_attr OUTPUT.

  DESCRIBE TABLE gt_accounting_lines LINES accounting_data-lines.

  LOOP AT accounting_data-cols ASSIGNING <column>.
    IF cl_erp_ehp_switch_check=>erp_sfws_maa_2( ) EQ abap_true
     AND gv_retpo IS INITIAL.
      IF <column>-screen-name = 'GS_ACCOUNTING_LINE-FINAL_QUANTITY'
       OR <column>-screen-name = 'GS_ACCOUNTING_LINE-FINAL_INDICATOR'.
        <column>-invisible = '0'.
      ENDIF.
    ELSE.
      IF <column>-screen-name = 'GS_ACCOUNTING_LINE-FINAL_QUANTITY'
       OR <column>-screen-name = 'GS_ACCOUNTING_LINE-FINAL_INDICATOR'.
        <column>-invisible = '1'.
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDMODULE.                    "ACCOUNTING_DATA_CHANGE_TC_ATTR OUTPUT

*&SPWIZARD: OUTPUT MODULE FOR TC 'ACCOUNTING_DATA'. DO NOT CHANGE THIS L
*&SPWIZARD: GET LINES OF TABLECONTROL
MODULE accounting_data_get_lines OUTPUT.
  g_accounting_data_lines = sy-loopc.
ENDMODULE.                    "ACCOUNTING_DATA_GET_LINES OUTPUT
*&---------------------------------------------------------------------*
*&      Module  ACCOUNTING_DATA_CHG_FIELD_ATTR  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE accounting_data_chg_field_attr OUTPUT.

  LOOP AT SCREEN.
    IF gs_accounting_line-final_indicator IS NOT INITIAL
     OR gs_accounting_line-received_quantity LE gs_accounting_line-invoiced_quantity .
*     in case of a goods receipt the posting quanitity regarding a final flagged
*     MAA line shall not manipulated
      IF screen-name = 'GS_ACCOUNTING_LINE-QUANTITY'
       AND gs_accounting_line-final_indicator IS NOT INITIAL
       AND gv_shkzg EQ 'S'.
        screen-input    = '0'.
        MODIFY SCREEN.
      ENDIF.
*     in case of a goods issue (return delivery) only GR-surplus is allowed to redistribute
*     among the AA-lines which actually have a GR-surplus
      IF screen-name = 'GS_ACCOUNTING_LINE-QUANTITY'
       AND gs_accounting_line-received_quantity LE gs_accounting_line-invoiced_quantity
       AND gv_shkzg EQ 'H'.
        screen-input    = '0'.
        MODIFY SCREEN.
      ENDIF.
*     MAA line shall not manipulated
    ENDIF.
*   in case that final indicator is not set, set field content to BLANK
    IF screen-name = 'GS_ACCOUNTING_LINE-FINAL_QUANTITY'
     AND gs_accounting_line-final_indicator EQ abap_false.
      screen-input    = '0'.
      screen-output   = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

ENDMODULE.                 " ACCOUNTING_DATA_CHG_FIELD_ATTR  OUTPUT
