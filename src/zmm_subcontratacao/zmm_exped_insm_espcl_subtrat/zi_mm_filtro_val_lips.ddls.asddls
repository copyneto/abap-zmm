@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro de Valores da LIPS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_FILTRO_VAL_LIPS
  as select from lips
{
  key vgbel                  as Vgbel,
  key substring(vgpos, 2, 5) as vGpos,
      matnr                  as Matnr,
      vrkme                  as Vrkme,
      @Semantics.quantity.unitOfMeasure : 'Vrkme'
      sum(lfimg)             as LFIMG
}
group by
  vgbel,
  vgpos,
  matnr,
  vrkme
