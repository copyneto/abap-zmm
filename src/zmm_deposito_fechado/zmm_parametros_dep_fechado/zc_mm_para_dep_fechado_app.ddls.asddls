@EndUserText.label: 'Administrar Parâmetros Depósito Fechado'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_MM_PARA_DEP_FECHADO_APP
  as projection on ZI_MM_PARA_DEP_FECHADO_APP
{
      @EndUserText.label: 'Guid'
  key Guid,
  
      @EndUserText.label: 'Descrição'
      Description,
      
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_CENTRO', element: 'Plant' }}]
      @EndUserText.label: 'Centro Origem'
      @ObjectModel.text.element: ['OriginPlantName']
      OriginPlant,
      OriginPlantName,
      OriginPlantCrit,
      
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_DF_TIPO_CENTRO', element: 'PlantType' }}]
      @EndUserText.label: 'Tipo de Centro Origem'
      @ObjectModel.text.element: ['OriginPlantTypeName']
      OriginPlantType,
      OriginPlantTypeName,
      OriginPlantTypeCrit,
      
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DEPOSITO', element: 'Lgort' },
                                           additionalBinding: [{  element: 'Werks', localElement: 'OriginPlant' }]}]
      @EndUserText.label: 'Deposito Origem'
      @ObjectModel.text.element: ['OriginStorageLocationName']
      OriginStorageLocation,
      OriginStorageLocationName,
      OriginStorageLocationCrit,
      
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_CENTRO', element: 'Plant' }}]
      @EndUserText.label: 'Centro Destino'
      @ObjectModel.text.element: ['DestinyPlantName']
      DestinyPlant,
      DestinyPlantName,
      DestinyPlantCrit,
      
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_DF_TIPO_CENTRO', element: 'PlantType' }}]
      @EndUserText.label: 'Tipo de Centro Destino'
      @ObjectModel.text.element: ['DestinyPlantTypeName']
      DestinyPlantType,
      DestinyPlantTypeName,
      DestinyPlantTypeCrit,
      
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DEPOSITO', element: 'Lgort' },
                                           additionalBinding: [{  element: 'Werks', localElement: 'DestinyPlant' }]}]
      @EndUserText.label: 'Deposito Destino'
      @ObjectModel.text.element: ['DestinyStorageLocationName']
      DestinyStorageLocation,
      DestinyStorageLocationName,
      DestinyStorageLocationCrit,
      
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
