@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Value Help 3C JOB Variante'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
//@Search.searchable: true
define view entity ZI_MM_VH_3C_JOB_VARIANTE
  as select from ZI_MM_3C_NF_FORNECEDORES
  association [0..1] to I_CmmdtyDrvtvOrderUserDetails as _CreatedBy on _CreatedBy.UserID = $projection.CreatedBy

{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @EndUserText.label: 'Nome da Variante'
  key LogExternalId as LogExternalId,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      CreatedAtTs,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      CreatedBy,
      @Search.defaultSearchElement: false
      @Search.fuzzinessThreshold: 0.8
      _CreatedBy.FullName
}
