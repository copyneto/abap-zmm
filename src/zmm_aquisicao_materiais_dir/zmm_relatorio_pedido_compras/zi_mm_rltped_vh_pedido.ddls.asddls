@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Value Help Pedido de Compras'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_RLTPED_VH_PEDIDO
  as select from ekko
{
  key ebeln,
      bukrs,
      bstyp,
      bsart
}
where
  loekz = ''
