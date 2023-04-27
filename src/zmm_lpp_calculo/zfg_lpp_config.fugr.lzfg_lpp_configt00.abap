*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVMM_MAP_COND...................................*
TABLES: ZVMM_MAP_COND, *ZVMM_MAP_COND. "view work areas
CONTROLS: TCTRL_ZVMM_MAP_COND
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVMM_MAP_COND. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVMM_MAP_COND.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVMM_MAP_COND_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVMM_MAP_COND.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVMM_MAP_COND_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVMM_MAP_COND_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVMM_MAP_COND.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVMM_MAP_COND_TOTAL.

*.........table declarations:.................................*
TABLES: T685                           .
TABLES: T685T                          .
TABLES: ZTMM_MAP_COND                  .
