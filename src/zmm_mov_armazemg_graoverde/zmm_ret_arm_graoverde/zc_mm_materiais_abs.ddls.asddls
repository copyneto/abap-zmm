@EndUserText.label: 'Parâmetro Material'
@Metadata.allowExtensions: true
define abstract entity ZC_MM_MATERIAIS_ABS
{
  @EndUserText.label: 'Material'
  @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_MATERIAL', element: 'Material' } }]
  MaterialAtribuido : matnr;
}
