*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTMM_REGIO_DIFER................................*
DATA:  BEGIN OF STATUS_ZTMM_REGIO_DIFER              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTMM_REGIO_DIFER              .
CONTROLS: TCTRL_ZTMM_REGIO_DIFER
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZTMM_REGIO_DIFER              .
TABLES: ZTMM_REGIO_DIFER               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
