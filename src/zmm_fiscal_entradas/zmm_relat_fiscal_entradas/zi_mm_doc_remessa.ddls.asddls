@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Doc. Remessa'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_DOC_REMESSA
  as select from I_BR_NFItem             as NFItem
    inner join   I_SDDocumentProcessFlow as _DocumentFlow on  _DocumentFlow.SubsequentDocument         = NFItem.BR_NFSourceDocumentNumber
//                                                          and _DocumentFlow.SubsequentDocumentCategory = 'T'
                                                          and _DocumentFlow.SubsequentDocumentCategory = 'J'
{
  key NFItem.BR_NotaFiscal,
  key NFItem.BR_NotaFiscalItem,

      max(_DocumentFlow.PrecedingDocument) as DocRemessa

}
where
  NFItem._BR_NotaFiscal.BR_NFPartnerType = 'C'
group by
  NFItem.BR_NotaFiscal,
  NFItem.BR_NotaFiscalItem
