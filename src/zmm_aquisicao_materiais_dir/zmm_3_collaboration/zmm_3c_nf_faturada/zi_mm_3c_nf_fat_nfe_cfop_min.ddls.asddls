@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'NF Faturada (NFE) - Menor CFOP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_3C_NF_FAT_NFE_CFOP_MIN
  as select from /xnfe/innfeit
{
  key guid_header  as GuidHeader,
      min( nitem ) as Nitem
}
group by
  guid_header
