@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Value Help DOCNUM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_VH_ARMZ_DOCNUM 
as select from /xnfe/innfehd as _nfe
    inner join /xnfe/innfeit as _nfeIte on _nfe.guid_header = _nfeIte.guid_header 
 {
  @EndUserText.label: 'NF-e'
  key _nfe.nnf as DocNum
}
where
  _nfeIte.cfop = '5906' or
  _nfeIte.cfop = '5907' or
  _nfeIte.cfop = '6906' or
  _nfeIte.cfop = '6907'  
group by
  _nfe.nnf
