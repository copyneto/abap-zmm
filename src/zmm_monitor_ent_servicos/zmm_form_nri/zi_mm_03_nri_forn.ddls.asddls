@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'View - NRI Fornecedor'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_mm_03_nri_forn
  as select from I_Supplier
{
  key Supplier,
  key _SupplierToBusinessPartner._BusinessPartner.BusinessPartner,
      _SupplierToBusinessPartner._BusinessPartner.PersonFullName,
      PhoneNumber1
}
