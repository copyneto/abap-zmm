*&---------------------------------------------------------------------*
*& Include ZMME_RECALC_LPP
*&---------------------------------------------------------------------*

CALL FUNCTION 'ZFMMM_RECALC_LPP'
  STARTING NEW TASK 'RECALC_LPP'
  DESTINATION 'NONE'
  EXPORTING
    iv_docnum    = ls_acttab-docnum
    iv_docnumber = doc_number.
