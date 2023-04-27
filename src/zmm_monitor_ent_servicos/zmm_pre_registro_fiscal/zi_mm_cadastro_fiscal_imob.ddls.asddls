@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Imobilizado'
define view entity ZI_MM_CADASTRO_FISCAL_IMOB
  as select from I_PurchaseOrderItem
{
  key PurchaseOrder,
      min( PurchaseOrderItem ) as ITEM
}
where
     ConsumptionPosting = 'A'
  or ConsumptionPosting = 'P'
group by
  PurchaseOrder
