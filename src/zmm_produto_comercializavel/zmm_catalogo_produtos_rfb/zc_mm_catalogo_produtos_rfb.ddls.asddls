@EndUserText.label: 'Projection view Catálogo de Produtos RFB'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.semanticKey: ['IdRFB']
define root view entity ZC_MM_CATALOGO_PRODUTOS_RFB
  as projection on ZI_MM_CATALOGO_PRODUTOS_RFB
{
      @Search.fuzzinessThreshold: 0.90
      @EndUserText.label: 'Id RFB'
      @Search.defaultSearchElement: true
  key Idrfb                                                              as IdRFB,

      @EndUserText.label: 'Tipo de Material'
      @Consumption: { semanticObject: 'MaterialType',
                      valueHelpDefinition: [{ entity: { name : 'I_MaterialType', element : 'MaterialType' } }]}
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: ['MaterialTypeName']
      Materialtype,
      @EndUserText.label: 'Nome do Tipo de Material'
      @Search: { defaultSearchElement: true, ranking: #LOW, fuzzinessThreshold: 0.7 }
      _MaterialTypeText.MaterialTypeName                                 as MaterialTypeName,

      @EndUserText.label: 'Material'
      @Consumption.valueHelpDefinition: [{ entity: {name : 'C_MM_MaterialValueHelp', element : 'Material' } }]
//                     additionalBinding: [{ element: 'MaterialType', localElement: 'MaterialType' }]   }]
      @Search: { defaultSearchElement: true, ranking: #HIGH , fuzzinessThreshold: 0.9 }
//      @ObjectModel.text.element: ['MaterialName']
      Material,
      @EndUserText.label: 'Nome do Material'
//      @Semantics.text: true
      @Search: { defaultSearchElement: true, ranking: #MEDIUM , fuzzinessThreshold: 0.8}
      _MaterialText[1: Language = $session.system_language].MaterialName as MaterialName,

      @EndUserText.label: 'Fornecedor'
      @Consumption.valueHelpDefinition: [{ entity: { name : 'C_MM_SupplierValueHelp', element : 'Supplier' }}]
//      @ObjectModel.text.element: ['SupplierName']
      Supplier                                                           as BusinessPartner,
      @EndUserText.label: 'Nome do Fornecedor'
//      @Semantics.text: true
      _Supplier.SupplierName                                             as SupplierName,

      @EndUserText.label: 'Status'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_STATUS_RFB', element: 'StatusId' } }]
      @ObjectModel.text.element: ['StatusName']
      Status,
      _StatusText.StatusName                                             as StatusName,
      StatusCriticality,

      @EndUserText.label: 'Início da Vigência'
      @Consumption.filter: { selectionType: #INTERVAL }
      Datefrom,

      @EndUserText.label: 'Fim da Vigência'
      @Consumption.filter: { selectionType: #INTERVAL }
      Dateto,

      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      /* Associations */
      _MaterialText,
      _MaterialType,
      _MaterialTypeText,
      _StatusText

}
