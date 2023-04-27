@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro do I_SupplierInvoiceItemPurOrdRef'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_RLTPED_FILT_SUPPINVPUR
  as select from I_SupplierInvoiceItemPurOrdRef
{

  key PurchaseOrder            as PurchaseOrder,
  key PurchaseOrderItem        as PurchaseOrderItem,
      max(SupplierInvoice)     as SupplierInvoice,
      FiscalYear               as FiscalYear,
      min(SupplierInvoiceItem) as SupplierInvoiceItem,

      PurchaseOrderQuantityUnit,

      @Semantics: { quantity : {unitOfMeasure: 'PurchaseOrderQuantityUnit'} }
      sum(case
       when DebitCreditCode = 'S' then cast( QuantityInPurchaseOrderUnit as abap.dec( 13, 3 ))
        else cast( QuantityInPurchaseOrderUnit as abap.dec( 13, 3 ) ) * -1
      end )                    as TotalQTD

}
group by
  PurchaseOrder,
  PurchaseOrderItem,
  FiscalYear,
  PurchaseOrderQuantityUnit
