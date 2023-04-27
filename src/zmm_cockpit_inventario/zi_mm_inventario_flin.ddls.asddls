@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZI_MM_INVENTARIO_FLIN
  as select from    ZI_MM_INVENTARIO_REFKEY as _Key
    left outer join j_1bnflin               as _Flin on  _Flin.refkey = _Key.refkey
                                                     and _Flin.matnr  = _Key.matnr
    inner join      j_1bnfdoc               as _Fdoc on _Fdoc.docnum = _Flin.docnum
    left outer join bkpf                    as _BKP  on _Flin.docnum = _BKP.xblnr
{
  key _Key.iblnr,
  key _Key.gjahr,
      max(  _Key.mblnr)                            as mblnr,
      _Key.budat,
      max( _Key.matnr)                             as matnr,
      max(  cast(_Flin.docnum as abap.char (10)) ) as docnum,
      max(_BKP.belnr )                             as belnr,
      _BKP.gjahr                                   as GJAHR_BKPF,
      max(_BKP.awref_rev )                         as awref_rev,
      _BKP.bldat,
      max( _Fdoc.nfenum )                          as nfenum,
      _Fdoc.cancel,
      _Fdoc.docstat
}
group by
  _Key.iblnr,
  _Key.gjahr,
  _Key.budat,
  _BKP.gjahr,
  _BKP.bldat,
  _Fdoc.cancel,
  _Fdoc.docstat
