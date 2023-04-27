@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro do endereço do parceiro'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_RLTPED_FILTER_BSNSSPTNR
  as select from I_BusinessPartnerAddressTP
{
  key BusinessPartner    as BUSINESSPARTNER,
  key max(AddressNumber) as ADDRESSNUMBER
}
where
      AddressValidityStartDate < $session.system_date
  and AddressValidityEndDate   > $session.system_date
group by
  BusinessPartner
