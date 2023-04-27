@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Divisão de remessas agrupadas'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_SCHED_LINE_GROUP 
  as select from eket
{
  key cast( ebeln as j_1b_purch_order_ext )                    as PurchasingDocument,
  key lpad( cast( ebelp as logbr_purch_ord_item_ext ), 6, '0') as PurchasingDocumentItem,     
  max(eindt)                                                   as ScheduleLineDeliveryDate
}
group by
    ebeln,
    ebelp,    
    eindt
