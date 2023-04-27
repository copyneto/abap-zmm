*&---------------------------------------------------------------------*
*& Include zmmr_emissao_nf_inventario_o01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_9000 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_9000 OUTPUT.
  "Criar AUTORITY-CHECK PARA BOTÕES
*  AUTHORITY-CHECK OBJECT 'F_BKPF_BUK'
*      ID 'BUKRS' FIELD gv_bukrs
*      ID 'ACTVT' FIELD '1'.
*
*  IF sy-subrc NE 0.
*    APPEND 'GERAR_NOTA' TO it_excluding.
*  ENDIF.

  SET PF-STATUS 'D9000'." EXCLUDING lt_status.
  SET TITLEBAR 'TITLE_INV'.

  go_inventario->process_data( ).
ENDMODULE.
