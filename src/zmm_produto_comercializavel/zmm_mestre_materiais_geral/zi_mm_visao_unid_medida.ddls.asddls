@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Visão de Unidade de Medida'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define root view entity ZI_MM_VISAO_UNID_MEDIDA
  as select from    mara
    left outer join makt as makt   on  makt.matnr = mara.matnr
                                   and makt.spras = $session.system_language
    left outer join makt as maktpt on  maktpt.matnr = mara.matnr
                                   and maktpt.spras = 'P'
    left outer join makt as makten on  makten.matnr = mara.matnr
                                   and makten.spras = 'E'
    left outer join makt as maktes on  maktes.matnr = mara.matnr
                                   and maktes.spras = 'S'
    left outer join marm           on marm.matnr = mara.matnr
{
  key mara.matnr,
  key marm.meinh,
      mara.mtart,
      @EndUserText.label: 'Descrição PT'
      maktpt.maktx                         as maktxpt,
      @EndUserText.label: 'Descrição EN'
      makten.maktx                         as maktxen,
      @EndUserText.label: 'Descrição ES'
      maktes.maktx                         as maktxes,
      makt.maktg,
      mara.ersda,
      mara.ernam,
      mara.matkl,
      marm.meabm,
      mara.meins,
      @Semantics.quantity.unitOfMeasure: 'meabm'
      marm.hoehe,
      marm./sttpec/serno_prov_bup,
      marm.umrez,
      marm.umren,
      marm.eannr,
      marm.ean11,
      marm.numtp,
      @Semantics.quantity.unitOfMeasure: 'meabm'
      marm.laeng,
      @Semantics.quantity.unitOfMeasure: 'meabm'
      marm.breit,
      @Semantics.quantity.unitOfMeasure: 'voleh'
      marm.volum,
      marm.voleh,
      @Semantics.quantity.unitOfMeasure: 'gewei'
      marm.brgew,
      marm.gewei,
      marm.mesub,
      cast ( marm.atinn as abap.char(30) ) as atinn,
      marm.mesrt,
      marm.xfhdw,
      marm.xbeww,
      marm.kzwso,
      marm.msehi,
      marm.bflme_marm,
      marm.gtin_variant,
      marm.nest_ftr,
      marm.max_stack,
      @Semantics.quantity.unitOfMeasure: 'top_load_full_uom'
      marm.top_load_full,
      marm.top_load_full_uom,
      marm.capause,
      marm.ty2tq,
      marm.dummy_uom_incl_eew_ps,
      marm./cwm/ty2tq,
      marm./sttpec/ncode,
      marm./sttpec/ncode_ty,
      marm./sttpec/rcode,
      marm./sttpec/seruse,
      marm./sttpec/syncchg,
      marm./sttpec/serno_managed,
      marm./sttpec/uom_sync,
      marm./sttpec/ser_gtin,
      marm.pcbut
}
