*----------------------------------------------------------------------*
***INCLUDE ZXM06O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0111 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0111 OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 = 'ZPR'.
      case  gv_campos_sub.
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

ENDMODULE.
