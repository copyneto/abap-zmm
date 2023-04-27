@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interface Conferência Parâmetro CFOP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_CONF_PARAM_CFOP
  as select from I_Product

  association [0..*] to ZI_MM_MATERIAL_CENTRO as _matcentro      on  $projection.Produto = _matcentro.Material
  association [0..1] to makt                  as _makt           on  $projection.Produto = _makt.matnr
                                                                 and _makt.spras         = $session.system_language
  //  association [0..1] to ZI_MM_ICMS_ST_DET     as _mm_icms_st_det on  $projection.codcontrole = _mm_icms_st_det.Ncm
  association [0..1] to ZI_MM_ICMS_ST_DET2    as _mm_icms_st_det on  $projection.codcontrole = _mm_icms_st_det.Ncm

  association [0..1] to ZI_CA_VH_INDUS        as _vindus         on  $projection.catcfop = _vindus.Indus
                                                                 and _vindus.Language    = $session.system_language
  association [0..1] to ZI_CA_VH_MTUSE        as _vmtuse         on  $projection.utilimaterial = _vmtuse.Mtuse
                                                                 and _vmtuse.Language          = $session.system_language
  association [0..1] to ZI_CA_VH_MTORG        as _vmtorg         on  $projection.origem = _vmtorg.Mtorg
                                                                 and _vmtorg.Language   = $session.system_language
{
  key ProductGroup         as GrupoMercadoria,
  key _matcentro.TipoAvaliacao,
  key _matcentro.Centro,
  key ProductType          as TipoProduto,
  key Product              as Produto,
      _makt.maktx          as DescProduto,
      _matcentro.CatCfop,
      _matcentro.UtiliMaterial,
      _matcentro.ProducaoInterna,
      _matcentro.Origem,
      _matcentro.CodControle,
      ProductHierarchy     as HieraquiaProd,
      ProductExternalID    as ProductExternalId,
      ExternalProductGroup as ExtProductGroup,
      _matcentro,
      _makt,
      _mm_icms_st_det,
      _vindus,
      _vmtuse,
      _vmtorg
}
