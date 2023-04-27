*----------------------------------------------------------------------*
***INCLUDE ZXM02O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0111 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0111 OUTPUT.

  SET PF-STATUS 'ZSTATUS'.
  SET TITLEBAR 'DADOSCLIENTE'.

*  DATA: lv_flag TYPE char1.
*
*   IMPORT flag_input FROM MEMORY ID 'Z_FLAG_INPUT_ZXM02U01'.
*
*   LOOP AT SCREEN.
*    IF screen-name = 'ZZ1_STATU'.
*     IF flag_input = 'X'.
*      screen-input = 1.
*     ELSE.
*      screen-input = 0.
*     ENDIF.
*      MODIFY SCREEN.
*    ENDIF.
*   ENDLOOP.

ENDMODULE.
