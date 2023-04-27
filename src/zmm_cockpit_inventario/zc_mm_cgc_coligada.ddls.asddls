@EndUserText.label: 'CGC das Coligadas por Empresa'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_CGC_COLIGADA
  as projection on ZI_MM_CGC_COLIGADA
{
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_BUKRS', element: 'bukrs' } } ]
  key Bukrs,
  key Bupla,
  key Cgc,
      Kunnr,
      Lifnr,
      Filial,
      Vkorg,
      ColCi,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
