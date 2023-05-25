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
      abs( PriceDiff )                                                     as PriceDiff,
      @Semantics.amount.currencyCode : 'Currency'
      PriceStock,
      //      fltp_to_dec( (( cast( 1 as abap.fltp ) - ( cast( PriceStock as abap.fltp ) / cast( PriceDiff as abap.fltp ) ) ) * cast( 100 as abap.fltp ) ) as abap.dec(11,2) ) as Accuracy,
      fltp_to_dec( cast( Accuracy as abap.fltp) / Lines as abap.dec(13,2)) as Accuracy,
      Lines

}
