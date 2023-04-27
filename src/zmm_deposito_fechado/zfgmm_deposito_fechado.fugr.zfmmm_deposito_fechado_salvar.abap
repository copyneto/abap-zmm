FUNCTION zfmmm_deposito_fechado_salvar.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_HISTORICO) TYPE  ZCTGMM_HIS_DEP_FEC OPTIONAL
*"     VALUE(IT_SERIE) TYPE  ZCTGMM_HIS_DEP_SER OPTIONAL
*"     VALUE(IT_MSG) TYPE  ZCTGMM_HIS_DEP_MSG OPTIONAL
*"  EXPORTING
*"     VALUE(ET_MESSAGES) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA(lo_events) = NEW zclmm_adm_emissao_nf_events( ).

  lo_events->call_save_background( EXPORTING it_historico = it_historico
                                             it_serie     = it_serie
                                             it_msg       = it_msg
                                   IMPORTING et_return    = et_messages ).



ENDFUNCTION.
