*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

* ===========================================================================
* Constantes globais
* ===========================================================================

  CONSTANTS:
    BEGIN OF gc_param_ativa,
      modulo TYPE ztca_param_val-modulo VALUE 'MM',
      chave1 TYPE ztca_param_val-chave1 VALUE 'SUBCONTRATACAO',
      chave2 TYPE ztca_param_val-chave2 VALUE 'ATIVA',
      chave3 TYPE ztca_param_val-chave3 VALUE '',
    END OF gc_param_ativa,

    BEGIN OF gc_param_bwart,
      modulo TYPE ztca_param_val-modulo VALUE 'MM',
      chave1 TYPE ztca_param_val-chave1 VALUE 'SUBCONTRATACAO',
      chave2 TYPE ztca_param_val-chave2 VALUE 'TIPO_MOV',
      chave3 TYPE ztca_param_val-chave3 VALUE '',
    END OF gc_param_bwart.
