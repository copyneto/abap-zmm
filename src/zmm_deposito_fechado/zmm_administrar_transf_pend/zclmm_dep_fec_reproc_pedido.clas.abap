CLASS zclmm_dep_fec_reproc_pedido DEFINITION PUBLIC FINAL CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      executar
        RETURNING
          VALUE(rt_retorno) TYPE bapiret2_t.

  PRIVATE SECTION.
    TYPES:
      tt_dep_fec_hist TYPE STANDARD TABLE OF ztmm_his_dep_fec WITH EMPTY KEY.

    METHODS:
      selecionar_doc_gerar_pedido
        RETURNING
          VALUE(rt_retorno) TYPE tt_dep_fec_hist,

      processar_documentos
        IMPORTING
          it_his_dep_fec    TYPE zclmm_adm_emissao_nf_events=>ty_t_historico
        RETURNING
          VALUE(rt_retorno) TYPE bapiret2_t.
ENDCLASS.



CLASS zclmm_dep_fec_reproc_pedido IMPLEMENTATION.
  METHOD executar.
    rt_retorno = processar_documentos( selecionar_doc_gerar_pedido( ) ).
  ENDMETHOD.

  METHOD selecionar_doc_gerar_pedido.
    SELECT * FROM ztmm_his_dep_fec
    WHERE process_step = 'F06'
      AND status = '10'
      AND main_purchase_order IS NOT INITIAL
      AND purchase_order IS INITIAL
    INTO TABLE @rt_retorno.
  ENDMETHOD.

  METHOD processar_documentos.
    CHECK it_his_dep_fec IS NOT INITIAL.

    DATA(lr_adm_emissao_nf_events) = NEW zclmm_adm_emissao_nf_events( ).
    lr_adm_emissao_nf_events->bapi_create_documents(
      EXPORTING
        it_historico_key = it_his_dep_fec
      IMPORTING
        et_return        = DATA(lt_return_po)
    ).
    lr_adm_emissao_nf_events->job_delivery(
      EXPORTING
        it_historico_key = it_his_dep_fec
        iv_status = '10'
      IMPORTING
        et_return = DATA(lt_return_delivery)
    ).
    APPEND LINES OF lt_return_po       TO rt_retorno.
    APPEND LINES OF lt_return_delivery TO rt_retorno.
  ENDMETHOD.
ENDCLASS.
