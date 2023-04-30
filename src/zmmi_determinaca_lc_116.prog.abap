*&---------------------------------------------------------------------*
*& Include          ZMMI_DETERMINACA_LC_116
*&---------------------------------------------------------------------*

CONSTANTS: lc_mm        TYPE ztca_param_par-modulo VALUE 'MM',
           lc_chave1_co TYPE ztca_param_par-chave1 VALUE 'COCKPIT_FRETE',
           lc_chave2_lc TYPE ztca_param_par-chave2 VALUE 'LC_116',
           lc_chave3_ny TYPE ztca_param_par-chave3 VALUE 'NFTYPE'.

DATA lr_nf_type_mm TYPE RANGE OF j_1bnfdoc-nftype .

DATA(lo_param_mm) = NEW zclca_tabela_parametros( ).
TRY.
    lo_param_mm->m_get_range(
      EXPORTING
        iv_modulo = lc_mm
        iv_chave1 = lc_chave1_co
        iv_chave2 = lc_chave2_lc
        iv_chave3 = lc_chave3_ny
      IMPORTING
        et_range  = lr_nf_type_mm
    ).
  CATCH zcxca_tabela_parametros.
ENDTRY.

IF lr_nf_type_mm IS NOT INITIAL.
  IF ls_nfdoc-nftype IN lr_nf_type_mm.
    LOOP AT ct_nflin ASSIGNING FIELD-SYMBOL(<fs_nflin>).

      " Validação de cenário de frete
      CHECK <fs_nflin>-matnr IS INITIAL.

      CLEAR <fs_nflin>-nbm.

    ENDLOOP.
  ENDIF.
ENDIF.
