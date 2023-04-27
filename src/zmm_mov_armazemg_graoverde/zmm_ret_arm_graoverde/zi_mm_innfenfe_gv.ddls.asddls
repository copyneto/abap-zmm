@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Filtro para campos status'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_INNFENFE_GV 
  as select from /xnfe/innfenfe as _innfenfe
{
  key guid_header as GuidHeader,
  substring(access_key, 1, 2) as regio,
  substring(access_key, 3, 2) as nfyear,
  substring(access_key, 5, 2) as nfmonth,
  substring(access_key, 7, 14) as stcd1,
  substring(access_key, 21, 2) as model,
  substring(access_key, 26, 9) as nfnum9
}
