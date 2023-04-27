@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit de Inventário - Total'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_INVENTARIO_H_TOTAL
  as select from ZI_MM_INVENTARIO_H_TOTAL_SUM
{

  key Documentid,
      Currency,
      QuantityStock,
      QuantityCount,
      QuantityCurrent,
      CountDiff,
      Weight,     
      @Semantics.amount.currencyCode : 'Currency'
      PriceCount,
      @Semantics.amount.currencyCode : 'Currency'
      abs( PriceDiff )                                                      as PriceDiff,
      @Semantics.amount.currencyCode : 'Currency'
      PriceStock,
      fltp_to_dec( cast( Accuracy as abap.fltp) / Lines as abap.dec(13,2)) as Accuracy,
      Lines

}
