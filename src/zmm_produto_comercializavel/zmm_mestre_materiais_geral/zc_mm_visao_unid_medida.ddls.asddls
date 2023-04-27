@EndUserText.label: 'Visão de Unidade de Medida'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_MM_VISAO_UNID_MEDIDA
  as projection on ZI_MM_VISAO_UNID_MEDIDA
{
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_MATERIAL', element: 'Product' }, label: 'Materiais por Descrição' }]
//      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_ProductStdVH', element: 'Product' }, label: 'Materiais por Descrição' },
//                                         { entity: { name: 'I_ProductByPlantVH', element: 'Product' }, qualifier: 'ProdPlant', label: 'Materiais por Centro' },
//                                         { entity: { name: 'I_ProductByDistributionChainVH', element: 'Product' }, qualifier: 'ProdDistrChain', label: 'Materiais por Canal de Distribuição' },
//                                         { entity: { name: 'I_ProdByEWMWarehouseVH', element: 'Product' }, qualifier: 'ProdEwm', label: 'Materiais por EWM Warehouse' }]
  key matnr as Product,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_UnitOfMeasure', element: 'UnitOfMeasure' } }]
  key meinh,
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
      breit,
      volum,
      hoehe,
      /sttpec/serno_prov_bup,
      @Consumption.valueHelpDefinition: [{entity: { name: 'ZI_MM_VH_EAN11', element: 'EAN11'}}]
      ean11,
      laeng,
      numtp,
      eannr,
      brgew,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'C_Weightuom', element: 'WeightUnit'} }]
      gewei,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'C_Volumeuom', element: 'VolumeUnit'} }]
      voleh,
      umrez,
      umren,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'C_ProductUnitOfMeasureVH', element: 'UnitOfMeasure' } }]
      meins,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'C_ProductLengthUoMVH', element: 'UnitOfMeasure' } }]
      meabm,
      mesub,
      @EndUserText.label: 'Característica'
      atinn,
      mesrt,
      xfhdw,
      xbeww,
      kzwso,
      msehi,
      bflme_marm,
      gtin_variant,
      nest_ftr,
      max_stack,
      top_load_full,
      top_load_full_uom,
      capause,
      ty2tq,
      dummy_uom_incl_eew_ps,
      /cwm/ty2tq,
      /sttpec/ncode,
      /sttpec/ncode_ty,
      /sttpec/rcode,
      /sttpec/seruse,
      /sttpec/syncchg,
      /sttpec/serno_managed,
      /sttpec/uom_sync,
      /sttpec/ser_gtin,
      pcbut
}
