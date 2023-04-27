FUNCTION zfmmm_subc_clear_atrib.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_KEY) TYPE  ZSMM_CHV_PEDNV OPTIONAL
*"----------------------------------------------------------------------

  CHECK is_key IS NOT INITIAL.

  SELECT client,
         ebeln,
         matnr,
         user_proc,
         ebeln_nv,
         qtd_nova,
         dats
    FROM ztmm_remes_pednv
   WHERE ebeln     = @is_key-ebeln
     AND matnr     = @is_key-matnr
     AND user_proc = @sy-uname
    INTO TABLE @DATA(lt_remes).

  SELECT client,
         ebeln,
         matnr,
         user_proc,
         ebeln_nv,
         qtd_nova,
         dats
    FROM ztmm_remes_pednv
   WHERE dats GT @sy-datum
    APPENDING TABLE @lt_remes.

  IF lt_remes[] IS NOT INITIAL.
    DELETE ztmm_remes_pednv FROM TABLE lt_remes.
    IF sy-subrc IS INITIAL.
      COMMIT WORK.
    ENDIF.
  ENDIF.

ENDFUNCTION.
