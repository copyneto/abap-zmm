@EndUserText.label: 'Período bloqueio fiscal GRC'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_MM_DATA_BLOQ_GRC
  as projection on ZI_MM_DATA_BLOQ_GRC
{
  key DocUuidH,
      @Consumption.filter.selectionType: #INTERVAL
      DataInicio,
      @Consumption.filter.selectionType: #INTERVAL
      DataFim,
      Obs,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
