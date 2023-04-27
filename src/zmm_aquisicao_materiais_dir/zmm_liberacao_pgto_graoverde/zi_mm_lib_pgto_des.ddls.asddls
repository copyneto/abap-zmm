@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interface Descontos'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_LIB_PGTO_DES
  as select from    bkpf            as _bkpf
    join            bseg            as _bseg  on  _bkpf.bukrs = _bseg.bukrs
                                              and _bkpf.gjahr = _bseg.gjahr
                                              and _bkpf.belnr = _bseg.belnr

    join            bsik_view       as _bsik  on  _bseg.bukrs = _bsik.bukrs
                                              and _bseg.gjahr = _bsik.gjahr
                                              and _bseg.belnr = _bsik.belnr
                                              and _bseg.buzei = _bsik.buzei

  //    join            bkpf            as _bkpk  on  _bsik.bukrs = _bkpk.bukrs
  //                                              and _bsik.gjahr = _bkpk.gjahr
  //                                              and _bsik.belnr = _bkpk.belnr

    left outer to one join ZI_MM_LIB_PGTO_CAB as _cab on  _bkpf.bukrs      = _cab.Empresa
                                                      and _bkpf.xref2_hd   = _cab.NumDocumento     
    
    left outer join ztmm_pag_gv_des as _gvDes on  _bkpf.bukrs = _gvDes.bukrs
                                              and _bkpf.xref2_hd = _gvDes.ebeln
                                              and _bkpf.belnr = _gvDes.belnr
                                              and _bsik.buzei = _gvDes.buzei
                                              and _cab.Ano    = _gvDes.gjahr
                                              //and _bkpf.gjahr = _gvDes.gjahr
                                                                                             

    association to parent ZI_MM_LIB_PGTO_APP as _App on  _App.Empresa      = $projection.Empresa
                                                     and _App.Ano          = $projection.Ano   
                                                     and _App.NumDocumento = $projection.NumDocumentoRef
                                                                                                          
{
  key _bkpf.bukrs                     as Empresa,
  //key _bkpf.gjahr                     as Ano,
  key _cab.Ano                        as Ano,  
  key cast( _bkpf.xref2_hd as ebeln ) as NumDocumentoRef,
  key _bkpf.belnr                     as NumDocumento,
  key _bsik.buzei                     as Item,
      //obs: tivemos que criar esse campo pois documentos que foram gerados no ano seguinte não eram exibidos
      //ex: pedido de 2022 e desconto financeiro gerado em 2023
      
      _bsik.zlspr                     as Bloqueio,
      _bsik.blart                     as TipoDocumento,
      _bkpf.xref1_hd                  as ReferenciaCab1,
      _bkpf.xref2_hd                  as ReferenciaCab2,
      _bkpf.bktxt                     as TextoCab,
      _bkpf.xblnr                     as DocReferencia,
      _bsik.waers                     as Moeda,
      @Semantics.amount.currencyCode: 'Moeda'
      _bsik.dmbtr                     as VlMontante,
      _bseg.netdt                     as DtVencimentoLiquido,
      _bsik.bupla                     as LocalNegocio,
      _bsik.lifnr                     as Fornecedor,
      _bsik.shkzg                     as Indicador,
      _bsik.zuonr                     as Atribuicao,
      _bsik.zlsch                     as FormaPagamento,
      _bsik.hbkid                     as BancoEmpresa,
      _gvDes.marcado                  as Marcado,
      case _gvDes.marcado when 'X' then 3 else 0 end as MarcadoCriticality, 
      _gvDes.created_by               as CreatedBy,
      _gvDes.created_at               as CreatedAt,
      _gvDes.last_changed_by          as LastChangedBy,
      _gvDes.last_changed_at          as LastChangedAt,
      _gvDes.local_last_changed_at    as LocalLastChangedAt,
      /* Associations */
      _App
}
where
  _bsik.shkzg = 'S'
