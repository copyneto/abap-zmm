*&---------------------------------------------------------------------*
*& Include          ZMME_RECALC_LPP_SAVE
*&---------------------------------------------------------------------*

*CALL FUNCTION 'ZFMMM_RECALC_LPP'
*  STARTING NEW TASK 'RECALC_LPP'
*  DESTINATION 'NONE'
*  EXPORTING
*    iv_tcode     = sy-tcode
*    iv_docnum    = rf_nf_tec_resp-docnum "VALUE #( gt_recalcorig[ 1 ]-docnum OPTIONAL )
*    iv_docnumber = document_number.

 NEW zclmm_transf_lpp( )->recalc_lpp( iv_docnum = rf_nf_tec_resp-docnum
                                      iv_update = abap_true ).
