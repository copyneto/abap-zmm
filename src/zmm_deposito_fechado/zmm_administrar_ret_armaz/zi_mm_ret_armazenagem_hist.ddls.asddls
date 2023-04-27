@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Retorno de Armazenagem - Historic Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZI_MM_RET_ARMAZENAGEM_HIST
  as select from    ztmm_his_dep_fec          as _Historico
    inner join      I_Material                as _Material        on _Material.Material = _Historico.material
    left outer join ZI_MM_DF_MATERIAL_UNIDADE as _MaterialUnidade on  _MaterialUnidade.Material = _Historico.material
                                                                  and _MaterialUnidade.Plant    = _Historico.plant
    left outer join I_SalesOrder                 as _SalesOrder      on _SalesOrder.SalesOrder = _Historico.out_sales_order
    left outer join ZI_MM_MARD_ARMAZENAGEM_AGR   as _Deposito        on  _Deposito.matnr = _Historico.material
                                                                     and _Deposito.werks = _Historico.origin_plant                                                                        
                                                                     and _Deposito.lgort = _Historico.origin_storage_location    
                                                                     and _Deposito.charg = _Historico.batch    

{
  key _Historico.guid                     as Guid,
  key _Historico.freight_order_id         as NumeroOrdemDeFrete,
  key _Historico.delivery_document        as NumeroDaRemessa,
  key _Historico.material                 as Material,
  key _Historico.origin_unit              as UmbOrigin,
  key _Historico.unit                     as UmbDestino,
  key _Historico.plant                    as CentroOrigem,
  key _Historico.storage_location         as DepositoOrigem,
  key _Historico.destiny_plant            as CentroDestino,
  key _Historico.destiny_storage_location as DepositoDestino,
  key _Historico.batch                    as Lote,
  key _MaterialUnidade.EANType            as EANType,
       _Historico.process_step             as ProcessStep,
      _SalesOrder.SoldToParty             as SoldToParty,
      _Historico.status                   as Status,
      @Semantics.quantity.unitOfMeasure: 'UmbDestino'
      _Historico.available_stock          as EstoqueRemessaOF,
      @Semantics.quantity.unitOfMeasure: 'UmbDestino'
      //_Historico.used_stock               as UtilizacaoLivre,
      _Deposito.AvalibleStock              as UtilizacaoLivre,
      _Historico.use_available            as UseAvailable,

      @Semantics.quantity.unitOfMeasure: 'UmbDestino'
      _Historico.available_stock          as EstoqueLivreUtilizacao,
      @Semantics.quantity.unitOfMeasure: 'UmbDestino'
//      _Historico.order_quantity           as QtdTransportada,
      _Historico.used_stock            as QtdTransportada,

      _Historico.status                   as StatusHistorico,
      @Semantics.quantity.unitOfMeasure : 'UmbOrigin'
      _Historico.order_quantity           as QtdOrdVenda,
      @Semantics.quantity.unitOfMeasure: 'UmbDestino'
      _MaterialUnidade.Marmumren          as EstoqueEmReserva,
      @Semantics.quantity.unitOfMeasure: 'UmbDestino'
      _MaterialUnidade.MarmUmrez          as EstoqueBloqueado,
      _Historico.guid                     as PrmDepFecId,
      _Historico.description              as Description,
      _Historico.origin_plant_type        as OriginPlantType,
      _Historico.destiny_plant_type       as DestinyPlantType,
      _SalesOrder.SalesDistrict           as SalesDistrict,
      _Historico.purchase_order           as purchaseorder,
      _Historico.out_br_nota_fiscal       as outbr_notafiscal




      //  key _Historico.material                    as Material,
      //  key _Historico.plant                       as OriginPlant,
      //  key _Historico.storage_location            as OriginStorageLocation,
      //  key _Historico.batch                       as Batch,
      //  key _Historico.origin_unit                 as OriginUnit,
      //  key _Historico.unit                        as Unit,
      //  key _Historico.guid                        as Guid,
      //  key _Historico.process_step                as ProcessStep,
      //  key _Historico.prm_dep_fec_id              as PrmDepFecId,
      //      _Historico.status                      as Status,
      //
      //      _Historico.description                 as Description,
      //      _Historico.origin_plant_type           as OriginPlantType,
      //      _Historico.destiny_plant               as DestinyPlant,
      //      _Historico.destiny_plant_type          as DestinyPlantType,
      //      _Historico.destiny_storage_location    as DestinyStorageLocation,
      //
      //      _Historico.use_available               as UseAvailable,
      //      @Semantics.quantity.unitOfMeasure : 'Unit'
      //      _Historico.available_stock             as AvailableStock,
      //      @Semantics.quantity.unitOfMeasure : 'Unit'
      //      _Historico.used_stock                  as UsedStock,
      //
      //      _Historico.carrier                     as Carrier,
      //      _Historico.driver                      as Driver,
      //      _Historico.equipment                   as Equipment,
      //      _Historico.shipping_conditions         as ShippingConditions,
      //      _Historico.shipping_type               as ShippingType,
      //      _Historico.equipment_tow1              as EquipmentTow1,
      //      _Historico.equipment_tow2              as EquipmentTow2,
      //      _Historico.equipment_tow3              as EquipmentTow3,
      //      _Historico.freight_mode                as FreightMode,
      //      _MaterialUnidade.EANType               as EANType,
      //      _Historico.main_plant                  as MainPlant,
      //      _Historico.main_purchase_order         as MainPurchaseOrder,
      //      _Historico.main_purchase_order_item    as MainPurchaseOrderItem,
      //      _Historico.main_material_document      as MainMaterialDocument,
      //      _Historico.main_material_document_year as MainMaterialDocumentYear,
      //      _Historico.main_material_document_item as MainMaterialDocumentItem,
      //      _Historico.order_quantity              as OrderQuantity,
      //      _Historico.order_quantity_unit         as OrderQuantityUnit,
      //      _Historico.purchase_order              as PurchaseOrder,
      //      _Historico.purchase_order_item         as PurchaseOrderItem,
      //      _Historico.incoterms1                  as Incoterms1,
      //      _Historico.incoterms2                  as Incoterms2,
      //
      //      _Historico.out_sales_order             as SalesOrder,
      //      _Historico.out_sales_order_item        as SalesOrderItem,
      //      _Historico.out_delivery_document       as DeliveryDocument,
      //      _Historico.out_delivery_document_item  as DeliveryDocumentItem,
      //      _Historico.out_material_document       as MaterialDocument,
      //      _Historico.out_material_document_year  as MaterialDocumentYear,
      //      _Historico.out_material_document_item  as MaterialDocumentItem,
      //      _Historico.out_br_nota_fiscal          as BrNotaFiscal,
      //      _Historico.out_br_nota_fiscal_item     as BrNotaFiscalItem,
      //
      //      _Historico.out_sales_order             as OutSalesOrder,
      //      _Historico.out_sales_order_item        as OutSalesOrderItem,
      //      _Historico.out_delivery_document       as OutDeliveryDocument,
      //      _Historico.out_delivery_document_item  as OutDeliveryDocumentItem,
      //      _Historico.out_material_document       as OutMaterialDocument,
      //      _Historico.out_material_document_year  as OutMaterialDocumentYear,
      //      _Historico.out_material_document_item  as OutMaterialDocumentItem,
      //      _Historico.out_br_nota_fiscal          as OutBR_NotaFiscal,
      //      _Historico.out_br_nota_fiscal_item     as OutBR_NotaFiscalItem,
      //      _Historico.rep_br_nota_fiscal          as RepBR_NotaFiscal,
      //      _Historico.in_delivery_document        as InDeliveryDocument,
      //      _Historico.in_delivery_document_item   as InDeliveryDocumentItem,
      //      _Historico.in_material_document        as InMaterialDocument,
      //      _Historico.in_material_document_year   as InMaterialDocumentYear,
      //      _Historico.in_material_document_item   as InMaterialDocumentItem,
      //      _Historico.in_br_nota_fiscal           as InBR_NotaFiscal,
      //      _Historico.in_br_nota_fiscal_item      as InBR_NotaFiscalItem,
      //
      //      _Historico.created_by                  as CreatedBy,
      //      _Historico.created_at                  as CreatedAt,
      //      _Historico.last_changed_by             as LastChangedBy,
      //      _Historico.last_changed_at             as LastChangedAt,
      //      _Historico.local_last_changed_at       as LocalLastChangedAt,
      //      _MaterialUnidade.Marmumren,
      //      _MaterialUnidade.MarmUmrez,
      //     ( cast( _MaterialUnidade.Marmumren as abap.fltp ) * cast( _Historico.available_stock  as abap.fltp ) ) / cast( _MaterialUnidade.MarmUmrez as abap.fltp ) as Available_stock_c,
      //     ( cast( _MaterialUnidade.Marmumren as abap.fltp ) * cast( _Historico.used_stock  as abap.fltp ) ) / cast( _MaterialUnidade.MarmUmrez as abap.fltp ) as used_stock_c,
      //     _Historico.freight_order_id  as FreightOrder
}
where
  _Historico.process_step = 'F05'
