@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Soma do Campo ZMENG da VBAP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_ZMENG_SUM
  as select from vbap
{
  key vbeln      as Vbeln,
      zieme      as Zieme,
      @Semantics.quantity.unitOfMeasure : 'Zieme'
      sum(zmeng) as sunZMENGE

}
group by
  vbeln,
  zieme
