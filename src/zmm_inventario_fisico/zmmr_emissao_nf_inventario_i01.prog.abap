*&---------------------------------------------------------------------*
*& Include zmmr_emissao_nf_inventario_i01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9000 INPUT.

  CASE sy-ucomm.
    WHEN 'BACK' OR 'EXIT' OR 'CANC'.
      SET SCREEN 0.
      LEAVE SCREEN.

    WHEN OTHERS.
      go_inventario->on_user_command( sy-ucomm ).
  ENDCASE.
ENDMODULE.
