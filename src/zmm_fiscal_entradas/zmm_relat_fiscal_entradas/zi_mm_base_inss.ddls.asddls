@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Base INSS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_BASE_INSS
  as select from I_BR_NFTax        as Tax
    inner join   I_BR_NFDocument   as _INSS   on _INSS.BR_NotaFiscal = Tax.BR_NotaFiscal
    inner join   FNDEI_LFBW_FILTER as _Filter on  _Filter.lifnr     = _INSS.BR_NFPartner
                                              and _Filter.bukrs     = _INSS.CompanyCode
                                              and _Filter.witht     = 'R1'
                                              and _Filter.wt_subjct = 'X'

{
  key Tax. BR_NotaFiscal,
  key Tax.BR_NotaFiscalItem,
      //      Tax.BR_TaxType,
      //      Tax.TaxGroup,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      max( Tax.BR_NFItemBaseAmount ) as BR_NFItemBaseAmount,
      Tax.SalesDocumentCurrency      as SalesDocumentCurrency
}
where
      _INSS.BR_NFHasServiceItem = 'X'
  and _INSS.BR_NFPartnerType    = 'V'
group by
  Tax.BR_NotaFiscal,
  Tax.BR_NotaFiscalItem,
  Tax.SalesDocumentCurrency
