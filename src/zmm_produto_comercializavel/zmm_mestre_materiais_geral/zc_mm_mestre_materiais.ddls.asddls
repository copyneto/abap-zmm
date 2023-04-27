@EndUserText.label: 'Relatório Geral - Mestre Materiais'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_MM_MESTRE_MATERIAIS
  as projection on ZI_MM_MESTRE_MATERIAIS
{
          @EndUserText.label: 'Id'
  key     VisionId,
          @EndUserText.label: 'Visão'
          VisionName,
          @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLMM_URL_MESTRE_MATERIAIS' }
          @EndUserText.label: 'URL Aplicativo'
  virtual URL : eso_longtext
}
