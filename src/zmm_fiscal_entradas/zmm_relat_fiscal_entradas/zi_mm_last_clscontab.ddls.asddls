@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro Classificação Contábil'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_LAST_CLSCONTAB
  as select from ekkn
{
  key ebeln                                as Pedido,
  key lpad(cast(ebelp as char6), 6 , '0' ) as Item,
      ebelp                                as ItemNconv,
      min(zekkn)                           as Contador

}
group by
  ebeln,
  ebelp
