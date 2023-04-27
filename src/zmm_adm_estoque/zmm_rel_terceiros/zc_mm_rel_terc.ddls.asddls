@EndUserText.label: 'Projection Rel Terceiro'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_REL_TERC
  as projection on ZI_MM_REL_TERC
{
      @Consumption.valueHelpDefinition: [{entity: {name: 'I_COMPANYCODEVH', element: 'CompanyCode' }}]
      @ObjectModel.text.element: ['DescEmpresa']
  key Empresa,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_LIFNR', element: 'LifnrCode' }}]
      @ObjectModel.text.element: ['DescFornecedor']
  key CodFornecedor,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_MATERIAL', element: 'Material' }}]
      @ObjectModel.text.element: ['DescMaterial']
  key Material,
      DescEmpresa,
      DescFornecedor,
      DescMaterial,
      @Consumption.valueHelpDefinition: [{  entity: {name: 'ZI_CA_VH_BRANCH', element: 'BusinessPlace' },
                     additionalBinding: [{  element: 'CompanyCode', localElement: 'Empresa' }]   }]
      LocalNegocio,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_WERKS', element: 'WerksCode' }}]      
      Centro,
      UnidMedida,
      QtdeRemessa,
      QtdeRetorno,
      Soma,

      _Remessa : redirected to composition child ZC_MM_REL_TERC_REM,
      _Retorno : redirected to composition child ZC_MM_REL_TERC_RET

}
