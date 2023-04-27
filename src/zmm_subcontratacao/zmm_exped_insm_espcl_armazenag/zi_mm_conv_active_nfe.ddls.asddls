@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Conversão J_1BNFE_ACTIVE e /XNFE/INNFEHD'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_CONV_ACTIVE_NFE
  as select from /xnfe/innfehd
{
  key guid_header,
      cuf                   as Regio,
      substring(demi, 3, 2) as NFYEAR,
      substring(demi, 5, 2) as NFMONTH,
      cnpj_emit             as STCD1,
      mod                   as MODEL,
      nnf                   as NFNUM9,
      nfeid

}
