@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Fornecimento com NF'
//@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_FORNECIMENTO2
  as select from ZI_MM_FORNECIMENTO as Fornecimento

  association [0..1] to I_MaterialDocumentRecord as _MaterialDocumentRecord2 on  $projection.ReversedMaterialDocument            = _MaterialDocumentRecord2.MaterialDocument
                                                                             and $projection.ReferenceSDDocument                 = _MaterialDocumentRecord2.PurchaseOrder
                                                                             and $projection.ReferenceSDDocumentItem             = _MaterialDocumentRecord2.PurchaseOrderItem
                                                                             and $projection.DeliveryDocument                    = _MaterialDocumentRecord2.DeliveryDocument
                                                                             and $projection.DeliveryDocumentItem                = _MaterialDocumentRecord2.DeliveryDocumentItem
                                                                             and _MaterialDocumentRecord2.IsAutomaticallyCreated = 'X'

  association [0..1] to ZI_MM_VALIDA_ESTORNO     as _Estorno                 on  $projection.MaterialDocumentYear = _Estorno.MaterialDocumentYear
                                                                             and $projection.MaterialDocument     = _Estorno.MaterialDocument
                                                                             and $projection.MaterialDocumentItem = _Estorno.MaterialDocumentItem

{
  key Fornecimento._MaterialDocumentRecord.MaterialDocumentYear                                      as MaterialDocumentYear,
  key Fornecimento._MaterialDocumentRecord.MaterialDocument                                          as MaterialDocument,
  key Fornecimento._MaterialDocumentRecord.MaterialDocumentItem                                      as MaterialDocumentItem,
  key Fornecimento.DeliveryDocument,
  key Fornecimento.DeliveryDocumentItem,
  key Fornecimento.ReferenceSDDocument,
  key Fornecimento.ReferenceSDDocumentItem,
      Fornecimento.StorageLocation,
      Fornecimento.InventorySpecialStockType,
      Fornecimento.GoodsMovementType,
      Fornecimento.DeliveryDocumentItemCategory,
      /* Associations */
      Fornecimento._MaterialDocumentRecord.ReversedMaterialDocument                                  as ReversedMaterialDocument,
      lpad( cast(Fornecimento._MaterialDocumentRecord.ReferenceDocument as logbr_docnum ), 10, '0' ) as ReferenceDocument,

      Fornecimento._PurchasingDocumentItem,
      Fornecimento._MaterialDocumentRecord.SpecialStockIdfgSupplier,
      Fornecimento._MaterialDocumentRecord.IsAutomaticallyCreated,
      _Estado.Estado,
      _Estado2.Estado                                                                                as Estado2,
      _MaterialDocumentRecord2,
      _Estorno

}
where
      Fornecimento._MaterialDocumentRecord.MaterialDocumentYear <> '0000'
  and Fornecimento._MaterialDocumentRecord.MaterialDocument     <> ''
  and Fornecimento._MaterialDocumentRecord.MaterialDocumentItem <> '0000'
