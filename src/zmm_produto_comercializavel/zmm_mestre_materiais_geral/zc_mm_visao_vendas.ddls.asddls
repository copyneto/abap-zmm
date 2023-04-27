@EndUserText.label: 'Visão de Vendas'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_MM_VISAO_VENDAS
  as projection on ZI_MM_VISAO_VENDAS
{
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_MATERIAL', element: 'Product' }, label: 'Materiais por Descrição' }]
      //      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_ProductStdVH', element: 'Product' }, label: 'Materiais por Descrição' },
      //                                         { entity: { name: 'I_ProductByPlantVH', element: 'Product' }, qualifier: 'ProdPlant', label: 'Materiais por Centro' },
      //                                         { entity: { name: 'I_ProductByDistributionChainVH', element: 'Product' }, qualifier: 'ProdDistrChain', label: 'Materiais por Canal de Distribuição' },
      //                                         { entity: { name: 'I_ProdByEWMWarehouseVH', element: 'Product' }, qualifier: 'ProdEwm', label: 'Materiais por EWM Warehouse' }]
  key matnr as Product,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'C_PlantVH', element: 'Plant'}}]
  key werks,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'C_SalesOrganizationVH', element: 'SalesOrganization' } }]
  key vkorg,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_DistributionChannelValueHelp', element: 'DistributionChannel' },
                                           additionalBinding: [{ localElement: 'vkorg', element: 'SalesOrganization' }] }]
  key vtweg,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_IDRFB', element: 'Idrfb' } }]
  key idrfb,
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
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_ProductGroup_2', element: 'ProductGroup' } }]
      matkl,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Division', element: 'Division' } }]
      spart,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_ProductHierarchy', element: 'ProductHierarchy' } }]
      prdha,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_MSTAV', element: 'StatusMaterial'}}]
      mstav,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_ProductStatus', element: 'Status'}}]
      mmsta,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'C_ProductUnitOfMeasureVH', element: 'UnitOfMeasure'} }]
      vrkme,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_ProductHierarchy', element: 'ProductHierarchy'} }]
      prodh,
      ktgrm,
      pmatn,
      versg,
      lfmng,
      aumng,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'C_ProductUnitOfMeasureVH', element: 'UnitOfMeasure' } }]
      meins,
      prat1,
      dwerk,
      /bev1/emdrckspl,
      sktof,
      bonus,
      provg,
      mtpos,
      kondm,
      pvmso,
      mvgr1,
      lfmax,
      mvgr2,
      mvgr3,
      mvgr4,
      mvgr5,
      bismt
}
