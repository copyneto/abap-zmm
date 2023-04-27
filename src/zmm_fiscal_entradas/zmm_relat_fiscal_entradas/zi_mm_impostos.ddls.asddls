@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Valor Impostos'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_IMPOSTOS
  as select from I_BR_NFTax as Tax
{
  key Tax.BR_NotaFiscal,
  key Tax.BR_NotaFiscalItem,
  key Tax.TaxGroup,
      Tax.BR_TaxType as TaxType,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      Tax.BR_NFItemBaseAmount,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      Tax.BR_NFItemTaxAmount,
      Tax.SalesDocumentCurrency,
      Tax.BR_NFItemExcludedBaseAmount,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      Tax.BR_NFItemOtherBaseAmount,
      Tax.BR_NFItemTaxRate
}
