@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit de Iventário - Estoque Atual'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_INVENTARIO_ESTOQUE_TOTAL
  as select from I_MaterialStock
{
  key Material,
  key Plant,
  key StorageLocation,
  key Batch,
      cast( MaterialBaseUnit as meins)                                as MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum( cast(MatlWrhsStkQtyInMatlBaseUnit as ze_quantity_current)) as EstoqueAtual
}
group by
  Material,
  Plant,
  StorageLocation,
  Batch,
  MaterialBaseUnit
