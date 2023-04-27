@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Fornecimento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_FORNECIMENTO
  as select from I_DeliveryDocumentItem as DeliveryDocumentItem //LIPS

  association [0..1] to I_DeliveryDocument       as _DeliveryDocument       on  $projection.DeliveryDocument = _DeliveryDocument.DeliveryDocument

  association [0..1] to I_MaterialDocumentRecord as _MaterialDocumentRecord on  $projection.ReferenceSDDocument                = _MaterialDocumentRecord.PurchaseOrder
                                                                            and $projection.ReferenceSDDocumentItem            = _MaterialDocumentRecord.PurchaseOrderItem
                                                                            and $projection.DeliveryDocument                   = _MaterialDocumentRecord.DeliveryDocument
                                                                            and $projection.DeliveryDocumentItem               = _MaterialDocumentRecord.DeliveryDocumentItem //MATDOC
                                                                            and _MaterialDocumentRecord.IsAutomaticallyCreated = 'X'
                                                                            and _MaterialDocumentRecord.SpecialStockIdfgSupplier = _MaterialDocumentRecord.Supplier

  association [0..1] to I_PurchasingDocumentItem as _PurchasingDocumentItem on  $projection.ReferenceSDDocument = _PurchasingDocumentItem.PurchasingDocument //EKPO

  association [0..1] to ZI_MM_ESTADO             as _Estado                 on  $projection.ReferenceSDDocument     = _Estado.PurchasingDocument
                                                                            and $projection.ReferenceSDDocumentItem = _Estado.PurchasingDocumentItem
                                                                            and $projection.Plant                   = _Estado.Plant

  association [0..1] to ZI_MM_ESTADO2            as _Estado2                on  $projection.DeliveryDocument = _Estado2.DeliveryDocument
                                                                            and $projection.shiptoparty      = _Estado2.ShipToParty


{

  key DeliveryDocumentItem.DeliveryDocument,
  key DeliveryDocumentItem.DeliveryDocumentItem,
  key DeliveryDocumentItem.ReferenceSDDocument,
  key substring( DeliveryDocumentItem.ReferenceSDDocumentItem, 2, 6 ) as ReferenceSDDocumentItem,
      DeliveryDocumentItem.StorageLocation,
      DeliveryDocumentItem.InventorySpecialStockType,
      DeliveryDocumentItem.GoodsMovementType,
      DeliveryDocumentItem.DeliveryDocumentItemCategory,
      DeliveryDocumentItem.Plant,
      
      _DeliveryDocument.ShipToParty,

      _PurchasingDocumentItem,
      _MaterialDocumentRecord,
      _Estado,
      _Estado2,
      _DeliveryDocument
}
where
      DeliveryDocumentItem.ReferenceSDDocument               <> ''
  and DeliveryDocumentItem.ReferenceSDDocumentItem           <> '000000'
  and _PurchasingDocumentItem.PurchasingDocumentItemCategory =  '3'
