@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Modalidade Frete'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true 
define view entity ZI_MM_VH_DF_MODALIDADE_FRETE
  as select from    tinc as Domain
    left outer join tinct as _Text on  _Text.spras    = $session.system_language
                                   and _Text.inco1   = Domain.inco1
{
      @ObjectModel.text.element: ['FreightModeText']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key cast( Domain.inco1 as ze_mm_freight_mode ) as FreightMode,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      _Text.bezei                                   as FreightModeText

}
