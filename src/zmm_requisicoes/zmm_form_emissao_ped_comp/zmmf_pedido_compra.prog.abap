*&---------------------------------------------------------------------*
*& Report zmmf_pedido_compra
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmmf_pedido_compra.

TABLES: nast, tnapr.

FORM f_entry_neu USING uv_ent_retco uv_ent_screen.

  uv_ent_retco = NEW zclmm_form_ped_compra( is_nast  = nast
                                            is_tnapr = tnapr
                                            iv_retco = uv_ent_retco )->execute( ).

ENDFORM.
