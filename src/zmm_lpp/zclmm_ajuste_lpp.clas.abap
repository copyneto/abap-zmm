class ZCLMM_AJUSTE_LPP definition
  public
  final
  create public .

public section.

  interfaces IF_EX_SAPLJ1BN_EXIT .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_AJUSTE_LPP IMPLEMENTATION.


  METHOD if_ex_saplj1bn_exit~change_units.

    FIELD-SYMBOLS: <fs_lpp> TYPE j_1blpp.

" Única BADI chamada antes do calculo do LPP para evitar Enhancement
    ASSIGN ('(SAPLJ1BLPP)GS_LPP') TO <fs_lpp>.
    IF sy-subrc IS INITIAL
   AND <fs_lpp> IS ASSIGNED.

      CLEAR: <fs_lpp>.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
