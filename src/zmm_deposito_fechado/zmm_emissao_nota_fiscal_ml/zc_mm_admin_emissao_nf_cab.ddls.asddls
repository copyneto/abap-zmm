@EndUserText.label: 'Emissão de NF (Cabeçalho)'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define root view entity ZC_MM_ADMIN_EMISSAO_NF_CAB
  as projection on ZI_MM_ADMIN_EMISSAO_NF_CAB
{
      @EndUserText.label: 'Status'
      @ObjectModel.text.element: ['StatusText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_STATUS', element: 'Status' } } ]
  key Status,
      StatusText,
      StatusCriticality,

      /* Associations */
      _Item : redirected to composition child ZC_MM_ADMIN_EMISSAO_NF_ITM
}
