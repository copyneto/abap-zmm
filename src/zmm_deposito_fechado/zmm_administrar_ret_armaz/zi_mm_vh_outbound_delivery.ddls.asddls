@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Remessa'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_MM_VH_OUTBOUND_DELIVERY
  as select from I_DeliveryDocument
{
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key DeliveryDocument,
      @Search.ranking: #LOW
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      SDDocumentCategory,
      @Search.ranking: #LOW
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      _SDDocumentCategory._Text[1:Language=$session.system_language].SDDocumentCategoryName,
      @Search.ranking: #LOW
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      DeliveryDocumentType,
      @Search.ranking: #LOW
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      _DeliveryDocumentType._Text[1:Language=$session.system_language].DeliveryDocumentTypeName,
      @Search.ranking: #LOW
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      CreatedByUser,
      @Search.ranking: #LOW
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      CreationDate,
      @Search.ranking: #LOW
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      CreationTime
}
