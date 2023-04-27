"Name: \FU:J_1B_NF_CFOP_2_DETERMINATION\SE:END\EI
ENHANCEMENT 0 ZEIMM_CHANGE_VALUES.

* ---------------------------------------------------------------------------
* Processo de Depósito Fechado
* ---------------------------------------------------------------------------
TRY.
    NEW zclmm_change_values( )->change_cfop( CHANGING cv_cfop = cfop  ).
  CATCH cx_root.
ENDTRY.

ENDENHANCEMENT.
