@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Tipo de visão'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.dataCategory: #TEXT
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_MM_VH_VISAO2
  as select from ZI_MM_VH_VISAO
{
      @UI.textArrangement: #TEXT_ONLY
      @ObjectModel.text.element: ['VisionName']
  key VisionId,
      @Semantics.language: true
  key Language,
      @UI.hidden: true
      VisionName,
      /* Associations */
      _Language
}
where
  VisionId <> 'Q'
