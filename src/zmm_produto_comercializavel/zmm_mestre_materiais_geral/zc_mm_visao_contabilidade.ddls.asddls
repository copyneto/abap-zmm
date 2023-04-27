@EndUserText.label: 'Visão de Contabilidade'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_MM_VISAO_CONTABILIDADE
  as projection on ZI_MM_VISAO_CONTABILIDADE
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
      @Consumption.valueHelpDefinition: [{ entity : { name: 'I_ProfitCenterStdVH', element: 'ProfitCenter' } }]
      prctr,
      fbwst,
      lbwst,
      vbwst,
      pdatl,
      kosgr,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_ExtProdGrp', element: 'ExternalProductGroup'} }]
      extwg,
      hrkft,
      abwkz,
      mbrue,
      mlmaa,
      bwspa,
      kalnr,
      pprdz,
      pprdv,
      stprv,
      bwph1,
      vplpx,
      lplpx,
      zplpr,
      lplpr,
      zplp1,
      zplp2,
      zplp3,
      vjbwh,
      vjbws,
      ownpr,
      timestamp,
      xlifo,
      pstat,
      laepr,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'C_ProductUnitOfMeasureVH', element: 'UnitOfMeasure' } }]
      meins,
      peinh,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'C_BR_MaterialUsageValHelp', element: 'BR_MaterialUsage'} }]
      mtuse,
      vjsal,
      vmsav,
      salkv,
      vmsal,
      vers1,
      kalsc,
      bklas,
      eklas,
      oklas,
      kziwl,
      @EndUserText.label: 'Cód.inv.físico IR - Dados de avaliação'
      abciw,
      ekalr,
      vprsv,
      zpld1,
      zpld2,
      zpld3,
      wlinl,
      vmkum,
      pdatz,
      @Consumption.filter.selectionType: #SINGLE
      @EndUserText.label: 'Marcação p/elim. - Dados gerais'
      lvorm,
      kaln1,
      hkmat,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'C_BR_MaterialOriginValHelp', element: 'BR_MaterialOrigin'} }]
      mtorg,
      mypol,
      zkprs,
      verpr,
      stprs,
      bwprh,
      bwprs,
      bwps1,
      salk3,
      bwva1,
      waers
}
