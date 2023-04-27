FUNCTION zfmmm_devolucao_vendas.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_HIS_DEP_FEC) TYPE  ZTMM_HIS_DEP_FEC ##ENH_OK
*"----------------------------------------------------------------------

  CONSTANTS:
    lc_status_centro_faturamento TYPE ze_mm_df_status VALUE '10'.

  MODIFY ztmm_his_dep_fec FROM is_his_dep_fec.
  WAIT UP TO 1 SECONDS.

  DATA(lr_adm_emissao_nf_events) = NEW zclmm_adm_emissao_nf_events( ).
  lr_adm_emissao_nf_events->bapi_create_documents(
    EXPORTING
      it_historico_key  = VALUE #( ( is_his_dep_fec ) )
*                iv_update_history = abap_true
    IMPORTING
      et_return         = DATA(lt_return_po)
  ).

  lr_adm_emissao_nf_events->job_delivery(
    EXPORTING
      iv_status = lc_status_centro_faturamento
    IMPORTING
      et_return = DATA(lt_return_delivery)
  ).



ENDFUNCTION.
