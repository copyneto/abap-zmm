@AbapCatalog.sqlViewName: 'ZVMMPCCABECALHO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface consulta Pedido de Compra - Cabeçalho'
define view zi_mm_pc_cabecalho
  as select from I_PurchaseOrderAPI01 as PurchaseOrder
{
  key PurchaseOrder.PurchaseOrder                                               as PurchaseOrder,
      cast( sum(PurchaseOrder._PurchaseOrderItem.GrossAmount) as ze_valorbruto) as ValorBruto
}
group by
  PurchaseOrder
