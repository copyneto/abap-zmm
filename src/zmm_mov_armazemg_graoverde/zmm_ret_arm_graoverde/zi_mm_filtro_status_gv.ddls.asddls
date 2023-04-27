@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Filtro para campos status'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_FILTRO_STATUS_GV 
  as select from dd07t as _Domain
{
      @ObjectModel.text.element: ['Descricao']
  key _Domain.domvalue_l as Status,
      _Domain.ddtext     as Descricao
}
where
      _Domain.domname    = 'ZD_MM_STATUS_GV'
  and _Domain.ddlanguage = $session.system_language
