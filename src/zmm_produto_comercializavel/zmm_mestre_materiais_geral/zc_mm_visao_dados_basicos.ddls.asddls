@EndUserText.label: 'Visão de Dados Básicos'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_MM_VISAO_DADOS_BASICOS
  as projection on ZI_MM_VISAO_DADOS_BASICOS
{
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_MATERIAL', element: 'Product' }, label: 'Materiais por Descrição' }]
//      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_ProductStdVH', element: 'Product' }, label: 'Materiais por Descrição' },
//                                         { entity: { name: 'I_ProductByPlantVH', element: 'Product' }, qualifier: 'ProdPlant', label: 'Materiais por Centro' },
//                                         { entity: { name: 'I_ProductByDistributionChainVH', element: 'Product' }, qualifier: 'ProdDistrChain', label: 'Materiais por Canal de Distribuição' },
//                                         { entity: { name: 'I_ProdByEWMWarehouseVH', element: 'Product' }, qualifier: 'ProdEwm', label: 'Materiais por EWM Warehouse' }]
  key matnr as Product,
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
      @Consumption.valueHelpDefinition: [{ entity: { name: 'C_ProductLengthUoMVH', element: 'UnitOfMeasure' } }]
      meabm,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_ProductHierarchy', element: 'ProductHierarchy' } }]
      prdha,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_ExtProdGrp', element: 'ExternalProductGroup'} }]
      extwg,
      @Consumption.valueHelpDefinition: [{entity: { name: 'I_ProductStatus', element: 'Status'} }]
      mstae,
      @Consumption.valueHelpDefinition: [{entity: { name: 'ZI_CA_VH_MSTAV', element: 'StatusMaterial'}}]
      mstav,
      @Consumption.valueHelpDefinition: [{entity: { name: 'ZI_MM_VH_EAN11', element: 'EAN11'}}]
      ean11,
      saisj,
      tragr,
      magrv,
      breit,
      satnr,
      kznfm,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_USER', element: 'Bname' } }]
      aenam,
      blanz,
      bismt,
      bwvor,
      ergew,
      ergei,
      mhdhb,
      vhart,
      mhdrz,
      volto,
      gewto,
      /cwm/valum,
      inhme,
      vabme,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'C_ProductUnitOfMeasureVH', element: 'UnitOfMeasure' } }]
      meins,
      liqdt,
      datab,
      ervol,
      ervoe,
      volum,
      mhdlp,
      @EndUserText.label: 'Admin.lotes - Dados gerais'
      xchpf,
      mlgut,
      taklv,
      cadkz,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_VISAO', element: 'VisionId' } }]
      @Consumption.filter: { selectionType: #SINGLE }
      @EndUserText.label: 'Completo'
      vpsta,
      laeng,
      raube,
      kzkfg,
      inhal,
      kzkup,
      numtp,
      attyp,
      normt,
      fsh_sealv,
      sgt_covsa,
      stfak,
      etifo,
      mtpos_mara,
      begru,
      etiag,
      @Consumption.filter.selectionType: #SINGLE
      @EndUserText.label: 'Marcação p/elim. - Dados gerais'
      lvorm,
      pmata,
      wrkst,
      fuelg,
      kzrev,
      eannr,
      rbnrm,
      brgew,
      ntgew,
      qmpur,
      wesch,
      mbrsh,
      groes,
      etiar,
      plgtp,
      laeda,
      gewei,
      voleh
}
