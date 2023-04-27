@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro Pedido'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_ADMDESCRG_FLT_PEDID
  as select from ekko
{
      @EndUserText.label: 'Pedido'
  key ebeln as Ebeln,
      bukrs as Bukrs,
      bstyp as Bstyp,
      bsart as Bsart
}
