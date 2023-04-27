@AbapCatalog.sqlViewName: 'ZVMMPCVALORBRUTO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface Valor Bruto'
define view zi_mm_pc_valbru
  as select from I_PurchaseOrderItemAPI01 as _PurchaseOrderItem
{
  key _PurchaseOrderItem.PurchaseOrder                                                                                                                                        as PurchaseOrder,
  key _PurchaseOrderItem.PurchaseOrderItem                                                                                                                                    as PurchaseOrderItem,
      _PurchaseOrderItem.Material                                                                                                                                             as Material,
      _PurchaseOrderItem.Plant                                                                                                                                                as Plant,
      (( cast(_PurchaseOrderItem.GrossAmount as abap.fltp) / cast(_PurchaseOrderItem.OrderQuantity as abap.fltp)) * cast(_PurchaseOrderItem.NetPriceQuantity as abap.fltp ) ) as PrecoBruto
}
