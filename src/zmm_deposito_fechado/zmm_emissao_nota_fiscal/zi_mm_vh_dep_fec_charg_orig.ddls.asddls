@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Lote'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
//@ObjectModel.resultSet.sizeCategory: #XS

define view entity ZI_MM_VH_DEP_FEC_CHARG_ORIG
  as select from mch1 as _mch1
     inner join  nsdm_e_mchb       as _Lote       on  _Lote.matnr = _mch1.matnr
           
  inner join ztmm_prm_dep_fec as _para on _para.origin_plant = _Lote.werks
                                      and _para.origin_storage_location = _Lote.lgort
    
{
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
    key _mch1.matnr as Material,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
    key _para.origin_plant as plant,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
    key _para.origin_storage_location as storage_location,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
    key _mch1.charg as Batch

  }
  group by
_mch1.matnr,
_para.origin_plant,
_para.origin_storage_location,
_mch1.charg
 