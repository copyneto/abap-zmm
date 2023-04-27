@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro de Active x NFE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_FILTRO_ACTIVE
  as select from j_1bnfe_active
{
  key max(docnum) as Docnum,
      regio,
      nfyear,
      nfmonth,
      stcd1,
      model,
      nfnum9
}
where
      action_requ =  'C'
  and cancel      <> 'X'
group by
  regio,
  nfyear,
  nfmonth,
  stcd1,
  model,
  nfnum9
