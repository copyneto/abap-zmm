@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Nota Fiscal Avulsa - Fornecedor'

define root view entity ZI_MM_NF_AVULSA
  as select from ztmm_nf_avulsa as _NF

  association [1..1] to I_Supplier as _Supplier on $projection.Lifnr = _Supplier.Supplier
{
      @ObjectModel.text.element: ['SupplierName']
  key _NF.lifnr                 as Lifnr,
      _NF.stcd1                 as Stcd1,
      @Semantics.user.createdBy: true
      _NF.created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      _NF.created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      _NF.last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.createdAt: true
      _NF.last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      _NF.local_last_changed_at as LocalLastChangedAt,

      _Supplier.SupplierName,

      _Supplier
}
