@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Total de Impostos ICST'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_IMPOSTOS_TOT_ICST 
as select from I_BR_NFTax as Tax
{
  key Tax.BR_NotaFiscal,
  key Tax.BR_NotaFiscalItem,
  key Tax.TaxGroup,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      sum(Tax.BR_NFItemTaxAmount) as BR_NFItemTaxAmount,
      Tax.SalesDocumentCurrency      
}
where
    Tax.TaxGroup = 'ICST'
group by
  Tax.BR_NotaFiscal,
  Tax.BR_NotaFiscalItem,  
  Tax.TaxGroup,
  Tax.SalesDocumentCurrency
    
