@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help Status - Monitor de Serviço'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.resultSet.sizeCategory: #XS
@Search.searchable: true
define view entity ZI_MM_MONIT_SERV_VH_STATUS
  as select from ZI_CA_PARAM_VAL
{
      //      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      //      @Search.fuzzinessThreshold: 0.8
      @EndUserText.label: 'Status'
  key Low as Status
}
where
      Modulo = 'MM'
  and Chave1 = 'MONITOR_SERVICOS'
  and Chave2 = 'STATUS'
group by
  Low
