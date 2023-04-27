*&---------------------------------------------------------------------*
*& Include          ZMMI_SUBCONTRATACAO_SAIDA_CODE
*&---------------------------------------------------------------------*

* ----------------------------------------------------------------------
* Enhancement: J_1BNFE_RETURN_OF_COMPONENTS-create_goods_movement
* ----------------------------------------------------------------------

* ---------------------------------------------------------------------------
* Gestão de subcontratação - Transação da BAPI
* ---------------------------------------------------------------------------
TRY.

    DATA(lo_subcontratacao) = zclmm_gestao_subcontratacao=>get_instance( ).

    GET REFERENCE OF i_tcode INTO DATA(lo_tcode).

    lo_subcontratacao->determine_tcode( EXPORTING it_imseg = it_imseg[]
                                        CHANGING  cv_tcode = lo_tcode->* ).

  CATCH cx_root INTO DATA(lo_root).
ENDTRY.
