@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Value Help de Status - Expedição'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_MM_VH_EXPEDIN_STATUS
  as select from dd07t
{
  key ddtext as Status
}
where
      domname    = 'ZD_SUBCT_STATUS'
  and ddlanguage = $session.system_language
