@EndUserText.label: 'Nota Fiscal Avulsa - Fornecedor'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_NF_AVULSA
  as projection on ZI_MM_NF_AVULSA
{
  key Lifnr,
      Stcd1,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      SupplierName,
      /* Associations */
      _Supplier
}
