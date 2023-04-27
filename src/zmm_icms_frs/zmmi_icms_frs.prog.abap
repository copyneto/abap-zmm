 IF xkomv-kschl = 'ZFTI'.

   frm_kondi_wert-nr = xkomv-kofrm.
   PERFORM (frm_kondi_wert) IN PROGRAM saplv61a IF FOUND.

 ENDIF.
