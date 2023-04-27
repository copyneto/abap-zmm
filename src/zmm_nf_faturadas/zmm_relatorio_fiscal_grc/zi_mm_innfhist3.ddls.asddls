@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: ' CDS hist3'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_INNFHIST3 
  as select from /xnfe/innfhist as _max
{

  _max.guid_header,
  max(_max.histcount) as histcount

}
where procstep = 'GRCONFQU'
group by
  _max.guid_header
  
