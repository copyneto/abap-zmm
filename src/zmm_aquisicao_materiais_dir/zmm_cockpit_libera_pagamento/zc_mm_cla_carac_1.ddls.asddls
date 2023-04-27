@AbapCatalog.sqlViewName: 'ZVCMMCLACARAC1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Pedido de Compra, Lotes e Romaneio'
define view ZC_MM_CLA_CARAC_1
  as select from ZI_MM_CLA_CARAC          as _Carac
    inner join   ZC_MM_CLA_BATCH_ROMANEIO as _Batch on _Carac.Ebeln = _Batch.PurchaseOrder
    inner join   C_PurchaseOrderItemTP    as _Purch on _Carac.Ebeln = _Purch.PurchaseOrder
    inner join   ZC_MM_ACCOUNT_DOCUMENT   as _Acc   on  _Carac.Ebeln = _Acc.PurchaseOrder
                                                    and _Carac.Ebelp = _Acc.PurchaseOrderItem
    inner join   ZC_MM_BR_NF_DOCUMENT     as _NFDoc on  _Carac.Ebeln = _NFDoc.PurchaseOrder
                                                    and _Carac.Ebelp = _NFDoc.PurchaseOrderItem
{
  key Ebeln                                                        as PurchaseOrder,
  key Ebelp                                                        as PurchaseOrderItem,
  key _Acc.ReferencedDocument,
  key _NFDoc.BR_NotaFiscal,
  key Charg,
  key '1'                                                          as ViewType,
      Vbeln                                                        as SalesDocument,
      Posnr                                                        as SalesDocumentItem,
      cast( ( _Purch.OrderQuantity * 60 ) as abap.fltp )           as QuantidadeKg,
      cast(_Purch.OrderQuantity as abap.fltp )                     as QuantidadeSacas,
      cast( division( _Purch.OrderQuantity, 60, 3 ) as abap.fltp ) as QuantidadeBag,
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
