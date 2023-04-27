FUNCTION ZFMMM_SET_REMESSA_UTILIZACAO_V.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IS_LIPS) TYPE  LIPS
*"     REFERENCE(IV_TYPE) TYPE  TRTYP
*"----------------------------------------------------------------------

  gv_abrvw = is_lips-abrvw.
  gv_type = iv_type.

ENDFUNCTION.
