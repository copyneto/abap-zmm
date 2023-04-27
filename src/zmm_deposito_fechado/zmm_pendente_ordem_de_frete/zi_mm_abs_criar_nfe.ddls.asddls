@EndUserText.label: 'Param. Criar NFE'
define abstract entity  ZI_MM_ABS_CRIAR_NFE 
{
      @EndUserText.label  : 'Transportador'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_TRANSPORTADOR', element: 'Carrier' } } ]
      Transportador       : lifnr;
      @EndUserText.label  : 'Código Motorista'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_MOTORISTA', element: 'Parceiro' } } ]
      Driver              : bu_partner;
      @EndUserText.label  : 'Placa do veículo '
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_VEICULO', element: 'Equipment' } } ]
      Equipment           : equnr;
      @EndUserText.label  : 'Condição expedição '
       @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VSBED', element: 'CondicaoExpedicao' } } ]
      Shipping_conditions : vsbed;
      @EndUserText.label  : 'Tipo de expedição'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VSART', element: 'TipoExpedicao' } } ]
      Shipping_type       : vsart;
      @EndUserText.label  : 'Placa Semirreboque 1'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_VEICULO', element: 'Equipment' } } ]
      Equipment_tow1      : equnr;
      @EndUserText.label  : 'Placa Semirreboque 2'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_VEICULO', element: 'Equipment' } } ]
      Equipment_tow2      : equnr;
      @EndUserText.label  : 'Placa Semirreboque 3'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_VEICULO', element: 'Equipment' } } ]
      Equipment_tow3      : equnr;
      @EndUserText.label  : 'Modalidade Frete'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_DF_MODALIDADE_FRETE', element: 'FreightMode' } } ]
      Freight_mode        : ze_mm_freight_mode;
      

}
