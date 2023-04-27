*&---------------------------------------------------------------------*
*& Include zmmr_emissao_nf_inventario_f01
*&---------------------------------------------------------------------*

* ======================================================================
* Form: F_START
* ======================================================================
* Start program
* ----------------------------------------------------------------------
FORM f_start.
  "Preenche parametros
  go_inventario->set_ref_data( ).

  "Busca registros
  go_inventario->get_data( ).

ENDFORM.

* ======================================================================
* Form: F_EXPORT_REFERENCIAS
* ======================================================================
* Exporta referências
* ----------------------------------------------------------------------
FORM f_export_referencias.
  "Cria instancia
  go_inventario = zclmm_inventario_fisico=>get_instance( ).

  "Export referencias
  GET REFERENCE OF: s_iblnr[]  INTO go_inventario->gr_iblnr,
                    s_gjahr[]  INTO go_inventario->gr_gjahr,
                    s_werks[]  INTO go_inventario->gr_werks,
                    s_budat[]  INTO go_inventario->gr_budat,
                    s_bldat[]  INTO go_inventario->gr_bldat,
                    s_mblnr[]  INTO go_inventario->gr_mblnr.

ENDFORM.
