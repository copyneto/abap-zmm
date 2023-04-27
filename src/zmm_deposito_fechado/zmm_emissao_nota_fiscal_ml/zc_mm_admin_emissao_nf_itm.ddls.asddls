@EndUserText.label: 'Emissão de NF (Item)'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: ['Material', 'OriginPlant', 'OriginStorageLocation' ]

define view entity ZC_MM_ADMIN_EMISSAO_NF_ITM
  as projection on ZI_MM_ADMIN_EMISSAO_NF_ITM
{
      @EndUserText.label: 'Status'
      @ObjectModel.text.element: ['StatusText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_STATUS', element: 'Status' } } ]
  key Status,
      @EndUserText.label: 'Material'
      @ObjectModel.text.element: ['MaterialText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_MATERIAL', element: 'Material' } } ]
  key Material,
      @EndUserText.label: 'Centro Origem' 
      @ObjectModel.text.element: ['OriginPlantText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } } ]
  key OriginPlant,
      @EndUserText.label: 'Depósito Origem'
      @ObjectModel.text.element: ['OriginStorageLocationText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_LGORT', element: 'StorageLocation' },
                                           additionalBinding: [{  element: 'Plant', localElement: 'OriginPlant' } ] } ]
  key OriginStorageLocation,
      @EndUserText.label: 'Lote'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_CHARG', element: 'Batch' },
                                           additionalBinding: [{  element: 'Material', localElement: 'Material' } ] } ]
  key Batch,
      @EndUserText.label: 'Unidade Original'
  key OriginUnit,
      @EndUserText.label: 'Unidade'
  key Unit,
      @EndUserText.label: 'ID'
  key Guid,
      @EndUserText.label: 'Etapa'
  key ProcessStep,
      @EndUserText.label: 'Configuração'
  key PrmDepFecId,
      @EndUserText.label: 'Tipo Estoque'
      @ObjectModel.text.element: ['EANTypeText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_TIPO_EAN', element: 'EANType' } } ]
  key EANType,

      _Status.StatusText                          as StatusText,
      StatusCriticality,

      @EndUserText.label: 'Tipo de Material'
      @ObjectModel.text.element: ['MaterialTypeText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_MTART', element: 'MaterialType' } } ]
      MaterialType,
      _MaterialType.MaterialTypeName              as MaterialTypeText,

      _OriginPlant.WerksCodeName                  as OriginPlantText,
      _OriginStorageLocation.StorageLocationText  as OriginStorageLocationText,
      _Material.Text                              as MaterialText,

      @EndUserText.label: 'Descrição'
      Description,
      @EndUserText.label: 'Tipo de Centro Origem'
      @ObjectModel.text.element: ['OriginPlantTypeText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_DF_TIPO_CENTRO', element: 'PlantType' } } ]
      OriginPlantType,
      _OriginPlantType.PlantTypeText              as OriginPlantTypeText,
      @EndUserText.label: 'Centro Destino'
      @ObjectModel.text.element: ['DestinyPlantText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } } ]
      DestinyPlant,
      _DestinyPlant.WerksCodeName                 as DestinyPlantText,
      @EndUserText.label: 'Tipo de Centro Destino'
      @ObjectModel.text.element: ['DestinyPlantTypeText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_DF_TIPO_CENTRO', element: 'PlantType' } } ]
      DestinyPlantType,
      _DestinyPlantType.PlantTypeText             as DestinyPlantTypeText,
      @EndUserText.label: 'Depósito Destino'
      @ObjectModel.text.element: ['DestinyStorageLocationText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_LGORT', element: 'StorageLocation' },
                                           additionalBinding: [{  element: 'Plant', localElement: 'DestinyPlant' } ] } ]
      DestinyStorageLocation,
      _DestinyStorageLocation.StorageLocationText as DestinyStorageLocationText,
      @EndUserText.label: 'Transportador'
      @ObjectModel.text.element: ['CarrierText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_TRANSPORTADOR', element: 'Carrier' } } ]
      Carrier,
      _Carrier.CarrierText                        as CarrierText,
      @EndUserText.label: 'Motorista'
      @ObjectModel.text.element: ['DriverText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_MOTORISTA', element: 'Parceiro' } } ]
      Driver,
      _Driver.Nome                                as DriverText,
      @EndUserText.label: 'Veículo'
      @ObjectModel.text.element: ['EquipmentText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_VEICULO', element: 'Equipment' } } ]
      Equipment,
      _Equipment.EquipmentText                    as EquipmentText,
      @EndUserText.label: 'Condição Expedição'
      @ObjectModel.text.element: ['ShippingConditionsText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VSBED', element: 'CondicaoExpedicao' } } ]
      ShippingConditions,
      _ShippingConditions.CondicaoExpedicaoText   as ShippingConditionsText,
      @EndUserText.label: 'Tipo de Expedição'
      @ObjectModel.text.element: ['ShippingTypeText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VSART', element: 'TipoExpedicao' } } ]
      ShippingType,
      _ShippingType.TipoExpedicaoText             as ShippingTypeText,
      @EndUserText.label: 'Semi-reboque 1'
      @ObjectModel.text.element: ['EquipmentTow1Text']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_VEICULO', element: 'Equipment' } } ]
      EquipmentTow1,
      _EquipmentTow1.EquipmentText                as EquipmentTow1Text,
      @EndUserText.label: 'Semi-reboque 2'
      @ObjectModel.text.element: ['EquipmentTow2Text']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_VEICULO', element: 'Equipment' } } ]
      EquipmentTow2,
      _EquipmentTow2.EquipmentText                as EquipmentTow2Text,
      @EndUserText.label: 'Semi-reboque 3'
      @ObjectModel.text.element: ['EquipmentTow3Text']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_VEICULO', element: 'Equipment' } } ]
      EquipmentTow3,
      _EquipmentTow3.EquipmentText                as EquipmentTow3Text,
      @EndUserText.label: 'Modalidade frete'
      @ObjectModel.text.element: ['FreightModeText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_MODALIDADE_FRETE', element: 'FreightMode' } } ]
      FreightMode,
      _FreightMode.FreightModeText                as FreightModeText,
      _EANType.EANTypeText                        as EANTypeText,

      @EndUserText.label: 'Utilizar quantidade'
      UseAvailable,
      UseAvailableCriticality,
      @EndUserText.label: 'Deseja utilizar quantidade disponível?'
      UseAvailableCheckBox,
      @EndUserText.label: 'Utilizar quantidade (Liga/Desliga)'
      UseAvailableCheckBoxEnable,
      @EndUserText.label: 'Utilização livre'
      AvailableStock_Conve,
      @EndUserText.label: 'Qtd.Transferida'
      UsedStock_conve,
      UsedStockCriticality,

      @EndUserText.label: 'Centro Principal'
      MainPlant,
      @EndUserText.label: 'Pedido Compra Principal'
      MainPurchaseOrder,
      @EndUserText.label: 'Item Pedido Compra Principal'
      MainPurchaseOrderItem,
      @EndUserText.label: 'Doc. Material Principal'
      MainMaterialDocument,
      @EndUserText.label: 'Ano Doc. Material Principal'
      MainMaterialDocumentYear,
      @EndUserText.label: 'Item Doc. Material Principal'
      MainMaterialDocumentItem,
      @EndUserText.label: 'Quantidade'
      OrderQuantity,
      @EndUserText.label: 'Unidade'
      OrderQuantityUnit,
      @EndUserText.label: 'Pedido de compra'
      PurchaseOrder,
      @EndUserText.label: 'Item Pedido de compra'
      PurchaseOrderItem,
      @EndUserText.label: 'Incoterms 1'
      Incoterms1,
      @EndUserText.label: 'Incoterms 2'
      Incoterms2,
      @EndUserText.label: 'Ordem de Venda Saída'
      OutSalesOrder,
      @EndUserText.label: 'Item Ordem de Venda Saída'
      OutSalesOrderItem,
      @EndUserText.label: 'Remessa Saída'
      OutDeliveryDocument,
      @EndUserText.label: 'Item Remessa Saída'
      OutDeliveryDocumentItem,
      @EndUserText.label: 'Doc. Material Saída'
      OutMaterialDocument,
      @EndUserText.label: 'Ano Doc. Material Saída'
      OutMaterialDocumentYear,
      @EndUserText.label: 'Item Doc. Material Saída'
      OutMaterialDocumentItem,
      @EndUserText.label: 'Nota Fiscal Saída'
      OutBR_NotaFiscal,
      @EndUserText.label: 'Item Nota Fiscal Saída'
      OutBR_NotaFiscalItem,
      @EndUserText.label: 'Nota Fiscal Replicação'
      RepBR_NotaFiscal,
      @EndUserText.label: 'Remessa Entrada'
      InDeliveryDocument,
      @EndUserText.label: 'Item Remessa Entrada'
      InDeliveryDocumentItem,
      @EndUserText.label: 'Doc. Material Entrada'
      InMaterialDocument,
      @EndUserText.label: 'Ano Doc. Material Entrada'
      InMaterialDocumentYear,
      @EndUserText.label: 'Item Doc. Material Entrada'
      InMaterialDocumentItem,
      @EndUserText.label: 'Nota Fiscal Entrada'
      InBR_NotaFiscal,
      @EndUserText.label: 'Item Nota Fiscal Entrada'
      InBR_NotaFiscalItem,

      @EndUserText.label: 'Utilização livre'
      AvailableStock,
      @EndUserText.label: 'Qtd.Transferida'
      UsedStock,

      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      /* Campos navegação */

      @EndUserText.label: 'Pedido Compra Principal (navegação)'
      Pedido,
      @EndUserText.label: 'Pedido de compra (navegação)'
      Pedido2,
      @EndUserText.label: 'Nota Fiscal Saída (navegação)'
      NFNum,
      @EndUserText.label: 'Nota Fiscal Entrada (navegação)'
      NFNum2,

      /* Associations */
      _Header : redirected to parent ZC_MM_ADMIN_EMISSAO_NF_CAB
}
