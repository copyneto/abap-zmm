@AbapCatalog.sqlViewName: 'ZVMMPCITEM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface consulta Pedido de Compra - Item'
define view zi_mm_pc_item

  as select from    I_PurchaseOrderItemAPI01 as _PurchaseOrderItem

    left outer join zi_mm_pc_valbru_ant      as _ValorBrutoAnterior on(
      _ValorBrutoAnterior.PurchaseOrder = _PurchaseOrderItem.PurchaseOrder
      and _ValorBrutoAnterior.Material  = _PurchaseOrderItem.Material
      and _ValorBrutoAnterior.Plant     = _PurchaseOrderItem.Plant
    )

    inner join      I_ProductValuation       as _ProductValuation   on(
        _ProductValuation.Product           = _PurchaseOrderItem.Material
        and _ProductValuation.ValuationArea = _PurchaseOrderItem.Plant
        and _ProductValuation.ValuationType = ''
        //          and _ProductValuation.InventoryValuationProcedure = 'V'
      )

    left outer join zi_mm_pc_valbru          as _ValorBruto         on(
              _ValorBruto.PurchaseOrder         = _PurchaseOrderItem.PurchaseOrder
              and _ValorBruto.PurchaseOrderItem = _PurchaseOrderItem.PurchaseOrderItem
              and _ValorBruto.Material          = _PurchaseOrderItem.Material
              and _ValorBruto.Plant             = _PurchaseOrderItem.Plant
            )

{
  key    _PurchaseOrderItem.PurchaseOrder                                                                           as PurchaseOrder,
  key    _PurchaseOrderItem.PurchaseOrderItem                                                                       as PurchaseOrderItem,
         _PurchaseOrderItem.Material                                                                                as Material,
         cast( fltp_to_dec( _ValorBrutoAnterior.PrecoBrutoAnterior as abap.dec( 10, 2 )) as ze_valorbrutoanterior ) as ValorBrutoAnterior,
         cast( _ProductValuation.PrevInvtryPriceInCoCodeCrcy as ze_valorbrutopmm )                                  as PrecoAnteriorPMM,
         cast( fltp_to_dec( _ValorBruto.PrecoBruto as abap.dec( 10, 2 )) as ze_precobruto)                          as ValorBruto
}

