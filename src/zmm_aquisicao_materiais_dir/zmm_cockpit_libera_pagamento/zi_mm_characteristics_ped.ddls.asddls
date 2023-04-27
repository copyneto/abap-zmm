@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Caracteísticas Lotes Pedidos'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_CHARACTERISTICS_PED
  as select from ZI_MM_CLA_CARAC       as _Carac

    inner join   C_PurchaseOrderItemTP as _Purch on  _Carac.Ebeln = _Purch.PurchaseOrder
                                                 and _Carac.Ebelp = _Purch.PurchaseOrderItem
    inner join   ZC_MM_BR_NF_DOCUMENT  as _NFDoc on  _Carac.Ebeln = _NFDoc.PurchaseOrder
                                                 and _Carac.Ebelp = _NFDoc.PurchaseOrderItem
                                                 
  association to parent ZI_MM_COCKPIT as _Cockpit on  _Cockpit.PurchaseOrder     = $projection.PurchaseOrder
                                                  and _Cockpit.PurchaseOrderItem = $projection.PurchaseOrderItem
                                                  and _Cockpit.BR_NotaFiscal     = $projection.BR_NotaFiscal                                                   
{
  key _Carac.Ebeln                                                                         as PurchaseOrder,
  key _Carac.Ebelp                                                                         as PurchaseOrderItem,
  key _NFDoc.BR_NotaFiscal,
  key _Carac.Charg                                                                         as Charg,
  key _Purch.Material                                                                      as Material,
      _Carac.Vbeln                                                                         as SalesDocument,
      _Carac.Posnr                                                                         as SalesDocumentItem,
      cast( ( cast(_Purch.OrderQuantity as abap.dec(13, 3)) * 60 ) as abap.fltp )          as QuantidadeKg,
      0                                                                                    as QuantidadeKgCriticality,
      cast(_Purch.OrderQuantity as abap.fltp )                                             as QuantidadeSacas,
      0                                                                                    as QuantidadeSacasCriticality,
      cast( division( cast(_Purch.OrderQuantity as abap.dec(13,3)), 60, 3 ) as abap.fltp ) as QuantidadeBag,
      0                                                                                    as QuantidadeBagCriticality,
      _Carac.Peneira10,
      0                                                                                    as Peneira10Criticality,
      _Carac.Peneira11,
      0                                                                                    as Peneira11Criticality,
      _Carac.Peneira12,
      0                                                                                    as Peneira12Criticality,
      _Carac.Peneira13,
      0                                                                                    as Peneira13Criticality,
      _Carac.Peneira14,
      0                                                                                    as Peneira14Criticality,
      _Carac.Peneira15,
      0                                                                                    as Peneira15Criticality,
      _Carac.Peneira16,
      0                                                                                    as Peneira16Criticality,
      _Carac.Peneira17,
      0                                                                                    as Peneira17Criticality,
      _Carac.Peneira18,
      0                                                                                    as Peneira18Criticality,
      _Carac.Peneira19,
      0                                                                                    as Peneira19Criticality,
      _Carac.Mk10,
      0                                                                                    as Mk10Criticality,
      _Carac.Fundo,
      0                                                                                    as FundoCriticality,
      _Carac.Catacao,
      0                                                                                    as CatacaoCriticality,
      _Carac.Umidade,
      0                                                                                    as UmidadeCriticality,
      _Carac.Defeito,
      0                                                                                    as DefeitoCriticality,
      _Carac.Impureza,
      0                                                                                    as ImpurezaCriticality,
      _Carac.Verde,
      0                                                                                    as VerdeCriticality,
      _Carac.PretoArdido,
      0                                                                                    as PretoArdidoCriticality,
      _Carac.Brocado,
      0                                                                                    as BrocadoCriticality,
      _Carac.Densidade,
      0                                                                                    as DensidadeCriticality,
      _Carac.Observacao,
      
      _Cockpit
}
