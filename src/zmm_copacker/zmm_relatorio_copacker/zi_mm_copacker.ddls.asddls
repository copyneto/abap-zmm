@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS de Interface - Copacker'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_COPACKER
  as select from    I_BR_NFItem as NFItem
    left outer join seri        as _SerialNumber on  NFItem.Material = _SerialNumber.matnr
                                                 and NFItem.Plant    = _SerialNumber.werk

  association [0..1] to ZI_MM_OPERACAO       as _Operacao      on  $projection.BR_CFOPCode = _Operacao.Cfop

  association [0..1] to I_PurchaseOrderAPI01 as _PurchaseOrder on  $projection.PurchaseOrder = _PurchaseOrder.PurchaseOrder

  association [0..1] to I_BR_NFTax           as _NFTax         on  $projection.BR_NotaFiscal     = _NFTax.BR_NotaFiscal
                                                               and $projection.BR_NotaFiscalItem = _NFTax.BR_NotaFiscalItem
                                                               and (
                                                                  _NFTax.BR_TaxType              = 'ICM0'
                                                                  or _NFTax.BR_TaxType           = 'ICM1'
                                                                  or _NFTax.BR_TaxType           = 'ICM2'
                                                                  or _NFTax.BR_TaxType           = 'ICM3'
                                                                )
                                                               and _NFTax.TaxGroup               = 'ICMS'

{
  key NFItem.BR_NotaFiscal,
  key case
  when cast( NFItem.BR_NotaFiscalItem as abap.int2(6) ) < 10
  then
  000010 * cast( NFItem.BR_NotaFiscalItem as abap.int2(6) )
  else
  cast( NFItem.BR_NotaFiscalItem as abap.int2(6) )
  end                                                                                 as BR_NotaFiscalItem2,
  key NFItem.BR_NotaFiscalItem,
      NFItem.Plant,
      NFItem.BR_CFOPCode,
      NFItem.Material,
      NFItem.PurchaseOrder,
      NFItem.PurchaseOrderItem,
      NFItem.MaterialName,
      NFItem.BR_TaxCode,
      NFItem.MaterialGroup,
      NFItem.NetPriceAmount,
      NFItem.SalesDocumentCurrency,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      NFItem.NetValueAmount,
      NFItem.BR_CFOPCategory,
      NFItem.BR_NFSourceDocumentNumber,
      NFItem.BaseUnit,
      @Semantics.quantity.unitOfMeasure:'BaseUnit'
      NFItem.QuantityInBaseUnit,
      NFItem.Batch,
      NFItem.NCMCode,
      @Consumption.hidden: true
      NFItem.BR_NFSourceDocumentItem,
      NFItem._BR_NotaFiscal.BR_NFPostingDate,
      NFItem._BR_NotaFiscal.BR_NFIssueDate,
      NFItem._BR_NotaFiscal.CompanyCode,
      NFItem._BR_NotaFiscal.BusinessPlace,
      NFItem._BR_NotaFiscal.BR_NFPartner,
      NFItem._BR_NotaFiscal.BR_NFeNumber,
      NFItem._BR_NotaFiscal.BR_NFNumber,
      NFItem._BR_NotaFiscal.BR_NFPartnerName1,
      NFItem._BR_NotaFiscal.BR_NFType,

      _PurchaseOrder.PurchasingGroup,

      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_CONVERT_SERNR'
      _SerialNumber.sernr                                                             as SerialNumber,

      cast(_SerialNumber.sernr as abap.char( 18 ))                                    as SerialNumber2,

      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      _NFTax.BR_NFItemBaseAmount,
      _NFTax.BR_NFItemTaxRate,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      _NFTax.BR_NFItemTaxAmount,


      dats_days_between(NFItem._BR_NotaFiscal.BR_NFPostingDate, $session.system_date) as DiasAberto,

      _Operacao,
      _PurchaseOrder,
      _NFTax
}
where
       NFItem._BR_NotaFiscal.BR_NFIsCanceled      = ''
  and(
       NFItem._BR_NotaFiscal.BR_NFeDocumentStatus = ''
    or NFItem._BR_NotaFiscal.BR_NFeDocumentStatus = '1'
  )
