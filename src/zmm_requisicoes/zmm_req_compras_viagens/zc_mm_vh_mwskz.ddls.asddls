@AbapCatalog.sqlViewName: 'ZC_MM_MWSKZ'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Value Help: Código IVA'
define view ZC_MM_VH_MWSKZ
  as select from ZI_CA_VH_MWSKZ
{
      @UI.hidden: true
  key kalsm,
      @ObjectModel.text.element: ['IVACodeName']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key IVACode,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      IVACodeName
}
where
  kalsm = 'TAXBRA'
