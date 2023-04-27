@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro tabela ZTMM_EMISSA_NF'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_FILTRO_SHIPPING
  as select from ztmm_emissa_nf
{
  key shipfrom as Shipfrom,
  key shipto   as Shipto,
      'X'      as sh_Found

}
