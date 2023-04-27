@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Retenção TRIO'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_RETENCAO_TRIO
  as select from I_BR_NFTax
{
  key BR_NotaFiscal,
  key BR_NotaFiscalItem,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      sum(BR_NFItemTaxAmount)           as TRIO,
      sum(BR_NFItemTaxRate)             as PercentTRIO,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      max(BR_NFItemBaseAmount)          as BaseTRIO,
      min(BR_NFItemWhldgCollectionCode) as CodReceitaTRIO,
      SalesDocumentCurrency
}
where
     TaxGroup = 'WHPI'
  or TaxGroup = 'WHCO'
  or TaxGroup = 'WHCS'
group by
  BR_NotaFiscal,
  BR_NotaFiscalItem,
  SalesDocumentCurrency

//  as select from YVIC_NFDOC_I      as TRIO
//    inner join   FNDEI_LFBW_FILTER as _Filter on  _Filter.lifnr     = TRIO.Parid
//                                              and _Filter.bukrs     = TRIO.Bukrs
//                                              and _Filter.witht     = 'MP'
//                                              and _Filter.wt_subjct = 'X'
//{
//  key TRIO.Docnum,
//      TRIO.Pstdat,
//      TRIO.Parid,
//      TRIO.Bukrs,
//      'X' as TRIO
//}
//where
//      TRIO.Nfesrv = 'X'
//  and TRIO.Partyp = 'V'
