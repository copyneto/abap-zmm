@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cálculo de Prazo de Pagamento'
//@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity zc_mm_calculo_prazo_pagamento
  as select from zi_mm_calculo_prazo_pagamento
{
  key belnr,
  key gjahr,
  key buzei,
      SupplierInvoiceIDByInvcgParty,
      bukrs,
      PurchaseOrder,
      budat,
      llief,
      matnr,
      DocumentCurrency,
      NetPriceAmount,
      NetPriceQuantity,
      NetAmount,
      //GLAccount
      //GLAccountName
      //CostCenter
      TaxCode,
      werks,
      bldat,
      CreatedByUser,
      bupla
}
