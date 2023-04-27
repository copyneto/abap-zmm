FUNCTION zfmmm_bapi_order_simulate.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"     VALUE(ES_TAXES) TYPE  ZTMM_MOV_SIMUL
*"  CHANGING
*"     VALUE(CS_DOCUMENTO) TYPE  ZTMM_MOV_CNTRL
*"----------------------------------------------------------------------


  DATA(lo_bapi) = NEW zclmm_order_simulate( ).

  lo_bapi->process(
    IMPORTING
      et_return   = et_return                 " Mensagens de erro
      et_taxes    = DATA(lt_taxes)
      es_taxes    = es_taxes
    CHANGING
      cs_document = cs_documento                 " Registro de movimentações e histórico
  ).

  SORT et_return BY type number.

ENDFUNCTION.
