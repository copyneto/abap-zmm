*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVMM_FCI........................................*
TABLES: ZVMM_FCI, *ZVMM_FCI. "view work areas
CONTROLS: TCTRL_ZVMM_FCI
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVMM_FCI. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVMM_FCI.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVMM_FCI_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVMM_FCI.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVMM_FCI_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVMM_FCI_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVMM_FCI.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVMM_FCI_TOTAL.

*.........table declarations:.................................*
TABLES: ZTMM_FCI                       .
