@AbapCatalog.viewEnhancementCategory: [#NONE]
@EndUserText.label: 'Ajuda de pesquisa para Pedido de Compras'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_MM_VH_PEDIDO
  as select from I_PurchaseOrderAPI01
{
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key PurchaseOrder,
      PurchaseOrderType,
      PurchaseOrderSubtype,
      PurchasingDocumentOrigin,
      CreatedByUser,
      CreationDate,
      PurchaseOrderDate,
      Language,
      CorrespncExternalReference,
      CorrespncInternalReference,
      PurchasingDocumentDeletionCode,
      ReleaseIsNotCompleted,
      PurchasingCompletenessStatus,
      PurchasingProcessingStatus,
      PurgReleaseSequenceStatus,
      ReleaseCode,
      CompanyCode,
      PurchasingOrganization,
      PurchasingGroup,
      Supplier
}
