@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS ITEM/HEADER'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}


define view entity ZI_MM_INVENTARIO_ITEM_H
  as select from           ztmm_inventory_i            as _Main

    left outer to one join ZI_MM_INVENTARIO_FLIN       as _Flin on  _Flin.iblnr = _Main.physinventory
                                                                and _Flin.gjahr = _Main.fiscalyear
  //                                                         and _Flin.matnr = _Main.material
    left outer to one join ZI_MM_PHYSINVTRYDOCHEADER   as _Phy  on  _Phy.PhysicalInventoryDocument = _Main.physinventory
                                                                and _Phy.FiscalYear                = _Main.fiscalyear
    inner join             ZI_MM_INVENTARIO_ITEM_UNICO as _Unic on  _Unic.Documentid = _Main.documentid
                                                                and _Unic.Material   = _Main.material
                                                                and _Unic.Nf         = _Flin.nfenum
    left outer join        ZI_MM_INVENTARIO_BALHDR     as _Bal  on _Bal.Extnumber = lpad(
      _Flin.docnum, 10, '0'
    )
{
  key _Main.documentid                                                                                           as Documentid,
      _Main.material                                                                                             as Material,
      _Main.physinventory                                                                                        as Physinventory,
      _Main.fiscalyear                                                                                           as FiscalYear,
      _Flin.mblnr,
      _Flin.budat,
      _Flin.matnr,
      lpad(_Flin.docnum,10,'0')                                                                                  as docnum,
      _Flin.belnr,
      _Flin.GJAHR_BKPF,
      _Flin.awref_rev,
      _Flin.bldat,
      _Flin.nfenum,
      _Flin.cancel,
      _Flin.docstat,
      _Phy.Bukrs,
      _Bal.Altime,
      concat(substring(_Bal.Altime, 1, 2),concat( substring(_Bal.Altime, 3, 2), substring(_Bal.Altime, 5, 2) ) ) as ExternalRef
}
group by
  _Main.documentid,
  _Main.material,
  _Main.physinventory,
  _Main.fiscalyear,
  _Flin.mblnr,
  _Flin.budat,
  _Flin.matnr,
  _Flin.docnum,
  _Flin.belnr,
  _Flin.GJAHR_BKPF,
  _Flin.awref_rev,
  _Flin.bldat,
  _Flin.nfenum,
  _Flin.cancel,
  _Flin.docstat,
  _Phy.Bukrs,
  _Bal.Altime
