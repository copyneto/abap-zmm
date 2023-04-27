*&---------------------------------------------------------------------*
*&  Include           LMBAA_MANUALI01
*&---------------------------------------------------------------------*

*&SPWIZARD: INPUT MODULE FOR TC 'ACCOUNTING_DATA'. DO NOT CHANGE THIS LI
*&SPWIZARD: MODIFY TABLE
MODULE accounting_data_modify INPUT.
  MODIFY gt_accounting_lines
    FROM gs_accounting_line
    INDEX accounting_data-current_line.
ENDMODULE.                    "ACCOUNTING_DATA_MODIFY INPUT

*&SPWIZARD: INPUT MODULE FOR TC 'ACCOUNTING_DATA'. DO NOT CHANGE THIS LI
*&SPWIZARD: PROCESS USER COMMAND
MODULE accounting_data_user_command INPUT.
  ok_code = sy-ucomm.
  PERFORM user_ok_tc USING    'ACCOUNTING_DATA'
                              'LT_ACCOUNTING_LINES'
                              ' '
                     CHANGING ok_code.
  sy-ucomm = ok_code.
ENDMODULE.                    "ACCOUNTING_DATA_USER_COMMAND INPUT
