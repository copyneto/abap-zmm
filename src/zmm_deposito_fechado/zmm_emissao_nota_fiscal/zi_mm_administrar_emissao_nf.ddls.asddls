@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Emissão de Nota Fiscal'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_ADMINISTRAR_EMISSAO_NF
  as select from ZI_MM_DF_EMISSAO_NF

  composition [0..*] of ZI_MM_ADMINISTRAR_SERIE      as _Serie
  composition [0..*] of ZI_MM_ADMINISTRAR_MSG        as _Mensagem

  association [0..1] to I_Material                   as _MaterialInfo           on  _MaterialInfo.Material = $projection.Material
  association [0..1] to ZI_MM_VH_DF_STATUS           as _Status                 on  _Status.Status = $projection.Status
  association [0..1] to ZI_CA_VH_MATERIAL            as _Material               on  _Material.Material = $projection.Material
  association [0..1] to ZI_CA_VH_MTART               as _MaterialType           on  _MaterialType.MaterialType = $projection.MaterialType
  association [0..1] to ZI_CA_VH_WERKS               as _OriginPlant            on  _OriginPlant.WerksCode = $projection.OriginPlant
  association [0..1] to ZI_CA_VH_LGORT               as _OriginStorageLocation  on  _OriginStorageLocation.Plant           = $projection.OriginPlant
                                                                                and _OriginStorageLocation.StorageLocation = $projection.OriginStorageLocation
  association [0..1] to ZI_SD_VH_DF_TIPO_CENTRO      as _OriginPlantType        on  _OriginPlantType.PlantType = $projection.OriginPlantType
  association [0..1] to ZI_CA_VH_WERKS               as _DestinyPlant           on  _DestinyPlant.WerksCode = $projection.DestinyPlant
  association [0..1] to ZI_CA_VH_LGORT               as _DestinyStorageLocation on  _DestinyStorageLocation.Plant           = $projection.DestinyPlant
                                                                                and _DestinyStorageLocation.StorageLocation = $projection.DestinyStorageLocation
  association [0..1] to ZI_SD_VH_DF_TIPO_CENTRO      as _DestinyPlantType       on  _DestinyPlantType.PlantType = $projection.DestinyPlantType
  association [0..1] to ZI_MM_VH_DF_TRANSPORTADOR    as _Carrier                on  _Carrier.Carrier = $projection.Carrier
  association [0..1] to ZI_MM_VH_DF_MOTORISTA        as _Driver                 on  _Driver.Parceiro = $projection.Driver
  association [0..1] to ZI_MM_VH_DF_VEICULO          as _Equipment              on  _Equipment.Equipment = $projection.Equipment
  association [0..1] to ZI_CA_VH_VSBED               as _ShippingConditions     on  _ShippingConditions.CondicaoExpedicao = $projection.ShippingConditions
  association [0..1] to ZI_CA_VH_VSART               as _ShippingType           on  _ShippingType.TipoExpedicao = $projection.ShippingType
  association [0..1] to ZI_MM_VH_DF_VEICULO          as _EquipmentTow1          on  _EquipmentTow1.Equipment = $projection.EquipmentTow1
  association [0..1] to ZI_MM_VH_DF_VEICULO          as _EquipmentTow2          on  _EquipmentTow2.Equipment = $projection.EquipmentTow2
  association [0..1] to ZI_MM_VH_DF_VEICULO          as _EquipmentTow3          on  _EquipmentTow3.Equipment = $projection.EquipmentTow3
  association [0..1] to ZI_MM_VH_DF_MODALIDADE_FRETE as _FreightMode            on  _FreightMode.FreightMode = $projection.FreightMode
  association [0..1] to ZI_MM_VH_DF_TIPO_EAN         as _EANType                on  _EANType.EANType = $projection.EANType

