@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Visão de Dados Básicos'
define root view entity ZI_MM_VISAO_DADOS_BASICOS
  as select from    mara
    left outer join makt             as makt   on  makt.matnr = mara.matnr
                                               and makt.spras = $session.system_language
    left outer join makt             as maktpt on  maktpt.matnr = mara.matnr
                                               and maktpt.spras = 'P'
    left outer join makt             as makten on  makten.matnr = mara.matnr
                                               and makten.spras = 'E'
    left outer join makt             as maktes on  maktes.matnr = mara.matnr
                                               and maktes.spras = 'S'
    left outer join mean                       on  mean.matnr = mara.matnr
                                               and mean.meinh = mara.meins
                                               and mean.lfnum = '00001'
    left outer join ztmm_catalogorfb as rfb    on rfb.material = mara.matnr
{
  key mara.matnr,
  key rfb.idrfb,
      mara.mtart,
      @EndUserText.label: 'Descrição PT'
      maktpt.maktx as maktxpt,
      @EndUserText.label: 'Descrição EN'
      makten.maktx as maktxen,
      @EndUserText.label: 'Descrição ES'
      maktes.maktx as maktxes,
      makt.maktg,
      mara.ersda,
      mara.ernam,
      mara.matkl,
      mara.spart,
      mara.meabm,
      mara.prdha,
      mara.extwg,      
      mara.mstae,
      mara.mstav,
      mara.ean11,
//      mean.ean11,
      mara.saisj,
      mara.tragr,
      mara.magrv,
      @Semantics.quantity.unitOfMeasure: 'meabm'
      mara.breit,
      mara.satnr,
      mara.kznfm,
      mara.aenam,
      mara.blanz,
      mara.bismt,
      mara.bwvor,
      @Semantics.quantity.unitOfMeasure: 'ergei'
      mara.ergew,
      mara.ergei,
      mara.mhdhb,
      mara.vhart,
      mara.mhdrz,
      mara.volto,
      mara.gewto,
      mara./cwm/valum,
      mara.inhme,
      mara.vabme,
      mara.meins,
      mara.liqdt,
      mara.datab,
      @Semantics.quantity.unitOfMeasure: 'ervoe'
      mara.ervol,
      mara.ervoe,
      @Semantics.quantity.unitOfMeasure: 'voleh'
      mara.volum,
      mara.mhdlp,
      @EndUserText.label: 'Admin.lotes - Dados gerais'
      mara.xchpf,
      mara.mlgut,
      mara.taklv,
      mara.cadkz,
      @EndUserText.label: 'Completo'
      mara.vpsta,
      @Semantics.quantity.unitOfMeasure: 'meabm'
      mara.laeng,
      mara.raube,
      mara.kzkfg,
      @Semantics.quantity.unitOfMeasure: 'inhme'
      mara.inhal,
      mara.kzkup,
      mara.numtp,
      mara.attyp,
      mara.normt,
      mara.fsh_sealv,
      mara.sgt_covsa,
      mara.stfak,
      mara.etifo,
      mara.mtpos_mara,
      mara.begru,
      mara.etiag,
      @EndUserText.label: 'Marcação p/elim. - Dados gerais'
      mara.lvorm,
      mara.pmata,
      mara.wrkst,
      mara.fuelg,
      mara.kzrev,
      mara.eannr,
      mara.rbnrm,
      @Semantics.quantity.unitOfMeasure: 'gewei'
      mara.brgew,
      @Semantics.quantity.unitOfMeasure: 'gewei'
      mara.ntgew,
      mara.qmpur,
      @Semantics.quantity.unitOfMeasure: 'meins'
      mara.wesch,
      mara.mbrsh,
      mara.groes,
      mara.etiar,
      mara.plgtp,
      mara.laeda,
      mara.gewei,
      mara.voleh
}
