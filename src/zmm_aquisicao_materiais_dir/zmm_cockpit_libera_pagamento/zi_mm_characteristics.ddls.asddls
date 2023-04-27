@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Caracteísticas Lotes Recebimento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_CHARACTERISTICS
  as select from ZI_MM_CHARACTERISTICS_SELECT

  association to parent ZI_MM_COCKPIT as _Cockpit on  _Cockpit.PurchaseOrder     = $projection.PurchaseOrder
                                                  and _Cockpit.PurchaseOrderItem = $projection.PurchaseOrderItem
                                                  and _Cockpit.BR_NotaFiscal     = $projection.BR_NotaFiscal

  //  association [0..1] to ZI_MM_CHARACTERISTICS_PED as _CharPed   on  _CharPed.PurchaseOrder     = $projection.PurchaseOrder
  //                                                                and _CharPed.PurchaseOrderItem = $projection.PurchaseOrderItem
  //                                                                and _CharPed.BR_NotaFiscal     = $projection.BR_NotaFiscal
  //                                                                and _CharPed.Charg             = $projection.Charg
  //
  //  association [0..1] to ZI_MM_CHARACTERISTICS_PED as _CharReceb on  _CharReceb.PurchaseOrder     = $projection.PurchaseOrder
  //                                                                and _CharReceb.PurchaseOrderItem = $projection.PurchaseOrderItem
  //                                                                and _CharReceb.BR_NotaFiscal     = $projection.BR_NotaFiscal
  //                                                                and _CharReceb.Charg             = $projection.Charg
{
  key PurchaseOrder,
  key PurchaseOrderItem,
  key BR_NotaFiscal,
  key Charg as Charg,
      ViewType,
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
      //      _CharPed.Observacao   as ObservacaoPed,
      //      _CharReceb.Observacao as ObservacaoReceb,
      ''    as Observacao,
      _Cockpit
}
