@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cabeçalho Reserva - RKPF'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define root view entity zi_mm_rkpf_reserva 
  as select from resb 
  composition [0..*] of zi_mm_resb_reserva_item as _Item
{
  key rsnum as Rsnum,
  ebeln as Ebeln,
  
  _Item
}group by rsnum , ebeln
