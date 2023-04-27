@EndUserText.label: 'Retorno de Armazenagem - Projection'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_RET_ARMAZENAGEM_APP
  as projection on ZI_MM_RET_ARMAZENAGEM_APP

{
  key Guid,
      @EndUserText.label: 'Numero de Ordem de Frete'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_ORDEM_FRETE', element: 'TransportationOrder' } } ]
  key NumeroOrdemDeFrete,

      @EndUserText.label: 'Numero da Remessa'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_OUTBOUND_DELIVERY', element: 'DeliveryDocument' } } ]
  key NumeroDaRemessa,

      @EndUserText.label: 'Material'
      @ObjectModel.text.element: ['MaterialText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_MATERIAL', element: 'Material' } } ]
  key Material,

      @EndUserText.label: 'UMD - Origem'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_UM', element: 'Unit' } } ]
  key UmbOrigin,

      @EndUserText.label: 'UMD - Destino'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_UM', element: 'Unit' } } ]
  key UmbDestino,

      @EndUserText.label: 'Centro de Origem'
      @ObjectModel.text.element: ['CentroOrigemText']
      //@Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } } ]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DEP_FECH_PLAN_ORI', element: 'WerksCode' } } ]
  key CentroOrigem,

      @EndUserText.label: 'Depósito Origem'
      @ObjectModel.text.element: ['DepositoOrigemText']
      //      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_LGORT', element: 'StorageLocation' },
      //                                           additionalBinding: [{  element: 'Plant', localElement: 'CentroOrigem' } ] } ]

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DEP_FEC_DEP_ORIGEM', element: 'StorageLocation' },
                                           additionalBinding: [{  element: 'Plant', localElement: 'CentroOrigem' } ] } ]
  key DepositoOrigem,

      @EndUserText.label: 'Centro de Destino'
      @ObjectModel.text.element: ['CentroDestinoText']
      //@Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } } ]

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DEP_FECH_PLAN_DES', element: 'WerksCode' },
                                       additionalBinding: [{  element: 'OrigWerks', localElement: 'CentroOrigem' },
                                                           {  element: 'OrigSto', localElement: 'DepositoOrigem' } ] } ]
  key CentroDestino,

      @EndUserText.label: 'Depósito Destino'
      @ObjectModel.text.element: ['DepositoDestinoText']
      //      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_LGORT', element: 'StorageLocation' },
      //                                           additionalBinding: [{  element: 'Plant', localElement: 'CentroDestino' } ] } ]

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DEP_FEC_DEP_DEST', element: 'DestStora' },
                                           additionalBinding: [{  element: 'OrigPlan', localElement: 'CentroOrigem' },
                                                               {  element: 'OrigStora', localElement: 'DepositoOrigem' },
                                                               {  element: 'DestPlant', localElement: 'CentroDestino' } ] } ]

  key DepositoDestino,

      @EndUserText.label: 'Lote'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_CHARG', element: 'Batch' },
                                         additionalBinding: [{  element: 'Material', localElement: 'Material' } ] } ]
  key Lote,

      @EndUserText.label: 'Tipo Estoque'
      @ObjectModel.text.element: ['EANTypeText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_TIPO_EAN', element: 'EANType' } } ]
  key EANType,

      @EndUserText.label: 'Dados do Historico'
      @Consumption.valueHelpDefinition: [{distinctValues: true}]
  key DadosDoHistorico,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_EBELN', element: 'Ebeln' } } ]
      PurchaseOrder,
      @EndUserText.label: 'Qtd.Ord.Venda'
      QtdOrdVenda,
      @EndUserText.label: 'Status NF'
      @ObjectModel.text.element: ['StatusNFText']
      //      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_CONFIRM_STATUS', element: 'confirmation' } } ]
      StatusNF,
      _NFActiveStatusText.Text                         as StatusNFText,
      //Status,
      //StatusText,
      StatusNFCriticality,
      //      @EndUserText.label: 'Estoque em Remessa com OF'
      //      EstoqueRemessaOF,
      @EndUserText.label: 'Estoque Livre Utilização'
      UtilizacaoLivre,
      @EndUserText.label: 'Utilizar quantidade'
      UseAvailable,
      @EndUserText.label: 'Deseja utilizar quantidade disponível?'
      UseAvailableCheckBox,
      @EndUserText.label: 'Utilizar quantidade (Liga/Desliga)'
      UseAvailableCheckBoxEnable,
      @EndUserText.label: 'Status Processo'
      @ObjectModel.text.element: ['StatusHistoricoText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_STATUS', element: 'Status' } } ]
      cast( StatusHistorico as num02 preserving type ) as StatusHistorico,
      _StatusHistorico.StatusText                      as StatusHistoricoText,
      StatusHistoricoCriticality,

      @EndUserText.label: 'Estoque em Reserva'
      EstoqueEmReserva,
      @EndUserText.label: 'Estoque Bloqueado (devoluções)'
      EstoqueBloqueado,
      @EndUserText.label: 'Estoque Livre Utilização'
      EstoqueLivreUtilizacao,

      @EndUserText.label: 'Qtd.Transf.'
      QtdTransportada,
      QtdTransportadaCriticality,

      _EANType.EANTypeText                             as EANTypeText,

      @EndUserText.label: 'Diferença'
      Diferenca,

      @EndUserText.label: 'Nome do Material'
      MaterialText,
      @EndUserText.label: 'Nome do Deposito Origem'
      DepositoOrigemText,
      @EndUserText.label: 'Nome do Centro Origem'
      CentroOrigemText,
      @EndUserText.label: 'Nome do Centro Destino'
      CentroDestinoText,
      @EndUserText.label: 'Nome do Deposito Destino'
      DepositoDestinoText,

      PrmDepFecId,
      Description,
      OriginPlantType,
      DestinyPlantType,

      //Campos do Pop UP
      @EndUserText.label: 'Transportador'
      @ObjectModel.text.element: ['CarrierText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_TRANSPORTADOR', element: 'Carrier' } } ]
      Transportador,
      _Carrier.CarrierText                             as CarrierText,
      @EndUserText.label: 'Motorista'
      @ObjectModel.text.element: ['DriverText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_MOTORISTA', element: 'Parceiro' } } ]
      Driver,
      _Driver.Nome                                     as DriverText,
      @EndUserText.label: 'Veículo'
      @ObjectModel.text.element: ['EquipmentText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_VEICULO', element: 'Equipment' } } ]
      Equipment,
      _Equipment.EquipmentText                         as EquipmentText,
      @EndUserText.label: 'Condição Expedição'
      @ObjectModel.text.element: ['ShippingConditionsText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VSBED', element: 'CondicaoExpedicao' } } ]
      Shipping_conditions,
      _ShippingConditions.CondicaoExpedicaoText        as ShippingConditionsText,
      @EndUserText.label: 'Tipo de Expedição'
      //      @ObjectModel.text.element: ['ShippingTypeText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VSART', element: 'TipoExpedicao' } } ]
      Shipping_type,

      @EndUserText.label: 'Semi-reboque 1'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_VEICULO', element: 'Equipment' } } ]
      Equipment_tow1,
      @EndUserText.label: 'Semi-reboque 2'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_VEICULO', element: 'Equipment' } } ]
      Equipment_tow2,
      @EndUserText.label: 'Semi-reboque 3'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_VEICULO', element: 'Equipment' } } ]
      Equipment_tow3,

      //      _ShippingType.TipoExpedicaoText           as ShippingTypeText,
      //      @EndUserText.label: 'Semi-reboque 1'
      //      @ObjectModel.text.element: ['EquipmentTow1Text']
      //      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_VEICULO', element: 'Equipment' } } ]
      //      Equipment_tow1,
      //      _EquipmentTow1.EquipmentText              as EquipmentTow1Text,
      //      @EndUserText.label: 'Semi-reboque 2'
      //      @ObjectModel.text.element: ['EquipmentTow2Text']
      //      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_VEICULO', element: 'Equipment' } } ]
      //      Equipment_tow2,
      //      _EquipmentTow2.EquipmentText              as EquipmentTow2Text,
      //      @EndUserText.label: 'Semi-reboque 3'
      //      @ObjectModel.text.element: ['EquipmentTow3Text']
      //      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_VEICULO', element: 'Equipment' } } ]
      //      Equipment_tow3,
      //      _EquipmentTow3.EquipmentText              as EquipmentTow3Text,
      //      @EndUserText.label: 'Modalidade frete'
      //      @ObjectModel.text.element: ['FreightModeText']
      //      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_MODALIDADE_FRETE', element: 'FreightMode' } } ]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_MODALIDADE_FRETE', element: 'FreightMode' } } ]
      Freight_mode,
      _FreightMode.FreightModeText                     as FreightModeText,
      @EndUserText.label: 'Qtd.Transferida'
      NewUsedStock,

      // Campos para navegação

      @EndUserText.label: 'Numero de Ordem de Frete'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_ORDEM_FRETE', element: 'TransportationOrder' } } ]
      FreightOrder,
      @EndUserText.label: 'Numero da Remessa'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_OUTBOUND_DELIVERY', element: 'DeliveryDocument' } } ]
      OutboundDelivery,

      @EndUserText.label: 'Qtd.Transferida (habilitar)'
      EstoqueLivreUtilEnable,
      EstoqueLivreUEnableCriticality,

      MaterialType,
      SalesDistrict,
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


      /* Associations */
      _Mard,
      //_StatusHistorico,
      _Material,
      _OriginPlant,
      _OriginStorageLocation,
      _EANType,
      _Carrier,
      _Driver,
      _Equipment,
      _ShippingConditions,
      _ShippingType,
      //      _EquipmentTow1,
      //      _EquipmentTow2,
      //      _EquipmentTow3,
      _FreightMode,
      _Serie    : redirected to composition child ZC_MM_RET_ARMAZENAGEM_SERIE,
      _Mensagem : redirected to composition child zc_mm_ret_armazenagem_msg

}
