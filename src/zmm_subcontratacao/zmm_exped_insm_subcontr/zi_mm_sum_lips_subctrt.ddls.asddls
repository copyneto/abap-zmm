@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Exped. Insumos - Subcont. Soma LIPS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_SUM_LIPS_SUBCTRT
  as select from     lips

    right outer join likp on  likp.vbeln = lips.vbeln
                          and likp.lfart = 'LB'
{
  key lips.vgbel                  as vgbel,
  key substring(lips.vgpos, 2, 5) as vgpos,
      lips.matnr                  as Matnr,
      @Semantics.quantity.unitOfMeasure: 'vrkme'
      sum(lips.lfimg)             as LFIMG,
      lips.vrkme                  as Vrkme,
      max(lips.vbeln)             as Vbeln,
      min(lips.posnr)             as Posnr,
      lips.bwtar                  as Bwtar

}
where
  lips.vgbel is not initial
group by
  lips.vgbel,
  lips.vgpos,
  lips.matnr,
  lips.vrkme,
  lips.bwtar
