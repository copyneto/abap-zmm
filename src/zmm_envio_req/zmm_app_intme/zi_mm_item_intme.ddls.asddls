@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'View - Integrações ME Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_ITEM_INTME
  as select from ztmm_me_item
  association        to parent ZI_MM_HEADER_INTME as _header on $projection.Bsart = _header.Bsart
  association [0..1] to zi_mm_vh_ekgrp            as _vh     on _vh.CompGroupCode = ztmm_me_item.ekgrp
{
  key ztmm_me_item.bsart                 as Bsart,
  key ztmm_me_item.ekgrp                 as Ekgrp,
      ztmm_me_item.created_by            as CreatedBy,
      ztmm_me_item.created_at            as CreatedAt,
      ztmm_me_item.last_changed_by       as LastChangedBy,
      ztmm_me_item.last_changed_at       as LastChangedAt,
      ztmm_me_item.local_last_changed_at as LocalLastChangedAt,
      _vh.CompGroupCodeName,
      
      _header

}
