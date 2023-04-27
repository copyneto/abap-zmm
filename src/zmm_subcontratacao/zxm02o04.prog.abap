*----------------------------------------------------------------------*
***INCLUDE ZXM02O04.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0111 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0111 OUTPUT.

  DATA lv_flag TYPE c.

  IMPORT  lv_flag FROM MEMORY ID 'Z_FLAG_INPUT_ZXM02U01'.
  LOOP AT SCREEN.
    IF screen-group1 = 'ZPR'.
      case lv_flag.
        when 0.
         screen-input = 0.
         screen-invisible = 0.
        WHEN 1.
         screen-input = 1.
         screen-invisible = 0.
        WHEN OTHERS.
         screen-active = 0.
         screen-invisible = 1.
      endcase.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

  FREE MEMORY ID 'Z_FLAG_INPUT_ZXM02U01'.
ENDMODULE.
