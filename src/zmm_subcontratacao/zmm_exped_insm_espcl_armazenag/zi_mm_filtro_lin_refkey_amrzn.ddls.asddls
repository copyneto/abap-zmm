@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro de REFKEY'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_FILTRO_LIN_REFKEY_AMRZN
  as select from j_1bnflin
{
  key max(docnum) as docnum,
  key max(itmnum) as itmnum,
      refkey
}
group by
  refkey
