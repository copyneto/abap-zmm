
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Executar ZMMSD_PLANLOG'
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
@Metadata.allowExtensions: true

define root view entity ZC_MM_PLANLOG_EXECUTE_GET as projection on ZI_MM_PLANLOG_EXECUTE_GET as Variante
{
      key ztran,
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'Zi_ca_vh_werks', element : 'WerksCode' }}]
      key zvari
}
