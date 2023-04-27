@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS hist2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_INNFHIST2 
  as select from /xnfe/innfhist as _max
{

  _max.guid_header,
  max(_max.histcount) as histcount

}
where procstep = 'POASSIGN'
group by
  _max.guid_header
  
