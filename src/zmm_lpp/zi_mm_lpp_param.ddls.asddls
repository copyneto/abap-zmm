@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Tabela de parametros'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_LPP_PARAM
  as select from ztca_param_val
{
  key modulo                as Modulo,
  key chave1                as Chave1,
  key chave2                as Chave2,
  key chave3                as Chave3,
  key sign                  as Sign,
  key opt                   as Opt,
  key left(low,2)           as Low,
      high                  as High,
      created_by            as CreatedBy,
      created_at            as CreatedAt,
      last_changed_by       as LastChangedBy,
      last_changed_at       as LastChangedAt,
      local_last_changed_at as LocalLastChangedAt
}
where
      modulo = 'MM'
  and chave1 = 'LPP_ESTORNO'
  and chave2 = 'ULTIMA_COMPRA'
  and chave3 = 'NFTYPE'
