@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Tabela /XNFE/INXML'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_XNFE_INXML
  as select from /xnfe/inxml
{
  key guid_header  as GuidHeader,
  key type         as Type,
      docid        as Docid,
      xmlstring    as Xmlstring,
      incomingtime as Incomingtime
}
