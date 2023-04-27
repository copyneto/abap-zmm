@EndUserText.label: 'Tipo de Imposto vs Grupo de Imposto'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_MM_TIPO_IMPOSTO
  as projection on ZI_MM_TIPO_IMPOSTO
{
      @Consumption.valueHelpDefinition: [{entity: {name: 'I_BR_TaxType', element: 'BR_TaxType'},
                                          additionalBinding: [{element: 'BR_TaxGroup', localElement: 'TaxGroup' }] }]
  key TaxType,
      TaxTypeText,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_MM_VH_GRUPO_IMPOSTO', element: 'TaxGroup'}}]
      TaxGroup,
      @EndUserText.label: 'Descrição de Grupo de Imposto'
      TaxGroupText,
      @EndUserText.label: 'Criado Por'
      @ObjectModel.text.element: ['CreatedByName']
      CreatedBy,
      _CreatedBy.UserDescription as CreatedByName,
      @EndUserText.label: 'Criado Em'
      CreatedAt,
      @EndUserText.label: 'Modificado Por'
      @ObjectModel.text.element: ['ChangedByName']
      LastChangedBy,
      _ChangedBy.UserDescription as ChangedByName,
      @EndUserText.label: 'Modificado Em'
      LastChangedAt,
      @EndUserText.label: 'Última Modif.'
      LocalLastChangedAt
}
