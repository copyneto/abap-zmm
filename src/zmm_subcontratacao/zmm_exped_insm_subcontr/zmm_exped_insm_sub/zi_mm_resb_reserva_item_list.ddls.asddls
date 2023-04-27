@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Exped. Insumos - Subcontratação - Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity zi_mm_resb_reserva_item_list 
as select from zi_mm_resb_reserva_item_union {
  key Rsnum,
  key Rspos,
  key Item,
  Charg,
  Matnr,
  Werks,
  Lgort,
  Quantidade,
  QtdePicking,
  Meins,
  Bwtar
}
