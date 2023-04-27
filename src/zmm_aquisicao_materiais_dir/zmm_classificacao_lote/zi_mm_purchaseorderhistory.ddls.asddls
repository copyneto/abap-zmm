@AbapCatalog.sqlViewName: 'ZVMM_PURC_HIST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Histórico de Pedido'
define view ZI_MM_PURCHASEORDERHISTORY
  //    as select from I_PurchaseOrderHistoryAPI01 as _History
  as select from I_SuplrInvcItemPurOrdRefAPI01 as _History

  //    inner join   ZI_MM_PARAM_MOVEMENT        as _Param
  //      on _Param.TpMov = _History.GoodsMovementType

{
  key PurchaseOrder,
  key PurchaseOrderItem,
      //      @Semantics.quantity.unitOfMeasure:'PurchaseOrderQuantityUnit'
      //      sum(
      //      case
      //        when DebitCreditCode = 'S' then _History.Quantity
      //         else _History.Quantity * -1
      //       end ) as Quantidade,
      //      PurchaseOrderQuantityUnit

      PurchaseOrderQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
      sum(  QuantityInPurchaseOrderUnit ) as Quantidade



}
where
  DebitCreditCode = 'H'
group by
  PurchaseOrder,
  PurchaseOrderItem,
  PurchaseOrderQuantityUnit
