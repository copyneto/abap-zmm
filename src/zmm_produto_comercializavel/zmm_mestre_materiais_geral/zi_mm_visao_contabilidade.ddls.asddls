@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Visão de Contabilidade'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define root view entity ZI_MM_VISAO_CONTABILIDADE
  as select from    mara
    left outer join makt as makt   on  makt.matnr = mara.matnr
                                   and makt.spras = $session.system_language
    left outer join makt as maktpt on  maktpt.matnr = mara.matnr
                                   and maktpt.spras = 'P'
    left outer join makt as makten on  makten.matnr = mara.matnr
                                   and makten.spras = 'E'
    left outer join makt as maktes on  maktes.matnr = mara.matnr
                                   and maktes.spras = 'S'
    left outer join marc           on marc.matnr = mara.matnr
    left outer join mbew           on mbew.matnr = mara.matnr
    left outer join t001k          on t001k.bwkey = mbew.bwkey
    left outer join t001           on t001.bukrs = t001k.bukrs
    left outer join mvke           on mvke.matnr = mara.matnr
    left outer join ztmm_catalogorfb as rfb    on rfb.material = mara.matnr
{
  key mara.matnr,
  key marc.werks,
  key mbew.bwkey,
  key mbew.bwtar,
  key mvke.vkorg,
  key mvke.vtweg,
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
      mara.extwg,
      marc.prctr,
      mbew.mtuse,
      mbew.mtorg,
      mbew.fbwst,
      mbew.lbwst,
      mbew.vbwst,
      mbew.pdatl,
      mbew.kosgr,
      mbew.hrkft,
      mbew.abwkz,
      mbew.mbrue,
      mbew.mlmaa,
      mbew.bwspa,
      mbew.kalnr,
      mbew.pprdz,
      mbew.pprdv,
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
      mbew.timestamp,
      mbew.xlifo,
      mbew.pstat,
      @EndUserText.label: 'Marcação p/elim. - Dados de avaliação'
      mbew.lvorm,
      mbew.laepr,
      mbew.peinh,
      @Semantics.amount.currencyCode: 'waers'
      mbew.vjsal,
      @Semantics.amount.currencyCode: 'waers'
      mbew.vmsav,
      @Semantics.amount.currencyCode: 'waers'
      mbew.salkv,
      @Semantics.amount.currencyCode: 'waers'
      mbew.vmsal,
      mbew.vers1,
      mbew.kalsc,
      mbew.bklas,
      mbew.eklas,
      mbew.oklas,
      mbew.kziwl,
      @EndUserText.label: 'Cód.inv.físico IR - Dados de avaliação'
      mbew.abciw,
      mbew.ekalr,
      mbew.vprsv,
      mbew.zpld1,
      mbew.zpld2,
      mbew.zpld3,
      mbew.wlinl,
      @Semantics.quantity.unitOfMeasure: 'meins'
      mbew.vmkum,
      mbew.pdatz,
      mbew.kaln1,
      mbew.hkmat,
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
      @Semantics.amount.currencyCode: 'waers'
      mbew.salk3,
      mbew.bwva1,
      mara.meins,
      t001.waers
}
