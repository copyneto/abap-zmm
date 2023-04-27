@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Histórico de compras'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_PURCHASE_HISTORY 
  as select from ekbe 
{ 
  key cast( ebeln as j_1b_purch_order_ext )                    as PurchaseOrder,
  key lpad( cast( ebelp as logbr_purch_ord_item_ext ), 6, '0') as PurchaseOrderItem,
  key vgabe                                                    as PurchaseOrderTransactionType,
      max( concat( gjahr, concat( belnr, buzei ) ) )           as Reference

}
group by
  ebeln,
  ebelp, 
  vgabe 
