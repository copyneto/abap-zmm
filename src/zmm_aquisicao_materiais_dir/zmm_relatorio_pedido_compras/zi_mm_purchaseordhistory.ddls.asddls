@AbapCatalog.sqlViewName: 'ZVMM_PURC_HISTOR'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Histórico de documento de compras'
define view zi_mm_PurchaseOrdHistory
  as select from C_GRIRPurchaseOrderHistory
{
  key PurchasingDocument,
  key PurchasingDocumentItem,
//  key PurchasingHistoryDocumentType,
      OrderQuantityUnit as OrderQuantityUnit,
      OrderPriceUnit,
      
      @Semantics: { quantity : {unitOfMeasure: 'OrderPriceUnit'} }
      sum(case
       when DebitCreditCode = 'S' then QtyInPurchaseOrderPriceUnit
        else QtyInPurchaseOrderPriceUnit * -1
      end )             as aserforn,

      @Semantics: { quantity : {unitOfMeasure: 'OrderQuantityUnit'} }
      sum(
      case
       when DebitCreditCode = 'S' then Quantity
        else Quantity * -1
      end )             as aserfat,

      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      sum(case
       when DebitCreditCode = 'S' then PurOrdAmountInCompanyCodeCrcy
        else PurOrdAmountInCompanyCodeCrcy * -1
      end )             as aserfatvalor,

      CompanyCodeCurrency
//      DebitCreditCode

}
where
     PurchasingHistoryDocumentType = '1'
  or PurchasingHistoryDocumentType = '2'
group by
  PurchasingDocument,
  PurchasingDocumentItem,
//  PurchasingHistoryDocumentType,
  OrderQuantityUnit,
  OrderPriceUnit,
  CompanyCodeCurrency
//  DebitCreditCode
