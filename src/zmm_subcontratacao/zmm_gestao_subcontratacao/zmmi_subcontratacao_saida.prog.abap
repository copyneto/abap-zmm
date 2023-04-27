*&---------------------------------------------------------------------*
*& Include          ZMMI_SUBCONTRATACAO_SAIDA
*&---------------------------------------------------------------------*

* ----------------------------------------------------------------------
* Enhancement: J_1BNFE_RETURN_OF_COMPONENTS-fill_imseg_component_return
* ----------------------------------------------------------------------

* ---------------------------------------------------------------------------
* Gestão de subcontratação - Tipo de movimento
* ---------------------------------------------------------------------------
TRY.

    DATA(lo_subcontratacao) = zclmm_gestao_subcontratacao=>get_instance( ).

    lo_subcontratacao->determine_movement_type( EXPORTING it_nfe_in_item = it_nfe_in_item[]
                                                          iv_bwart       = iv_bwart
                                                CHANGING  ct_imseg       = et_imseg[]
                                                          ct_bapiret2    = et_bapiret2[] ).

  CATCH cx_root INTO DATA(lo_root).
ENDTRY.
