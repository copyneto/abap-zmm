@AbapCatalog.sqlViewName: 'ZVMM_DF_EMI_NF'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Relatório Emissão NF'
define view ZI_MM_DF_EMISSAO_NF
  as select from    ztmm_prm_dep_fec          as _Configuracao

    left outer join ZI_MM_MARD_ARMAZENAGEM_AGR     as _Deposito   on  _Deposito.werks = _Configuracao.origin_plant
                                                                  and _Deposito.lgort = _Configuracao.origin_storage_location

    inner join     mara                       as _mara           on _mara.matnr = _Deposito.matnr                                                                  
    left outer join ZI_MM_DF_MATERIAL_UNIDADE as _MaterialUnidade on  _MaterialUnidade.Material = _Deposito.matnr
                                                                  and _MaterialUnidade.Plant    = _Deposito.werks
    left outer join ztmm_his_dep_fec          as _Historico       on  _Historico.material         = _Deposito.matnr
                                                                  and _Historico.plant            = _Deposito.werks
                                                                  and _Historico.storage_location = _Deposito.lgort
                                                                  and _Historico.plant_dest       = _Configuracao.destiny_plant
                                                                  and _Historico.storage_location_dest = _Configuracao.destiny_storage_location
                                                                  and _Historico.guid             = hextobin('00000000000000000000000000000000')
                                                                  and _Historico.process_step     = 'F02'
                                                                  and _Historico.batch            = _Deposito.charg

