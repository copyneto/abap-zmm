@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtr Accounting Document'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_RETENCAO_FILT_ACCOUNT
  as select from I_AccountingDocument
{

  key OriginalReferenceDocument as OriginalReferenceDocument,
      max(AccountingDocument)   as AccountingDocument


}
group by
  OriginalReferenceDocument
