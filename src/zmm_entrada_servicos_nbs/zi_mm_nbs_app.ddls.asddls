@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS - Entrada de Serviço com NBS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_NBS_APP
  as select from ztmm_nbs
  association [1..1] to I_MaterialText as _MaterialText on  _MaterialText.Material = $projection.Matnr
                                                        and _MaterialText.Language = $session.system_language

  association [1..1] to j_1btnbs       as _1BTNBS       on  _1BTNBS.nbs = $projection.Nbs


{
  key matnr                          as Matnr,
      _MaterialText.MaterialName     as Maktx,
      nbs                            as Nbs,
      _1BTNBS.description            as Description,

      @Semantics.user.createdBy: true
      ztmm_nbs.created_by            as CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      ztmm_nbs.created_at            as CreatedAt,

      @Semantics.user.lastChangedBy: true
      ztmm_nbs.last_changed_by       as LastChangedBy,

      @Semantics.systemDateTime.lastChangedAt: true
      ztmm_nbs.last_changed_at       as LastChangedAt,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      ztmm_nbs.local_last_changed_at as LocalLastChangedAt
}
