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
                                                                     
  
  left outer join j_1bbrancht                as _text           on        P_BusinessPlace.bukrs  = _text.bukrs
                                                                      and P_BusinessPlace.branch = _text.branch
                                                                      and _text.bupla_type   = ''
                                                                      and _text.language   = $session.system_language  
{

      @Consumption.hidden: true
  key min(P_BusinessPlace.bukrs) as CompanyCode,
      @ObjectModel.text.element: ['BusinessPlaceName']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key P_BusinessPlace.branch     as BusinessPlace,
      @Semantics.text: true
//      @Search.defaultSearchElement: true
//      @Search.ranking: #HIGH
//      @Search.fuzzinessThreshold: 0.7
      max(P_BusinessPlace.name)  as BusinessPlaceName,     
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      @UI.hidden: true      
      _text.name as name_filter       

}
group by
  P_BusinessPlace.branch,  
  _text.name
