@EndUserText.label: 'Regra para cálculo DIFAL/ST - Base Dupla'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_ZMMT003
  as projection on ZI_MM_ZMMT003
{
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_SHIPTO', element: 'Region' } }]
      @ObjectModel.foreignKey.association: '_ShipTo'
  key Shipto,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_STEUC', element: 'Steuc' } }]
      @ObjectModel.foreignKey.association: '_Steuc'
  key J1bnbm,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'zi_ca_vh_taxcode_mm', element: 'Mwskz' } }]
  key mwskz,
      ShipToText,
      J_1bnbmText,
      Flag,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      _ShipTo,
      _Steuc
}
