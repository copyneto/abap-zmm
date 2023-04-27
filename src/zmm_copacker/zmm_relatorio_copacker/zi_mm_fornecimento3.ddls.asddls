@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Fornec. sem estorno'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_FORNECIMENTO3
  as select from ZI_MM_FORNECIMENTO2
{
  key MaterialDocumentYear,
  key MaterialDocument,
  key MaterialDocumentItem,
  key DeliveryDocument,
  key DeliveryDocumentItem,
  key ReferenceSDDocument,
  key ReferenceSDDocumentItem,
      cast(DeliveryDocumentItem as abap.int4(10)) as DeliveryDocumentItemAux,
      ltrim(ReferenceDocument, '0')               as ReferenceDocumentAux,
      StorageLocation,
      InventorySpecialStockType,
      GoodsMovementType,
      DeliveryDocumentItemCategory,
      ReversedMaterialDocument,
      ReferenceDocument,
      Estado,
      Estado2,
      /* Associations */
      _MaterialDocumentRecord2,
      _PurchasingDocumentItem,

      //      case
      //      when _Estorno.MaterialDocument = MaterialDocument then 'S'
      //      else 'N'
      //      end                       as IsEstorno
      case
      when ReversedMaterialDocument = MaterialDocument then 'S'
      else 'N'
      end                                         as IsEstorno
}
