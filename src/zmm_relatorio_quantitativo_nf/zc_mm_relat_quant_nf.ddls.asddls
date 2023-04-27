@EndUserText.label: 'Relatório Quantitativo de Notas Fiscais'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

@ObjectModel.semanticKey: ['BR_NotaFiscalItem','CreatedByUser','BR_CFOPCode']

define root view entity ZC_MM_RELAT_QUANT_NF
  as projection on ZI_MM_RELAT_QUANT_NF
{
      @EndUserText.label: 'N° Documento'
  key BR_NotaFiscal,
      @EndUserText.label: 'Item'
  key BR_NotaFiscalItem,
      @EndUserText.label: 'Direção de movimento'
      @ObjectModel.text.element: ['BR_NFDirectionDesc']
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_DIRECT', element: 'Direct' }}]
      BR_NFDirection,
      BR_NFDirectionDesc,
      BR_NFDirectionCrit,
      @EndUserText.label: 'Tipo de documento'
      @ObjectModel.text.element: ['BR_NFDocumentTypeName']
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_DOCTYP_NF', element: 'BR_NFDocumentType' }}]
      BR_NFDocumentType,
      @EndUserText.label: 'Tipo de documento'
      _DocType.text                       as BR_NFDocumentTypeName,
      @EndUserText.label: 'Data do documento'
      BR_NFIssueDate,
      @EndUserText.label: 'Mês do documento'
      BR_NFIssueMonth,
      @EndUserText.label: 'Empresa'
      @ObjectModel.text.element: ['CompanyCodeName']
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_BRANCH', element: 'CompanyCode' }}]
      CompanyCode,
      CompanyCodeName,
      @EndUserText.label: 'Local de Negócio'
      @ObjectModel.text.element: ['BusinessPlaceName']
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_BRANCH', element: 'BusinessPlace' }}]
      BusinessPlace,
      _Branch.name                        as BusinessPlaceName,
      @EndUserText.label: 'Status do documento'
      @ObjectModel.text.element: ['BR_NFeDocumentStatusDesc']
      BR_NFeDocumentStatus,
      BR_NFeDocumentStatusDesc,
      BR_NFeDocumentStatusCrit,
      @EndUserText.label: 'Data de lançamento'
      BR_NFPostingDate,
      @EndUserText.label: 'Hora de criação documento'
      CreationTime,
      @EndUserText.label: 'Tipo de Nota Fiscal'
      @ObjectModel.text.element: ['BR_NFTypeName']
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_NFTYPE', element: 'BR_NFType' }}]
      BR_NFType,
      @EndUserText.label: 'Tipo de Nota Fiscal'
      _NFType.nfttxt                      as BR_NFTypeName,
      @EndUserText.label: 'Criado por'
      @ObjectModel.text.element: ['CreatedByUserName']
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_USER', element: 'Bname' }}]
      CreatedByUser,
      _User.NAME_TEXTC                    as CreatedByUserName,
      CreatedByUserCrit,
      @EndUserText.label: 'Identificação do Parceiro'
      @ObjectModel.text.element: ['BR_NFPartnerName']
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_PARID', element: 'BR_NFPartner' }}]
      BR_NFPartner,
      _BR_NFPartner.BR_NFPartnerName1     as BR_NFPartnerName,
      @EndUserText.label: 'Tipo de Parceiro'
      @ObjectModel.text.element: ['BR_NFPartnerTypeDesc']
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_PARTYP', element: 'BR_NFPartnerType' }}]
      BR_NFPartnerType,
      _NFPartnerType.BR_NFPartnerTypeDesc as BR_NFPartnerTypeDesc,
      @EndUserText.label: 'N° NF-e'
      BR_NFeNumber,
      @EndUserText.label: 'N° NF'
      BR_UtilsNFNumber,
      @EndUserText.label: 'CFOP'
      @ObjectModel.text.element: ['BR_CFOPCodeMask']
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_CFOP', element: 'Cfop' }}]
      BR_CFOPCode,
      BR_CFOPCodeMask,
      @EndUserText.label: 'Descrição CFOP'
      _CFOP.Text                          as BR_CFOPDesc,
      @EndUserText.label: 'Nota fiscal cancelada'
      BR_NFIsCanceled
}
