@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_ATIVIDADE
  as select from /xnfe/innfehd        as HD
    inner join   ZI_MM_ATIVIDADE_CONT as CT on HD.guid_header = CT.GuidHeader
    inner join   /xnfe/inhdsta        as ST on  CT.GuidHeader = ST.guid_header
                                            and CT.Stepcount  = ST.stepcount
    inner join   /xnfe/procstept      as PT on  PT.procstep = ST.procstep
                                            and PT.langu    = 'P'
{

  key HD.guid_header as GuidHeader,
      HD.nfeid       as Nfeid,
      PT.procstep,
      PT.description
}
