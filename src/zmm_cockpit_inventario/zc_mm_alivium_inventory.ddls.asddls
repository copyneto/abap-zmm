@AbapCatalog.sqlViewName: 'ZCMMINVENTORY'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Inventário Físico - Alivium'
@ObjectModel:{ dataCategory: #HIERARCHY }
@Hierarchy.parentChild: [{
    name: 'Inventory',
    recurse: { parent: ['ParentNodeID'], child: ['NodeID'] },
    siblingsOrder: [{ by: 'NodeID', direction: #ASC }],
    orphanedNode.handling: #ROOT_NODES
}]
define view ZC_MM_ALIVIUM_INVENTORY
  as select from    ZI_MM_ALIVIUM_INVENTORY as _Inv
    left outer join makt                    as _Makt on  _Inv.matnr  = _Makt.matnr
                                                     and _Makt.spras = $session.system_language
{
  key  _Inv.iblnr,
  key  _Inv.gjahr,
  key  _Inv.zeili,
  key  _Inv.NodeID,
  key  _Inv.ParentNodeID,
  key  _Inv.HierarchyLevel,
  key  _Inv.DrillState,
       _Inv.matnr,
       _Makt.maktx,
       _Inv.werks,
       _Inv.lgort,
       _Inv.bldat,
       _Inv.budat,
       _Inv.usnam,
       _Inv.buchm,
       _Inv.menge,
       _Inv.meins,
       _Inv.mblnr
}
