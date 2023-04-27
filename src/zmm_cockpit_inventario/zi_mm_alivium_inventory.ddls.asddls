@AbapCatalog.sqlViewName: 'ZIMMINVENTORY'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Inventário Físico - Alivium'
@ObjectModel.representativeKey: 'iblnr'
define view ZI_MM_ALIVIUM_INVENTORY
  as select from ikpf as _Ikpf
{
  key  _Ikpf.iblnr,
  key  _Ikpf.gjahr,
  key  cast( '' as dzeil )                as zeili,
  key  concat( _Ikpf.iblnr, _Ikpf.gjahr ) as NodeID,
  key  cast( '' as abap.char(14) )        as ParentNodeID,
  key  '0'                                as HierarchyLevel,
  key  'expanded'                         as DrillState,
       cast( '' as matnr )                as matnr,
       _Ikpf.werks,
       _Ikpf.lgort,
       _Ikpf.bldat,
       _Ikpf.budat,
       _Ikpf.usnam,
       @Semantics.quantity.unitOfMeasure: 'meins'
       cast( 0 as buchm )                 as buchm,
       @Semantics.quantity.unitOfMeasure: 'meins'
       cast( 0 as menge_d )               as menge,
       cast( '' as meins )                as meins,
       cast( '' as mblnr )                as mblnr
}
union select from iseg as _Iseg
{
  key  _Iseg.iblnr,
  key  _Iseg.gjahr,
  key  _Iseg.zeili,
  key  concat( concat( _Iseg.iblnr, _Iseg.gjahr ), _Iseg.zeili ) as NodeID,
  key  concat( _Iseg.iblnr, _Iseg.gjahr )                        as ParentNodeID,
  key  '1'                                                       as HierarchyLevel,
  key  'leaf'                                                    as DrillState,
       _Iseg.matnr,
       _Iseg.werks,
       _Iseg.lgort,
       cast( '' as bldat )                                       as bldat,
       _Iseg.budat,
       _Iseg.usnam,
       _Iseg.buchm,
       _Iseg.menge,
       _Iseg.meins,
       _Iseg.mblnr
}
