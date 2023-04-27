@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contador de mensagens'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity zi_mm_message_counter
  as select from zi_mm_message_group
{
  key guid,
      cast( count(*) as abap.fltp ) as msgCounter
}
group by
  guid
