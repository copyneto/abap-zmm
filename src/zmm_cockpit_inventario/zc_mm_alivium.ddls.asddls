@AbapCatalog.sqlViewName: 'ZCMMALIVIUM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Fluxo de Documentos Projeto Alivium'
define view ZC_MM_ALIVIUM
  as select from    ZC_MM_ALIVIUM_INVENTORY as _Inventory
    left outer join ZI_MM_ALIVIUM           as _Alivium on  _Inventory.iblnr = _Alivium.Iblnr
                                                        and _Inventory.gjahr = _Alivium.Gjahr
    left outer join ZC_MM_ALIVIUM_NFEDOC    as _Nfedoc  on  _Alivium.DocnumEntrada = _Nfedoc.docnum
                                                        and _Nfedoc.direct         = '1'
{
  key _Inventory.iblnr,
  key _Inventory.gjahr,
  key _Alivium.Bukrs,
  key _Inventory.werks,
  key _Inventory.lgort,
  key _Inventory.bldat,
  key _Alivium.Mblnr,
  key _Inventory.zeili,
  key _Inventory.NodeID,
  key _Inventory.ParentNodeID,
  key _Inventory.HierarchyLevel,
  key _Inventory.DrillState,
      _Inventory.budat,
      _Inventory.usnam,
      _Alivium.DocnumEntrada,
      _Alivium.DocnumSaida,
      _Alivium.Belnr,
      _Alivium.Belnr_estorn,
      _Alivium.Status_belnr,
      _Nfedoc.Nfenum_en,
      _Nfedoc.status_nf_en,

      _Nfedoc.nfenum,

      case
        when _Alivium.DocnumEntrada is initial and _Alivium.DocnumSaida is initial
          then ''
        when _Nfedoc.nfenum is initial
          then '-1' // 'sap-icon://warning2'               //
        when _Nfedoc.nfenum is not initial and _Nfedoc.docstat is initial
          then '0'  // 'sap-icon://activities'             //
        when ( _Nfedoc.docstat = '1' and _Nfedoc.code <> '100' ) or _Nfedoc.cancel = 'X' or _Nfedoc.action_requ = 'C'
          then '1'  // 'sap-icon://complete'               //
        when _Nfedoc.docstat = '2'
          then '2'   // 'sap-icon://alert'                  //
        else
               '3'   // 'sap-icon://error'                  //
      end                                                               as Docstat_icon,

      case
        when ( _Nfedoc.code <> '100' and _Nfedoc.docstat = '1' ) or _Nfedoc.cancel = 'X'
          then 'X' //'sap-icon://undo'                   //
        else
          ''
      end                                                               as status_nf,

      _Nfedoc.docstat_icon_en,
      _Inventory.matnr,
      _Inventory.buchm,
      _Inventory.menge,
      _Inventory.meins,

      cast( ( _Inventory.menge - _Inventory.buchm ) as abap.dec(13,3) ) as Difmg,

      _Nfedoc.docstat,
      _Nfedoc.code,
      _Nfedoc.cancel,

      _Alivium.last_changed_at,
      _Alivium.last_changed_by,
      _Alivium.created_at,
      _Alivium.created_by,
      _Alivium.local_last_changed_at

}
union select from ZC_MM_ALIVIUM_INVENTORY as _Inventory
  left outer join ZI_MM_ALIVIUM           as _Alivium on  _Inventory.iblnr = _Alivium.Iblnr
                                                      and _Inventory.gjahr = _Alivium.Gjahr
  left outer join ZC_MM_ALIVIUM_NFEDOC    as _Nfedoc  on  _Alivium.DocnumSaida = _Nfedoc.docnum
                                                      and _Nfedoc.direct       = '2'
{
  key _Inventory.iblnr,
  key _Inventory.gjahr,
  key _Alivium.Bukrs,
  key _Inventory.werks,
  key _Inventory.lgort,
  key _Inventory.bldat,
  key _Alivium.Mblnr,
  key _Inventory.zeili,
      _Inventory.NodeID,
      _Inventory.ParentNodeID,
      _Inventory.HierarchyLevel,
      _Inventory.DrillState,
      _Inventory.budat,
      _Inventory.usnam,
      _Alivium.DocnumEntrada,
      _Alivium.DocnumSaida,
      _Alivium.Belnr,
      _Alivium.Belnr_estorn,
      _Alivium.Status_belnr,
      _Nfedoc.Nfenum_en,
      _Nfedoc.status_nf_en,

      _Nfedoc.nfenum,

      case
        when _Alivium.DocnumEntrada is initial and _Alivium.DocnumSaida is initial
          then ''
        when _Nfedoc.nfenum is initial
          then '-1' // 'sap-icon://warning2'               //
        when _Nfedoc.nfenum is not initial and _Nfedoc.docstat is initial
          then '0'  // 'sap-icon://activities'             //
        when ( _Nfedoc.docstat = '1' and _Nfedoc.code <> '100' ) or _Nfedoc.cancel = 'X' or _Nfedoc.action_requ = 'C'
          then '1'  // 'sap-icon://complete'               //
        when _Nfedoc.docstat = '2'
          then '2'   // 'sap-icon://alert'                  //
        else
               '3'   // 'sap-icon://error'                  //
      end                                                               as Docstat_icon,

      case
        when ( _Nfedoc.code <> '100' and _Nfedoc.docstat = '1' ) or _Nfedoc.cancel = 'X'
          then 'X' //'sap-icon://undo'                   //
        else
          ''
      end                                                               as status_nf,

      _Nfedoc.docstat_icon_en,
      _Inventory.matnr,
      _Inventory.buchm,
      _Inventory.menge,
      _Inventory.meins,

      cast( ( _Inventory.menge - _Inventory.buchm ) as abap.dec(13,3) ) as Difmg,

      _Nfedoc.docstat,
      _Nfedoc.code,
      _Nfedoc.cancel,

      _Alivium.last_changed_at,
      _Alivium.last_changed_by,
      _Alivium.created_at,
      _Alivium.created_by,
      _Alivium.local_last_changed_at
}
