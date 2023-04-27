@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro na LIPS adaptada a RESB'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_EXPED_FILTR_LIPS
  as select from    lips

    left outer join likp on likp.vbeln = lips.vbeln

{
  key lips.vgbel                  as vgbel,
  key substring(lips.vgpos, 2, 5) as vgpos,
      lips.matnr                  as Matnr,
      @Semantics.quantity.unitOfMeasure: 'vrkme'
      sum(lips.lfimg)             as LFIMG,
      lips.vrkme                  as vrkme,
      lips.vbeln                  as Vbeln,
      min(lips.posnr)             as Posnr,
      max(likp.inco3_l)           as XML
      //  key lips.vbeln                  as Vbeln,
      //  key lips.posnr                  as Posnr,
      //      lips.vgbel                  as Vgbel,
      //      lips.matnr                  as Matnr,
      //      substring(lips.vgpos, 2, 5) as Vgpos,
      //      @Semantics.quantity.unitOfMeasure : 'Vrkme'
      //      lips.lfimg                  as Lfimg,
      //      lips.vrkme                  as Vrkme,
      //      likp.inco3_l                as XML
      //      //      'X'                         as encontrado
}
where
  lips.vgbel is not initial
group by
  lips.vgbel,
  lips.vgpos,
  lips.matnr,
  lips.vrkme,
  lips.vbeln
