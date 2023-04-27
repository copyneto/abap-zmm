*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTPLANLOG_PARAM.................................*
DATA:  BEGIN OF STATUS_ZTPLANLOG_PARAM               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTPLANLOG_PARAM               .
CONTROLS: TCTRL_ZTPLANLOG_PARAM
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZTPLANLOG_PARAM               .
TABLES: ZTPLANLOG_PARAM                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
