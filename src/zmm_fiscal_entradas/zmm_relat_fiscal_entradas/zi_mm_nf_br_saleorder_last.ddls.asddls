@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Última ordem relacionada à fatura'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_NF_BR_SALEORDER_LAST
  as select from I_BR_NFItem      as NFItem
    inner join   I_BR_SaleHistory as History on  History.SubsequentDocument     = NFItem.BR_NFSourceDocumentNumber
                                             and History.SubsequentDocumentItem = NFItem.BR_NFSourceDocumentItem
{
  key NFItem.BR_NotaFiscal                                           as BR_NotaFiscal,
  key NFItem.BR_NotaFiscalItem                                       as BR_NotaFiscalItem,
      History.SubsequentDocument                                     as Fatura,
      History.SubsequentDocumentItem                                 as FaturaItem,
      max( concat( History.PrecedingDocument,
           cast( History.PrecedingDocumentItem as abap.char(6) ) ) ) as OrdemHeaderItem
}
where
     History.PrecedingDocumentCategory = 'C' -- Ordem
  or History.PrecedingDocumentCategory = 'H' -- Devolução

group by
  NFItem.BR_NotaFiscal,
  NFItem.BR_NotaFiscalItem,
  History.SubsequentDocument,
  History.SubsequentDocumentItem
