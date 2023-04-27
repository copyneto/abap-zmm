*&---------------------------------------------------------------------*
*& Include          ZMMI_DEPOSITO_FECHADO_MIRO
*&---------------------------------------------------------------------*
*value( I_RBKPV ) TYPE MRM_RBKPV  Invoice Document Header
*value( TI_DRSEG )  TYPE MMCR_TDRSEG  Invoice Document Item
*value( TE_RBWS )	TYPE MRM_TAB_RBWS	Withholding Tax
*value( TE_RBVS )	TYPE MRM_T_RBVS	Supplier Split
*value( E_QSSKZ )	TYPE RBKP-QSSKZ	Withholding tax code

if SY-UCOMM = 'BU'.
  ASSIGN ('(SAPLMRMC)XPOST_PREPARE') to FIELD-SYMBOL(<fs_XPOST_PREPARE>).

  if <fs_XPOST_PREPARE> is ASSIGNED.
    if <fs_XPOST_PREPARE> = abap_true.

      data(lo_dep_fechado) = new zclmm_deposito_fechado_miro( ).

      lo_dep_fechado->process_deposito_fechado(
                                                EXPORTING
                                                Is_RBKPV  = I_RBKPV
                                                It_DRSEG  = TI_DRSEG
                                                it_RBWS   = TE_RBWS
                                                it_RBVS   = TE_RBvs
                                                iv_QSSKZ  = E_QSSKZ ).
    endif.
  endif.
endif.
