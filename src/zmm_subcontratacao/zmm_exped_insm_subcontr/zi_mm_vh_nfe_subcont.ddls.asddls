@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: NFE Subcontratação'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_VH_NFE_SUBCONT
  as select from ZI_MM_EXPED_SUBCONTRAT
{
  key NFENUM
}
where
  NFENUM is not initial
group by
  NFENUM
