*&---------------------------------------------------------------------*
*& Include ZMME_MONIT_IMOBILIZADO
*&---------------------------------------------------------------------*

CONSTANTS: lc_error  TYPE char1    VALUE 'E',
           lc_etapa1 TYPE ze_etapa VALUE '1',
           lc_etapa3 TYPE ze_etapa VALUE '3',
           lc_etapa4 TYPE ze_etapa VALUE '4',
           lc_etapa5 TYPE ze_etapa VALUE '5'.

" Estorno NFe Saída
SELECT *
  FROM ztmm_mov_cntrl
 WHERE docnum_s = @ls_acttab-docnum
  INTO TABLE @DATA(lt_mov_cntrl).

IF sy-subrc IS INITIAL.

  READ TABLE lt_mov_cntrl ASSIGNING FIELD-SYMBOL(<fs_mov_cntrl>) INDEX 1.
  IF sy-subrc IS INITIAL.
    IF <fs_mov_cntrl>-etapa = lc_etapa3.

      CLEAR <fs_mov_cntrl>-docnum_s.
      <fs_mov_cntrl>-etapa          = lc_etapa1.
      <fs_mov_cntrl>-docnum_est_sai = doc_number.
      <fs_mov_cntrl>-status2        = lc_error.

      MODIFY ztmm_mov_cntrl FROM TABLE lt_mov_cntrl.
      COMMIT WORK.

    ENDIF.
  ENDIF.
ENDIF.

" Estorno NFe Entrada
* IF ls_acttab-cancel IS NOT INITIAL
*AND doc_number       IS NOT INITIAL.

SELECT *
  FROM ztmm_mov_cntrl
 WHERE docnum_ent = @ls_acttab-docnum
  INTO TABLE @lt_mov_cntrl.

IF sy-subrc IS INITIAL.

  READ TABLE lt_mov_cntrl ASSIGNING <fs_mov_cntrl> INDEX 1.
  IF sy-subrc IS INITIAL.
    IF <fs_mov_cntrl>-etapa = lc_etapa5.

      CLEAR <fs_mov_cntrl>-docnum_ent.
      CLEAR <fs_mov_cntrl>-docdat.
      <fs_mov_cntrl>-etapa          = lc_etapa4.
      <fs_mov_cntrl>-docnum_est_ent = doc_number.
      <fs_mov_cntrl>-status4        = lc_error.

      MODIFY ztmm_mov_cntrl FROM TABLE lt_mov_cntrl.
      COMMIT WORK.

    ENDIF.
  ENDIF.
ENDIF.
* ENDIF.
