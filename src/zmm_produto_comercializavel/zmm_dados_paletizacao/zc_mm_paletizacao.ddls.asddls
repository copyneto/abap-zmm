@EndUserText.label: 'CDS de Projeção Paletização'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_MM_PALETIZACAO
  as projection on ZI_MM_PALETIZACAO
{
      @Consumption.semanticObject: 'Material'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_MATERIAL', element: 'Material' } }]
  key Product,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'C_MM_PlantValueHelp', element: 'Plant' } }]
  key Centro,
      @Consumption.filter.selectionType: #SINGLE
      @EndUserText.label: 'Descrição'
      DescricaoMaterial,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_TIPO_MATERIAL', element: 'ProductType' } }]
      TipoMaterial,
      DescricaoTipoMaterial,
      @Consumption.filter.selectionType: #SINGLE
      Lastro,
      @Consumption.filter.selectionType: #SINGLE
      Altura,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_UNIDADE_MEDIDA', element: 'UnitOfMeasure' } }]
      Unit,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
