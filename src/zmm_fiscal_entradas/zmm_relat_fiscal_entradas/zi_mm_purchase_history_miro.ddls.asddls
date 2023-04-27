@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Recupera MIRO válida (não estornada)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_PURCHASE_HISTORY_MIRO
  as select from    ZI_MM_PURCHASE_HISTORY as _History
  
    left outer join rbkp                   as _MIRO on  _MIRO.belnr = substring( _History.Reference, 5, 10 )  
                                                    and _MIRO.gjahr = substring( _History.Reference, 1, 4 )

{
  key _History.PurchaseOrder                                   as PurchaseOrder,
  key _History.PurchaseOrderItem                               as PurchaseOrderItem,
      cast( substring( _History.Reference, 1, 4 ) as gjahr )   as BR_NFSourceDocumentNumberYear,
      cast( substring( _History.Reference, 5, 10 ) as mblnr )  as BR_NFSourceDocumentNumber,
      cast( substring( _History.Reference, 15, 4 ) as mblpo  ) as BR_NFSourceDocumentNumberItem,

      case when _MIRO.stblg is not null
           then _MIRO.stblg
           else cast( '' as re_stblg ) end                     as ReverseDocument,
      case when _MIRO.stjah is not null
           then _MIRO.stjah
           else cast( '' as re_stjah ) end                     as ReverseDocumentYear

}
where
  _History.PurchaseOrderTransactionType = '2'
