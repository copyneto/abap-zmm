@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Divisão de remessas'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_SCHED_LINE
  as select from eket
{
  key cast( ebeln as j_1b_purch_order_ext )                    as PurchasingDocument,
  key lpad( cast( ebelp as logbr_purch_ord_item_ext ), 6, '0') as PurchasingDocumentItem,  
  key etenr                                                    as ScheduleLine,
  key cast(lpad( rpad( ebelp , 4, '0' ) , 6, '0' ) as logbr_purch_ord_item_ext) as PurchasingDocumentItem2,
      eindt                                                    as ScheduleLineDeliveryDate
}
