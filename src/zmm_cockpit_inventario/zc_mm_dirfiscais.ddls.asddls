@EndUserText.label: 'Gestão Contratos Direitos Fiscais x CFOP'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_DIRFISCAIS
  as projection on ZI_MM_DIRFISCAIS
{
  key Shipfrom,
  key Direcao,
  key Cfop,
      Ativo,
      Taxlw1,
      Taxlw2,
      Taxlw4,
      Taxlw5,
      Taxsit,
      Cbenef,
      Motdesicms,
      ZtipoCalc,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
