@EndUserText.label: 'Administrar Retorno De Armazenagem'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_PENDENTE_ORDEM_FRETE_APP
  as projection on ZI_MM_PENDENTE_ORDEM_FRETE_APP
{
      @EndUserText.label: 'Numero de Ordem de Frete'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_ORDEM_FRETE', element: 'NumeroOrdemDeFrete' } } ]
  key NumeroOrdemDeFrete,
      @EndUserText.label: 'Numero da Remessa'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_ORDEM_FRETE', element: 'NumeroDaRemessa' } } ]
  key NumeroDaRemessa,
      @EndUserText.label: 'Material'
      @ObjectModel.text.element: ['MaterialText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_MATERIAL', element: 'Material' } } ]
  key Material,
      @EndUserText.label: 'UMD - Origem'
  key UmbOrigin,
      @EndUserText.label: 'UMD - Destino'
  key UmbDestino,
      @EndUserText.label: 'Centro de Remessa'
      @ObjectModel.text.element: ['CentroText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } } ]
  key CentroRemessa,
      @EndUserText.label: 'Deposito'
      @ObjectModel.text.element: ['DepositoText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_LGORT', element: 'StorageLocation' },
                                           additionalBinding: [{  element: 'Plant', localElement: 'CentroRemessa' } ] } ]
  key Deposito,
      @EndUserText.label: 'Lote'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_CHARG', element: 'Batch' },
                                         additionalBinding: [{  element: 'Material', localElement: 'Material' } ] } ]
  key Lote,
      @EndUserText.label: 'Centro Destino'
      @ObjectModel.text.element: ['CentroDestinoText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } } ]
  key CentroDestino,
      @EndUserText.label: 'Deposito Destino'
      @ObjectModel.text.element: ['DepositoDestinoText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_LGORT', element: 'StorageLocation' },
                                           additionalBinding: [{  element: 'Plant', localElement: 'CentroRemessa' } ] } ]
  key DepositoDestino,

      @EndUserText.label: 'Dados do Histórico'
      @Consumption.valueHelpDefinition: [{distinctValues: true}]
  key DadosDoHistorico,
      @EndUserText.label: 'Configuração'
  key PrmDepFecId,
      @EndUserText.label: 'Tipo Estoque'
      @ObjectModel.text.element: ['EANTypeText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_TIPO_EAN', element: 'EANType' } } ]
  key EANType,
      EANTypeText,
      @EndUserText.label: 'Cliente'
      @ObjectModel.text.element: ['SoldToPartyName']
      SoldToParty,
      @EndUserText.label: 'Nome do Cliente'
      SoldToPartyName,
      @EndUserText.label: 'Nome do Material'
      MaterialText,
      @EndUserText.label: 'Centro Origem'
      CentroText,
      @EndUserText.label: 'Nome do Deposito'
      DepositoText,
      CentroDestinoText,
      DepositoDestinoText,
      @EndUserText.label: 'Status'
      Status,
      @EndUserText.label: 'Estoque em Remessa com OF'
      EstoqueRemessaOF,
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
      @EndUserText.label: 'Utilizar quantidade'
      UseAvailable,
      @EndUserText.label: 'Deseja utilizar quantidade disponível?'
      UseAvailableCheckBox,
      @EndUserText.label: 'Utilizar quantidade (Liga/Desliga)'
      UseAvailableCheckBoxEnable,

      @EndUserText.label: 'Status'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_STATUS', element: 'Status' } } ]
      @ObjectModel.text.element: ['StatusHistoricoText']
      StatusHistorico,
      _StatusHistorico.StatusText as StatusHistoricoText,
      StatusHistoricoCriticality,

      @EndUserText.label: 'Diferença'
      Diferenca,

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
