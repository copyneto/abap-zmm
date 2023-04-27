@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Value Help de Material - Expedição'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_MM_VH_EXPEDIN_MATNR
  as select from ZI_MM_EXPEDINSUM_ESPC_SUBCONTR

  association [0..1] to makt as _Makt on  _Makt.matnr = $projection.Matnr
                                      and _Makt.spras = $session.system_language

{
      @ObjectModel.text.element: ['DesMat']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key Matnr       as Matnr,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      _Makt.maktx as DesMat
}
group by
  Matnr,
  _Makt.maktx
