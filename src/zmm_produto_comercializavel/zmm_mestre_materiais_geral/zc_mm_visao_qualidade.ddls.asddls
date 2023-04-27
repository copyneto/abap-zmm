@EndUserText.label: 'Visão de Qualidade'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_MM_VISAO_QUALIDADE
  as projection on ZI_MM_VISAO_QUALIDADE
{
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_MATERIAL', element: 'Product' }, label: 'Materiais por Descrição' }]
//      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_ProductStdVH', element: 'Product' }, label: 'Materiais por Descrição' },
//                                         { entity: { name: 'I_ProductByPlantVH', element: 'Product' }, qualifier: 'ProdPlant', label: 'Materiais por Centro' },
//                                         { entity: { name: 'I_ProductByDistributionChainVH', element: 'Product' }, qualifier: 'ProdDistrChain', label: 'Materiais por Canal de Distribuição' },
//                                         { entity: { name: 'I_ProdByEWMWarehouseVH', element: 'Product' }, qualifier: 'ProdEwm', label: 'Materiais por EWM Warehouse' }]
  key matnr as Product,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'C_PlantVH', element: 'Plant'}}]
  key werks,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_ValuationArea', element: 'ValuationArea' } }]
  key bwkey,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_MaterialValuationTypeVH', element: 'InventoryValuationType' } }]
  key bwtar,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'C_InspectionLotTypeVH', element: 'InspectionLotType' } }]
  key art,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Producttype', element: 'ProductType' } }]
      mtart,
      @EndUserText.label: 'Descrição PT'
      maktxpt,
      @EndUserText.label: 'Descrição EN'
      maktxen,
      @EndUserText.label: 'Descrição ES'
      maktxes,
      maktg,
      @Consumption.filter: { selectionType: #INTERVAL }
      ersda,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_USER', element: 'Bname' } }]
      ernam,
      mhdhb,
      @EndUserText.label: 'Admin.lotes - Dados gerais'
      xchpf,
      qmatv,
      @Consumption.filter: { selectionType: #INTERVAL }
      nkmpr,
      pstat,
      scm_grprt,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'C_ProductUnitOfMeasureVH', element: 'UnitOfMeasure' } }]
      meins,
      @Consumption.filter: { selectionType: #INTERVAL }
      datab,
      ssqss,
      qzgtp,
      rbnrm,
      qmpur,
      ausme
}
