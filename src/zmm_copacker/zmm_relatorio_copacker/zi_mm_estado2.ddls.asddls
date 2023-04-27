@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Busa Estado'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_ESTADO2
  as select from    I_DeliveryDocument as DeliveryDocument
    left outer join kna1 on DeliveryDocument.ShipToParty = kna1.kunnr
{
  key DeliveryDocument.DeliveryDocument,
      DeliveryDocument.ShipToParty,
      kna1.regio as Estado
}
where
  DeliveryDocument.ShipToParty <> ''
