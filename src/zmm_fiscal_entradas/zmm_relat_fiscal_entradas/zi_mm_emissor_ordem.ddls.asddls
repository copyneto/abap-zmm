@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Emissor da Ordem'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_EMISSOR_ORDEM
  as select from I_BR_NFDocument as NFHeader

{
  key NFHeader.BR_NotaFiscal,
      BR_NFPartnerFunction,
      BR_NFPartner as EmissorOrdem
}
where
     BR_NFPartnerFunction = 'RE'
  or BR_NFPartnerFunction = 'AG'
  or BR_NFPartnerFunction = 'WE'
  or BR_NFPartnerFunction = 'RG'
