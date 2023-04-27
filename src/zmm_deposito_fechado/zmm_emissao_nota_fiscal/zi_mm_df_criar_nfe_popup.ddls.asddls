@EndUserText.label: 'Depósito fechado - Popup de Criar NFe'
define abstract entity ZI_MM_DF_CRIAR_NFE_POPUP
{
  @EndUserText.label    : 'Transportador'
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_TRANSPORTADOR', element: 'Carrier' } } ]
  NewCarrier            : lifnr;

  @EndUserText.label    : 'Motorista'
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_MOTORISTA', element: 'Parceiro' } } ]
  NewDriver             : bu_partner;

  @EndUserText.label    : 'Placa do veículo'
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_VEICULO', element: 'Equipment' } } ]
  NewEquipment          : equnr;

  @EndUserText.label    : 'Condição expedição'
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VSBED', element: 'CondicaoExpedicao' } } ]
  NewShippingConditions : vsbed;

  @EndUserText.label    : 'Tipo de expedição'
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VSART', element: 'TipoExpedicao' } } ]
  NewShippingType       : vsart;

  @EndUserText.label    : 'Placa Semi-reboque 1'
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_VEICULO', element: 'Equipment' } } ]
  NewEquipmentTow1      : equnr;

  @EndUserText.label    : 'Placa Semi-reboque 2'
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_VEICULO', element: 'Equipment' } } ]
  NewEquipmentTow2      : equnr;

  @EndUserText.label    : 'Placa Semi-reboque 3'
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_VEICULO', element: 'Equipment' } } ]
  NewEquipmentTow3      : equnr;

  @EndUserText.label    : 'Modalidade Frete'
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_MODALIDADE_FRETE', element: 'FreightMode' } } ]
  @Consumption.filter.defaultValue: 'CIF'
  NewFreightMode        : ze_mm_freight_mode ;

}
