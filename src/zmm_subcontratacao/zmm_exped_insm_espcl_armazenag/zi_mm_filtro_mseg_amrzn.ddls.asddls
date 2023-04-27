@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro MSEG'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_FILTRO_mseg_AMRZN
  as select from nsdm_e_mseg
{
  key mblnr,
  key mjahr,
  key max(zeile) as Zeile
}
group by
  mblnr,
  mjahr
