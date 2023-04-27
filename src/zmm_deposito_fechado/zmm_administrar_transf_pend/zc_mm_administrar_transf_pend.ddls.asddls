@EndUserText.label: 'Administrar Transf. Pendentes'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_ADMINISTRAR_TRANSF_PEND
  as projection on ZI_MM_ADMINISTRAR_TRANSF_PEND
{
//      @EndUserText.label: 'Material'
//      @ObjectModel.text.element: ['MaterialName']
//      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_MaterialStdVH', element: 'Material' } } ]
    @Consumption.hidden: true
 key Material,

      //      @EndUserText.label: 'Centro Origem'
      @EndUserText.label: 'Centro Entrada material'
      @ObjectModel.text.element: ['OriginPlantName']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_CENTRO_ORIGEM_DEP_FEC', element: 'Plant' } } ]
  key OriginPlant,

      @EndUserText.label: 'Depósito Origem'
      @ObjectModel.text.element: ['OriginStorageLocationName']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DEPOSITO', element: 'Lgort'}}]
  key OriginStorageLocation,

      //      @EndUserText.label: 'Centro Destino'
      @EndUserText.label: 'Centro Depósito Fechado'
      @ObjectModel.text.element: ['DestinyPlantName']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_CENTRO_DEST_DEP_FEC', element: 'Plant' } } ]
  key DestinyPlant,

      @EndUserText.label: 'Depósito Destino'
      @ObjectModel.text.element: ['DestinyStorageLocationName']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DEPOSITO', element: 'Lgort'}}]
  key DestinyStorageLocation,

      @EndUserText.label: 'Ordem de Frete'
  key FreightOrder,

      @EndUserText.label: 'Remessa'
  key OutboundDelivery,

      @EndUserText.label: 'Etapa'
      @ObjectModel.text.element: ['ProcessStepName']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_PROCESS_STEP', element: 'ProcessStep'}}]
  key ProcessStep,

      @EndUserText.label: 'Guid'
  key Guid,

      @EndUserText.label: 'Status'
      @ObjectModel.text.element: ['StatusText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_STATUS', element: 'Status' } } ]
      Status,
      StatusText,
      StatusCriticality,

//      @EndUserText.label: 'Material'
//      MaterialName,

      @EndUserText.label: 'Centro Origem'
      OriginPlantName,

      @EndUserText.label: 'Depósito Origem'
      OriginStorageLocationName,

      @EndUserText.label: 'Centro Destino'
      DestinyPlantName,

      @EndUserText.label: 'Depósito Destino'
      DestinyStorageLocationName,

      @EndUserText.label: 'Etapa'
      ProcessStepName,

      @EndUserText.label: 'Entrada Transf.'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_MATERIAL_DOCUMENT_KEY', element: 'MaterialDocumentKey' } } ]
      EntradaTransf,

      @EndUserText.label: 'Nº de pedido'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_PEDIDO', element: 'PurchaseOrder' } } ]
      //      NumPedido             as Pedido,
      NumPedido             as PurchaseOrder,

      @EndUserText.label: 'Criado Por'
      @ObjectModel.text.element: ['CriadoPorNome']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_USER', element: 'Bname' } } ]
      CriadoPor,
      CriadoPorNome,

      @EndUserText.label: 'Esc.Ent. DF '
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DOCNUM',element: 'BR_NotaFiscal' } } ]
      EscEntDF              as BR_NotaFiscal,

      @EndUserText.label: 'Doc. remessa DF '
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DOCNUM',element: 'BR_NotaFiscal' } } ]
      DocRemessaDF          as OutBR_NotaFiscal,
      //      DocRemessaDF          as NFNum,

      @EndUserText.label: 'Num. pedido de saída (remessa)'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_PEDIDO', element: 'PurchaseOrder' } } ]
//      NumPedidoSaidaRemessa as Pedido2,
      NumPedidoSaidaRemessa as PurchaseOrder2,

      @EndUserText.label: 'Num. movimento saída da remessa'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_MATERIAL_DOCUMENT_KEY', element: 'MaterialDocumentKey' } } ]
      NumMovSaidaRemessa,
      @EndUserText.label: 'Num. movimento saída da remessa'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_MATERIAL_DOCUMENT_KEY', element: 'MaterialDocument' } } ]
      OutMaterialDocument,
      @EndUserText.label: 'Ano movimento saída da remessa'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_MATERIAL_DOCUMENT_KEY', element: 'MaterialDocumentYear' } } ]
      OutMaterialDocumentYear,

      @EndUserText.label: 'Status Sefaz (remessa)'
      @ObjectModel.text.element: ['NomeStatusDocRemessaDF']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_STATUS_NF_DEP_FECH', element: 'StatusNF' } } ]
      StatusSefaz_DocRemessaDF,
      NomeStatusDocRemessaDF,
      StatusDocRemessaDFCritic,

      @EndUserText.label: 'Doc de entrada da remessa'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DOCNUM', element: 'BR_NotaFiscal' } } ]
      DocEntradaRemessa     as NFNum2,

      @EndUserText.label: 'Status Sefaz (Doc.entrada remessa)'
      @ObjectModel.text.element: ['NomeStatusDocEntradaRemessa']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_STATUS_NF_DEP_FECH', element: 'StatusNF' } } ]
      StatusSefaz_DocEntradaRemessa,
      NomeStatusDocEntradaRemessa,
      StatusDocEntradaRemessaCritic,

      @EndUserText.label: 'Doc Material Entrada da remessa'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_MATERIAL_DOCUMENT_KEY', element: 'MaterialDocumentKey' } } ]
      DocMaterialEntradaRemessa,

      @EndUserText.label: 'Doc Material Entrada da remessa'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_MATERIAL_DOCUMENT_KEY', element: 'MaterialDocument' } } ]
      InMaterialDocument,
      @EndUserText.label: 'Ano Material Entrada da remessa'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_MATERIAL_DOCUMENT_KEY', element: 'MaterialDocumentYear' } } ]
      InMaterialDocumentYear,

      @EndUserText.label: 'Processado'
      Processado
}
