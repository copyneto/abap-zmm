@EndUserText.label: 'Decisão de Armazenagem do Café - Lote'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_MM_DECIS_ARMAZENAG_LOTE
  as projection on ZI_MM_DECIS_ARMAZENAG_LOTE
{
  key DocUuidH,
  key DocUuidLot,
      Charg,
      Qtde,

      CreatedAt,
      CreatedBy,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      /* Associations */
      _Header : redirected to parent ZC_MM_DECIS_ARMAZENAG_CAFE
}
