@EndUserText.label: 'Usuarios liberados fiscal - GRC'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_MM_USER_LIB_GRC
  as projection on ZI_MM_USER_LIB_GRC
{
  key DocUuidH,
      @Consumption.valueHelpDefinition: [{entity: { name: 'P_USER_ADDR', element: 'bname' }}]
  key Usuario,
      Obs,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
