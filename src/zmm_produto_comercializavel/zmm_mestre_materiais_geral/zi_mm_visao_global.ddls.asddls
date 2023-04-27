@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Visão Global'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define root view entity ZI_MM_VISAO_GLOBAL
  as select from    mara
    left outer join makt             as makt   on  makt.matnr = mara.matnr
                                               and makt.spras = $session.system_language
    left outer join makt             as maktpt on  maktpt.matnr = mara.matnr
                                               and maktpt.spras = 'P'
    left outer join makt             as makten on  makten.matnr = mara.matnr
                                               and makten.spras = 'E'
    left outer join makt             as maktes on  maktes.matnr = mara.matnr
                                               and maktes.spras = 'S'
    left outer join marc                       on marc.matnr = mara.matnr
    left outer join mard                       on  mard.matnr = mara.matnr
                                               and mard.werks = marc.werks
    left outer join mbew                       on mbew.matnr = mara.matnr
    left outer join t001k                      on t001k.bwkey = mbew.bwkey
    left outer join t001                       on t001.bukrs = t001k.bukrs
    left outer join mvke                       on mvke.matnr = mara.matnr
    left outer join marm                       on marm.matnr = mara.matnr
    left outer join mean                       on  mean.matnr = mara.matnr
                                               and mean.meinh = mara.meins
    left outer join ztmm_catalogorfb as rfb    on rfb.material = mara.matnr
{
  key mara.matnr,
  key marc.werks,
  key mard.lgort,
  key mbew.bwkey,
  key mbew.bwtar,
  key mvke.vkorg,
  key mvke.vtweg,
  key marm.meinh,
  key rfb.idrfb,
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
      mara.spart,
      mara.prdha,
      mara.mstae,
      mara.mstav,
      marc.mmsta,
      marc.ekgrp,
      marc.prctr,
      marc.steuc,
      mard.sperr,
      marc.herbl,
      mbew.fbwst,
      mbew.lbwst,
      mbew.vbwst,
      mbew.pdatl,
      mara.saisj,
      marc.abfac,
      marc.lgrad,
      mvke.ktgrm,
      mbew.kosgr,
      mara.extwg,
      mbew.hrkft,
      mara.tragr,
      mara.magrv,
      marc.fxhor,
      mbew.abwkz,
      marc.sbdkz,
      marc.vint2,
      marc.prfrq,
      @Semantics.quantity.unitOfMeasure: 'meins'
      marc.ltinc,
      mbew.mbrue,
      @Semantics.quantity.unitOfMeasure: 'meabm'
      mara.breit,
      mbew.mlmaa,
      mbew.bwspa,
      mara.satnr,
      mara.kznfm,
      marc.indus,
      mvke.pmatn,
      mara.aenam,
      marc.vrmod,
      marc.ncost,
      marc.kzagl,
      mbew.kalnr,
      mara.blanz,
      mara.bismt,
      marc.copam,
      mara.bwvor,
      marc.qmatv,
      marc.kzkri,
      marc.rwpro,
      marc.sfcpf,
      marc.dispr,
      mbew.pprdz,
      mbew.pprdv,
      @Semantics.quantity.unitOfMeasure: 'ergei'
      mara.ergew,
      mara.ergei,
      marc.dispo,
      @Semantics.quantity.unitOfMeasure: 'meins'
      marc.minbe,
      mara.mhdhb,
      @Semantics.amount.currencyCode: 'waers'
      mbew.stprv,
      @Semantics.amount.currencyCode: 'waers'
      mbew.bwph1,
      @Semantics.amount.currencyCode: 'waers'
      mbew.vplpx,
      @Semantics.amount.currencyCode: 'waers'
      mbew.lplpx,
      @Semantics.amount.currencyCode: 'waers'
      mbew.zplpr,
      @Semantics.amount.currencyCode: 'waers'
      mbew.lplpr,
      @Semantics.amount.currencyCode: 'waers'
      mbew.zplp1,
      @Semantics.amount.currencyCode: 'waers'
      mbew.zplp2,
      @Semantics.amount.currencyCode: 'waers'
      mbew.zplp3,
      @Semantics.amount.currencyCode: 'waers'
      mbew.vjbwh,
      @Semantics.amount.currencyCode: 'waers'
      mbew.vjbws,
      mbew.ownpr,
      marc.sauft,
      marc.nkmpr,
      mvke.versg,
      @Semantics.quantity.unitOfMeasure: 'meins'
      mvke.lfmng,
      @Semantics.quantity.unitOfMeasure: 'meins'
      mvke.aumng,
      @Semantics.quantity.unitOfMeasure: 'meins'
      marc.basmg,
      mbew.timestamp,
      mbew.xlifo,
      mbew.pstat,
      @Semantics.quantity.unitOfMeasure: 'meins'
      marc.losgr,
      @Semantics.quantity.unitOfMeasure: 'meins'
      marc.bstma,
      @Semantics.quantity.unitOfMeasure: 'meins'
      marc.bstmi,
      marc.tranz,
      marc.vrvez,
      marc.webaz,
      cast ( marc.scm_grprt as abap.fltp ) as scm_grprt,
      cast ( marc.scm_giprt as abap.fltp ) as scm_giprt,
      marc.dzeit,
      marc.wzeit,
      @EndUserText.label: 'Marcação p/elim. - Dados de avaliação'
      mbew.lvorm                           as LVORMW,
      marc.dismm,
      marc.otype,
      marc.beskz,
      mara.vhart,
      @Semantics.quantity.unitOfMeasure: 'meins'
      mard.einme,
      marc.takzt,
      mara.mhdrz,
      mara.volto,
      marc.uneto,
      marc.ueeto,
      mara.gewto,
      @Semantics.amount.currencyCode: 'waers'
      marc.vkumc,
      mbew.laepr,
      mara./cwm/valum,
      mara.inhme,
      mara.vabme,
      mara.meins,
      marc.lzeih,
      mbew.peinh,
      mbew.mtuse,
      @Semantics.amount.currencyCode: 'waers'
      mard.vklab,
      @Semantics.amount.currencyCode: 'waers'
      marc.vkglg,
      mara.liqdt,
      mara.datab,
      @Semantics.amount.currencyCode: 'waers'
      mbew.vjsal,
      @Semantics.quantity.unitOfMeasure: 'meins'
      marc.bstrf,
      @Semantics.amount.currencyCode: 'waers'
      mbew.vmsav,
      @Semantics.amount.currencyCode: 'waers'
      mbew.salkv,
      @Semantics.amount.currencyCode: 'waers'
      mbew.vmsal,
      marc.plvar,
      @Semantics.quantity.unitOfMeasure: 'meins'
      marc.glgmg,
      marc.mtvfp,
      mbew.vers1,
      @Semantics.quantity.unitOfMeasure: 'ervoe'
      mara.ervol,
      mara.ervoe,
      @Semantics.quantity.unitOfMeasure: 'voleh'
      mara.volum,
      mara.mhdlp,
      @EndUserText.label: 'Admin.lotes - Dados de centro'
      marc.xchpf                           as XCHPFC,
      @EndUserText.label: 'Admin.lotes - Dados gerais'
      mara.xchpf,
      @Semantics.quantity.unitOfMeasure: 'meabm'
      marm.hoehe,
      marc.sproz,
      mvke.prat1,
      mara.mlgut,
      marc.sobsk,
      marc.mrppp,
      mvke.dwerk,
      marc.ssqss,
      marc.awsls,
      mbew.kalsc,
      mbew.bklas,
      mara.taklv,
      marm./sttpec/serno_prov_bup,
      mbew.eklas,
      mbew.oklas,
      marc.max_troc,
      marc.min_troc,
      mbew.kziwl,
      @EndUserText.label: 'Cód.inv.físico IR - Dados de avaliação'
      mbew.abciw,
      @EndUserText.label: 'Cód.inv.físico IR - Dados de centro'
      marc.abcin,
      marc.maabc,
      mara.cadkz,
      marc.auftl,
      marc.perkz,
      mara.ean11,
      marc.shflg,
      marc.kzppv,
      mvke./bev1/emdrckspl,
      mbew.ekalr,
      @EndUserText.label: 'Completo'
      mara.vpsta,
      @Semantics.quantity.unitOfMeasure: 'meabm'
      mara.laeng,
      marc.wstgh,
      mara.raube,
      marc.cuobj,
      mara.kzkfg,
      @Semantics.quantity.unitOfMeasure: 'inhme'
      mara.inhal,
      mbew.vprsv,
      mara.kzkup,
      @Semantics.amount.currencyCode: 'waers'
      marc.losfx,
      marc.bwtty,
      marc.qzgtp,
      mara.numtp,
      mara.attyp,
      @Semantics.quantity.unitOfMeasure: 'meins'
      mard.vmein,
      mbew.zpld1,
      mbew.zpld2,
      mbew.zpld3,
      mara.normt,
      mvke.sktof,
      marc.kzdkz,
      mbew.wlinl,
      marc.mpdau,
      @Semantics.quantity.unitOfMeasure: 'meins'
      marc.umlmc,
      mara.fsh_sealv,
      @Semantics.quantity.unitOfMeasure: 'meins'
      marc.eisbe,
      @Semantics.quantity.unitOfMeasure: 'meins'
      marc.trame,
      @Semantics.quantity.unitOfMeasure: 'meins'
      marc.mabst,
      @Semantics.quantity.unitOfMeasure: 'meins'
      mbew.vmkum,
      @Semantics.quantity.unitOfMeasure: 'meins'
      marc.eislo,
      @Semantics.quantity.unitOfMeasure: 'meins'
      marc.target_stock,
      marc.scm_ges_bst_use,
      @Semantics.quantity.unitOfMeasure: 'meins'
      marc.bwesb,
      @Semantics.amount.currencyCode: 'waers'
      marc.vktrw,
      mara.sgt_covsa,
      marc.lfgja,
      mbew.pdatz,
      marc.vzusl,
      mara.stfak,
      mara.etifo,
      marc.ueetk,
      mara.mtpos_mara,
      marc.ladgr,
      mara.begru,
      mvke.bonus,
      mvke.provg,
      mvke.mtpos,
      mara.etiag,
      mvke.kondm,
      marc.resvp,
      marc.dplho,
      marc.vint1,
      marc.mcrue,
      @EndUserText.label: 'Marcação p/elim. - Dados gerais'
      mara.lvorm,
      marc.shzet,
      mara.pmata,
      mara.wrkst,
      marc.vrbfk,
      mara.fuelg,
      mara.kzrev,
      mbew.kaln1,
      mara.eannr,
      mvke.pvmso,
      mbew.hkmat,
      mbew.mtorg,
      marc.atpkz,
      mvke.mvgr1,
      marc.maxlz,
      mara.rbnrm,
      marc.sernp,
      marc.lfmon,
      @Semantics.quantity.unitOfMeasure: 'gewei'
      mara.brgew,
      @Semantics.quantity.unitOfMeasure: 'gewei'
      mara.ntgew,
      marc.kzdie,
      marc.gpmkz,
      mbew.mypol,
      @Semantics.amount.currencyCode: 'waers'
      mbew.zkprs,
      @Semantics.amount.currencyCode: 'waers'
      mbew.verpr,
      @Semantics.amount.currencyCode: 'waers'
      mbew.stprs,
      @Semantics.amount.currencyCode: 'waers'
      mbew.bwprh,
      @Semantics.amount.currencyCode: 'waers'
      mbew.bwprs,
      @Semantics.amount.currencyCode: 'waers'
      mbew.bwps1,
      marc.plifz,
      mara.qmpur,
      @Semantics.quantity.unitOfMeasure: 'meins'
      mvke.lfmax,
      @Semantics.quantity.unitOfMeasure: 'meins'
      mara.wesch,
      marc.kausf,
      marc.quazt,
      marc.ausss,
      marc.disls,
      marc.kzpro,
      mara.mbrsh,
      marc.sobsl,
      @Semantics.quantity.unitOfMeasure: 'meins'
      marc.bstfe,
      mara.groes,
      mara.etiar,
      marc.plnty,
      mara.plgtp,
      mara.laeda,
      marc.ausme,
      mara.gewei,
      mvke.vrkme,
      mara.voleh,
      marc.usequ,
      @Semantics.amount.currencyCode: 'waers'
      mbew.salk3,
      mbew.bwva1,
      marm.umrez,
      marm.umren,
      marm.eannr                           as eannrm,
      marm.ean11                           as ean11m,
      marm.numtp                           as numtpm,
      @Semantics.quantity.unitOfMeasure: 'meabm'
      marm.laeng                           as laengm,
      @Semantics.quantity.unitOfMeasure: 'meabm'
      marm.breit                           as breitm,
      @Semantics.quantity.unitOfMeasure: 'meabm'
      marm.hoehe                           as hoehem,
      marm.meabm,
      @Semantics.quantity.unitOfMeasure: 'volehm'
      marm.volum                           as volumm,
      marm.voleh                           as volehm,
      @Semantics.quantity.unitOfMeasure: 'geweim'
      marm.brgew                           as brgewm,
      marm.gewei                           as geweim,
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
      marm.pcbut,
      t001.waers
}
