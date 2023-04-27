@AbapCatalog.sqlViewName: 'ZVCMMCLACARAC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Pedido de Compra, Lotes e Romaneio'
define view ZC_MM_CLA_CARAC
  as select from ZC_MM_CLA_CARAC_1 as _Carac1
{
  key PurchaseOrder,
  key PurchaseOrderItem,
  key ReferencedDocument,
  key BR_NotaFiscal,
  key Charg,
  key ViewType,
      SalesDocument,
      SalesDocumentItem,
      QuantidadeKg,
      QuantidadeSacas,
      QuantidadeBag,
      Peneira10,
      Peneira11,
      Peneira12,
      Peneira13,
      Peneira14,
      Peneira15,
      Peneira16,
      Peneira17,
      Peneira18,
      Peneira19,
      Mk10,
      Fundo,
      Catacao,
      Umidade,
      Defeito,
      Impureza,
      Verde,
      PretoArdido,
      Brocado,
      Densidade,
      Observacao

}
union all select from ZC_MM_CLA_CARAC_2
{
  key PurchaseOrder,
  key PurchaseOrderItem,
  key ReferencedDocument,
  key BR_NotaFiscal,
  key Charg,
  key ViewType,
      SalesDocument,
      SalesDocumentItem,
      QuantidadeKg,
      QuantidadeSacas,
      QuantidadeBag,
      Peneira10,
      Peneira11,
      Peneira12,
      Peneira13,
      Peneira14,
      Peneira15,
      Peneira16,
      Peneira17,
      Peneira18,
      Peneira19,
      Mk10,
      Fundo,
      Catacao,
      Umidade,
      Defeito,
      Impureza,
      Verde,
      PretoArdido,
      Brocado,
      Densidade,
      Observacao
}
