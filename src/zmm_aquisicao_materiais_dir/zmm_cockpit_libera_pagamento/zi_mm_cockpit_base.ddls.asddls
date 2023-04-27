@AbapCatalog.sqlViewName: 'ZVIMMLIBPGTOBASE'
@AbapCatalog.dataMaintenance: #RESTRICTED
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cockpit Liberação - Seleção Inicial'
define view ZI_MM_COCKPIT_BASE
  as select from    I_PurchaseOrderItemTP as _Purchase
    inner join      ztmm_control_cla      as _CLA  on  _Purchase.PurchaseOrder     = _CLA.ebeln
                                                   and _Purchase.PurchaseOrderItem = _CLA.ebelp
//    left outer join ztmm_desc_pag_gv      as _Desc on  _CLA.ebeln = _Desc.ebeln
//                                                   and _CLA.ebelp = _Desc.ebelp
{
  key _CLA.ebeln                  as PurchaseOrder,
  key _CLA.ebelp                  as PurchaseOrderItem,
      _Purchase.Material,
      _Purchase.OrderQuantity,
      _Purchase.PurchaseOrderQuantityUnit,
      _Purchase.Plant,

//      case when _Desc.status is initial or _Desc.status is null
//           then 'X'
//         else _Desc.status
//      end                         as status,

      //////      _Desc.tipo,

//      case _Desc.status
//       when 'X'
//         then 1
//       when 'F'
//         then 3
//       else 2
//      end                         as DescontoCriticality,


//      @Semantics.amount.currencyCode: 'waers'
//      _Desc.vlr_desconto_com      as DescontoComercial,
//      _Desc.observacao_com        as ObservComercial,
//      _Desc.usuario_com           as UsuarioComercial,
//      _Desc.data_com              as DataComercial,

//      @Semantics.amount.currencyCode: 'waers'
//      _Desc.vlr_desconto_fin      as DescontoFinanceiro,
//      @Semantics.amount.currencyCode: 'waers'
//      _Desc.vlr_dev_fut_fin       as DevolucaoFutura,
//      _Desc.observacao_fin        as ObservFinanceiro,
//      _Desc.usuario_fin           as UsuarioFinanceiro,
//      _Desc.data_fin              as DataFinanceiro,

//      _Desc.waers,

      //////      @Semantics.amount.currencyCode: 'waers'
      //////      case when _Desc.tipo = 'C'
      //////           then _Desc.vlr_desconto
      //////           else 0
      //////      end                         as DescontoComercial,
      //////
      //////      case when _Desc.tipo = 'C'
      //////           then _Desc.observacao
      //////           else ''
      //////      end                         as ObservComercial,
      //////
      //////      case when _Desc.tipo = 'C'
      //////           then _Desc.usuario
      //////           else ''
      //////      end                         as UsuarioComercial,
      //////
      //////      case when _Desc.tipo = 'C'
      //////           then _Desc.data
      //////           else ''
      //////      end                         as DataComercial,

      //////      @Semantics.amount.currencyCode: 'waers'
      //////      case when _Desc.tipo = 'F'
      //////           then _Desc.vlr_desconto
      //////           else 0
      //////      end                         as DescontoFinanceiro,
      //////
      //////      case when _Desc.tipo = 'F'
      //////         then _Desc.observacao
      //////         else ''
      //////      end                         as ObservFinanceiro,
      //////
      //////      case when _Desc.tipo = 'F'
      //////           then _Desc.usuario
      //////           else ''
      //////      end                         as UsuarioFinanceiro,
      //////
      //////      case when _Desc.tipo = 'F'
      //////           then _Desc.data
      //////           else ''
      //////      end                         as DataFinanceiro,
      //////
      //////      @Semantics.amount.currencyCode: 'waers'
      //////      _Desc.vlr_dev_fut           as DevolucaoFutura,
      
      _CLA.nro_contrato,
      _CLA.tp_sacaria,
      _CLA.tp_embal,
      _CLA.lifnr,
      _CLA.menge,
      _CLA.meins,
      _CLA.lagmg,
      _CLA.observacao


//      _Desc.created_by            as CreatedBy,
//      _Desc.created_at            as CreatedAt,
//      _Desc.last_changed_by       as LastChangedBy,
//      _Desc.last_changed_at       as LastChangedAt,
//      _Desc.local_last_changed_at as LocalLastChangedAt

}
