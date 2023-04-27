@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro Romaneio'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_ADMDESCRG_FLT_ROMAN
  as select from ztmm_romaneio_in
{
  key sequence as Romaneio,
      @EndUserText.label: 'Pedido'
      ebeln    as Ebeln,
      ebelp    as Ebelp
}
group by
  sequence,
  ebeln,
  ebelp
