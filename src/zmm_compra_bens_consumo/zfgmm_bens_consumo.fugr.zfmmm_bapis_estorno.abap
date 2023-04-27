FUNCTION zfmmm_bapis_estorno.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"     VALUE(EV_DOCNUM) TYPE  J_1BDOCNUM
*"  CHANGING
*"     VALUE(CS_DOCUMENTO) TYPE  ZTMM_MOV_CNTRL
*"----------------------------------------------------------------------


  DATA(lo_bapi) = NEW zclmm_reverse_bens_cons( ).

  lo_bapi->reverse_process(
    IMPORTING
      et_return       = et_return
    CHANGING
      cs_document     = cs_documento
  ).

  SORT et_return BY type number.

ENDFUNCTION.
