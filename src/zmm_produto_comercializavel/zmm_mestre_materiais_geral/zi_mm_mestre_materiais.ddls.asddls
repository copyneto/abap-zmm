@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Relatório Geral - Mestre Materiais'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define root view entity ZI_MM_MESTRE_MATERIAIS
  as select from dd07l as Visao
    join         dd07t as Text on  Text.domname    = Visao.domname
                               and Text.as4local   = Visao.as4local
                               and Text.valpos     = Visao.valpos
                               and Text.as4vers    = Visao.as4vers
                               and Text.ddlanguage = $session.system_language
{
  key Visao.domvalue_l as VisionId,
      Text.ddtext      as VisionName
}
where
      Visao.domname  = 'ZD_VISAO_MATERIAL'
  and Visao.as4local = 'A'
