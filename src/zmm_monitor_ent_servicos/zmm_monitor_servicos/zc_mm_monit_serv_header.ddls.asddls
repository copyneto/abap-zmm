@EndUserText.label: 'Header Monitor de Serviço'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_MONIT_SERV_HEADER
  as projection on ZI_MM_MONIT_SERV_HEADER
{
      @EndUserText.label: 'Empresa'
      @ObjectModel.text.element: ['EmpText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_BUKRS', element: 'Empresa' }}]
  key Empresa,
      @EndUserText.label: 'Filial/centro'
      @ObjectModel.text.element: ['BranchText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_BRANCH', element: 'BusinessPlace' },
                                           additionalBinding: [{  element: 'CompanyCode', localElement: 'Empresa' }] }]
  key Filial,
      @EndUserText.label: 'Fornecedor'
      @ObjectModel.text.element: ['LifnrText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_LIFNR', element: 'LifnrCode' }}]
  key Lifnr,
      @EndUserText.label: 'N° da NF'
  key NrNf,
      @EndUserText.label: 'CNPJ/CPF'
      CnpjCpf,
      //      @EndUserText.label: 'Razão Social'
      //      RazSocial,
      @EndUserText.label: 'Data de Emissão'
      @Consumption.filter.selectionType: #INTERVAL
      DtEmis,
      @EndUserText.label: 'Data Vencimento'
      @Consumption.filter.selectionType: #INTERVAL
      DtVenc,
      @EndUserText.label: 'Data Liberação'
      @Consumption.filter.selectionType: #INTERVAL
      DtReg,
      @EndUserText.label: 'Hora Liberação'
      @Consumption.filter.selectionType: #INTERVAL
      HrReg,
      @EndUserText.label: 'Valor Total NF'
      VlTotNf,
      //      @EndUserText.label: 'Valor Liq. NF'
      //      VlrLiqNf,
      //      @EndUserText.label: 'CFOP'
      //      CFOP,
      //      @EndUserText.label: 'IVA'
      //      IVA,
      //      @EndUserText.label: 'Conta contábil'
      //      ContContab,
      @EndUserText.label: 'Pedido de compras'
      Pedido,
      @EndUserText.label: 'Nº Doc.Miro'
      Miro,
      @EndUserText.label: 'Docnum'
      Docnum,
      @EndUserText.label: 'Ctg. NF'
      NFType,
      FiscalYear,
      //      @EndUserText.label: 'Setor do usuário de cadastro'
      //      SetorCadst,
      @EndUserText.label: 'Usuário de cadastro'
      @ObjectModel.text.element: ['UserText']
      Uname,
      //      @EndUserText.label: 'Categoria NF'
      //      CategNf,
      @EndUserText.label: 'LC'
      LC,
      @EndUserText.label: 'Descrição LC'
      LCText,
      @EndUserText.label: 'Município do fornecedor'
      @ObjectModel.text.element: ['MunicFornDomicilio']
      MunicForn,
      MunicFornDomicilio,
      @EndUserText.label: 'Município prestação serviço'
      @ObjectModel.text.element: ['MunicRemesDomicilio']
      MunicRemes,
      MunicRemesDomicilio,
      @EndUserText.label: 'Destinatário'
      @ObjectModel.text.element: ['EmpDestText']
      EmpresDest,
      @EndUserText.label: 'Data de lançamento'
      @Consumption.filter.selectionType: #INTERVAL
      DtLancto,
      @EndUserText.label: 'Data vencimento'
      DtBase,
      @EndUserText.label: 'Status Fiscal'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_MONIT_SERV_VH_STATUS', element: 'Status' }}]
      StatusFiscal,
      StFiscCritic,
      @EndUserText.label: 'SLA Financeiro'
      SlaFinanc,
      SlaFinancCritc,
      @EndUserText.label: 'SLA Fiscal'
      SlaFiscal,
      SlaFiscalCritc,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      _Branch.BusinessPlaceName as BranchText,
      _Bukrs.EmpresaText        as EmpText,
      _BukrsDest.EmpresaText    as EmpDestText,
      _Lifnr.LifnrCodeName      as LifnrText,
      _User.Text                as UserText,


      /* Associations */
      _Anexo  : redirected to composition child ZC_MM_MONIT_SERV_ANEXO,
      _Branch,
      _Bukrs,
      _BukrsDest,
      _Item   : redirected to composition child ZC_MM_MONIT_SERV_ITEM,
      _Lifnr,
      _User,
      _Simula : redirected to composition child ZC_MM_MONIT_SERV_SIMULA
}
