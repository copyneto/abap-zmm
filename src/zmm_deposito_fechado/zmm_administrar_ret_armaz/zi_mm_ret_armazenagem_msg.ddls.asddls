@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Adm retorno armazenagem mensagens'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity zi_mm_ret_armazenagem_msg
  as select from ZI_MM_RET_ARMAZENAGEM_UNION as _Documentos

    inner join   ztmm_his_dep_msg            as _msg               on  _msg.material              = _Documentos.Material
                                                                   and _msg.plant                 = _Documentos.CentroOrigem
                                                                   and _msg.storage_location      = _Documentos.DepositoOrigem
                                                                   and _msg.batch                 = _Documentos.Lote
                                                                   and _msg.plant_dest            = _Documentos.CentroDestino
                                                                   and _msg.storage_location_dest = _Documentos.DepositoDestino
                                                                   and _msg.guid                  = _Documentos.Guid

    inner join   ZI_MM_VH_DF_TIPO_EAN        as _MM_VH_DF_TIPO_EAN on  _MM_VH_DF_TIPO_EAN.EANType = _MM_VH_DF_TIPO_EAN.EANType
                                                                   and _MM_VH_DF_TIPO_EAN.EANType = _Documentos.EANType

  association to parent ZI_MM_RET_ARMAZENAGEM_APP as _Emissao on  _Emissao.NumeroOrdemDeFrete = $projection.NumeroOrdemDeFrete
                                                              and _Emissao.NumeroDaRemessa    = $projection.NumeroDaRemessa
                                                              and _Emissao.Material           = $projection.Material
                                                              and _Emissao.UmbOrigin          = $projection.UmbOrigin
                                                              and _Emissao.UmbDestino         = $projection.UmbDestino
                                                              and _Emissao.CentroOrigem       = $projection.CentroOrigem
                                                              and _Emissao.DepositoOrigem     = $projection.DepositoOrigem
                                                              and _Emissao.CentroDestino      = $projection.CentroDestino
                                                              and _Emissao.DepositoDestino    = $projection.DepositoDestino
                                                              and _Emissao.Lote               = $projection.Lote
                                                              and _Emissao.EANType            = $projection.EANType
                                                              and _Emissao.DadosDoHistorico   = $projection.DadosDoHistorico
                                                              and _Emissao.Guid               = $projection.Guid

{

  key _Documentos.NumeroOrdemDeFrete,
  key _Documentos.NumeroDaRemessa,
  key _Documentos.Material,
  key _Documentos.CentroOrigem,
  key _Documentos.DepositoOrigem,
  key _Documentos.Lote,
  key _Documentos.CentroDestino,
  key _Documentos.DepositoDestino,
  key _Documentos.Guid,

  key _Documentos.UmbOrigin,
  key _Documentos.UmbDestino,
  key _Documentos.ProcessStep,
  key _Documentos.PrmDepFecId,
  key _Documentos.DadosDoHistorico,
  key cast( _MM_VH_DF_TIPO_EAN.EANType as ze_mm_df_ean_type ) as EANType,
  key _msg.sequencial                                         as Sequencial,
      _msg.type                                               as Type,
      _msg.msg                                                as Msg,
      _msg.created_by                                         as CreatedBy,
      _msg.created_at                                         as CreatedAt,
      _msg.last_changed_by                                    as LastChangedBy,
      _msg.last_changed_at                                    as LastChangedAt,
      _msg.local_last_changed_at                              as LocalLastChangedAt,

      /* associations */
      _Emissao
}
