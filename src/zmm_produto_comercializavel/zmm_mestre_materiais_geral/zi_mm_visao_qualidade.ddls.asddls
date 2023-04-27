@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Visão de Qualidade'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define root view entity ZI_MM_VISAO_QUALIDADE
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
    left outer join qmat           on  qmat.matnr = mara.matnr
                                   and qmat.werks = marc.werks
    left outer join mbew           on mbew.matnr = mara.matnr
 {
  key mara.matnr,
  key marc.werks,
  key mbew.bwkey,
  key mbew.bwtar,
  key qmat.art,
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
      mara.mhdhb,
      marc.xchpf,
      marc.qmatv,
      marc.nkmpr,
      mbew.pstat,
      cast ( marc.scm_grprt as abap.fltp ) as scm_grprt,
      mara.meins,
      mara.datab,
      marc.ssqss,
      marc.qzgtp,
      mara.rbnrm,
      mara.qmpur,
      marc.ausme
}
