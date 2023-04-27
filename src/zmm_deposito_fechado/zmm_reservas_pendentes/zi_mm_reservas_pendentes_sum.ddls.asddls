@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Soma dos Itens de Reserva'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_RESERVAS_PENDENTES_SUM
  as select from I_ReservationDocumentItem

{

  key Reservation,
      Product                              as Material,
      BaseUnit,
      Plant,
      StorageLocation,
      Batch,
      _ReservationDocumentHeader.UserID    as CreatedBy,
      _ReservationDocumentHeader.CreationDateTime,
      @Semantics.quantity.unitOfMeasure : 'BaseUnit'
      sum( ResvnItmRequiredQtyInBaseUnit ) as EstoqueReservaPendente

}
//where
//  GoodsMovementIsAllowed = 'X'
group by
  Reservation,
  Product,
  BaseUnit,
  Plant,
  Batch,
  StorageLocation,
  _ReservationDocumentHeader.UserID,
  _ReservationDocumentHeader.CreationDateTime
