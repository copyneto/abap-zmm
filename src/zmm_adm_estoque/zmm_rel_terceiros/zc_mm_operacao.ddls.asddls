@EndUserText.label: 'CDS Consumo Operação'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_OPERACAO
  as projection on ZI_MM_OPERACAO
{
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_MM_VH_OPERACAO', element: 'Operacao' }}]
      @ObjectModel.text.element: ['DescOp']
  key Operacao,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_BWART', element: 'GoodsMovementType' }}]  
      @ObjectModel.text.element: ['DescMov']   
  key TpMov,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_CFOP', element: 'Cfop' }}]    
  key Cfop,
      @ObjectModel.text.element: ['DescTp']  
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_MM_VH_TIPO', element: 'Tipo' }}]  
      Tipo,
      _OpDesc.Descricao as DescOp,      
      _TpDesc.Descricao as DescTp,
      _MovDesc.Description as DescMov,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
