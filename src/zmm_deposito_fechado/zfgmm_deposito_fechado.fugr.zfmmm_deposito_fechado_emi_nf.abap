FUNCTION zfmmm_deposito_fechado_emi_nf.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IT_HISTORICO_KEY) TYPE  ZCTGMM_HIS_DEP_FEC
*"  EXPORTING
*"     VALUE(ET_MESSAGES) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA(lo_events) = NEW zclmm_adm_emissao_nf_events( ).

  lo_events->bapi_create_documents( EXPORTING it_historico_key = it_historico_key
                                    IMPORTING et_return        = et_messages ).

ENDFUNCTION.
