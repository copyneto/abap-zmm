@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Depósito'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true

define view entity ZI_MM_VH_DEP_FEC_DEP_ORIGEM
  as select from t001l as _t001l
  inner join ztmm_prm_dep_fec as _para on _para.origin_plant = _t001l.werks
                                      and  _para.origin_storage_location = _t001l.lgort
{
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key _t001l.werks as Plant,
      @ObjectModel.text.element: ['StorageLocationText']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key _t001l.lgort as StorageLocation,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      _t001l.lgobe as StorageLocationText
}
group by
_t001l.werks,
_t001l.lgort,
_t001l.lgobe

