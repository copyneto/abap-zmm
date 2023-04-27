@EndUserText.label: 'Projection Rel de Terceiros'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_REL_TERC_AGRUP
  as projection on ZI_MM_REL_TERC_AGRUP
{
         @Consumption.valueHelpDefinition: [{entity: {name: 'I_COMPANYCODEVH', element: 'CompanyCode' }}]
         @ObjectModel.text.element: ['DescEmpresa']
  key    Empresa,
         @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_LIFNR', element: 'LifnrCode' }}]
         //         @ObjectModel.text.element: ['DescFornecedor']
  key    CodFornecedor,
         @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_MATERIAL', element: 'Material' }}]
         @ObjectModel.text.element: ['DescMaterial']
  key    Material,
         @Consumption.valueHelpDefinition: [{  entity: {name: 'ZI_CA_VH_BRANCH', element: 'BusinessPlace' },
         additionalBinding: [{  element: 'CompanyCode', localElement: 'Empresa' }]   }]
  key    LocalNegocio,
         @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_WERKS', element: 'WerksCode' }}]
  key    Centro,
  key    DocnumRemessa,
  key    NfItemRM,
  key    DocnumRetorno,
  key    NfItem,
         DescEmpresa,
         DescFornecedor,
         DescMaterial,
         TipoImpostoRM,
         TipoImposto,
         CodFornecedorRM,
         DescFornecedorRM,
         ValorItemRM,
         CfopRemessa,
         MovimentoRM,
         NFRemessa,
         DataRemessa,
         MaterialMovement,
         CodMaterialRM,
         DescMaterialRM,
         QtdeRM,
         UnidMedidaRM,
         MoedaRM,
         ValorTotalRM,
         DepositoRM,
         LoteRM,
         NcmRM,
         MontBasicRetornoRM,
         TaxaRetornoRM,
         IcmsRetornoRM,
         CodFornecedorRT,
         DescFornecedorRT,
         ValorItemRT,
         CfopRetorno,
         MovimentoRT,
         NFRetorno,
         DataRetorno,
         DocMaterial,
         CodMaterialRT,
         DescMaterialRT,
         QtdeRT,
         UnidMedidaRT,
         MoedaRT,
         ValorTotalRT,
         DepositoRT,
         LoteRT,
         NcmRT,
         MontBasicRetornoRT,
         TaxaRetornoRT,
         IcmsRetornoRT,
         @EndUserText.label: 'Status'
         Status,
         @Consumption.filter.hidden: true
         ColorStatus,
         DiasAberto,
         ContaContabilIcmsRM,
         ContaContabilIcmsRT,
         SaldoFornecedor,
         NumSerie,
         DataDocumentoRM,
         @EndUserText.label: 'Data Lançamento Inicial'
         DataLancamentoRM,
         PedidoSub,
         Iva,
         CategoriaNFE,
         GrupoCompra,
         GrupoMercado,
         DataDocumentoRT,
         @EndUserText.label: 'Data Lançamento Final'
         DataLancamentoRT,
         SaldoTerceiro
}
