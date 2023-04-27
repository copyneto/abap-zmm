@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interface Operação'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_OPERACAO
  as select from ztmm_operacao
  association [0..1] to ZI_MM_VH_OPERACAO as _OpDesc  on  $projection.Operacao = _OpDesc.Operacao
                                                      and _OpDesc.Language     = $session.system_language
  association [0..1] to ZI_MM_VH_TIPO     as _TpDesc  on  $projection.Operacao = _TpDesc.Tipo
                                                      and _TpDesc.Language     = $session.system_language
  association [0..1] to ZI_CA_VH_BWART    as _MovDesc on  $projection.TpMov = _MovDesc.GoodsMovementType
                                                      and _MovDesc.Language = $session.system_language
{
  key operacao              as Operacao,
  key tp_mov                as TpMov,
  key cfop                  as Cfop,
      tipo                  as Tipo,
      cfop_int              as CfopInt,

      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      _OpDesc,
      _TpDesc,
      _MovDesc

}
