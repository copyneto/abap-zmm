FUNCTION zfmmm_bapi_goodsmvt.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"  CHANGING
*"     VALUE(CS_DOCUMENTO) TYPE  ZTMM_MOV_CNTRL
*"----------------------------------------------------------------------


  DATA(lo_bapi) = NEW zclmm_goodsmvt_bens_cons( ).

  lo_bapi->process(
    IMPORTING
      es_goodsmvt = DATA(ls_doc)              " MMIM: Estrutura output para MF geral 'regist.movim.mercad.'
      et_return   = et_return                 " Mensagens de erro
    CHANGING
      cs_document = cs_documento              " Registro de movimentações e histórico
  ).

  SORT et_return BY type number.

ENDFUNCTION.
