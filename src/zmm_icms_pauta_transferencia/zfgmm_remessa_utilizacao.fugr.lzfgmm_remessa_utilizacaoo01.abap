*----------------------------------------------------------------------*
***INCLUDE LZFGMM_REMESSA_UTILIZACAOO01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module MODE_EDIT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE mode_edit OUTPUT.
*A  Exibir
*B  Processar
*C  Exibir a partir do arquivo
*E  Planejamento individual MRP
*H  Inserir
*V  Modificar
*X  Transação inicial
*S  Parâmetros standard: modo normal
*U  Converter ordem planej.individual
*L  Eliminar
*P  Marcação para planejamento

  LOOP AT SCREEN .

    IF gv_type = 'V'.
      "screen-active = 1.
      screen-input = 1.
    ELSE.
      "screen-active = 0.
      screen-input = 0.
    ENDIF.

    MODIFY SCREEN.

  ENDLOOP.


ENDMODULE.
