@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interface Devoluções'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_LIB_PGTO_DEV
  as select from    bsik_view            as _bsik
  
   join ZI_MM_LIB_PGTO_BSEG              as _bseg on _bsik.bukrs        = _bseg.Empresa
                                                  and _bsik.belnr       = _bseg.NumDocumento
                                                  and _bsik.gjahr       = _bseg.Ano
                                                  and _bseg.TipoConta   = 'S'
  
    
    join            bkpf            as _bkpk  on  _bsik.bukrs = _bkpk.bukrs
                                              and _bsik.gjahr = _bkpk.gjahr
                                              and _bsik.belnr = _bkpk.belnr

    left outer join ztmm_pag_gv_dev as _gvDev on  _bseg.Empresa         = _gvDev.bukrs
                                              and _bseg.NumDocumentoRef = _gvDev.ebeln
                                              and _bseg.NumDocumento    = _gvDev.belnr
                                              and _bsik.buzei           = _gvDev.buzei
                                              and _bseg.Ano             = _gvDev.gjahr
                                              
    left outer to one join ZI_MM_LIB_PGTO_VENCTO as _vencto on  _bseg.Empresa       = _vencto.Empresa
                                                            and _bseg.Ano           = _vencto.Ano
                                                            and _bseg.NumDocumento  = _vencto.NumDocumento                                               

  association to parent ZI_MM_LIB_PGTO_APP as _App on  _App.Empresa      = $projection.Empresa
                                                   and _App.Ano          = $projection.Ano
                                                   and _App.NumDocumento = $projection.NumDocumentoRef
{
  key _bseg.Empresa                as Empresa,
  key _bseg.Ano                    as Ano,
  key _bseg.NumDocumentoRef        as NumDocumentoRef,
  key _bseg.NumDocumento           as NumDocumento,
  key _bsik.buzei                  as Item,
      _bsik.zlspr                  as Bloqueio,
      _bsik.blart                  as TipoDocumento,
      _bkpk.xref1_hd               as ReferenciaCab1,
      _bkpk.xref2_hd               as ReferenciaCab2,
      _bkpk.bktxt                  as TextoCab,
      _bkpk.xblnr                  as DocReferencia,
      _bsik.waers                  as Moeda,
      @Semantics.amount.currencyCode: 'Moeda'
      _bsik.dmbtr                  as VlMontante,
      //_bseg.netdt                  as DtVencimentoLiquido,
      _vencto.DtVencimentoLiquido  as DtVencimentoLiquido,
      _bsik.bupla                  as LocalNegocio,
      _bsik.lifnr                  as Fornecedor,
      _bsik.shkzg                  as Indicador,
      _bsik.zuonr                  as Atribuicao,
      _bsik.zlsch                  as FormaPagamento,
      _bsik.hbkid                  as BancoEmpresa,
      _gvDev.marcado               as Marcado,
      case _gvDev.marcado when 'X' then 3 else 0 end as MarcadoCriticality, 
      _gvDev.created_by            as CreatedBy,
      _gvDev.created_at            as CreatedAt,
      _gvDev.last_changed_by       as LastChangedBy,
      _gvDev.last_changed_at       as LastChangedAt,
      _gvDev.local_last_changed_at as LocalLastChangedAt,

      /* Associations */
      _App
}
where
    _bsik.shkzg = 'S'
