@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Período bloqueio fiscal GRC'
define root view entity ZI_MM_DATA_BLOQ_GRC
  as select from ztmm_data_bloq
{

  key doc_uuid_h            as DocUuidH,
      data_inicio           as DataInicio,
      data_fim              as DataFim,
      obs                   as Obs,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt
}
