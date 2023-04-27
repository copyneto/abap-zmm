@EndUserText.label: 'Parâmetros direitos fiscais'
@AccessControl.authorizationCheck: #CHECK
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity ZC_MM_MOV_PARAM
  as projection on ZI_MM_MOV_PARAM as MovParam
{
      @Consumption.valueHelpDefinition: [ { entity: { name: 'C_GHORegionVH', element: 'Region' }  } ]
      @Search.defaultSearchElement: true
  key Shipfrom,
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_DIRECT', element: 'Direct' }  } ]
      @Search.defaultSearchElement: true
  key Direcao,
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_CFOP', element: 'Cfop' }  } ]
      @Search.defaultSearchElement: true
      @EndUserText.label: 'CFOP'
  key Cfop,
      //@Consumption.valueHelpDefinition: [ { entity: { name: 'P_material_value_help', element: 'Material' }  } ]
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_MATERIAL', element: 'Material' }  } ]
  key Matnr,
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_MATKL', element: 'Matkl' }  } ]
  key Matkl,
      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_BR_TaxLawICMSText', element: 'BR_ICMSTaxLaw' }  } ]
  key Taxlw1,
      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_BR_TaxLawIPIText', element: 'BR_IPITaxLaw' }  } ]
  key Taxlw2,
      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_BR_TaxLawPISText', element: 'BR_PISTaxLaw' }  } ]
  key Taxlw5,
      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_BR_TaxLawCOFINSText', element: 'BR_COFINSTaxLaw' }  } ]
  key Taxlw4,
      //@Consumption.valueHelpDefinition: [ { entity: { name: 'I_BR_ICMSTaxSituationText', element: 'BR_ICMSTaxSituation' }  } ]
      //@Consumption.valueHelpDefinition: [ { entity: { name: 'I_BR_ICMSTaxSituation', element: 'BR_ICMSTaxSituation' }  } ]
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_ICMSTAX', element: 'BR_ICMSTaxSituation' }  } ]
      @EndUserText.label: 'Situação tributária ICMS'
  key Taxsit,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_BOOLE', element: 'ObjetoId' }}]
      Ativo,      
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
