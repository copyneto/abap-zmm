FUNCTION zfmmm_integracao_klassmatt.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_PALETIZACAO) TYPE  ZSMM_PALETIZACAO
*"  EXPORTING
*"     VALUE(ES_RETUN) TYPE  ZSMM_CLASSMATT_MSG
*"----------------------------------------------------------------------
  DATA ls_paletizacao TYPE ztmm_paletizacao.
  DATA lv_tstampl     TYPE timestampl.



  SELECT SINGLE matnr, werks, disgr
    FROM marc
    WHERE matnr = @is_paletizacao-material
      AND werks = @is_paletizacao-centro
    INTO @DATA(ls_marc).

  IF sy-subrc <> 0.
    es_retun-tipo = 'E'.
    es_retun-numero = 006.
    es_retun-mensagem = TEXT-006.
    EXIT.
  ENDIF.

  if ls_marc-disgr <> is_paletizacao-tipo_mat.
    es_retun-tipo = 'E'.
    es_retun-numero = 007.
    es_retun-mensagem = TEXT-007.
    EXIT.
  endif.


  SELECT *
    FROM ztmm_paletizacao
    INTO CORRESPONDING FIELDS OF @ls_paletizacao
    WHERE material EQ @is_paletizacao-material
    AND   centro   EQ @is_paletizacao-centro.

    GET TIME STAMP FIELD lv_tstampl.

  ENDSELECT.

  IF ls_paletizacao IS INITIAL.
    ls_paletizacao-created_by = sy-uname.
    ls_paletizacao-created_at = lv_tstampl.
  ENDIF.

  MOVE-CORRESPONDING is_paletizacao TO ls_paletizacao.

  ls_paletizacao-last_changed_by = sy-uname.
  ls_paletizacao-last_changed_at = lv_tstampl.
  ls_paletizacao-local_last_changed_at = lv_tstampl.

  MODIFY ztmm_paletizacao FROM ls_paletizacao.

  IF sy-subrc = 0.
    es_retun-tipo = 'S'.
    es_retun-numero = 001.
    es_retun-mensagem = TEXT-001.
  ELSE.
    es_retun-tipo = 'E'.
    es_retun-numero = 002.
    es_retun-mensagem = TEXT-002.
  ENDIF.

ENDFUNCTION.
