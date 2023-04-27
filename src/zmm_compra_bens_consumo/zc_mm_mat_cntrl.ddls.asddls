@EndUserText.label: 'Controle de Mercadoria'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_MM_MAT_CNTRL
  as projection on ZI_MM_MAT_CNTRL as _MatCntrl
{
  key Id,
      IdMov,
      Anln1,
      Anln2,
      Invnr,
      Lgort,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
      /* Associations */
      , _MovCntrl : redirected to parent ZC_MM_MOV_CNTRL
}
