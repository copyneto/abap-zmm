@AbapCatalog.sqlViewName: 'ZVMMVALORBRUTO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface Valor Bruto Anterior'
define view zi_mm_pc_valbru_ant
  as select from I_PurchaseOrderItemAPI01 as _PurchaseOrderItem

    inner join   zi_mm_pc_doc_ant         as _ValorBrutoAnterior     on(
          _ValorBrutoAnterior.PurchaseOrder         = _PurchaseOrderItem.PurchaseOrder
          and _ValorBrutoAnterior.PurchaseOrderItem = _PurchaseOrderItem.PurchaseOrderItem
          and _ValorBrutoAnterior.Material          = _PurchaseOrderItem.Material
          and _ValorBrutoAnterior.Plant             = _PurchaseOrderItem.Plant
        )

    inner join   I_PurchasingDocumentItem as _ValorDocumentoAnterior on(
      _ValorDocumentoAnterior.PurchasingDocument         = _ValorBrutoAnterior.DocumentoAnterior
      and _ValorDocumentoAnterior.PurchasingDocumentItem = _ValorBrutoAnterior.PurchaseOrderItem
    )

{
  key    _PurchaseOrderItem.PurchaseOrder                                                                                                                                                       as PurchaseOrder,
         _PurchaseOrderItem.PurchaseOrderItem                                                                                                                                                   as PurchaseOrderItem,
         _PurchaseOrderItem.Material                                                                                                                                                            as Material,
         _PurchaseOrderItem.Plant                                                                                                                                                               as Plant,
         _ValorBrutoAnterior.DocumentoAnterior                                                                                                                                                  as DocumentoAnterior,
         (( cast(_ValorDocumentoAnterior.GrossAmount as abap.fltp) / cast(_ValorDocumentoAnterior.OrderQuantity as abap.fltp)) * cast(_ValorDocumentoAnterior.NetPriceQuantity as abap.fltp ) ) as PrecoBrutoAnterior
}
