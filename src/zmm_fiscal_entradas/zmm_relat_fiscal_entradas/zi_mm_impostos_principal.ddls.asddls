@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Valor Impostos'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_IMPOSTOS_PRINCIPAL
  as select from I_BR_NFTax as Tax
  //    inner join   j_1baj     as _GrpImp on  _GrpImp.taxtyp = Tax.BR_TaxType
  //                                       and _GrpImp.taxgrp = Tax.TaxGroup
    inner join   ztmmgrpimp as _GrpImp on  _GrpImp.taxgrp = Tax.TaxGroup
                                       and _GrpImp.taxtyp = Tax.BR_TaxType
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
