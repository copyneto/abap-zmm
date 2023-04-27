@EndUserText.label: 'CDS Conferência Parâmetros CFOP'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_CONF_PARAM_CFOP as projection on ZI_MM_CONF_PARAM_CFOP {
  @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_GRP_MERCADORIA', element: 'GrpMercadoria' }}]
  key GrupoMercadoria,
  key TipoAvaliacao,
  @Consumption.valueHelpDefinition: [{entity: {name: 'C_Plantvaluehelp', element: 'Plant' }}]
  key Centro,
  @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_TIPO_MATERIAL', element: 'TipoMaterial' }}]
  key TipoProduto,
  @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_MATERIAL', element: 'Material' }}]
  key Produto           as Product,
      DescProduto,
      CatCfop,
      _vindus.Descricao as DescCatCfop,
      UtiliMaterial,
      _vmtuse.Descricao as DescUtiliMaterial,
      ProducaoInterna,
      Origem,
      _vmtorg.Descricao as DescOrigem,
      CodControle,
      cast ( _mm_icms_st_det.Cest as char9 preserving type ) as Cest,
      _mm_icms_st_det.Cest_Out    as Cest_Out,        
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_GRP_MERC_EXT', element: 'GrpMercExt' }}]
      ExtProductGroup,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_HIERARQUIA_PROD', element: 'HierProd' }}]
      HieraquiaProd,
      ProductExternalId
}
