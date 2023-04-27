@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Relatório Terceiro'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_REL_TERC
  as select from ZI_MM_REL_TERC_MAIN
  composition [0..*] of ZI_MM_REL_TERC_REM as _Remessa
  composition [0..*] of ZI_MM_REL_TERC_RET as _Retorno
{

  key Empresa,
  key CodFornecedor,
  key Material,
      DescEmpresa,
      DescFornecedor,
      DescMaterial,
      LocalNegocio,
      Centro,
      UnidMedida,
      @Semantics.quantity.unitOfMeasure: 'UnidMedida'
      sum( QtdeRemessa )          as QtdeRemessa,
      @Semantics.quantity.unitOfMeasure: 'UnidMedida'
      sum( QtdeRetorno )          as QtdeRetorno,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_CDS_REMRET'
      cast( '' as abap.char(12) ) as Soma,
      
      _Remessa,
      _Retorno

}
group by
  Empresa,
  CodFornecedor,
  Material,
  DescMaterial,
  DescFornecedor,
  DescEmpresa,
  UnidMedida,
  LocalNegocio,
  Centro
