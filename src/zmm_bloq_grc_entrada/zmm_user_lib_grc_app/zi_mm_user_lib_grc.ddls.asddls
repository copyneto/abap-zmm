@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Usuarios liberados fiscal - GRC'
define root view entity ZI_MM_USER_LIB_GRC
  as select from ztmm_user_libgrc
{
  key doc_uuid_h            as DocUuidH,
  key usuario               as Usuario,
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
