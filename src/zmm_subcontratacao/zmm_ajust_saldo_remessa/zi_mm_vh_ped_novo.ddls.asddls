@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Value Help de Pedido Novo'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
//@Search.searchable: true
define view entity ZI_MM_VH_PED_NOVO
  as select from ekpo
{
  key ebeln as PedNv,
      matnr
}
where
  matnr is not initial

group by
  ebeln,
  matnr
