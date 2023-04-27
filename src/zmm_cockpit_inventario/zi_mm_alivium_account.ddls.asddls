@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Alivium: Dados Contab NF-e'
define root view entity ZI_MM_ALIVIUM_ACCOUNT
  as select from ztmm_alivium_acc
{
  key processo              as Processo,
  key bwart                 as Bwart,
  key grupo                 as Grupo,
  key newbs                 as Newbs,
      newko                 as Newko,
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
