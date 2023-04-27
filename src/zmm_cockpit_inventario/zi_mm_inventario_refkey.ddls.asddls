@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS refkey'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZI_MM_INVENTARIO_REFKEY
  as select from    iseg      as _Seg
{
  key _Seg.iblnr,
  key _Seg.gjahr,
      _Seg.mblnr,
      _Seg.budat,
     max( _Seg.matnr ) as matnr,
     case
     when _Seg.mblnr is not null
     then
      concat( _Seg.mblnr, _Seg.gjahr ) end as refkey
}
where mblnr is not initial
group by
_Seg.iblnr,
_Seg.gjahr,
_Seg.mblnr,
_Seg.budat
