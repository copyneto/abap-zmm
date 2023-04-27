FUNCTION ZFMMM_GET_REMESSA_UTILIZACAO_V.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IV_TYPE) TYPE  TRTYP
*"  EXPORTING
*"     REFERENCE(ES_LIPS) TYPE  LIPS
*"----------------------------------------------------------------------

  es_lips-abrvw = gv_abrvw.
  gv_type = iv_type.

ENDFUNCTION.
