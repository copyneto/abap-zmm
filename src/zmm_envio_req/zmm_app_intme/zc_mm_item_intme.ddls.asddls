@EndUserText.label: 'Projection - Integrações ME Item'
@AccessControl.authorizationCheck: #CHECK
@Search.searchable: true
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: ['Bsart','Ekgrp']
define view entity ZC_MM_ITEM_INTME
  as projection on ZI_MM_ITEM_INTME
{
      @Search.defaultSearchElement: true
  key Bsart,
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'zi_mm_vh_ekgrp', element : 'CompGroupCode' }}]
      @ObjectModel.text.element: ['CompGroupCodeName']
  key Ekgrp,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      @UI.hidden: true
      CompGroupCodeName,

      /* Associations */
      _header : redirected to parent ZC_MM_HEADER_INTME
}
