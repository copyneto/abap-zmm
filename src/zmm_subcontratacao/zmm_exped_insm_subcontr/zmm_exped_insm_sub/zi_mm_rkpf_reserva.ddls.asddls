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
  as select from zi_mm_rkpf_reserva_filt

  composition [1..*] of zi_mm_resb_reserva_item as _Item
{
  key Rsnum as Rsnum,
      Ebeln as Ebeln,

      _Item
}
