@EndUserText.label: 'Alivium: Dados Contab NF-e'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_ALIVIUM_ACCOUNT
  as projection on ZI_MM_ALIVIUM_ACCOUNT
{
  key Processo,
  key Bwart,
  key Grupo,
  key Newbs,
      Newko,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
