@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Visão MRP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define root view entity ZI_MM_VISAO_MRP
  as select from           mara
    left outer join        makt as makt   on  makt.matnr = mara.matnr
                                          and makt.spras = $session.system_language
    left outer join        makt as maktpt on  maktpt.matnr = mara.matnr
                                          and maktpt.spras = 'P'
    left outer join        makt as makten on  makten.matnr = mara.matnr
                                          and makten.spras = 'E'
    left outer join        makt as maktes on  maktes.matnr = mara.matnr
                                          and maktes.spras = 'S'
    left outer join        marc           on marc.matnr = mara.matnr
    left outer join        mdma           on mdma.matnr = mara.matnr
    left outer to one join mbew           on mbew.matnr = mara.matnr
    left outer join        t001k          on t001k.bwkey = mbew.bwkey
    left outer join        t001           on t001.bukrs = t001k.bukrs
{
  key mara.matnr,
  key marc.werks,
  key mdma.berid,
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
      marc.dismm,
      marc.mtvfp,
      marc.mmsta,
      marc.ekgrp,
      marc.prctr,
      marc.steuc,
      marc.herbl,
      marc.abfac,
      marc.lgrad,
      marc.fxhor,
      marc.sbdkz,
      marc.vint2,
      marc.prfrq,
      @Semantics.quantity.unitOfMeasure: 'meins'
      marc.ltinc,
      marc.indus,
      marc.vrmod,
      marc.ncost,
      marc.kzagl,
      marc.copam,
      marc.qmatv,
      marc.kzkri,
      marc.rwpro,
      marc.sfcpf,
      marc.dispr,
      marc.dispo,
      @Semantics.quantity.unitOfMeasure: 'meins'
      marc.minbe,
      marc.sauft,
      marc.nkmpr,
      @Semantics.quantity.unitOfMeasure: 'meins'
      marc.basmg,
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
      marc.otype,
      marc.beskz,
      marc.takzt,
      marc.uneto,
      marc.ueeto,
      @Semantics.amount.currencyCode: 'waers'
      marc.vkumc,
      marc.lzeih,
      @Semantics.amount.currencyCode: 'waers'
      marc.vkglg,
      @Semantics.quantity.unitOfMeasure: 'meins'
      marc.bstrf,
      marc.plvar,
      @Semantics.quantity.unitOfMeasure: 'meins'
      marc.glgmg,
      @EndUserText.label: 'Admin.lotes - Dados de centro'
      marc.xchpf,
      marc.sproz,
      marc.sobsk,
      marc.mrppp,
      marc.ssqss,
      marc.awsls,
      marc.max_troc,
      marc.min_troc,
      @EndUserText.label: 'Cód.inv.físico IR - Dados de centro'
      marc.abcin,
      marc.maabc,
      marc.auftl,
      marc.perkz,
      marc.shflg,
      marc.kzppv,
      marc.wstgh,
      marc.cuobj,
      @Semantics.amount.currencyCode: 'waers'
      marc.losfx,
      marc.bwtty,
      marc.qzgtp,
      marc.kzdkz,
      marc.mpdau,
      @Semantics.quantity.unitOfMeasure: 'meins'
      marc.umlmc,
      @Semantics.quantity.unitOfMeasure: 'meins'
      marc.eisbe,
      @Semantics.quantity.unitOfMeasure: 'meins'
      marc.trame,
      @Semantics.quantity.unitOfMeasure: 'meins'
      marc.mabst,
      @Semantics.quantity.unitOfMeasure: 'meins'
      marc.eislo,
      @Semantics.quantity.unitOfMeasure: 'meins'
      marc.target_stock,
      marc.scm_ges_bst_use,
      @Semantics.quantity.unitOfMeasure: 'meins'
      marc.bwesb,
      @Semantics.amount.currencyCode: 'waers'
      marc.vktrw,
      marc.lfgja,
      marc.vzusl,
      marc.ueetk,
      marc.ladgr,
      marc.resvp,
      marc.dplho,
      marc.vint1,
      marc.mcrue,
      @EndUserText.label: 'Marcação p/elim. - Dados gerais'
      marc.shzet,
      marc.vrbfk,
      marc.atpkz,
      marc.maxlz,
      marc.sernp,
      marc.lfmon,
      marc.kzdie,
      marc.gpmkz,
      marc.plifz,
      marc.kausf,
      marc.quazt,
      marc.ausss,
      marc.disls,
      marc.kzpro,
      marc.sobsl,
      @Semantics.quantity.unitOfMeasure: 'meins'
      marc.bstfe,
      marc.plnty,
      marc.ausme,
      marc.usequ,
      mara.meins,
      t001.waers
}
