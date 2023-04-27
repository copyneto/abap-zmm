@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Limite para maximo de processamento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity zi_mm_limite_processa_registro 
as select from zi_mm_message_counter 
left outer join ztca_param_val  on ztca_param_val.modulo = 'MM' and ztca_param_val.chave1 = 'LIMITE_PROCESSA_JOB' and ztca_param_val.chave2 = 'QUANTIDADE'
{

  key zi_mm_message_counter.guid,
  zi_mm_message_counter.msgCounter,
  cast( cast( ztca_param_val.low as abap.numc(16) ) as abap.fltp ) as maximo,
  case when zi_mm_message_counter.msgCounter >= cast( cast( ztca_param_val.low as abap.numc(16) ) as abap.fltp ) 
  then 'X'
  else ''
  end as valor
}