{
  key  _Deposito.matnr                                as Material,
  key  _Deposito.werks                                as OriginPlant,
  key  _Deposito.lgort                                as OriginStorageLocation,
  key  _Deposito.charg                                as Batch,         -- _Historico.batch
  key  _MaterialUnidade.OriginUnit                    as OriginUnit,
  key  _MaterialUnidade.Unit                          as Unit,
  key  hextobin( '00000000000000000000000000000000' ) as Guid,
  key  case when _Historico.process_step is not null
     then _Historico.process_step
     else 'F02' end                                   as ProcessStep,
  key _Configuracao.guid                             as PrmDepFecId,     
   key    _Configuracao.destiny_plant                    as DestinyPlant,
//       _Configuracao.destiny_plant_type               as DestinyPlantType,
   key    _Configuracao.destiny_storage_location         as DestinyStorageLocation, 
  
       case when _Historico.status is not null
       then _Historico.status
       else '00' end                                  as Status, -- Inicial

        
       _Configuracao.description                      as Description,
       _Configuracao.origin_plant_type                as OriginPlantType,
//       _Configuracao.destiny_plant                    as DestinyPlant,
       _Configuracao.destiny_plant_type               as DestinyPlantType,
//       _Configuracao.destiny_storage_location         as DestinyStorageLocation,
       _Historico.use_available                       as UseAvailable,

     @Semantics.quantity.unitOfMeasure : 'Unit'     
      _Deposito.AvalibleStock   as AvailableStock,
//      case when _Historico.available_stock is not null
//       then _Historico.available_stock
//      else _Deposito.labst end                       as AvailableStock,


       @Semantics.quantity.unitOfMeasure : 'Unit'
       _Historico.used_stock                          as UsedStock,

       _Historico.carrier                             as Carrier,
       _Historico.driver                              as Driver,
       _Historico.equipment                           as Equipment,
       _Historico.shipping_conditions                 as ShippingConditions,
       _Historico.shipping_type                       as ShippingType,
       _Historico.equipment_tow1                      as EquipmentTow1,
       _Historico.equipment_tow2                      as EquipmentTow2,
       _Historico.equipment_tow3                      as EquipmentTow3,
       _Historico.freight_mode                        as FreightMode,
       _MaterialUnidade.EANType                       as EANType,
       _Historico.main_plant                          as MainPlant,
       _Historico.main_purchase_order                 as MainPurchaseOrder,
       _Historico.main_purchase_order_item            as MainPurchaseOrderItem,
       _Historico.main_material_document              as MainMaterialDocument,
       _Historico.main_material_document_year         as MainMaterialDocumentYear,
       _Historico.main_material_document_item         as MainMaterialDocumentItem,
       _Historico.order_quantity                      as OrderQuantity,
       _Historico.order_quantity_unit                 as OrderQuantityUnit,
       _Historico.purchase_order                      as PurchaseOrder,
       _Historico.purchase_order_item                 as PurchaseOrderItem,
       _Historico.incoterms1                          as Incoterms1,
       _Historico.incoterms2                          as Incoterms2,

       _Historico.out_sales_order                     as SalesOrder,
       _Historico.out_sales_order_item                as SalesOrderItem,
       _Historico.out_delivery_document               as DeliveryDocument,
       _Historico.out_delivery_document_item          as DeliveryDocumentItem,
       _Historico.out_material_document               as MaterialDocument,
       _Historico.out_material_document_year          as MaterialDocumentYear,
       _Historico.out_material_document_item          as MaterialDocumentItem,
       _Historico.out_br_nota_fiscal                  as BrNotaFiscal,
       _Historico.out_br_nota_fiscal_item             as BrNotaFiscalItem,

       _Historico.out_sales_order                     as OutSalesOrder,
       _Historico.out_sales_order_item                as OutSalesOrderItem,
       _Historico.out_delivery_document               as OutDeliveryDocument,
       _Historico.out_delivery_document_item          as OutDeliveryDocumentItem,
       _Historico.out_material_document               as OutMaterialDocument,
       _Historico.out_material_document_year          as OutMaterialDocumentYear,
       _Historico.out_material_document_item          as OutMaterialDocumentItem,
       _Historico.out_br_nota_fiscal                  as OutBR_NotaFiscal,
       _Historico.out_br_nota_fiscal_item             as OutBR_NotaFiscalItem,
       _Historico.rep_br_nota_fiscal                  as RepBR_NotaFiscal,
       _Historico.in_delivery_document                as InDeliveryDocument,
       _Historico.in_delivery_document_item           as InDeliveryDocumentItem,
       _Historico.in_material_document                as InMaterialDocument,
       _Historico.in_material_document_year           as InMaterialDocumentYear,
       _Historico.in_material_document_item           as InMaterialDocumentItem,
       _Historico.in_br_nota_fiscal                   as InBR_NotaFiscal,
       _Historico.in_br_nota_fiscal_item              as InBR_NotaFiscalItem,

       _Historico.created_by                          as CreatedBy,
       _Historico.created_at                          as CreatedAt,
       _Historico.last_changed_by                     as LastChangedBy,
       _Historico.last_changed_at                     as LastChangedAt,
       _Historico.local_last_changed_at               as LocalLastChangedAt,
       _MaterialUnidade.Marmumren,
       _MaterialUnidade.MarmUmrez,

       ( cast( _MaterialUnidade.Marmumren as abap.fltp ) * cast(  _Deposito.AvalibleStock  as abap.fltp ) ) / cast( _MaterialUnidade.MarmUmrez as abap.fltp )  as Available_stock_c, 
//       case when _Historico.available_stock is not null
//       then
//       ( cast( _MaterialUnidade.Marmumren as abap.fltp ) * cast( _Historico.available_stock  as abap.fltp ) ) / cast( _MaterialUnidade.MarmUmrez as abap.fltp ) 
//       else 
//       ( cast( _MaterialUnidade.Marmumren as abap.fltp ) * cast( _Deposito.labst  as abap.fltp ) ) / cast( _MaterialUnidade.MarmUmrez as abap.fltp ) end as Available_stock_c,
       ( cast( _MaterialUnidade.Marmumren as abap.fltp ) * cast( _Historico.used_stock  as abap.fltp ) ) / cast( _MaterialUnidade.MarmUmrez as abap.fltp ) as used_stock_c,
       
       _Historico.freight_order_id  as FreightOrder       
       
}
// where
//     _Deposito.labst       > 0
//  or _Historico.used_stock > 0 

