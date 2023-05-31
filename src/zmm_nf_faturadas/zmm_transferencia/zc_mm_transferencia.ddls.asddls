@EndUserText.label: 'CDS de Projeção Transferencia'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_TRANSFERENCIA
  as projection on ZI_MM_TRANSFERENCIA
{
  
  key NumeroDocumento, 
  key NumeroDocumentoItem, 
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DOCNUM', element: 'BR_NotaFiscal' } }]
      BR_NotaFiscal,
      @Consumption.filter: { selectionType: #INTERVAL }
//      @EndUserText.label: 'Data de Entrada'
      DataLancamento,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CompanyCodeVH', element: 'CompanyCode' } }]
      Empresa,
      @EndUserText.label: 'Centro Origem'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_PlantStdVH', element: 'Plant' } }]
      LocalNegocioOrigem,
      @EndUserText.label: 'Centro Destino'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_PLANTSTDVH', element: 'werks' } }]
      LocalNegocioDestino,
      //      @EndUserText.label: 'Local de negócio recebedor'
      //      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BusinessPartnerVH', element: 'BusinessPartner' } }]
      //      LocalNegocioRecebedor,
      
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZC_TM_VH_CFOP', element: 'cfop' } }]
      CFOP, 
      //@Consumption.filter: { selectionType: #INTERVAL }
      @EndUserText.label: 'Data do Documento'
      DataDocumento,
      @Consumption.filter: { selectionType: #INTERVAL }
      @EndUserText.label: 'Data do Documento'
      DataDocumento1 ,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_MATERIAL', element: 'Product' } }]
      Material,
      @EndUserText.label: 'Nº NF'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_NFENUM', element: 'nfenumcast' } }]
      NumeroNf,
      DescricaoMaterial,
      @EndUserText.label: 'Quantidade U.M.'
      Quantidade1,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_UnitOfMeasureStdVH', element: 'UnitOfMeasure' } }]
      BaseUnit,
      @EndUserText.label: 'Quantidade KG liq'
      Quantidade2,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_UnitOfMeasureStdVH', element: 'UnitOfMeasure' } }]
      UnidadePeso,
      Dias,
      @EndUserText.label: 'Remessa saída'
      DocRefEntrada,
      @EndUserText.label: 'Doc. ref. entrada'
      DocRefEntreda1,
//      SourceDocument,
//      SourceYear,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_STATUS_NF', element: 'StatusId' } }]
      Status,
//      @EndUserText.label: 'Data do Recebimento'      
      @EndUserText.label: 'Data de Entrada'      
      @Consumption.filter: { selectionType: #INTERVAL }
      DataRecebimento
      //      teste,
      /* Associations */
//      _AccessKey,
//      _LocNegOrigem,
//      _LocNegDestino,
//      _LocNegRecebedor 
//      _Mkpf
      
      //      _NFDocumentFlow,
      //      _NFItem,
      //      _Quantidade

}
