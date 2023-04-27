@AbapCatalog.sqlViewName: 'ZVMM_I_XNFE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Dados de Nota Fiscal - GRC'
define view ZI_MM_XNFE
  as select from /xnfe/innfehd as _xhdr
    inner join   /xnfe/innfeit as _xitm on _xhdr.guid_header = _xitm.guid_header
{
  key _xhdr.guid_header as GuidHeader,
      _xhdr.nfeid       as NfeID,
      _xhdr.nnf         as Nnf,
      _xhdr.cnpj_dest   as CnpjDest,
      _xhdr.cnpj_emit   as CnpjEmit,
      _xitm.nitem       as Nitem,
      _xitm.ponumber    as PoNumber,
      _xitm.poitem      as PoItem,
      _xitm.cprod       as Cprod,
      _xitm.cfop        as CFOP,
      _xitm.xprod       as Xprod,
      _xitm.ncm         as NCM
//      cast( _xitm.nitem  as abap.int8 ) as item
}
