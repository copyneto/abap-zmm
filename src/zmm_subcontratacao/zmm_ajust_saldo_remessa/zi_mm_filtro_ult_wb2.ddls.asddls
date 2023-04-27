@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro na WB2_V_LIKP_LIPS2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_MM_FILTRO_ULT_WB2
  as select from    likp
    left outer join lips            on lips.vbeln = likp.vbeln
    left outer join lips as Lips_un on  Lips_un.vbeln = likp.vbeln
                                    and Lips_un.posnr = '000010'
{
  key lips.vgbel                  as Vgbel,
  key substring(lips.vgpos, 2, 5) as Vgpos,
      max(likp.vbeln)             as Vbeln,
      lips.matnr                  as MATNR,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      sum(lips.lfimg)             as Lfimg,
      Lips_un.meins               as Meins

}
where
      likp.lfart = 'LB'
  and lips.vgbel is not initial
  and lips.vgpos is not initial
group by
  lips.vgbel,
  lips.vgpos,
  lips.matnr,
  Lips_un.meins
