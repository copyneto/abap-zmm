FUNCTION ZFMMM_CRIAR_DOCUMENTO.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_HIS_DEP_FEC) TYPE  ZCTGMM_HIS_DEP_FEC
*"----------------------------------------------------------------------

    CHECK IT_HIS_DEP_FEC IS NOT INITIAL.
    data(lt_his_dep_fec)  = IT_HIS_DEP_FEC.

    MODIFY ztmm_his_dep_fec FROM  TABLE lt_his_dep_fec.
    WAIT UP TO 5 SECONDS.

    DATA(lr_adm_emissao_nf_events) = NEW zclmm_adm_emissao_nf_events( ).
    lr_adm_emissao_nf_events->bapi_create_documents(
      EXPORTING
        it_historico_key = lt_his_dep_fec
*       iv_update_history = abap_true
      IMPORTING
        et_return        = DATA(lt_return_po)
    ).

    lr_adm_emissao_nf_events->job_delivery(
      EXPORTING
        iv_status = '10'
      IMPORTING
        et_return = DATA(lt_return_delivery)
    ).

    APPEND LINES OF lt_return_po TO lt_return_delivery.

ENDFUNCTION.
