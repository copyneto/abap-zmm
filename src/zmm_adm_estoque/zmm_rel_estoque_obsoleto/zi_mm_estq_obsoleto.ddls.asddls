@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Interface - Itens Estoque Obsoleto'
@Metadata: {
             ignorePropagatedAnnotations: true,
             allowExtensions: true
           }
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@VDM: {
        viewType: #COMPOSITE
        }
define root view entity ZI_MM_ESTQ_OBSOLETO
  as select from ZI_MM_obs_JOIN as tipo
{
                    @Consumption.hidden: true
  key               tipo.MaterialDocumentYear,
                    @Consumption.hidden: true
  key               tipo.MaterialDocument,
  key               tipo.MaterialDocumentItem,
                    @Consumption.valueHelpDefinition: [{entity: {name: 'C_Materialvh', element: 'Material' }}]
  key               tipo.Material,
                    @Consumption.valueHelpDefinition: [{entity: {name: 'C_MM_PlantValueHelp', element: 'Plant' }}]
  key               tipo.Plant,
  key               tipo.CompanyCode,
  key               tipo.ChartOfAccounts,
  key               tipo.GLAccount,
  key               tipo.CalendarMonthName,

                    tipo.MaterialName,
                    tipo.PlantName,
                    tipo.CompanyCodeName,

                    @Consumption.valueHelpDefinition: [{entity: {name: 'C_StorageLocationVH', element: 'StorageLocation' }}]
                    tipo.StorageLocation,
                    @Consumption.hidden: true
                    tipo.Supplier,
                    @Consumption.hidden: true
                    tipo.WBSElementInternalID1,
                    @Consumption.hidden: true
                    tipo.Customer,
                    tipo.MovementType,
                    tipo.MaterialBaseUnit,
                    tipo.PostingDate,
                    tipo.CompanyCodeCurrency,
                    @Consumption.valueHelpDefinition: [{entity:{name: 'C_MM_MaterialValueHelp', element: 'MaterialType'} }]
                    tipo.MaterialType,
                    @Consumption.valueHelpDefinition: [{entity: {name: 'C_MM_MaterialGroupValueHelp', element: 'MaterialGroup' }}]
                    tipo.GrupoMaterial,
                    @Consumption.valueHelpDefinition: [{entity: {name: 'C_SalesOrganizationVH', element: 'SalesOrganization' }}]
                    tipo.OrgVendas,
                    @EndUserText.label: 'Data para Análise'
                    @Consumption.filter.selectionType: #SINGLE
                    tipo.DataAnalise,
                    tipo.AnaliseDias,
                    tipo.Segmento,
                    @EndUserText.label: 'Período Corrente'
                    @ObjectModel.text.element: ['CalendarMonthName']
                    tipo.PeriodoCorrente,
                    tipo.Exercicio,
                    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
                    @DefaultAggregation : #SUM
                    tipo.MatlWrhsStkQtyInMatlBaseUnit,
                    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
                    @DefaultAggregation : #SUM
                    tipo.StockValueInCCCrcy,
                    tipo.GLAccountName,
                    tipo.MaterialTypeName
}
where
      tipo.MatlWrhsStkQtyInMatlBaseUnit > 0
  and tipo.StockValueInCCCrcy           > 0
group by
  tipo.MaterialDocumentYear,
  tipo.MaterialDocument,
  tipo.MaterialDocumentItem,
  tipo.Material,
  tipo.MaterialName,
  tipo.Plant,
  tipo.PlantName,
  tipo.CompanyCode,
  tipo.CompanyCodeName,
  tipo.ChartOfAccounts,
  tipo.GLAccount,
  tipo.CalendarMonthName,
  tipo.StorageLocation,
  tipo.Supplier,
  tipo.WBSElementInternalID1,
  tipo.Customer,
  tipo.MovementType,
  tipo.MaterialBaseUnit,
  tipo.PostingDate,
  tipo.CompanyCodeCurrency,
  tipo.MaterialType,
  tipo.GrupoMaterial,
  tipo.OrgVendas,
  tipo.MaterialTypeName,
  tipo.DataAnalise,
  tipo.PeriodoCorrente,
  tipo.Exercicio,
  tipo.GLAccountName,
  tipo.StockValueInCCCrcy,
  tipo.MatlWrhsStkQtyInMatlBaseUnit,
  tipo.AnaliseDias,
  tipo.Segmento
