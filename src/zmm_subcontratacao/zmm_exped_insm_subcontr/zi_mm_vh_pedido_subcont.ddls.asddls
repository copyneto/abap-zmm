@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Pedidos Subcontratação'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_VH_PEDIDO_SUBCONT
  as select from ZI_MM_EXPED_SUBCONTRAT
{
  key Ebeln
}
group by
  Ebeln
