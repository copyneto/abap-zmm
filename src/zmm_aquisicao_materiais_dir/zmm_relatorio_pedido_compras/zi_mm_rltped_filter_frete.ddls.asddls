@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro de Frete'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_RLTPED_FILTER_FRETE
  as select from ekbe
{

  key ebeln as Ebeln,
  key ebelp as Ebelp,
      'X'   as Frete

}
where
      vgabe = '3'
  and bewtp = 'N'

group by
  ebeln,
  ebelp
