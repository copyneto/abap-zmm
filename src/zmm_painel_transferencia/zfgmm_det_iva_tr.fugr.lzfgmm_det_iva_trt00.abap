*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTMM_DET_IVA_TRA................................*
DATA:  BEGIN OF STATUS_ZTMM_DET_IVA_TRA              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTMM_DET_IVA_TRA              .
CONTROLS: TCTRL_ZTMM_DET_IVA_TRA
            TYPE TABLEVIEW USING SCREEN '0001'.
*...processing: ZTMM_DET_IVA_TRC................................*
DATA:  BEGIN OF STATUS_ZTMM_DET_IVA_TRC              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTMM_DET_IVA_TRC              .
CONTROLS: TCTRL_ZTMM_DET_IVA_TRC
            TYPE TABLEVIEW USING SCREEN '0002'.
*.........table declarations:.................................*
TABLES: *ZTMM_DET_IVA_TRA              .
TABLES: *ZTMM_DET_IVA_TRC              .
TABLES: ZTMM_DET_IVA_TRA               .
TABLES: ZTMM_DET_IVA_TRC               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
