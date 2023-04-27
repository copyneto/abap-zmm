@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interface Faturas'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_LIB_PGTO_FAT
  as select from bsik_view               as _bsik  
  
   join ZI_MM_LIB_PGTO_BSEG              as _bseg on  _bsik.bukrs        = _bseg.Empresa
                                                  and _bsik.belnr       = _bseg.NumDocumento
                                                  and _bsik.gjahr       = _bseg.Ano
                                                  and _bseg.TipoConta   = 'S'  

    left outer join bkpf            as _bkpk  on  _bsik.bukrs = _bkpk.bukrs
                                              and _bsik.gjahr = _bkpk.gjahr
                                              and _bsik.belnr = _bkpk.belnr

    left outer join ztmm_pag_gv_fat as _gvFat on  _bseg.Empresa         = _gvFat.bukrs
                                              and _bseg.NumDocumentoRef = _gvFat.ebeln
                                              and _bseg.NumDocumento    = _gvFat.belnr
                                              and _bsik.buzei           = _gvFat.buzei
                                              and _bseg.Ano             = _gvFat.gjahr
                                              
    left outer to one join ZI_MM_LIB_PGTO_VENCTO as _vencto on  _bseg.Empresa       = _vencto.Empresa
                                                            and _bseg.Ano           = _vencto.Ano
                                                            and _bseg.NumDocumento  = _vencto.NumDocumento     
                                                            
    join j_1bnfdoc                      as _docFat on  _bseg.NumDocumento = _docFat.belnr
                                                   and _bseg.Empresa = _docFat.bukrs
                                                   and _bseg.Ano = _docFat.gjahr
                                                                                                                                                         
    join ztmm_desc_pag_gv               as _descCom on  _docFat.docnum = _descCom.docnum 
                                                    and _descCom.status <> 'X' 
                                                    and _descCom.status <> 'A'

    association to parent ZI_MM_LIB_PGTO_APP as _App on _App.Empresa      = $projection.Empresa
                                                    and _App.Ano          = $projection.Ano
                                                    and _App.NumDocumento = $projection.NumDocumentoRef


{
  key _bseg.Empresa                                  as Empresa,
  key _bseg.Ano                                      as Ano,
  key _bseg.NumDocumentoRef                          as NumDocumentoRef,
  key _bseg.NumDocumento                             as NumDocumento,
  key _bsik.buzei                                    as Item,
      _bsik.zlspr                                    as Bloqueio,
      _bsik.blart                                    as TipoDocumento,
      _bkpk.xref1_hd                                 as ReferenciaCab1,
      _bkpk.xref2_hd                                 as ReferenciaCab2,
      _bkpk.bktxt                                    as TextoCab,
      _bkpk.xblnr                                    as DocReferencia,
      _bsik.waers                                    as Moeda,
      @Semantics.amount.currencyCode: 'Moeda'
      _bsik.dmbtr                                    as VlMontante,
      //_bseg.netdt                                    as DtVencimentoLiquido,
      _vencto.DtVencimentoLiquido                    as DtVencimentoLiquido,
      _bsik.bupla                                    as LocalNegocio,
      _bsik.lifnr                                    as Fornecedor,
      _bsik.shkzg                                    as Indicador,
      _bsik.zuonr                                    as Atribuicao,
      _bsik.zlsch                                    as FormaPagamento,
      _bsik.hbkid                                    as BancoEmpresa,
      _gvFat.marcado                                 as Marcado,
      case _gvFat.marcado when 'X' then 3 else 0 end as MarcadoCriticality,
      _gvFat.created_by                              as CreatedBy,
      _gvFat.created_at                              as CreatedAt,
      _gvFat.last_changed_by                         as LastChangedBy,
      _gvFat.last_changed_at                         as LastChangedAt,
      _gvFat.local_last_changed_at                   as LocalLastChangedAt,
      /* Associations */
      _App
}
where
    _bsik.shkzg = 'H'
