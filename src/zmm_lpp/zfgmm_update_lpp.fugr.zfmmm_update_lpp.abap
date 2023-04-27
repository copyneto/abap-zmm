FUNCTION zfmmm_update_lpp.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_LPP) TYPE  ZCTGMM_J_1BLPP OPTIONAL
*"----------------------------------------------------------------------

  DATA: lt_lpp TYPE zctgmm_j_1blpp.

  CHECK it_lpp[] IS NOT INITIAL.

  lt_lpp[] = it_lpp[].

  CALL FUNCTION 'J_1B_LPP_UPDATE'
    TABLES
      i_lpp = lt_lpp.

  COMMIT WORK.

ENDFUNCTION.
