@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Máx contador'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_ATIVIDADE_CONT
  as select from /xnfe/inhdsta
{
  key guid_header     as GuidHeader,
      max(stepcount)  as Stepcount
//      deactiv         as Deactiv
//      max(stepstatus) as Stepstatus
}
group by
  guid_header
//  deactiv
