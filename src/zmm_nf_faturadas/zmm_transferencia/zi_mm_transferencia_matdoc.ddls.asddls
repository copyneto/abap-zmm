@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Documento de material de transferência'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZI_MM_TRANSFERENCIA_MATDOC
  as select from ZI_MM_TRANSFERENCIA_MATDOC_N
{
  key Refkey,
  key Refitem,
  key Material,
      RefMaterialDocument,
      RefMaterialDocumentYear,
      RefMaterialDocumentItem,
      MaterialDocument,
      MaterialDocumentYear,
      MaterialDocumentItem,
      DebitCreditCode,
      PurchaseOrder,
      PurchaseOrderItem,
      GoodsMovementType,
      DocumentDate,
      Plant,
      IssuingOrReceivingPlant,
      PurchaseOrderType,
      IsCancelled,
      ReversalGoodsMovementType,
      ReversedMaterialDocument,
      ReversedMaterialDocumentYear,
      ReversedMaterialDocumentItem
}
group by
  Refkey,
  Refitem,
  RefMaterialDocument,
  RefMaterialDocumentYear,
  RefMaterialDocumentItem,
  Material,
  MaterialDocument,
  MaterialDocumentYear,
  MaterialDocumentItem,
  DebitCreditCode,
  PurchaseOrder,
  PurchaseOrderItem,
  GoodsMovementType,
  DocumentDate,
  Plant,
  IssuingOrReceivingPlant,
  PurchaseOrderType,
  IsCancelled,
  ReversalGoodsMovementType,
  ReversedMaterialDocument,
  ReversedMaterialDocumentYear,
  ReversedMaterialDocumentItem
