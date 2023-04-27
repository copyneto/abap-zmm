@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro C_GRIRPurchaseOrderHistory'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_RLTPED_FILT_PURORDHIS
  as select from C_GRIRPurchaseOrderHistory
{
  key PurchasingDocument               as PurchasingDocument,
  key PurchasingDocumentItem           as PurchasingDocumentItem,
      OrderQuantityUnit,

      @Semantics: { quantity : {unitOfMeasure: 'OrderQuantityUnit'} }
      sum(case
       when DebitCreditCode = 'S' then cast(Quantity as abap.dec( 13, 3 ) )
        else cast(Quantity as abap.dec( 13, 3 ) ) * -1
      end )                            as Quantity,

      @Semantics: { quantity : {unitOfMeasure: 'OrderQuantityUnit'} }
      sum(QtyInPurchaseOrderPriceUnit) as QtyInPurchaseOrderPriceUnit
}
group by
  PurchasingDocument,
  PurchasingDocumentItem,
  OrderQuantityUnit
