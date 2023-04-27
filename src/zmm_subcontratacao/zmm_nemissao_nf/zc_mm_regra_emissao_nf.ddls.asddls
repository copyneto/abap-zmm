@EndUserText.label: 'Regra para não emissão de Nota Fiscal'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_REGRA_EMISSAO_NF
  as projection on ZI_MM_REGRA_EMISSAO_NF
{
      @ObjectModel.text.element: ['FromText']
  key ShipFrom,
      @ObjectModel.text.element: ['ToText']
  key ShipTo,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      _Regtxtfrom.txt as FromText,
      _Regtxtto.txt as ToText,

      _Regtxtfrom,
      _Regtxtto

}
