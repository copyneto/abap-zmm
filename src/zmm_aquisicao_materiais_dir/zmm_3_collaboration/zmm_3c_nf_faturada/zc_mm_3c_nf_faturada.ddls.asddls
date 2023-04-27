@EndUserText.label: '3Collaboration - NF Faturada'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define root view entity ZC_MM_3C_NF_FATURADA
  as projection on ZI_MM_3C_NF_FATURADA
{
        
  key NumRegistro,
      @EndUserText.label: 'Tipo de documento'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_3C_VH_DOC_TYPE', element: 'Doctype' } } ]
      @ObjectModel.text.element: ['DoctypeText']
  key Doctype,
      @EndUserText.label: 'UUID'
  key Guid,
      DoctypeText,
      DoctypeCrit,
      @EndUserText.label: 'Data do documento'
      DtDocumento,
      @EndUserText.label: 'Nome Emissor'
      NomeEmissor,
      @EndUserText.label: 'CNPJ Emissor'
      CNPJEmissor,
      @EndUserText.label: 'Nome Destinatário'
      NomeDestinatario,
      @EndUserText.label: 'CNPJ Destinatário'
      CNPJDestinatario,      
      @EndUserText.label: 'Nº NF-e'
      //@Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_NFENUM', element: 'nfenum' } } ]
      BR_NFeNumber,
      @EndUserText.label: 'Chave de acesso'
      //@Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_CHAVE_NFE', element: 'chaveNFE' } } ]
      AccessKey,
      @EndUserText.label: 'CFOP'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_3C_VH_CFOP', element: 'CfopHeader' } } ]
      Cfop,
      @EndUserText.label: 'Tipo de Evento'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_3C_VH_TP_EVENTO', element: 'TpEvento' } } ]
      @ObjectModel.text.element: ['TpEventoText']
      TpEvento,
      TpEventoText,
      @EndUserText.label: 'Nome do arquivo'
      Filename
}
