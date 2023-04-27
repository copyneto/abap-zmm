@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Help Search: Local Negócios'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_MM_PARAM_VH_BRANCH
  as select from P_BusinessPlace
{

      @Consumption.hidden: true
  key min(bukrs) as CompanyCode,
      @ObjectModel.text.element: ['BusinessPlaceName']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key branch     as BusinessPlace,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      max(name)  as BusinessPlaceName

}
group by
  branch
