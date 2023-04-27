@AbapCatalog.sqlViewName: 'ZIMM_DF_WERKS_DE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Help Search: Centro'
@Search.searchable: true
define view ZI_MM_VH_DEP_FECH_PLAN_DES
  as select from t001w as _Centro
    inner join ztmm_prm_dep_fec as _para on _para.destiny_plant = _Centro.werks
{
//      @ObjectModel.text.element: ['WerksCodeName']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key _para.origin_plant as OrigWerks,
 //     @ObjectModel.text.element: ['WerksCodeName']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key _para.origin_storage_location as OrigStor,  
      @ObjectModel.text.element: ['WerksCodeName']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key _Centro.werks as WerksCode,
//      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      _Centro.name1 as WerksCodeName
}
group by 
_para.origin_plant,
_para.origin_storage_location,
_Centro.werks,
_Centro.name1

