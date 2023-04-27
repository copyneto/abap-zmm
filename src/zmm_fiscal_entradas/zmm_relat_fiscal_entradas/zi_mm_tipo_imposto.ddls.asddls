@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Tipo de Imposto vs Grupo de Imposto'
define root view entity ZI_MM_TIPO_IMPOSTO
  as select from ztmmgrpimp as Tax

  association [1..1] to I_BR_TaxTypeText       as _TaxTypText on  _TaxTypText.Language   = $session.system_language
                                                              and _TaxTypText.BR_TaxType = Tax.taxtyp

  association [1..1] to ZI_MM_VH_GRUPO_IMPOSTO as _TaxGrpText on  _TaxGrpText.TaxGroup = Tax.taxgrp
  association [1..1] to I_CreatedByUser        as _CreatedBy  on  _CreatedBy.UserName = $projection.CreatedBy
  association [1..1] to I_CreatedByUser        as _ChangedBy  on  _ChangedBy.UserName = $projection.CreatedBy
{
  key Tax.taxtyp                                       as TaxType,
      _TaxTypText.TaxTypeName                          as TaxTypeText,
      cast(Tax.taxgrp as logbr_taxgrp preserving type) as TaxGroup,
      _TaxGrpText.TaxGroupText                         as TaxGroupText,
      @Semantics.user.createdBy: true
      created_by                                       as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at                                       as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by                                  as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at                                  as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at                            as LocalLastChangedAt,
      _CreatedBy,
      _ChangedBy
}
