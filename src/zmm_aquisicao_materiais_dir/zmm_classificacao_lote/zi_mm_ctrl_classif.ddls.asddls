@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Controle Classif. e Corretagem - Compras'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_MM_CTRL_CLASSIF
  as select from    ztmm_control_cla      as _Classific
    inner join      I_PurchaseOrderItemTP as _PurchaseOrderItemTP on  _PurchaseOrderItemTP.PurchaseOrder     = _Classific.ebeln
                                                                  and _PurchaseOrderItemTP.PurchaseOrderItem = _Classific.ebelp
    inner join      mara                  as _Material            on _Material.matnr = _PurchaseOrderItemTP.Material

    left outer join t134g                 as _Divisao             on  _Divisao.werks = _PurchaseOrderItemTP.Plant
                                                                  and _Divisao.spart = _Material.spart

  composition [0..*] of ZI_MM_VLR_CARACTERISTICA       as _Caract

  association [0..*] to ZI_MM_DADOS_BANCARIOS          as _DadosBancarios       on  _DadosBancarios.Supplier = $projection.Fornecedor

  association [1..1] to ZI_MM_QUANT_TOTAL_PEDIDO       as _QuantTotal           on  _QuantTotal.PurchaseOrder     = $projection.Pedido
                                                                                and _QuantTotal.PurchaseOrderItem = $projection.ItemPedido

  association [0..1] to ZI_MM_VH_STATUS_CLASSIFIC      as _StatusClassific      on  _StatusClassific.Valor = $projection.StatusClassific

  association [0..1] to ZI_MM_VH_SACARIA               as _Sacaria              on  _Sacaria.Valor = $projection.TpSacaria

  association [0..1] to ZI_MM_VH_EMBALAGEM             as _Embalagem            on  _Embalagem.Valor = $projection.TpEmbal

  association [1..1] to I_PurchaseOrderTP              as _PurchaseOrderTP      on  _PurchaseOrderTP.PurchaseOrder = $projection.Pedido

  association [1..1] to I_Supplier                     as _Fornecedor           on  _Fornecedor.Supplier = $projection.Fornecedor

  association [1..1] to I_Supplier                     as _Corretora            on  _Corretora.Supplier = $projection.Corretora

  association [1..1] to I_Supplier                     as _Destinatario         on  _Destinatario.Supplier = $projection.Destinatario

  association [1..1] to I_Supplier                     as _Embarcador           on  _Embarcador.Supplier = $projection.Embarcador

  association [1..1] to I_CompanyCode                  as _CompanyCode          on  _CompanyCode.CompanyCode = $projection.Empresa

  association [1..1] to I_BR_Plant                     as _Plant                on  _Plant.Plant = $projection.Centro

  association [0..1] to I_BR_BusinessPlace             as _BusinessPlace        on  _BusinessPlace.CompanyCode = $projection.Empresa
                                                                                and _BusinessPlace.Branch      = $projection.LocalNegocios
  association [0..1] to I_BusinessAreaText             as _BusinessAreaText     on  _BusinessAreaText.BusinessArea = $projection.Divisao
                                                                                and _BusinessAreaText.Language     = $session.system_language
  association [1..1] to I_MaterialText                 as _MaterialText         on  _MaterialText.Material = $projection.Material
                                                                                and _MaterialText.Language = $session.system_language
  association [0..1] to I_CreatedByUser                as _CreatedByUser        on  _CreatedByUser.UserName = $projection.CreatedBy

  association [0..1] to I_ChangedByUser                as _ChangedByUser        on  _ChangedByUser.UserName = $projection.LastChangedBy

  association [0..1] to I_PurchasingDocumentStatusText as _StatusText           on  _StatusText.PurchasingDocumentStatus = $projection.Status
                                                                                and _StatusText.Language                 = $session.system_language
  association [0..*] to I_PurOrdScheduleLineTP         as _PurOrdScheduleLineTP on  _PurOrdScheduleLineTP.PurchaseOrder     = $projection.Pedido
                                                                                and _PurOrdScheduleLineTP.PurchaseOrderItem = $projection.ItemPedido
{
  key _Classific.ebeln                                    as Pedido,
  key _Classific.ebelp                                    as ItemPedido,
      _PurchaseOrderTP.Supplier                           as Fornecedor,
      _Classific.corretor                                 as Corretor,
      _Classific.corretora                                as Corretora,
      _Classific.perc_corretagem                          as PercCorretagem,
      _Classific.tp_sacaria                               as TpSacaria,
      _Classific.tp_embal                                 as TpEmbal,
      _Classific.nro_contrato                             as Contrato,
      @Semantics.quantity.unitOfMeasure: 'UnidadeMedidaPedido'
      _PurchaseOrderItemTP.OrderQuantity                  as Quantidade,
      _PurchaseOrderItemTP.PurchaseOrderQuantityUnit      as UnidadeMedidaPedido,
      _PurchaseOrderItemTP._Material.MaterialBaseUnit     as UnidadeMedida,
      @Semantics.quantity.unitOfMeasure: 'UnidadeMedida'
      _Classific.lagmg                                    as QuantidadeEstoque,
      _Classific.emlif                                    as Destinatario,
      _Classific.observacao                               as Observacao,
      _Classific.status_classific                         as StatusClassific,
      _Classific.open_purchorder                          as PedidoAberto,
      _Classific.data_classif                             as DataClassif,
      _Classific.inco1                                    as Incoterms,
      _Classific.embarcador                               as Embarcador,
      @Semantics.amount.currencyCode: 'Moeda'
      _Classific.prc_unit_embarcador                      as PrecoUnitEmbarcador,
      @Semantics.amount.currencyCode: 'Moeda'
      _Classific.vlr_tot_corretagem                       as VlrTotalCorretagem,
      @Semantics.amount.currencyCode: 'Moeda'
      _Classific.vlr_tot_embarcador                       as VlrTotalEmbarcador,
      _PurchaseOrderItemTP.Material                       as Material,
      _PurchaseOrderItemTP.CompanyCode                    as Empresa,
      _CompanyCode.CompanyCodeName                        as NomeEmpresa,
      _PurchaseOrderItemTP.Plant                          as Centro,
      _Plant.BusinessPlace                                as LocalNegocios,
      _Divisao.gsber                                      as Divisao,
      //      CONCAT_WITH_SPACE( _Material.spart, _Divisao.gsber, 1) as SetorDivisao,
      @Semantics.amount.currencyCode: 'Moeda'
      _PurchaseOrderTP.PurchaseOrderNetAmount             as ValorTotal,
      _PurchaseOrderTP.DocumentCurrency                   as Moeda,
      @Semantics.quantity.unitOfMeasure: 'UnidadeMedidaPedido'
      _QuantTotal.PurchaseOrderQuantity                   as QuantidadeTotal,
      @Semantics.user.createdBy: true
      _Classific.created_by                               as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      _Classific.created_at                               as CreatedAt,
      @Semantics.user.lastChangedBy: true
      _Classific.last_changed_by                          as LastChangedBy,
      _ChangedByUser.UserDescription                      as NomeModificador,
      @Semantics.systemDateTime.lastChangedAt: true
      _Classific.last_changed_at                          as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      _Classific.local_last_changed_at                    as LocalLastChangedAt,
      _PurchaseOrderItemTP.PurchasingDocumentDeletionCode as DeletionCode,

      case _PurchaseOrderItemTP.PurchasingDocumentDeletionCode
        when ' ' then ' '
        else _PurchaseOrderItemTP.PurchaseOrderItemStatus
      end                                                 as Status,

      cast( '%' as meins )                                as Porcentagem,

      case _Classific.status_classific
        when 'S' then 3
        when 'N' then 2
        else 0
      end                                                 as CriticStatusClassific,

      _Caract,
      _QuantTotal,
      _DadosBancarios,
      _PurchaseOrderTP,
      _PurOrdScheduleLineTP,
      _CompanyCode,
      _StatusClassific,
      _StatusText,
      _Sacaria,
      _Embalagem,
      _Plant,
      _BusinessPlace,
      _BusinessAreaText,
      _MaterialText,
      _Fornecedor,
      _Corretora,
      _Embarcador,
      _Destinatario,
      _CreatedByUser,
      _ChangedByUser

}
