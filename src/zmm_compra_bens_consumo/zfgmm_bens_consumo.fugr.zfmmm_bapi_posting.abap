FUNCTION zfmmm_bapi_posting.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"     VALUE(EV_OBJ_KEY) TYPE  BAPIACHE09-OBJ_KEY
*"  CHANGING
*"     VALUE(CS_DOCUMENTO) TYPE  ZTMM_MOV_CNTRL
*"----------------------------------------------------------------------


  DATA(lo_bapi) = NEW zclmm_document_post( ).

  lo_bapi->process(
    IMPORTING
      et_return   = et_return                 " Mensagens de erro
      ev_obj_key  = ev_obj_key
    CHANGING
      cs_document = cs_documento              " Registro de movimentações e histórico
  ).

  SORT et_return BY type number.

ENDFUNCTION.
