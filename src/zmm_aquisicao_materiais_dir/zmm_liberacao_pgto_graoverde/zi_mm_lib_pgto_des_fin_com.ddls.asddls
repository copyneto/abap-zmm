@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interface Desconto Financeiro e Comercial'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_LIB_PGTO_DES_FIN_COM
  as select from    ztmm_pag_gv_desc as _ztmDesc
    join            ekko             as _ekko        on _ztmDesc.ebeln = _ekko.ebeln
    join            ztmm_pag_gv_cab  as _ztmCab      on  _ztmDesc.ebeln = _ztmCab.ebeln
                                                     and _ztmDesc.bukrs = _ztmCab.bukrs

    left outer join ztmm_pag_gv_dfc  as _gvDesFinCom on  _ztmDesc.guid  = _gvDesFinCom.guid
                                                     and _ztmDesc.bukrs = _gvDesFinCom.bukrs
                                                     and _ztmDesc.ebeln = _gvDesFinCom.ebeln
                                                     and _ztmCab.gjahr  = _gvDesFinCom.gjahr

  association to parent ZI_MM_LIB_PGTO_APP as _App on  _App.Empresa      = $projection.Empresa
                                                   and _App.Ano          = $projection.Ano
                                                   and _App.NumDocumento = $projection.NumDocumento
{
  key _ztmDesc.guid                      as Guid,
  key _ztmDesc.ebeln                     as NumDocumento,
  key _ztmDesc.bukrs                     as Empresa,
      _ztmCab.gjahr                      as Ano,
      _ztmCab.status                     as Status,
      _ztmDesc.waers                     as Moeda,
      _ztmDesc.docnum_com                as DocNumComercial,
      _ztmDesc.doccont_com               as DocContabilComercial,
      @Semantics.amount.currencyCode: 'Moeda'
      _ztmDesc.vlr_desconto_com          as VlrDescontoCom,
      _ztmDesc.observacao_com            as ObservacaoCom,
      _ztmDesc.usuario_com               as UsuarioCom,
      _ztmDesc.data_com                  as DataCom,
      _ztmDesc.gjahr_com                 as GjahrComercial,
      _ztmDesc.docnum_fin                as DocNumFinanceiro,
      _ztmDesc.doccont_fin               as DocContabilFinanceiro,
      @Semantics.amount.currencyCode: 'Moeda'
      _ztmDesc.vlr_desconto_fin          as VlrDescontoFin,
      _ztmDesc.observacao_fin            as ObservacaoFin,
      _ztmDesc.usuario_fin               as UsuarioFin,
      _ztmDesc.data_fin                  as DataFin,
      _ztmDesc.gjahr_fin                 as GjahrFinanceiro,
      _ztmDesc.created_by                as CreatedBy,
      _ztmDesc.created_at                as CreatedAt,
      _ztmDesc.last_changed_by           as LastChangedBy,
      _ztmDesc.last_changed_at           as LastChangedAt,
      _ztmDesc.local_last_changed_at     as LocalLastChangedAt,
      _gvDesFinCom.marcado               as Marcado,
      _gvDesFinCom.created_by            as CreatedByControle,
      _gvDesFinCom.created_at            as CreatedAtControle,
      _gvDesFinCom.last_changed_by       as LastChangedByControle,
      _gvDesFinCom.last_changed_at       as LastChangedAtControle,
      _gvDesFinCom.local_last_changed_at as LocalLastChangedAtControle,

      /* Associations */
      _App
}
