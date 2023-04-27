*&---------------------------------------------------------------------*
*& Include          ZMMI_RECALC_LPP_SAVE
*&---------------------------------------------------------------------*

  NEW zclmm_transf_lpp( )->recalc_lpp_save(
    EXPORTING
      is_mseg  = i_mseg
      is_komv  = i_komv
      it_cond  = gt_cond
    CHANGING
      ct_1blpp = gt_recalc  ).