and _Historico.guid != hextobin('00000000000000000000000000000000')
//define view entity ZI_MM_RET_ARMAZENAGEM_HIST
//  as select from           ztmm_his_dep_fec       as _Historico
//    inner join             /scmtms/d_torrot       as _OrdemFrete   on _OrdemFrete.tor_id = _Historico.freight_order_id
//    left outer join        /scmtms/d_torite       as _Entrega      on  _Entrega.parent_key   = _OrdemFrete.db_key
//                                                                   and _Entrega.base_btd_tco = '73' -- Entrega
//
//    left outer to one join /scmtms/d_torrot       as _UnidadeFrete on  _UnidadeFrete.db_key  = _Entrega.fu_root_key
//                                                                   and _UnidadeFrete.tor_cat = 'FU' -- Unidade de Frete
//
//    left outer to one join I_DeliveryDocumentItem as _DocItem      on _DocItem.DeliveryDocument = substring(
//      _Entrega.base_btd_id, 26, 10
//    )
//
//    left outer join        I_SalesOrder           as _SalesOrder   on _SalesOrder.SalesOrder = _DocItem.ReferenceSDDocument
//
//
//    left outer join        ZI_MM_ZMENG_SUM        as _ZMENG        on _ZMENG.Vbeln = _SalesOrder.SalesOrder
//
//    right outer join       ZI_MM_RESB_SUM         as _RESB         on _RESB.Matnr = _Historico.material
//
//    inner join             mard                   as _Mard         on  _Mard.matnr = _Historico.material
//                                                                   and _Mard.werks = _Historico.plant
//                                                                   and _Mard.lgort = _Historico.storage_location
//
//
//{
//  key _Historico.freight_order_id         as NumeroOrdemDeFrete, //Nº ordem de frete
//  key _Historico.delivery_document        as NumeroDaRemessa, //Nº da remessa
//  key _Historico.material                 as Material,        //MATERIAL
//      //Texto breve do material -- VH
//  key _Historico.origin_unit              as UmbOrigin, //UMB Origin
//  key _Historico.unit                     as UmbDestino, //UMB Destino
//  key _Historico.plant                    as CentroOrigem, //Centro remessa
//  key _Historico.storage_location         as DepositoOrigem, //Depósito
//  key _Historico.destiny_plant            as CentroDestino,
//  key _Historico.destiny_storage_location as DepositoDestino,
//  key _Historico.batch                    as Lote,
//  key _Historico.ean_type                 as EANType,
//  key _Historico.process_step             as ProcessStep,
//      //Denominação do depósito -- VH
//      _SalesOrder.SoldToParty, //Código cliente
//      //Nome cliente -- VH
//      _OrdemFrete.confirmation            as Status, //Status da ordem de frete
//      @Semantics.quantity.unitOfMeasure: 'UmbDestino'
//      _Historico.available_stock          as EstoqueRemessaOF, //Estoque em remessa com OF
//      @Semantics.quantity.unitOfMeasure: 'UmbDestino'
//      _Historico.used_stock               as UtilizacaoLivre, //Utilização livre
//      _Historico.use_available            as UseAvailable,
//
//      @Semantics.quantity.unitOfMeasure: 'UmbDestino'
//      _Historico.order_quantity           as EstoqueLivreUtilizacao, //Estoque livre utilização
//      @Semantics.quantity.unitOfMeasure: 'UmbDestino'
//      _Historico.order_quantity           as QtdTransportada, //Estoque livre utilização
//
//      case when _Historico.status is not null
//      then _Historico.status
//      else '00' end                       as StatusHistorico, -- Inicial
//      @Semantics.quantity.unitOfMeasure : 'UmbOrigin'
//      _ZMENG.sunZMENGE                    as QtdOrdVenda,
//      @Semantics.quantity.unitOfMeasure: 'UmbDestino'
//      _RESB.SunLbast                      as EstoqueEmReserva,
//      @Semantics.quantity.unitOfMeasure: 'UmbDestino'
//      _Mard.speme                         as EstoqueBloqueado, //Estoque bloqueado (devoluções)
//      _Historico.guid                     as Guid,
//      _Historico.guid                     as PrmDepFecId,
//      _Historico.description              as Description,
//      _Historico.origin_plant_type        as OriginPlantType,
//      _Historico.destiny_plant_type       as DestinyPlantType,
//      _SalesOrder.SalesDistrict           as SalesDistrict,
//      _Historico.purchase_order           as purchaseorder,
//      _Historico.out_br_nota_fiscal       as outbr_notafiscal
//
//
//}
//where
//      _Historico.process_step = 'F05'
//  and _Historico.guid != hextobin('00000000000000000000000000000000')
