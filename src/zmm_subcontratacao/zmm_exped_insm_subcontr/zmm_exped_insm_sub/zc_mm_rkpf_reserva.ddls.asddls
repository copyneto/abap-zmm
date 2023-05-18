@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Exped. Insumos - Subcontratação'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity zc_mm_rkpf_reserva
  as projection on zi_mm_rkpf_reserva
{
  key Rsnum,
      Ebeln,
      /* Associations */
      _Item : redirected to composition child zc_mm_resb_reserva_item
}
