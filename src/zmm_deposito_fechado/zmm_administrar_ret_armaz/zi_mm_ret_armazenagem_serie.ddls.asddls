@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Serie'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_RET_ARMAZENAGEM_SERIE
  as select from ZI_MM_RET_ARMAZENAGEM_HIST as _Documentos

  //  association [0..*] to ztmm_his_dep_ser                 as _Serie   on  _Serie.material         = _Documentos.Material
  //                                                                     and _Serie.plant            = _Documentos.CentroOrigem
  //                                                                     and _Serie.storage_location = _Documentos.DepositoOrigem
  //                                                                     and _Serie.guid             = _Documentos.Guid
  //                                                                     and _Serie.process_step     = 'F05'
    inner join   ztmm_his_dep_ser           as _Serie on  _Serie.material              = _Documentos.Material
                                                      and _Serie.plant                 = _Documentos.CentroOrigem
                                                      and _Serie.storage_location      = _Documentos.DepositoOrigem
                                                      and _Serie.batch                 = _Documentos.Lote
                                                      and _Serie.plant_dest            = _Documentos.CentroDestino
                                                      and _Serie.storage_location_dest = _Documentos.DepositoDestino
                                                      and _Serie.guid                  = _Documentos.Guid

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
  key _Documentos.NumeroOrdemDeFrete           as NumeroOrdemDeFrete,
  key _Documentos.NumeroDaRemessa              as NumeroDaRemessa,
  key _Documentos.Material                     as Material,
  key _Documentos.UmbOrigin                    as UmbOrigin,
  key _Documentos.UmbDestino                   as UmbDestino,
  key _Documentos.CentroOrigem                 as CentroOrigem,
  key _Documentos.DepositoOrigem               as DepositoOrigem,
  key _Documentos.CentroDestino                as CentroDestino,
  key _Documentos.DepositoDestino              as DepositoDestino,
  key _Documentos.Lote                         as Lote,
  key _Documentos.EANType                      as EANType,
  key 'X'                                      as DadosDoHistorico,
  key cast( _Serie.serialno as abap.char(18) ) as SerialNo,
  key _Documentos.Guid                         as Guid,
      ltrim( _Serie.serialno, '0')             as SerialNoText,

      @Semantics.user.createdBy: true
      _Serie.created_by                        as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      _Serie.created_at                        as CreatedAt,
      @Semantics.user.lastChangedBy: true
      _Serie.last_changed_by                   as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      _Serie.last_changed_at                   as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      _Serie.local_last_changed_at             as LocalLastChangedAt,

      /* associations */
      _Emissao
}
group by
  _Documentos.NumeroOrdemDeFrete,
  _Documentos.NumeroDaRemessa,
  _Documentos.Material,
  _Documentos.UmbOrigin,
  _Documentos.UmbDestino,
  _Documentos.CentroOrigem,
  _Documentos.DepositoOrigem,
  _Documentos.CentroDestino,
  _Documentos.DepositoDestino,
  _Documentos.Lote,
  _Documentos.EANType,
  _Serie.serialno,
  _Documentos.Guid,
  _Serie.created_by,
  _Serie.created_at,
  _Serie.last_changed_by,
  _Serie.last_changed_at,
  _Serie.local_last_changed_at
