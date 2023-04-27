@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro Pricing'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_RLTPED_FILT_PRICING
  as select from I_PurgDocPricingElement
{
  key PurchasingDocument,
  key PurchasingDocumentItem,
      ConditionType,
      sum(ConditionRateValue) as ConditionRateValue,
      ConditionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      sum(ConditionAmount)    as ConditionAmount,
      TransactionCurrency
}
group by
  PurchasingDocument,
  PurchasingDocumentItem,
  ConditionType,
  ConditionCurrency,
  TransactionCurrency