{
  key Material,
  key OriginPlant,
  key OriginStorageLocation,
  key Batch,
  key OriginUnit,
  key Unit,
  key Guid,
  key ProcessStep,
  key PrmDepFecId,
  key DestinyPlant,
  key DestinyStorageLocation, 
  
  key EANType,

    Status,

      case Status
      when '00' then 0 -- Inicial
      when '01' then 2 -- Em processamento
      when '02' then 1 -- Incompleto
      when '03' then 3 -- Completo
      when '04' then 2 -- Aguardando job Entrada Mercadoria
      when '05' then 1 -- Nota Rejeitada pela SEFAZ
      when '06' then 1 -- Erro na composição da Nota
      when '07' then 2 -- Em trânsito
      when '09' then 2 -- Aguardando Saída de Material
      when '11' then 2 -- Aguardando Ordem de Frente
                else 0
      end                                               as StatusCriticality,

      _MaterialInfo.MaterialType                        as MaterialType,

      Description,
      OriginPlantType,
      DestinyPlantType,
      
      UseAvailable,

      case when UseAvailable is not initial
      then 3
      when UseAvailable is initial and UsedStock > 0
      then 2
      else 0
      end                                               as UseAvailableCriticality,

      UseAvailable                                      as UseAvailableCheckBox,

      cast( case Status
      when '00' then '' -- Inicial
      when '01' then 'X' -- Em processamento
      when '02' then ''  -- Incompleto
      when '03' then ''  -- Completo
      when '04' then ''  -- Aguardando job Entrada Mercadoria
      when '05' then ''  -- Nota Rejeitada pela SEFAZ
      when '06' then ''  -- Erro na composição da Nota
      when '07' then ''  -- Em trânsito
      when '08' then ''  -- Em trânsito
      when '09' then ''  -- Em trânsito
      when '11' then ''  -- Aguardando Ordem de frente
                else 'X'
      end as boole_d )                                  as UseAvailableCheckBoxEnable,

      @Semantics.quantity.unitOfMeasure : 'Unit'
      AvailableStock,

      @Semantics.quantity.unitOfMeasure : 'Unit'
      fltp_to_dec(Available_stock_c as abap.quan(13,3)) as AvailableStock_Conve,

      @Semantics.quantity.unitOfMeasure : 'Unit'
      UsedStock,

      @Semantics.quantity.unitOfMeasure : 'Unit'
      fltp_to_dec(used_stock_c as mng06 )               as UsedStock_conve,

      case
      when UseAvailable is not initial then 3
      when UseAvailable is initial and UsedStock > 0 then 2
      else 0
      end                                               as UsedStockCriticality,

      case
      when UseAvailable = 'X' then cast( '' as boole_d )  -- Utilização completa marcado
      when Status = '02'      then cast( '' as boole_d )  -- Incompleto
      when Status = '03'      then cast( '' as boole_d )  -- Completo
      when Status = '04'      then cast( '' as boole_d )  -- Aguardando job Entrada Mercadoria
      when Status = '05'      then cast( '' as boole_d )  -- Nota Rejeitada pela SEFAZ
      when Status = '06'      then cast( '' as boole_d )  -- Erro na composição da Nota
      when Status = '07'      then cast( '' as boole_d )  -- Em trânsito
      when Status = '08'      then cast( '' as boole_d )  -- Completo
      when Status = '09'      then cast( '' as boole_d )  -- Completo
      when Status = '11'      then cast( '' as boole_d )  -- Aguardando Ordem de Frete
                              else cast( 'X' as boole_d )
      end                                               as UsedStockEnable,

      case
      when UseAvailable = 'X' then 2  -- Utilização completa marcado
      when Status = '02'      then 2  -- Incompleto
      when Status = '03'      then 2  -- Completo
      when Status = '04'      then 2  -- Aguardando job Entrada Mercadoria
      when Status = '05'      then 2  -- Nota Rejeitada pela SEFAZ
      when Status = '06'      then 2  -- Erro na composição da Nota
      when Status = '07'      then 2  -- Em trânsito
      when Status = '08'      then 2  -- Em trânsito
      when Status = '09'      then 2  -- Em trânsito
      when Status = '11'      then 2  -- Aguardando Ordem de Frete
      else 3
      end                                               as UsedStockEnableCriticality,

      Carrier,
      Driver,
      Equipment,
      ShippingConditions,
      ShippingType,
      EquipmentTow1,
      EquipmentTow2,
      EquipmentTow3,
      FreightMode,
      MainPlant,
      MainPurchaseOrder,
      MainPurchaseOrderItem,
      MainMaterialDocument,
      MainMaterialDocumentYear,
      MainMaterialDocumentItem,
      @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
      OrderQuantity,
      OrderQuantityUnit,
      PurchaseOrder,
      PurchaseOrderItem,
      Incoterms1,
      Incoterms2,

      OutSalesOrder,
      OutSalesOrderItem,      
      OutDeliveryDocument as OutboundDelivery,
      OutDeliveryDocument,
      OutDeliveryDocumentItem,
      OutMaterialDocument,
      OutMaterialDocumentYear,
      OutMaterialDocumentItem,
      OutBR_NotaFiscal,
      OutBR_NotaFiscalItem,
      RepBR_NotaFiscal,
      InDeliveryDocument,
      InDeliveryDocumentItem,
      InMaterialDocument,
      InMaterialDocumentYear,
      InMaterialDocumentItem,
      InBR_NotaFiscal,
      InBR_NotaFiscalItem,

      @Semantics.user.createdBy: true
      CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      CreatedAt,
      @Semantics.user.lastChangedBy: true
      LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,
      Marmumren,
      MarmUmrez,

      /* Campos navegação */
      MainPurchaseOrder                                 as Pedido,
      PurchaseOrder                                     as Pedido2,
      PurchaseOrder                                     as PurchaseOrder2,
      OutBR_NotaFiscal                                  as NFNum,
      InBR_NotaFiscal                                   as NFNum2,
      /* Campos Abstract  */
      cast( '' as lifnr  )                              as NewCarrier,
      cast( '' as bu_partner )                          as NewDriver,
      cast( '' as equnr )                               as NewEquipment,
      cast( '09' as vsbed )                               as NewShippingConditions,
      cast( '' as vsart )                               as NewShippingType,
      cast( '' as equnr )                               as NewEquipmentTow1,
      cast( '' as equnr )                               as NewEquipmentTow2,
      cast( '' as equnr )                               as NewEquipmentTow3,
      cast( 'CIF' as ze_mm_freight_mode )                  as NewFreightMode,
      cast( 0 as abap.dec(13,3) )                       as NewUsedStock,
      FreightOrder,
      

      /* Compositions */
      _Serie,
      _Mensagem,

      /* Associations */
      _MaterialInfo,
      _Status,
      _Material,
      _MaterialType,
      _OriginPlant,
      _OriginStorageLocation,
      _OriginPlantType,
      _DestinyPlant,
      _DestinyStorageLocation,
      _DestinyPlantType,
      _Carrier,
      _Driver,
      _Equipment,
      _ShippingConditions,
      _ShippingType,
      _EquipmentTow1,
      _EquipmentTow2,
      _EquipmentTow3,
      _FreightMode,
      _EANType


} where AvailableStock > 0 
