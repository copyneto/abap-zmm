@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Tabela /XNFE/INNFEHD'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_ALTESTOQ_INNFEHD
  as select from /xnfe/innfehd
{
  key guid_header,
  key nnf,
  key statcod,
      nprot
}
