@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'VH Status Rel de terceiros'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_MM_VH_STATUS_REL_TERC 

  as select from dd07t
{
  key ddtext as Status
}
where
      domname    = 'ZD_MM_STATUS_REL'
  and ddlanguage = $session.system_language
