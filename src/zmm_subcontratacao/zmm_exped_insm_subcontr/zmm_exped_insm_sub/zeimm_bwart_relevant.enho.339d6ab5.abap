"Name: \FU:J_1B_IM_TF_BWART_RELEVANT\SE:BEGIN\EI
ENHANCEMENT 0 ZEIMM_BWART_RELEVANT.
  FIELD-SYMBOLS <fs_app_exp> TYPE xfeld.
  ASSIGN ('(SAPLZFGMM_PICKING)GV_APP_EXP') TO <fs_app_exp>.
  IF <fs_app_exp> IS ASSIGNED AND <fs_app_exp> = abap_true.
    IF i_bwart = '541'.
      e_tf_active = abap_true.
      EXIT.
    ENDIF.
  ENDIF.
ENDENHANCEMENT.
