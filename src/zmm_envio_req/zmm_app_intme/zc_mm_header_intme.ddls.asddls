@EndUserText.label: 'Projection - Integrações ME Header'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.semanticKey: ['Bsart']

define root view entity ZC_MM_HEADER_INTME
  as projection on ZI_MM_HEADER_INTME
{
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_CA_VH_BSART', element : 'Bsart' }}]
  key Bsart,
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'zi_mm_vh_int', element : 'Inte' }}]
      @ObjectModel.text.element: ['Text']
      Zz1Int,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      Text,
      StatusCriticality,
      /* Associations */
      _item : redirected to composition child ZC_MM_ITEM_INTME
}
