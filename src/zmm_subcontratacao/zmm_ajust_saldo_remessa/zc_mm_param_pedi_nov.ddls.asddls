@EndUserText.label: 'Parâmetro de Pedido de Compra Novo'
@Metadata.allowExtensions: true
define abstract entity ZC_MM_PARAM_PEDI_NOV
{
  @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_PED_NOVO', element: 'PedNv' } }]
  PedNv : ebeln;

}
