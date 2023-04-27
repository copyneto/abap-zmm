FUNCTION zfmmm_roman_status_andmt.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_ROMANEIO) TYPE  ZE_ROMANEIO
*"----------------------------------------------------------------------

  SELECT doc_uuid_h,
         status_ordem
    FROM ztmm_romaneio_in
   WHERE sequence = @iv_romaneio
    INTO @DATA(ls_romaneio)
   UP TO 1 ROWS.
  ENDSELECT.

  IF sy-subrc IS INITIAL.

    IF ls_romaneio-status_ordem EQ '0'
    OR ls_romaneio-status_ordem EQ '1'.
      UPDATE ztmm_romaneio_in SET status_ordem = '2'
                            WHERE doc_uuid_h = ls_romaneio-doc_uuid_h.
      IF sy-subrc IS INITIAL.
        COMMIT WORK.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFUNCTION.
