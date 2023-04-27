*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTMM_RED_PISCOF.................................*
DATA:  BEGIN OF STATUS_ZTMM_RED_PISCOF               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTMM_RED_PISCOF               .
CONTROLS: TCTRL_ZTMM_RED_PISCOF
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZTMM_RED_PISCOF               .
TABLES: ZTMM_RED_PISCOF                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
