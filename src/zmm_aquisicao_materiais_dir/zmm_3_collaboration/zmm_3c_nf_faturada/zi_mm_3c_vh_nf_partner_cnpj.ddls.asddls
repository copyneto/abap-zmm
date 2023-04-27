@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Nº CNPJ'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_MM_3C_VH_NF_PARTNER_CNPJ
  as select from I_BR_NFDocument
{
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key BR_NFPartnerCNPJ,
      BR_NFPartner,
      BR_NFPartnerName1
}
where
  BR_NFPartnerCNPJ is not initial
group by
  BR_NFPartnerCNPJ,
  BR_NFPartner,
  BR_NFPartnerName1
