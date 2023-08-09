@EndUserText.label: 'Proj Cadastro Fiscal - cabeçalho'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_CADASTRO_FISCAL_CABEC
  as projection on ZI_MM_CADASTRO_FISCAL_CABEC
{
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_CA_VH_BUKRS', element : 'Empresa' }}]
      @ObjectModel.text.element: ['EmprText']
  key Empresa,
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_CA_VH_BRANCH', element : 'BusinessPlace' }}]
  key Filial,
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_CA_VH_LIFNR', element : 'LifnrCode' }}]
      @ObjectModel.text.element: ['LifnrText']
  key Lifnr,

      //      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_CA_VH_NFENUM', element : 'nfenum' }}]
      //      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_MM_CADASTRO_FISCAL_VH_NFE', element : 'NrNf' }}]
//        key NrNf,
  key NrNf,
//      NrNf2,
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_CA_VH_EBELN', element : 'Ebeln' }}]
      Pedido,
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_CA_VH_CPF_CNPJ', element : 'CpfCnpj' }}]
      @EndUserText.label: 'CPF/CNPJ'
      CnpjCpf,
      DtEmis,
      DtLancto,
      @EndUserText.label: 'Data Vencimento'
      DtVenc,
      @EndUserText.label: 'Data Liberação'
      DtReg,
      @EndUserText.label: 'Hora Liberação'
      HrReg,
      Lblni,
      VlFrete,
      VlDesc,
      @EndUserText.label: 'Valor Total NF'
      VlTotNf,
      VlIss,
      VlPis,
      VlCofins,
      VlCsll,
      VlIr,
      VlInss,
      //      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_CA_VH_ZTERM', element : 'CndPgtoCode' }}]
      CondPag,
      //      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_CA_VH_INCO1_VIEW', element : 'inco1' }}]
      //      Incoterms,
      //      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_CA_VH_USER', element : 'Bname' }}]
      //      @ObjectModel.text.element: ['UserName']
      //      Uname,
      //      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_CA_VH_ZUONR', element : 'Zuonr' }}]
      //      Atrib,
      //      Cancel,
      //      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_CA_VH_USER', element : 'Bname' }}]
      //      @ObjectModel.text.element: ['UserCancName']
      //      CancelUser,
      @Consumption.valueHelpDefinition: [{ entity:{name: 'ZI_MM_MONIT_SERV_VH_STATUS', element: 'Status'} }]
      StatusFiscal,
      StFiscCritic,
      //      DtVenc2,
      //      DtVenc3,
      //      DtVenc4,
      //      DtVenc5,
      DtBase,
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_CA_VH_DOMICILIO_FISCAL', element : 'Txjcd' }}]
      @EndUserText.label: 'Local da Prestação'
      DomicilioFiscal,
      @EndUserText.label: 'LC'
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_CA_VH_NCM_SERVICO', element : 'CodigoNcm' }}]
      Lc,
      @EndUserText.label: 'Rpa?'
      FlagRpa,
      //      DtRecusa,
      //      Liberado,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      Currency,
      _T001.butxt         as EmprText,
      _Lfa1.LifnrCodeName as LifnrText,
      _User.Text          as UserName,
      _UserCanc.Text      as UserCancName,
      @EndUserText.label: 'Imobilizado?'
      Imob,


      /* Associations */
      _Item  : redirected to composition child ZC_MM_CADASTRO_FISCAL_ITEM,
      _Anexo : redirected to composition child ZC_MM_CADASTRO_FISCAL_ANEXO
}
