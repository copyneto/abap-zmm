@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Centro de Custos Projeto Novas Ordens'
define root view entity ZI_MM_ALIVIUM_CC
  as select from ztmm_alivium_cc
{
  key bukrs                 as Bukrs,
      kostl                 as Kostl,
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
