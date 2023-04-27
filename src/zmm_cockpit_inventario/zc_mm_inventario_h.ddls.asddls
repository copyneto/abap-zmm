@EndUserText.label: 'Cockpit de Inventário - Cabeçalho'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_MM_INVENTARIO_H
  as projection on ZI_MM_INVENTARIO_H
  
{
  key Documentid,
      Documentno,
      Countid,
      @Consumption.filter.selectionType: #INTERVAL
      Datesel,
      @ObjectModel.text.element: ['PlantText']
      @Consumption.valueHelpDefinition: [{
                entity: {
                    name: 'I_Plant',
                    element: 'Plant'
                }
            }]
      Plant,
      PlantText,
      @ObjectModel.text.element: ['StatusText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_INVENTARIO_STATUS', element: 'Status' } } ]
      Status,
      StatusText,
      StatusCriticality,
      Description,
      Accuracy,
      DataLanc,
      DocMaterial,
      @EndUserText.label: 'Doc.Entrada Saída'
      DocEntSai,
      @EndUserText.label: 'N° Doc Contabilização'
      DocComp,
      Empresa,
      PhysicalInventoryDocument,
      NumNF,
      EstornoNfe,
      DocStat,
      DocContEst,
      DatDocCont,
      FiscalYear,
      ExternalRef,
      _Total.QuantityCount   as QuantityCount,
      _Total.QuantityCurrent as QuantityCurrent,
      _Total.QuantityStock   as QuantityStock,
      _Total.CountDiff       as CountDiff,
      _Total.Weight          as Weight,
      @Semantics.amount.currencyCode: 'Currency'
      _Total.PriceCount      as PriceCount,
      @Semantics.amount.currencyCode: 'Currency'
      _Total.PriceDiff       as PriceDiff,
      @Semantics.amount.currencyCode: 'Currency'
      _Total.PriceStock      as PriceStock,
      _Total.Currency        as Currency,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      /* Associations */
      _Itens : redirected to composition child ZC_MM_INVENTARIO_ITEM

}
