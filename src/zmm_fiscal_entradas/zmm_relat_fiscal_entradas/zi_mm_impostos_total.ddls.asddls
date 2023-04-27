@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Total Imposto Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_IMPOSTOS_TOTAL 
as select from I_BR_NFTax as Tax
{
  key Tax.BR_NotaFiscal,
  key Tax.BR_NotaFiscalItem,
  Tax.SalesDocumentCurrency,
  @Semantics.amount.currencyCode:'SalesDocumentCurrency'
  sum(Tax.BR_NFItemTaxAmount) as BR_NFItemTaxAmount     
}
group by
    Tax.BR_NotaFiscal,
    Tax.SalesDocumentCurrency,
    Tax.BR_NotaFiscalItem
