@EndUserText.label: 'Cadastro - De / Para UM'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_MM_FISCAL_INB
  as projection on ZI_MM_FISCAL_INB
{

  key Lifnr,
  key Matnr,
  key UmIn,
  key UmOut,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      SupplierFullName,
      MaterialName,
      UoMCommName,
      UoMTechName,

      _Material,
      _Supplier,
      _UoMIn,
      _UoMOut
}
