@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Consumo Características Pedido'
@Metadata.allowExtensions: true
define view entity ZC_MM_CHARACTERISTICS_PED as projection on ZI_MM_CHARACTERISTICS_PED
{
    key PurchaseOrder,
    key PurchaseOrderItem,
    key BR_NotaFiscal,
    key Charg,
    key Material,
    SalesDocument,
    SalesDocumentItem,
    QuantidadeKg,
    QuantidadeKgCriticality,
    QuantidadeSacas,
    QuantidadeSacasCriticality,
    QuantidadeBag,
    QuantidadeBagCriticality,
    Peneira10,
    Peneira10Criticality,
    Peneira11,
    Peneira11Criticality,
    Peneira12,
    Peneira12Criticality,
    Peneira13,
    Peneira13Criticality,
    Peneira14,
    Peneira14Criticality,
    Peneira15,
    Peneira15Criticality,
    Peneira16,
    Peneira16Criticality,
    Peneira17,
    Peneira17Criticality,
    Peneira18,
    Peneira18Criticality,
    Peneira19,
    Peneira19Criticality,
    Mk10,
    Mk10Criticality,
    Fundo,
    FundoCriticality,
    Catacao,
    CatacaoCriticality,
    Umidade,
    UmidadeCriticality,
    Defeito,
    DefeitoCriticality,
    Impureza,
    ImpurezaCriticality,
    Verde,
    VerdeCriticality,
    PretoArdido,
    PretoArdidoCriticality,
    Brocado,
    BrocadoCriticality,
    Densidade,
    DensidadeCriticality,
    Observacao,
    /* Associations */
    _Cockpit : redirected to parent ZC_MM_COCKPIT    
}