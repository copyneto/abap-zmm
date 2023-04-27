@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro Item Monitor de Serviço'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_MONIT_SERV_FILTRO_ITEM
  as select from ekpo
{
  key ebeln      as Ebeln,
      min(ebelp) as ebelp,
      min(werks) as Werks
}
group by
  ebeln
