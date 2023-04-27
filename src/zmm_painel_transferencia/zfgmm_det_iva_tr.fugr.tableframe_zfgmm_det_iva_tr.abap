*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZFGMM_DET_IVA_TR
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZFGMM_DET_IVA_TR   .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
