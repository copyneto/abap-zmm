@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Centro (acima de 2000)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_VH_PlantValueHelp
  as select from C_MM_PlantValueHelp
{
  key Plant,
  key PurchasingOrganization,
      PlantName,
      PurchasingOrganizationName,
      CityName,
      PostalCode,
      /* Associations */
      _PlantPurchasingOrganization,
      _PurchasingOrganization

}
where
  Plant >= '2000'
