@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Valores Totais'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_TOTAL_TAX
  as select from I_BR_NFTax as Tax
{
  key BR_NotaFiscal,
  key BR_NotaFiscalItem,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      sum( BR_NFItemTaxAmount ) as SumNFItemTaxAmount,
      SalesDocumentCurrency
}
group by
  BR_NotaFiscal,
  BR_NotaFiscalItem,
  SalesDocumentCurrency
