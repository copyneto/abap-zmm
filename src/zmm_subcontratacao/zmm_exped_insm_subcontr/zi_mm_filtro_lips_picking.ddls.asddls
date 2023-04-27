@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro LIPS - Picking'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_FILTRO_LIPS_PICKING
  as select from lips
{
  key vbeln                                   as Vbeln,
      matnr                                   as Matnr,
      sum( cast( lfimg as abap.dec( 13, 3 ))) as Lfimg
}
group by
  vbeln,
  matnr
