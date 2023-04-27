@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Recupera MIGO válida (não estornada)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_PURCHASE_HISTORY_MIGO
  as select from    ZI_MM_PURCHASE_HISTORY as _History

    left outer join mseg                   as _MIGO on  _MIGO.belnr = substring( _History.Reference, 5, 10 )  
                                                    and _MIGO.gjahr = substring( _History.Reference, 1, 4 ) 
                                                    and _MIGO.buzei = substring( _History.Reference, 15, 4 ) 

{
  key _History.PurchaseOrder                                   as PurchaseOrder,
  key _History.PurchaseOrderItem                               as PurchaseOrderItem,
      cast( substring( _History.Reference, 1, 4 ) as gjahr )   as BR_NFSourceDocumentNumberYear,
      cast( substring( _History.Reference, 5, 10 ) as mblnr )  as BR_NFSourceDocumentNumber,
      cast( substring( _History.Reference, 15, 4 ) as mblpo  ) as BR_NFSourceDocumentNumberItem,
      case when _MIGO.smbln is not null
           then _MIGO.smbln
           else cast( '' as mblnr ) end                        as ReverseDocument,
      case when _MIGO.sjahr is not null 
           then _MIGO.sjahr
           else cast( '' as mjahr  ) end                       as ReverseDocumentYear

}
where
  _History.PurchaseOrderTransactionType = '1'
