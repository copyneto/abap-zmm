@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help Ordem Frete'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_MM_VH_ORDEM_FRETE as select from ZI_MM_PORDEM_FRETE_UNION

{
  @Search.ranking: #MEDIUM
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.8
  @EndUserText.label: 'Numero de Ordem de Frete'
  key NumeroOrdemDeFrete,
  @Search.ranking: #MEDIUM
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.8  
  @EndUserText.label: 'Numero da Remessa'
  key NumeroDaRemessa,
  @EndUserText.label: 'UMD - Origem'
  key UmbOrigin,
  @EndUserText.label: 'UMD - Destino'
  key UmbDestino,
  @EndUserText.label: 'Centro de Remessa'
  key CentroRemessa,
  @EndUserText.label: 'Deposito'
  key Deposito     
}
