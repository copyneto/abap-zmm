@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Value Help Processo Grão Verde'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_VH_ARMZGRV_PROCESS
  as select from dd07t
{
  key domvalue_l as Process,
      ddtext     as Descricao
}
where
      domname    = 'ZD_MM_PROCESSO_MATNR'
  and ddlanguage = $session.system_language
