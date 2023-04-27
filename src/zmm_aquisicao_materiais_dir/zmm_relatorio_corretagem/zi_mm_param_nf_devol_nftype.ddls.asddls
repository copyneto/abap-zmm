@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Parâmetros de Tipos de NFs de Devolução'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_PARAM_NF_DEVOL_NFTYPE
  as select from ztca_param_val
{
  key modulo,
  key chave1,
  key chave2,
  key chave3,
  key cast( low as j_1bnftype ) as NfType
}
where
      modulo = 'MM'
  and chave1 = 'GRAOVERDE'
  and chave2 = 'BR_NFTYPE'
  and chave3 = 'DEVOL'
