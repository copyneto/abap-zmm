*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

* ===========================================================================
* CONSTANTES
* ===========================================================================

CONSTANTS:

  BEGIN OF gc_cds,
    piscofins TYPE string VALUE 'PISCOFINS',          " PIS/COFINS
  END OF gc_cds,

  BEGIN OF gc_param_ativo,
    modulo TYPE ztca_param_val-modulo VALUE 'MM'             ##NO_TEXT,
    chave1 TYPE ztca_param_val-chave1 VALUE 'REDETERMINACAO' ##NO_TEXT,
    chave2 TYPE ztca_param_val-chave2 VALUE 'PISCOFINS'      ##NO_TEXT,
    chave3 TYPE ztca_param_val-chave3 VALUE 'ATIVO'          ##NO_TEXT,
  END OF gc_param_ativo.
