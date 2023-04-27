@AbapCatalog.sqlViewName: 'ZMM_MATNR_VH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS VH matnr'
@Search.searchable: true
define view ZI_MM_MATNR_VH 
  as select from makt as _Material
{
      @ObjectModel.text.element: ['MatnrCodeName']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key _Material.matnr as MatnrCode,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      _Material.maktg as MatnrCodeName
//  key _Material.spras
}
where _Material.spras = $session.system_language
