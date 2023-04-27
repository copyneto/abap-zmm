@EndUserText.label: 'Cockpit de Inventário - Item'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
//@Search.searchable: true
define view entity ZC_MM_INVENTARIO_ITEM
  as projection on ZI_MM_INVENTARIO_ITEM
{
  key Documentid,
  key Documentitemid,


      @ObjectModel.text.element: ['MaterialText']
      Material,
      MaterialText,
      @ObjectModel.text.element: ['PlantText']
      Plant,
      PlantText,
      @ObjectModel.text.element: ['StorageLocationText']
      Storagelocation,
      StorageLocationText,
      Batch,
      Quantitystock,
      Quantitycount,
      Quantitycurrent,
      MaterialBaseQuantityCurrent,
      MaterialBaseUnit,
      Balance,
      Balancecurrent,
      Unit,
      Pricestock,
      Pricecount,
      Pricediff,
      Currency,
      Weight,
      Weightunit,
      ProductHierarchy,
      Accuracy,
      PhysicalInventoryDocument,
      FiscalYear,
      Prct,
      @ObjectModel.text.element: ['StatusText']
      Status,
      StatusText,
      StatusCriticality,
      DocMaterial,
      DataLanc,
      DocEntSai,
      DocComp,
      DataComp,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      /* Associations */
      _H : redirected to parent ZC_MM_INVENTARIO_H
}
