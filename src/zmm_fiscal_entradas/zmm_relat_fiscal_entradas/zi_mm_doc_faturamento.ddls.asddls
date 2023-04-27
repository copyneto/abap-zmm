@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Documento Faturamento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_DOC_FATURAMENTO
  as select from I_BR_NFItem     as NFItem
    inner join   I_BR_NFDocument as _NFDoc on _NFDoc.BR_NotaFiscal = NFItem.BR_NotaFiscal
{
  key NFItem.BR_NotaFiscal,
  key NFItem.BR_NotaFiscalItem,
      NFItem._BR_NotaFiscal.BR_NFPartnerType,
      NFItem.BR_NFSourceDocumentNumber
}
where
  _NFDoc.BR_NFPartnerType = 'C'
