@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '3Collaboration - Pasta do servidor'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_3C_VH_PASTA_SERVIDOR
  as select from ztca_param_val
{
  key low as ServerFolder

}
where
      modulo = 'MM'
  and chave1 = '3COLLABORATION'
  and chave2 = 'PASTASERV'
  and chave3 = ''
  and sign   = 'I'
  and opt    = 'EQ'
  and low    is not initial