/* union

select from    ztmm_prm_dep_fec          as _Configuracao
    inner join      nsdm_e_mard_agg           as _Deposito        on  _Deposito.werks = _Configuracao.origin_plant
                                                                  and _Deposito.lgort = _Configuracao.origin_storage_location
    left outer join      nsdm_e_mchb_agg           as _Lote           on  _Lote.matnr = _Deposito.matnr
                                                                 and _Lote.werks = _Deposito.werks
                                                                 and _Lote.lgort = _Deposito.lgort
    inner join     mara                       as _mara           on _mara.matnr = _Deposito.matnr                                                                  
    left outer join ZI_MM_DF_MATERIAL_UNIDADE as _MaterialUnidade on  _MaterialUnidade.Material = _Deposito.matnr
                                                                  and _MaterialUnidade.Plant    = _Deposito.werks
    left outer join ztmm_his_dep_fec          as _Historico       on  _Historico.material         = _Deposito.matnr
                                                                  and _Historico.plant            = _Deposito.werks
                                                                  and _Historico.storage_location = _Deposito.lgort
                                                                  and _Historico.plant_dest       = _Configuracao.destiny_plant
                                                                  and _Historico.storage_location_dest = _Configuracao.destiny_storage_location
                                                                  and _Historico.guid             = hextobin('00000000000000000000000000000000')
                                                                  and _Historico.process_step     = 'F02'
                                                                  and _Historico.batch            = ''
                                                                  // and _Historico.batch            = COALESCE( _Lote.charg,'' )  //_Lote.charg

{
  key  _Deposito.matnr                                as Material,
  key  _Deposito.werks                                as OriginPlant,
  key  _Deposito.lgort                                as OriginStorageLocation,
  key  COALESCE( _Lote.charg,'' )                     as Batch,         -- _Historico.batch
  key  _MaterialUnidade.OriginUnit                    as OriginUnit,
  key  _MaterialUnidade.Unit                          as Unit,
  key  hextobin( '00000000000000000000000000000000' ) as Guid,
  key  case when _Historico.process_step is not null
     then _Historico.process_step
     else 'F02' end                                   as ProcessStep,
  key _Configuracao.guid                             as PrmDepFecId,     

       case when _Historico.status is not null
       then _Historico.status
       else '00' end                                  as Status, -- Inicial

        
       _Configuracao.description                      as Description,
       _Configuracao.origin_plant_type                as OriginPlantType,
       _Configuracao.destiny_plant                    as DestinyPlant,
       _Configuracao.destiny_plant_type               as DestinyPlantType,
       _Configuracao.destiny_storage_location         as DestinyStorageLocation,
       _Historico.use_available                       as UseAvailable,

     @Semantics.quantity.unitOfMeasure : 'mara.meins'     
     COALESCE( _Lote.stock_qty , _Deposito.stock_qty )   as AvailableStock,
//      case when _Historico.available_stock is not null
//       then _Historico.available_stock
//      else _Deposito.labst end                       as AvailableStock,


       @Semantics.quantity.unitOfMeasure : 'Unit'
       _Historico.used_stock                          as UsedStock,

       _Historico.carrier                             as Carrier,
       _Historico.driver                              as Driver,
       _Historico.equipment                           as Equipment,
       _Historico.shipping_conditions                 as ShippingConditions,
       _Historico.shipping_type                       as ShippingType,
       _Historico.equipment_tow1                      as EquipmentTow1,
       _Historico.equipment_tow2                      as EquipmentTow2,
       _Historico.equipment_tow3                      as EquipmentTow3,
       _Historico.freight_mode                        as FreightMode,
       _MaterialUnidade.EANType                       as EANType,
       _Historico.main_plant                          as MainPlant,
       _Historico.main_purchase_order                 as MainPurchaseOrder,
       _Historico.main_purchase_order_item            as MainPurchaseOrderItem,
       _Historico.main_material_document              as MainMaterialDocument,
       _Historico.main_material_document_year         as MainMaterialDocumentYear,
       _Historico.main_material_document_item         as MainMaterialDocumentItem,
       _Historico.order_quantity                      as OrderQuantity,
       _Historico.order_quantity_unit                 as OrderQuantityUnit,
       _Historico.purchase_order                      as PurchaseOrder,
       _Historico.purchase_order_item                 as PurchaseOrderItem,
       _Historico.incoterms1                          as Incoterms1,
       _Historico.incoterms2                          as Incoterms2,

       _Historico.out_sales_order                     as SalesOrder,
       _Historico.out_sales_order_item                as SalesOrderItem,
       _Historico.out_delivery_document               as DeliveryDocument,
       _Historico.out_delivery_document_item          as DeliveryDocumentItem,
       _Historico.out_material_document               as MaterialDocument,
       _Historico.out_material_document_year          as MaterialDocumentYear,
       _Historico.out_material_document_item          as MaterialDocumentItem,
       _Historico.out_br_nota_fiscal                  as BrNotaFiscal,
       _Historico.out_br_nota_fiscal_item             as BrNotaFiscalItem,

       _Historico.out_sales_order                     as OutSalesOrder,
       _Historico.out_sales_order_item                as OutSalesOrderItem,
       _Historico.out_delivery_document               as OutDeliveryDocument,
       _Historico.out_delivery_document_item          as OutDeliveryDocumentItem,
       _Historico.out_material_document               as OutMaterialDocument,
       _Historico.out_material_document_year          as OutMaterialDocumentYear,
       _Historico.out_material_document_item          as OutMaterialDocumentItem,
       _Historico.out_br_nota_fiscal                  as OutBR_NotaFiscal,
       _Historico.out_br_nota_fiscal_item             as OutBR_NotaFiscalItem,
       _Historico.rep_br_nota_fiscal                  as RepBR_NotaFiscal,
       _Historico.in_delivery_document                as InDeliveryDocument,
       _Historico.in_delivery_document_item           as InDeliveryDocumentItem,
       _Historico.in_material_document                as InMaterialDocument,
       _Historico.in_material_document_year           as InMaterialDocumentYear,
       _Historico.in_material_document_item           as InMaterialDocumentItem,
       _Historico.in_br_nota_fiscal                   as InBR_NotaFiscal,
       _Historico.in_br_nota_fiscal_item              as InBR_NotaFiscalItem,

       _Historico.created_by                          as CreatedBy,
       _Historico.created_at                          as CreatedAt,
       _Historico.last_changed_by                     as LastChangedBy,
       _Historico.last_changed_at                     as LastChangedAt,
       _Historico.local_last_changed_at               as LocalLastChangedAt,
       _MaterialUnidade.Marmumren,
       _MaterialUnidade.MarmUmrez,

       ( cast( _MaterialUnidade.Marmumren as abap.fltp ) * cast( COALESCE( _Lote.stock_qty , _Deposito.stock_qty )   as abap.fltp ) ) / cast( _MaterialUnidade.MarmUmrez as abap.fltp )  as Available_stock_c, 
//       case when _Historico.available_stock is not null
//       then
//       ( cast( _MaterialUnidade.Marmumren as abap.fltp ) * cast( _Historico.available_stock  as abap.fltp ) ) / cast( _MaterialUnidade.MarmUmrez as abap.fltp ) 
//       else 
//       ( cast( _MaterialUnidade.Marmumren as abap.fltp ) * cast( _Deposito.labst  as abap.fltp ) ) / cast( _MaterialUnidade.MarmUmrez as abap.fltp ) end as Available_stock_c,
       ( cast( _MaterialUnidade.Marmumren as abap.fltp ) * cast( _Historico.used_stock  as abap.fltp ) ) / cast( _MaterialUnidade.MarmUmrez as abap.fltp ) as used_stock_c       
       
} */

 union
 select from  ztmm_his_dep_fec as _Historico
  inner join I_Material       as _Material on _Material.Material = _Historico.material
  left outer join ZI_MM_DF_MATERIAL_UNIDADE as _MaterialUnidade on  _MaterialUnidade.Material = _Historico.material
                                                               and _MaterialUnidade.Plant    = _Historico.plant  
{
  key _Historico.material                    as Material,
  key _Historico.plant                       as OriginPlant,
  key _Historico.storage_location            as OriginStorageLocation,
  key _Historico.batch                       as Batch,
  key _Historico.origin_unit                 as OriginUnit,
  key _Historico.unit                        as Unit,
  key _Historico.guid                        as Guid,
  key _Historico.process_step                as ProcessStep,
  key _Historico.prm_dep_fec_id              as PrmDepFecId,
  key       _Historico.destiny_plant               as DestinyPlant,
//      _Historico.destiny_plant_type          as DestinyPlantType,
  key    _Historico.destiny_storage_location    as DestinyStorageLocation,
      _Historico.status                      as Status,

      _Historico.description                 as Description,
      _Historico.origin_plant_type           as OriginPlantType,
//      _Historico.destiny_plant               as DestinyPlant,
      _Historico.destiny_plant_type          as DestinyPlantType,
//      _Historico.destiny_storage_location    as DestinyStorageLocation,

      _Historico.use_available               as UseAvailable,
      @Semantics.quantity.unitOfMeasure : 'Unit'
      _Historico.available_stock             as AvailableStock,
      @Semantics.quantity.unitOfMeasure : 'Unit'
      _Historico.used_stock                  as UsedStock,

      _Historico.carrier                     as Carrier,
      _Historico.driver                      as Driver,
      _Historico.equipment                   as Equipment,
      _Historico.shipping_conditions         as ShippingConditions,
      _Historico.shipping_type               as ShippingType,
      _Historico.equipment_tow1              as EquipmentTow1,
      _Historico.equipment_tow2              as EquipmentTow2,
      _Historico.equipment_tow3              as EquipmentTow3,
      _Historico.freight_mode                as FreightMode,
      _MaterialUnidade.EANType               as EANType,
      _Historico.main_plant                  as MainPlant,
      _Historico.main_purchase_order         as MainPurchaseOrder,
      _Historico.main_purchase_order_item    as MainPurchaseOrderItem,
      _Historico.main_material_document      as MainMaterialDocument,
      _Historico.main_material_document_year as MainMaterialDocumentYear,
      _Historico.main_material_document_item as MainMaterialDocumentItem,
      _Historico.order_quantity              as OrderQuantity,
      _Historico.order_quantity_unit         as OrderQuantityUnit,
      _Historico.purchase_order              as PurchaseOrder,
      _Historico.purchase_order_item         as PurchaseOrderItem,
      _Historico.incoterms1                  as Incoterms1,
      _Historico.incoterms2                  as Incoterms2,

      _Historico.out_sales_order             as SalesOrder,
      _Historico.out_sales_order_item        as SalesOrderItem,
      _Historico.out_delivery_document       as DeliveryDocument,
      _Historico.out_delivery_document_item  as DeliveryDocumentItem,
      _Historico.out_material_document       as MaterialDocument,
      _Historico.out_material_document_year  as MaterialDocumentYear,
      _Historico.out_material_document_item  as MaterialDocumentItem,
      _Historico.out_br_nota_fiscal          as BrNotaFiscal,
      _Historico.out_br_nota_fiscal_item     as BrNotaFiscalItem,

      _Historico.out_sales_order             as OutSalesOrder,
      _Historico.out_sales_order_item        as OutSalesOrderItem,
      _Historico.out_delivery_document       as OutDeliveryDocument,
      _Historico.out_delivery_document_item  as OutDeliveryDocumentItem,
      _Historico.out_material_document       as OutMaterialDocument,
      _Historico.out_material_document_year  as OutMaterialDocumentYear,
      _Historico.out_material_document_item  as OutMaterialDocumentItem,
      _Historico.out_br_nota_fiscal          as OutBR_NotaFiscal,
      _Historico.out_br_nota_fiscal_item     as OutBR_NotaFiscalItem,
      _Historico.rep_br_nota_fiscal          as RepBR_NotaFiscal,
      _Historico.in_delivery_document        as InDeliveryDocument,
      _Historico.in_delivery_document_item   as InDeliveryDocumentItem,
      _Historico.in_material_document        as InMaterialDocument,
      _Historico.in_material_document_year   as InMaterialDocumentYear,
      _Historico.in_material_document_item   as InMaterialDocumentItem,
      _Historico.in_br_nota_fiscal           as InBR_NotaFiscal,
      _Historico.in_br_nota_fiscal_item      as InBR_NotaFiscalItem,

      _Historico.created_by                  as CreatedBy,
      _Historico.created_at                  as CreatedAt,
      _Historico.last_changed_by             as LastChangedBy,
      _Historico.last_changed_at             as LastChangedAt,
      _Historico.local_last_changed_at       as LocalLastChangedAt,
      _MaterialUnidade.Marmumren,
      _MaterialUnidade.MarmUmrez,
     ( cast( _MaterialUnidade.Marmumren as abap.fltp ) * cast( _Historico.available_stock  as abap.fltp ) ) / cast( _MaterialUnidade.MarmUmrez as abap.fltp ) as Available_stock_c,
     ( cast( _MaterialUnidade.Marmumren as abap.fltp ) * cast( _Historico.used_stock  as abap.fltp ) ) / cast( _MaterialUnidade.MarmUmrez as abap.fltp ) as used_stock_c,
     _Historico.freight_order_id  as FreightOrder
}
 where
      _Historico.process_step =  'F02'
//  and _Historico.guid         <> hextobin( '00000000000000000000000000000000' )
