@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Parametro para limite de linhas do App'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_ADMINISTRAR_PARAM_LINHAS
  as select from ztca_param_val
{
  key low as limitador
}
where
      modulo = 'MM'
  and chave1 = 'LIMITADOR_ITENS'
  and chave2 = 'QTDE_ITENS_NF'
