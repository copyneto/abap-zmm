@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Reservas Pendentes - P.  Principal'
@Metadata.allowExtensions: true
define root view entity ZC_mm_RESERVAS_PENDENTES_APP
  as projection on ZI_MM_RESERVAS_PENDENTES_APP
{
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_RESERVATION', element: 'Reservation' } } ]
      @EndUserText.label: 'Reserva Pendente'
  key Reservation,
      @EndUserText.label: 'ID Parâmetro'
  key PrmDepFec,
      @EndUserText.label: 'Tipo Estoque'
      @ObjectModel.text.element: ['EANTypeText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_TIPO_EAN', element: 'EANType' } } ]
  key EANType,
      @EndUserText.label: 'Dados do Historico'
      @Consumption.valueHelpDefinition: [{distinctValues: true}]
  key DadosDoHistorico,

      EANTypeText,

      @EndUserText.label: 'Criado Por'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_USER', element: 'Bname' } } ]
      CreatedBy,
      @EndUserText.label: 'Material'
      @ObjectModel.text.element: ['MaterialText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_MATERIAL', element: 'Material' } } ]
      Material,
      MaterialText,
      @EndUserText.label: 'UMD - Origem'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_UM', element: 'Unit' } } ]
      BaseUnit,
      @EndUserText.label: 'UMD - Destino'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_UM', element: 'Unit' } } ]
      Unit,
      @EndUserText.label: 'Centro Origem'
      @ObjectModel.text.element: ['PlantName']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } } ]
      Plant,
      PlantName,
      @EndUserText.label: 'Depósito Origem'
      @ObjectModel.text.element: ['DepositoText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_LGORT', element: 'StorageLocation' },
                                           additionalBinding: [{  element: 'Plant', localElement: 'Plant' } ] } ]
      StorageLocation,
      DepositoText,
      
      @EndUserText.label: 'Lote'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_CHARG', element: 'Batch' },
                                         additionalBinding: [{  element: 'Material', localElement: 'Material' } ] } ]
      Batch,

      @EndUserText.label: 'Centro Destino'
      @ObjectModel.text.element: ['DestinyPlantName']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } } ]
      DestinyPlant,
      DestinyPlantName,
      
      @EndUserText.label: 'Depósito Destino'
      @ObjectModel.text.element: ['DestinyStorageLocationName']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_LGORT', element: 'StorageLocation' },
                                           additionalBinding: [{  element: 'Plant', localElement: 'DestinyPlant' } ] } ]
      DestinyStorageLocation,
      DestinyStorageLocationName,
      @EndUserText.label: 'Criado Em'
      CreationDateTime,
      @EndUserText.label: 'Utilizar quantidade'
      UseAvailable,
      @EndUserText.label: 'Deseja utilizar quantidade disponível?'
      UseAvailableCheckBox,
      @EndUserText.label: 'Utilizar quantidade (Liga/Desliga)'
      UseAvailableCheckBoxEnable,
      
      @EndUserText.label: 'Estoque Qtd.Transf.'
      UtilizacaoLivre,
      
      @EndUserText.label: 'Utilização livre'
      AvailableStock_Conve,
      @EndUserText.label: 'Utilização livre'
      AvailableStock,
      @EndUserText.label: 'Qtd.Transferida'
      UsedStock_conve,
      @EndUserText.label: 'Qtd.Transferida'
      UsedStock,
      @EndUserText.label: 'Qtd.Transferida (habilitar)'
      UsedStockEnable,

      @EndUserText.label: 'Diferença'
      Diferenca,

      //Aux
      @ObjectModel.text.element: ['StatusHistoricoText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_STATUS', element: 'Status' } } ]
      StatusHistorico,
      _StatusHistorico.StatusText as StatusHistoricoText,
      StatusHistoricoCriticality,

      //Campos do Pop UP
      @EndUserText.label  : 'Transportador'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_TRANSPORTADOR', element: 'Transportador' } } ]
      Transportador,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_MOTORISTA', element: 'Parceiro' } } ]
      @EndUserText.label  : 'Código Motorista'
      Driver,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_VEICULO', element: 'Equipment' } } ]
      @EndUserText.label  : 'Placa do veículo '
      Equipment,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VSBED', element: 'CondicaoExpedicao' } } ]
      @EndUserText.label  : 'Condição expedição '
      Shipping_conditions,
      @EndUserText.label  : 'Tipo de expedição'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VSART', element: 'TipoExpedicao' } } ]
      Shipping_type,
      @EndUserText.label  : 'Placa Semirreboque 1'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_VEICULO', element: 'Equipment' } } ]
      Equipment_tow1,
      @EndUserText.label  : 'Placa Semirreboque 2'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_VEICULO', element: 'Equipment' } } ]
      Equipment_tow2,
      @EndUserText.label  : 'Placa Semirreboque 3'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_VEICULO', element: 'Equipment' } } ]
      Equipment_tow3,
      @EndUserText.label  : 'Modalidade Frete'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_MODALIDADE_FRETE', element: 'FreightMode' } } ]
      Freight_mode,
      @EndUserText.label: 'Qtd.Transferida'
      NewUsedStock
}
