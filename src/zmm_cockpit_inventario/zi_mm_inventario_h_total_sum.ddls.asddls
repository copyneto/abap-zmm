@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit de Iventário - Sum'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_INVENTARIO_H_TOTAL_SUM
  as select from ZI_MM_INVENTARIO_ITEM
{
  key Documentid                                    as Documentid,
      Currency                                      as Currency,
      sum( cast(Quantitystock as abap.dec(13,2)))   as QuantityStock,
      sum( cast(Quantitycount as abap.dec(13,2)))   as QuantityCount,
      sum( cast(Quantitycurrent as abap.dec(13,2))) as QuantityCurrent,
      @Semantics.amount.currencyCode : 'Currency'
      sum( Pricestock )                             as PriceStock,
      @Semantics.amount.currencyCode : 'Currency'
      sum( Pricecount )                             as PriceCount,
      @Semantics.amount.currencyCode : 'Currency'
      sum( Pricediff )                              as PriceDiff,
      sum( cast(abs(Balance) as abap.dec(13,2)))    as CountDiff,
      sum( cast(abs(Weight) as abap.dec(13,2)))     as Weight,
      sum( Accuracy )                               as Accuracy,
      sum( 1.00 )                                   as Lines
}
group by
  Documentid,
  Currency
