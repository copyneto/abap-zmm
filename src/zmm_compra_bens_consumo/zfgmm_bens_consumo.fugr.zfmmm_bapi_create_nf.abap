FUNCTION zfmmm_bapi_create_nf.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_NFE_ENTRADA) TYPE  BOOLEAN OPTIONAL
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"     VALUE(EV_DOCNUM) TYPE  J_1BDOCNUM
*"  CHANGING
*"     VALUE(CS_DOCUMENTO) TYPE  ZTMM_MOV_CNTRL
*"----------------------------------------------------------------------

  DATA(lo_bapi) = NEW zclmm_create_nf( ).

  lo_bapi->process(
    EXPORTING
      iv_nfe_entrada = iv_nfe_entrada
    IMPORTING
      ev_docnum   = ev_docnum
      et_return   = et_return                " Mensagens de erro
    CHANGING
      cs_document = cs_documento              " Registro de movimentações e histórico
  ).

  SORT et_return BY type number.

ENDFUNCTION.
