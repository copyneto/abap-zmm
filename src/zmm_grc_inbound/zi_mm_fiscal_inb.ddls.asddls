@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cadastro - De / Para UM'
define root view entity ZI_MM_FISCAL_INB
  as select from    ztmm_fiscal_inb     as _Inb
  association [0..1] to I_Supplier          as _Supplier on  $projection.Lifnr = _Supplier.Supplier
  association [0..1] to I_MaterialText      as _Material on  $projection.Matnr  = _Material.Material
                                                         and _Material.Language = $session.system_language
  association [0..1] to I_UnitOfMeasureText as _UoMIn    on  $projection.UmIn = _UoMIn.UnitOfMeasure
                                                         and _UoMIn.Language  = $session.system_language
  association [0..1] to I_UnitOfMeasureText as _UoMOut   on  $projection.UmOut = _UoMOut.UnitOfMeasure
                                                         and _UoMOut.Language  = $session.system_language
{
      @ObjectModel.text.element: ['SupplierFullName']
      key lifnr                              as Lifnr,
      @ObjectModel.text.element: ['MaterialName']
      key matnr                              as Matnr,
      @ObjectModel.text.element: ['UoMCommName']
      key um_in                              as UmIn,
      @ObjectModel.text.element: ['UoMTechName']
      key um_out                             as UmOut,
      created_by                         as CreatedBy,
      created_at                         as CreatedAt,
      last_changed_by                    as LastChangedBy,
      last_changed_at                    as LastChangedAt,
      local_last_changed_at              as LocalLastChangedAt,

      _Supplier.SupplierFullName,
      _Material.MaterialName,
      _UoMIn.UnitOfMeasureCommercialName as UoMCommName,
      _UoMOut.UnitOfMeasureTechnicalName as UoMTechName,

      _Supplier,
      _Material,
      _UoMIn,
      _UoMOut
}
