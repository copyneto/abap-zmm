@EndUserText.label: 'Decisão de Armazenagem do Café'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_DECIS_ARMAZENAG_CAFE
  as projection on ZI_MM_DECIS_ARMAZENAG_CAFE
{
  key DocUuidH,
      Romaneio,
      Vbeln,
      Ebelp,
      QtdKG,
      @ObjectModel.text.element: ['CentroDesc']
      Werks,
      Material,
      DescMat,
      Charg,
      @ObjectModel.text.element: ['DepDesc']
      Lgort,
      Unidade,
      Quantidade,
      _Centro.name1 as CentroDesc,
      _Dep.lgobe    as DepDesc,

      CreatedAt,
      CreatedBy,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      /* Associations */
      _Lote : redirected to composition child ZC_MM_DECIS_ARMAZENAG_LOTE
}
