@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Decisão de Armazenagem do café'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_03_NFNUM
  as select from ztmm_romaneio_in
{
  key nfnum,
      lpad( cast( nfnum as abap.numc( 10 ) ), 10, '0' ) as notafiscal
}
