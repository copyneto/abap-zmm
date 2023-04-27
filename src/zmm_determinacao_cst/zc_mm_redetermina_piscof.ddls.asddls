@EndUserText.label: 'Redeterminação PIS COFINS'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: ['ekorg', 'werks', 'lifnr', 'matnr', 'knttp', 'sakto', 'cfop']

define root view entity ZC_MM_REDETERMINA_PISCOF
  as projection on ZI_MM_REDETERMINA_PISCOF
{
  key id,
      @EndUserText.label: 'Organização de compras'
      @ObjectModel.text.element: ['ekorg_txt']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_EKORG', element: 'PurchasingOrganization' } } ]
      ekorg,
      ekorg_txt,
      @EndUserText.label: 'Centro'
      @ObjectModel.text.element: ['werks_txt']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } } ]
      werks,
      werks_txt,
      @EndUserText.label: 'Fornecedor'
      @ObjectModel.text.element: ['lifnr_txt']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_LIFNR', element: 'LifnrCode' } } ]
      lifnr,
      lifnr_txt,
      @EndUserText.label: 'Material'
      @ObjectModel.text.element: ['matnr_txt']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_MATERIAL', element: 'Material' } } ]
      matnr,
      matnr_txt,
      @EndUserText.label: 'Categoria Classificação contábil'
      @ObjectModel.text.element: ['knttp_txt']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_KNTTP', element: 'AccountAssignmentCategory' } } ]
      knttp,
      knttp_txt,
      @EndUserText.label: 'Conta Razão'
      @ObjectModel.text.element: ['sakto_txt']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_SAKNR_PC3C', element: 'GLAccount' } } ]
      sakto,
      sakto_txt,
      @EndUserText.label: 'CFOP'
      @ObjectModel.text.element: ['cfop_txt']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_CFOP', element: 'Cfop1' } } ]
      cfop,
      cfop_mask,
      _cfop.Text as cfop_txt,
      @EndUserText.label: 'Lei Fiscal PIS'
      @ObjectModel.text.element: ['taxlaw_pis_txt']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_TAXLAW_PIS', element: 'Taxlaw' } } ]
      taxlaw_pis,
      taxlaw_pis_txt,
      @EndUserText.label: 'Situação Trib. PIS'
      @ObjectModel.text.element: ['taxsit_pis_txt']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_TAXLAW_PIS', element: 'Taxsit' } } ]
      taxsit_pis,
      taxsit_pis_txt,
      @EndUserText.label: 'Lei Fiscal COFINS'
      @ObjectModel.text.element: ['taxlaw_cofins_txt']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_TAXLAW_COFINS', element: 'Taxlaw' } } ]
      taxlaw_cofins,
      taxlaw_cofins_txt,
      @EndUserText.label: 'Situação Trib. COFINS'
      @ObjectModel.text.element: ['taxsit_cofins_txt']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_TAXLAW_COFINS', element: 'Taxsit' } } ]
      taxsit_cofins,
      taxsit_cofins_txt,
      @EndUserText.label: 'Criado por'
      createdby,
      @EndUserText.label: 'Criado em'
      createdat,
      @EndUserText.label: 'Alterado por'
      lastchangedby,
      @EndUserText.label: 'Alterado em'
      lastchangedat,
      @EndUserText.label: 'Registrado em'
      locallastchangedat
}
