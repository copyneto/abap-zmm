@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Calcula Valores Montante'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_MONTANTE
  as select from    I_BR_NFItem as NFItem

    left outer join I_BR_NFTax  as _ICMS_FCP on  _ICMS_FCP.BR_NotaFiscal     = NFItem.BR_NotaFiscal
                                             and _ICMS_FCP.BR_NotaFiscalItem = NFItem.BR_NotaFiscalItem
                                             and _ICMS_FCP.BR_TaxType        = 'ICSC'
                                             and _ICMS_FCP.TaxGroup          = 'ICMS'

    left outer join I_BR_NFTax  as _ST_FCP   on  _ST_FCP.BR_NotaFiscal     = NFItem.BR_NotaFiscal
                                             and _ST_FCP.BR_NotaFiscalItem = NFItem.BR_NotaFiscalItem
                                             and _ST_FCP.BR_TaxType        = 'ICFP'
                                             and _ST_FCP.TaxGroup          = 'ICST'
{
  key NFItem.BR_NotaFiscal,
  key NFItem.BR_NotaFiscalItem,
      NFItem.SalesDocumentCurrency,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //      NFItem.BR_NFTotalAmount                                                      as ValorProdutos,
      NFItem.NetValueAmount                                                        as ValorProdutos,
      abs( NFItem.BR_NFNetDiscountAmount )                                         as DescontoINC,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      NFItem.BR_NFNetFreightAmount                                                 as Frete,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      cast( cast( NFItem.BR_NFTotalAmount as abap.dec(15,2) ) -
            cast( NFItem.BR_NFNetFreightAmount as abap.dec(15,2) ) as j_1bnetfre ) as TotalSemFrete,


      @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
      NFItem._BR_NotaFiscal.BR_NFTotalAmount                                       as TotalNota,
      @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
      NFItem._BR_NotaFiscal.BR_NFTotalAmount                                       as BaseCalcFunrural,
      NFItem._BR_NotaFiscal.BR_NFIsIncomingIssdByCust                              as Entrada,

      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      _ICMS_FCP.BR_NFItemBaseAmount                                                as BcICMSFCP,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      _ICMS_FCP.BR_NFItemTaxAmount                                                 as ValorICMSFCP,

      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      _ST_FCP.BR_NFItemBaseAmount                                                  as BaseSTFCP,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      _ST_FCP.BR_NFItemTaxAmount                                                   as ValorSTFCP
}
