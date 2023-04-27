@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Condições de Pagamento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_VENCTO_DOC_FAT
  as select from I_SupplierInvoice

{
  key SupplierInvoice,
  key FiscalYear,
      PaymentTerms,
      case when CashDiscount2Days <> 0
        then dats_add_days(DueCalculationBaseDate,
                           cast( CashDiscount2Days as abap.int4 ),
                           'INITIAL')
        else dats_add_days(DueCalculationBaseDate,
                           cast( CashDiscount1Days as abap.int4 ),
                           'INITIAL')
      end as VencNota
}
