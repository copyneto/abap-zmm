@AbapCatalog.sqlViewName: 'ZVMMPCDOCANT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface consulta Pedido Anterior'
define view zi_mm_pc_doc_ant
  as select from I_PurchaseOrderItemAPI01 as _PurchaseOrderItem

    join         I_PurchasingDocumentItem as _ValorBrutoAnterior on(
      _ValorBrutoAnterior.PurchasingDocument                 < _PurchaseOrderItem.PurchaseOrder
      and _ValorBrutoAnterior.Material                       = _PurchaseOrderItem.Material
      and _ValorBrutoAnterior.Plant                          = _PurchaseOrderItem.Plant
      and _ValorBrutoAnterior.PurchasingDocumentDeletionCode = ''
    )

{
  key    _PurchaseOrderItem.PurchaseOrder            as PurchaseOrder,
  key    _PurchaseOrderItem.PurchaseOrderItem        as PurchaseOrderItem,
         _PurchaseOrderItem.Material                 as Material,
         _PurchaseOrderItem.Plant                    as Plant,
         max(_ValorBrutoAnterior.PurchasingDocument) as DocumentoAnterior
}

group by
  _PurchaseOrderItem.PurchaseOrder,
  _PurchaseOrderItem.PurchaseOrderItem,
  _PurchaseOrderItem.Material,
  _PurchaseOrderItem.Plant
