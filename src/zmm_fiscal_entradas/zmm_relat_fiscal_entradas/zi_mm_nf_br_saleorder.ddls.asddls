@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ordem de Venda'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_NF_BR_SALEORDER
  as select from ZI_MM_NF_BR_SALEORDER_LAST as NFItem

  association [0..1] to I_SalesDocument as _Header on  _Header.SalesDocument = $projection.Ordem
  association [0..1] to vbap            as _Item   on  _Item.vbeln = $projection.Ordem
                                                   and _Item.posnr = $projection.OrdemItem

{
  key NFItem.BR_NotaFiscal                            as BR_NotaFiscal,
  key NFItem.BR_NotaFiscalItem                        as BR_NotaFiscalItem,
      NFItem.Fatura                                   as Fatura,
      NFItem.FaturaItem                               as FaturaItem,
      cast( left(OrdemHeaderItem, 10) as vbeln_von )  as Ordem,
      cast( right(OrdemHeaderItem, 6) as posnr_von  ) as OrdemItem,
      _Header,
      _Item
}
