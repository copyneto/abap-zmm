@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Status geral'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_MM_STATUS_GERAL
  as select from dd07t
{
  key ddtext as Status
}
where
      domname    = 'ZD_STATUS_GERAL_IMOB'
  and ddlanguage = $session.system_language
