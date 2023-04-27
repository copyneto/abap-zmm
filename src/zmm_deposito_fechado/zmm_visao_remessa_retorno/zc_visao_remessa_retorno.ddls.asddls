@EndUserText.label: 'Visão Remessa e Retorno'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_VISAO_REMESSA_RETORNO
  as projection on ZI_VISAO_REMESSA_RETORNO
{
      @EndUserText.label: 'Centro Origem'
      @ObjectModel.text.element: ['NomeCentroOrigem']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_CENTRO_ORIGEM_DEP_FEC', element: 'Plant'}}]
  key OriginPlant,
      @EndUserText.label: 'Centro Destino'
      @ObjectModel.text.element: ['NomeCentroDestino']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_CENTRO_DEST_DF_VIS', element: 'Plant'}}]
  key DestinyPlant,
      @EndUserText.label: 'Docnum saída remessa'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DOCNUM', element: 'BR_NotaFiscal'}}]
  key OutBrNotaFiscal      as OutBR_NotaFiscal,
      @EndUserText.label: 'Nº Pedido'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_PurchaseOrder', element: 'PurchaseOrder'}}]
  key PurchaseOrder,

      @EndUserText.label: 'Spool NFe'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_REP_NOTA_FISCAL', element: 'RepBrNotaFiscal'}}]
      RepBrNotaFiscal      as NFNum3,
      //  key PurchaseOrder as Pedido,
      @EndUserText.label: 'Data Doc. Entrada'
      E_data_doc,
      @EndUserText.label: 'Data Doc. Saída'
      S_data_doc,
      @EndUserText.label: 'Depósito Origem'
      @ObjectModel.text.element: ['NomeDepositoOrigem']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DEPOSITO', element: 'Lgort'}}]
      S_deposito_origem,
      @EndUserText.label:'Depósito Destino'
      @ObjectModel.text.element: ['NomeDepositoDestino']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DEPOSITO', element: 'Lgort'}}]
      S_deposito_destino,
//      @EndUserText.label:'Doc. Material'
//      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_MATERIAL_DOCUMENT_KEY', element: 'MaterialDocumentKey' } } ]
//      S_doc_material,
      @EndUserText.label:'Usuário Saída'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_V_USR_NAME', element: 'Bname'}}]
      SaidaCriadoPor,
      @EndUserText.label:'Usuário Entrada'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_V_USR_NAME', element: 'Bname'}}]
      EntCriadoPor,
      @EndUserText.label: 'Num. Fornecimento de Transf. Remessa'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_VBELN_VL', element: 'OutboundDelivery' } } ]
      OutDeliveryDocnum    as OutboundDelivery,
//      @EndUserText.label: 'Doc. Movimento saída'
//      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_MATERIAL_DOCUMENT_KEY', element: 'MaterialDocumentKey' } } ]
//      DocMovimentoSaida,

      @EndUserText.label: 'Doc. Movimento saída'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_MATERIAL_DOCUMENT_KEY', element: 'MaterialDocument' } } ]
      OutMaterialDocument,
      @EndUserText.label: 'Ano Movimento saída'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_MATERIAL_DOCUMENT_KEY', element: 'MaterialDocumentYear' } } ]
      OutMaterialDocumentYear,
      
      
//      @EndUserText.label: 'Data Doc. de Saída'
//      DataDocumentoSaida,
      @EndUserText.label: 'Nº Nota Fiscal remessa'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_NFENUM', element: 'nfenum'}}]
      NumNotaFiscalRemessa,
      @EndUserText.label: 'Código status'
      @ObjectModel.text.element: ['CodigoStatusTexto']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_STATUS_CODE', element: 'StatusCode'}}]
      CodigoStatus,
      CodigoStatusTexto,
      @EndUserText.label: 'Status Sefaz'
      @ObjectModel.text.element: ['StatusSefazDesc']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_STATUSSEFAZTEXT', element: 'StatusNF' }}]
      StatusSefaz,
      @EndUserText.label: 'Nº Transporte'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_ORDEM_FRETE', element: 'TransportationOrder'}}]
      TorId,
      @EndUserText.label: 'Docnum entrada'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DOCNUM', element: 'BR_NotaFiscal'}}]
      DocnumEntrada as NFNum2,
      @EndUserText.label: 'Mov. Mercadoria entrada'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_MATERIAL_DOCUMENT_KEY', element: 'MaterialDocumentKey' } } ]
      MovMercaEntra,

      @EndUserText.label: 'Mov. Mercadoria entrada'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_MATERIAL_DOCUMENT_KEY', element: 'MaterialDocument' } } ]
      InMaterialDocument,
      @EndUserText.label: 'Ano Mov. Mercadoria entrada'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_MATERIAL_DOCUMENT_KEY', element: 'MaterialDocumentYear' } } ]
      InMaterialDocumentYear,
      @EndUserText.label: 'Data do Pedido'
      DataPedido,
     
      
      @UI.hidden: true
      NomeCentroOrigem,
      @UI.hidden: true
      NomeCentroDestino,
      @UI.hidden: true
      _NomeStatusSefaz.TextoStatusNF as StatusSefazDesc,
      @UI.hidden: true
      CriticalStatus,
      @UI.hidden: true
      NomeDepositoOrigem,
      @UI.hidden: true
      NomeDepositoDestino
}
