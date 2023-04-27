@EndUserText.label: 'Parâmetro de Transporte - Expedição'
@Metadata.allowExtensions: true
define abstract entity ZC_MM_PARAM_TRANSP_ARMAZ
{

//  @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_LIFNR', element: 'LifnrCode' } }]
//  Transptdr  : lifnr;
//  @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_INCO1_VIEW', element: 'inco1' } }]
//  Incoterms1 : inco1;
//  Incoterms2 : inco2; 
//  TRAID      : traid;
  @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_ARMZ_TXSDC', element: 'taxcode' } }]
  TXSDC      : j_1btxsdc_;

}
