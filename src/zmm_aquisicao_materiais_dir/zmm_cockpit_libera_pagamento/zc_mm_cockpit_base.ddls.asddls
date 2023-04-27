@AbapCatalog.sqlViewName: 'ZVCMMLIBPGTOBASE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cockpit Liberação - Seleção Inicial'
define view ZC_MM_COCKPIT_BASE
  as select from    ZI_MM_COCKPIT_BASE     as _Base
    inner join      ZC_MM_BR_NF_DOCUMENT   as _NFDoc on  _Base.PurchaseOrder     = _NFDoc.PurchaseOrder
                                                     and _Base.PurchaseOrderItem = _NFDoc.PurchaseOrderItem
    inner join      ZC_MM_ACCOUNT_DOCUMENT as _Acc   on _NFDoc.ReferencedDocument = _Acc.ReferencedDocument
    left outer join ztmm_desc_pag_gv       as _Desc  on  _Desc.ebeln  = _Base.PurchaseOrder
                                                     and _Desc.ebelp  = _Base.PurchaseOrderItem
                                                     and _Desc.docnum = _NFDoc.BR_NotaFiscal

  //    inner join   ZC_MM_CLA_CARAC        as _Carac on  _Base.PurchaseOrder     = _Carac.PurchaseOrder
  //                                                  and _Base.PurchaseOrderItem = _Carac.PurchaseOrderItem
{
  key _Base.PurchaseOrder,
  key _Base.PurchaseOrderItem,
  key _NFDoc.BR_NotaFiscal,
      _NFDoc.BR_NFeNumber,
      _NFDoc.BR_NFSeries,
      CONCAT( CONCAT( _Base.PurchaseOrder, _Base.PurchaseOrderItem), _NFDoc.BR_NotaFiscal) as ExtLogNumber,
      _Acc.ReferencedDocument,
      AccountingDocument,
      FiscalYear,
      CompanyCode,
      //  key _Carac.Charg,
      //  key _Carac.ViewType,
      //      _Carac.SalesDocument,
      //      _Carac.SalesDocumentItem,
      Material,
      OrderQuantity,
      PurchaseOrderQuantityUnit,
      Plant,

      case when _Desc.status is initial or _Desc.status is null
           then 'X'
         else _Desc.status
      end                                                                                  as status,

      case _Desc.status
        when 'A' // Em Revisão Comercial
          then 2
        when 'B' // Liberado Comercial
          then 2          
        when 'C' // Em Revisão Financeiro
          then 2
        when 'D' // Retornado Comercial
          then 1
        when 'E' // Liberado Financeiro
          then 2
        when 'F' // Finalizado
          then 3
        else 0   // Pendente
      end                                                                                  as DescontoCriticality,

      @Semantics.amount.currencyCode: 'waers'
      _Desc.vlr_desconto_com                                                               as DescontoComercial,
      _Desc.observacao_com                                                                 as ObservComercial,
      _Desc.usuario_com                                                                    as UsuarioComercial,
      _Desc.data_com                                                                       as DataComercial,
      _Desc.docok_com,

      @Semantics.amount.currencyCode: 'waers'
      _Desc.vlr_desconto_fin                                                               as DescontoFinanceiro,
      @Semantics.amount.currencyCode: 'waers'
      _Desc.vlr_dev_fut_fin                                                                as DevolucaoFutura,
      _Desc.observacao_fin                                                                 as ObservFinanceiro,
      _Desc.usuario_fin                                                                    as UsuarioFinanceiro,
      _Desc.data_fin                                                                       as DataFinanceiro,
      _Desc.docok_fin,

      _Desc.waers,

      //      status,
      //////      tipo,
      //      DescontoCriticality,
      //      DescontoComercial,
      //      ObservComercial,
      //      UsuarioComercial,
      //      DataComercial,
      //      DescontoFinanceiro,
      //      DevolucaoFutura,
      //      ObservFinanceiro,
      //      UsuarioFinanceiro,
      //      DataFinanceiro,
      nro_contrato                                                                         as Contrato,
      tp_sacaria                                                                           as Sacaria,
      tp_embal                                                                             as Embalagem,
      //      _Base.waers,
      _Base.lifnr,
      _Base.menge,
      _Base.meins,
      _Base.lagmg,
      _Base.observacao,

      _NFDoc.BR_ReferenceNFNumber,
      _NFDoc.Nfnum,
      _NFDoc.Supplier,
      _NFDoc.SupplierName,
      _NFDoc.NFTotalAmount,
      _NFDoc.NFTotalQuantity,
      _NFDoc.NFTotalReversalValue,
      _NFDoc.NFBaseUnit,
      _NFDoc.NFCurrency,

      @Semantics.amount.currencyCode: 'waers'
      _NFDoc.NFTotalAmount - _Desc.vlr_desconto_com - _Desc.vlr_desconto_fin               as ValorApurado,

      @Semantics.amount.currencyCode: 'waers'
      _Acc.MontanteAdiantamento,
      _Acc.StatusCompensado,
      _Acc.CompensadoCriticality,

      @Semantics.user.createdBy: true
      _Desc.created_by                                                                     as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      _Desc.created_at                                                                     as CreatedAt,
      @Semantics.user.lastChangedBy: true
      _Desc.last_changed_by                                                                as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      _Desc.last_changed_at                                                                as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      _Desc.local_last_changed_at                                                          as LocalLastChangedAt

      //      _Carac.QuantidadeKg,
      //      _Carac.QuantidadeSacas,
      //      _Carac.QuantidadeBag,
      //      _Carac.Peneira10,
      //      _Carac.Peneira11,
      //      _Carac.Peneira12,
      //      _Carac.Peneira13,
      //      _Carac.Peneira14,
      //      _Carac.Peneira15,
      //      _Carac.Peneira16,
      //      _Carac.Peneira17,
      //      _Carac.Peneira18,
      //      _Carac.Peneira19,
      //      _Carac.Mk10,
      //      _Carac.Fundo,
      //      _Carac.Catacao,
      //      _Carac.Umidade,
      //      _Carac.Defeito,
      //      _Carac.Impureza,
      //      _Carac.Verde,
      //      _Carac.PretoArdido,
      //      _Carac.Brocado,
      //      _Carac.Densidade,
      //      _Carac.Observacao

}
