@EndUserText.label: 'Centro de Custos Projeto Novas Ordens'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_ALIVIUM_CC
  as projection on ZI_MM_ALIVIUM_CC
{

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_BUKRS', element: 'bukrs' } } ]
  key Bukrs,
      Kostl,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
