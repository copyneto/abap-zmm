@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Filtro para itens /XNFE/INNFEIT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_FILTRO_ITEMS_GV 
as select from /xnfe/innfeit 
{
    key guid_header as GuidHeader,
    cfop as Cfop
}
where
     cfop = '5906'
  or cfop = '6906'
  or cfop = '5907'
  or cfop = '6907'
group by guid_header,  cfop
