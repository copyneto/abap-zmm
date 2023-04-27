@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dados do Produto'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_MM_CONF_PROD
  as select from    marc             as a
    left outer join mara             as b on a.matnr = b.matnr
    left outer join makt             as c on  a.matnr = c.matnr
                                          and c.spras = 'P'
    left outer join marm             as d on b.matnr = d.matnr
    left outer join ztmm_paletizacao as e on  a.matnr = e.material
                                          and a.werks = e.centro
    left outer join t179             as f on b.prdha = f.prodh
    left outer join t179t            as g on f.prodh = g.prodh

{
  key a.werks,
  key b.mtart,
  key a.matnr,
  key d.meinh,
      a.maxlz,
      b.meins,
      b.gewei,
      b.mhdrz,
      b.mhdhb,
      b.prdha,
      c.maktx,
      d.umrez,
      d.umren,
      //      @Semantics.quantity.unitOfMeasure: 'z_unit'
      cast( e.z_lastro as abap.dec( 13, 3 ) ) as z_lastro,
      //      @Semantics.quantity.unitOfMeasure: 'z_unit'
      cast( e.z_altura as abap.dec( 13, 3 ) ) as z_altura,
      e.z_unit,
      g.vtext                                 as VTEXT1,
      g.vtext                                 as VTEXT2,
      g.vtext                                 as VTEXT3,

      case
      when d.umren > 1
       then fltp_to_dec((cast(d.umrez as abap.fltp) / cast(d.umren as abap.fltp)) * cast(b.ntgew as abap.fltp) as abap.dec( 13, 3 ))
       else (d.umrez * d.umren) * cast(b.ntgew as abap.dec(13,3))
      end                                     as zntgew,

      cast(d.brgew as abap.dec(13,3))         as zbrgew,
      //      b.ntgew                                 as ntgew,
      //      //      cast( b.ntgew as abap.dec( 13, 3 ) )    as ntgew,
      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_CONV_MAT'
      //      //      @Semantics.quantity.unitOfMeasure: 'gewei'
      //      cast( 0 as abap.dec( 13, 3 ) )          as zntgew,
      //      //      @Semantics.quantity.unitOfMeasure: 'gewei'
      //      cast( d.brgew as abap.dec( 13, 3 ) )    as brgew,
      //      cast( b.brgew as abap.dec( 13, 3 ) )    as brgew_mara,
      //      //      @Semantics.quantity.unitOfMeasure: 'gewei'
      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_CONV_MAT'
      //      cast( 0  as abap.dec( 13, 3 ) )         as zbrgew,
      d.ean11,
      d.numtp,
      //      @Semantics.quantity.unitOfMeasure: 'meabm'
      cast( d.laeng as abap.dec( 13, 3 ) )    as laeng,
      //      @Semantics.quantity.unitOfMeasure: 'meabm'
      cast( d.breit as abap.dec( 13, 3 ) )    as breit,
      //      @Semantics.quantity.unitOfMeasure: 'meabm'
      cast(  d.hoehe as abap.dec( 13, 3 ) )   as hoehe,
      d.meabm,
      //      @Semantics.quantity.unitOfMeasure: 'voleh'
      cast( d.volum as abap.dec( 13, 3 ) )    as volum,
      d.voleh
}
