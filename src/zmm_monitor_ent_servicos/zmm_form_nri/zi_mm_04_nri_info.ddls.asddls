@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'VIEW - NRI INFO'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_04_NRI_INFO
  as select from I_SuplrInvcItemPurOrdRefAPI01 as _pur01
    inner join   I_SupplierInvoiceAPI01        as _inv01 on  _inv01.SupplierInvoice = _pur01.SupplierInvoice
                                                         and _inv01.FiscalYear      = _pur01.FiscalYear
    inner join   I_MaterialDocumentItem        as _mat   on  _mat.MaterialDocument     = _pur01.ReferenceDocument
                                                         and _mat.MaterialDocumentYear = _pur01.ReferenceDocumentFiscalYear

{
//  _pur01.SupplierInvoice,
  _pur01.FiscalYear,
  _pur01.PurchaseOrder,
  _pur01.PurchaseOrderItem,
  _inv01.SupplierInvoiceIDByInvcgParty,
  _mat.Batch,
  _mat.Plant
//  _mat.StorageLocation,
//  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
//  _mat.QuantityInBaseUnit,
//  _mat.MaterialBaseUnit
}
