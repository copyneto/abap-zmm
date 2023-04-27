@EndUserText.label: 'CDS de Projeção - Log de modificações de material'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_LOG_MODIF_MATERIAIS
  as projection on ZI_MM_LOG_MODIF_MATERIAIS
{
      @Consumption.semanticObject: 'Material'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_MATERIAL', element: 'Product' } }]
  key matnr as Product,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_CENTRO', element: 'Plant' } }]
  key werks,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DEPOSITO', element: 'Lgort' } }]
  key lgort,
  key bwkey,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_BWTAR', element: 'bwtar' } }]
  key bwtar,
  key lgnum,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VKORG', element: 'OrgVendas' } }]
  key vkorg,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VTWEG', element: 'CanalDistrib' } }]
  key vtweg,
      @ObjectModel.text.element: ['ChngindTxt']
  key chngind,
  key fname,
  key value_new,
  key value_old,
      @Consumption.filter: { selectionType: #INTERVAL, mandatory: true }
  key udate,
  key utime,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_ChangeDocUser', element: 'UserName' } }]
  key username,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_TIPO_MATERIAL', element: 'ProductType' } }]
      mtart,
      @Consumption: { valueHelpDefinition: [{ entity: { name: 'I_Division', element: 'Division'} }] }
      spart,

      ddtext,
      maktx,
      chngindtxt
}
