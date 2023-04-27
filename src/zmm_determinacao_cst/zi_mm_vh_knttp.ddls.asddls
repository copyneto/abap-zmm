@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Categ. Class. Contábil'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_MM_VH_KNTTP
  as select from t163k as _Category
    inner join   t163i as _Text on  _Category.knttp = _Text.knttp
                                and _Text.spras     = $session.system_language
{
      @ObjectModel.text.element: ['AccountAssignmentCategoryName']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key _Category.knttp as AccountAssignmentCategory,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      _Text.knttx     as AccountAssignmentCategoryName
}
