@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Reserva'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_MM_VH_RESERVATION
  as select from I_ReservationDocumentHeader
{
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key Reservation,
      @Search.ranking: #LOW
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      OrderID,
      @Search.ranking: #LOW
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      GoodsMovementType,
      @Search.ranking: #LOW
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      CostCenter,
      @Search.ranking: #LOW
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      ControllingArea,
      @Search.ranking: #LOW
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      GoodsRecipientName,
      @Search.ranking: #LOW
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      ReservationDate,
      @Search.ranking: #LOW
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      IsCheckedAgainstFactoryCal,
      @Search.ranking: #LOW
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      SalesOrder

}
