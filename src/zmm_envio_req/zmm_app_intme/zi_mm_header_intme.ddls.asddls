@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'View - Integrações ME Header'
define root view entity ZI_MM_HEADER_INTME
  as select from ztmm_me_header as zheader
  composition [0..*] of ZI_MM_ITEM_INTME as _item
  association [0..1] to zi_mm_vh_int     as _vh on zheader.zz1_int = _vh.Inte
{
  key zheader.bsart                                    as Bsart,
      zheader.zz1_int                                  as Zz1Int,
      zheader.created_by                               as CreatedBy,
      zheader.created_at                               as CreatedAt,
      zheader.last_changed_by                          as LastChangedBy,
      zheader.last_changed_at                          as LastChangedAt,
      zheader.local_last_changed_at                    as LocalLastChangedAt,
      case
            when zheader.zz1_int is initial then 2
                                            else 3 end as StatusCriticality,
      // Association
      _item,
      _vh.Text
}
