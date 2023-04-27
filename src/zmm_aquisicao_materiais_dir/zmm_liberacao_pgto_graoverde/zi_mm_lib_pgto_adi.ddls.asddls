@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interface Adiantamentos'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_LIB_PGTO_ADI
  as select from    bsik_view       as _bsik
    join            bkpf            as _bkpk  on  _bsik.bukrs = _bkpk.bukrs
                                              and _bsik.gjahr = _bkpk.gjahr
                                              and _bsik.belnr = _bkpk.belnr
    join            bseg            as _bseg  on  _bsik.bukrs = _bseg.bukrs
                                              and _bsik.gjahr = _bseg.gjahr
                                              and _bsik.belnr = _bseg.belnr
                                              and _bsik.buzei = _bseg.buzei

    left outer join ztmm_pag_gv_adi as _gvAdi on  _bsik.bukrs = _gvAdi.bukrs
                                              and _bsik.ebeln = _gvAdi.ebeln
                                              and _bsik.belnr = _gvAdi.belnr
                                              and _bsik.buzei = _gvAdi.buzei
                                              and _bsik.gjahr = _gvAdi.gjahr

  association to parent ZI_MM_LIB_PGTO_APP as _App on  _App.Empresa      = $projection.Empresa
                                                   and _App.Ano          = $projection.Ano
                                                   and _App.NumDocumento = $projection.NumDocumentoRef

{
  key _bsik.bukrs                  as Empresa,
  key _bsik.gjahr                  as Ano,
  key _bsik.ebeln                  as NumDocumentoRef,
  key _bsik.belnr                  as NumDocumento,
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
      _bseg.netdt                  as DtVencimentoLiquido,
      _bsik.bupla                  as LocalNegocio,
      _bsik.lifnr                  as Fornecedor,
      _bsik.shkzg                  as Indicador,
      _bsik.zuonr                  as Atribuicao,
      _bsik.zlsch                  as FormaPagamento,
      _bsik.hbkid                  as BancoEmpresa,
      _gvAdi.marcado               as Marcado,
      case _gvAdi.marcado when 'X' then 3 else 0 end as MarcadoCriticality,       
      _gvAdi.created_by            as CreatedBy,
      _gvAdi.created_at            as CreatedAt,
      _gvAdi.last_changed_by       as LastChangedBy,
      _gvAdi.last_changed_at       as LastChangedAt,
      _gvAdi.local_last_changed_at as LocalLastChangedAt,

      /* Associations */
      _App
}
where
        _bsik.shkzg =  'S'
  and(
        _bsik.umskz <> 'F'
    and _bsik.umskz is not initial
  )
