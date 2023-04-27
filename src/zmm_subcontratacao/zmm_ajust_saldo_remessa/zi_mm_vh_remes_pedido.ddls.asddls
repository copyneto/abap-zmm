@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Value Help de Pedido de Saldo de Remessa'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_MM_VH_REMES_PEDIDO
  as select from ZI_MM_RELAT_SALDO_REMESSA
{
  key Ebeln,
  key Matnr
}
group by
  Ebeln,
  Matnr
