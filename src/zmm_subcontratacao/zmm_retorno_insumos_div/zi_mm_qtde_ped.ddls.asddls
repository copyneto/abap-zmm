@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS para calcular a quantidade de pedido'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_QTDE_PED
  as select from   matdoc as _mat
    inner join matdoc as _mat2 on  _mat.mblnr  = _mat2.mblnr
                                    and _mat2.bwart = '101'
    inner join      ekpo   as _ek   on  _mat2.ebeln = _ek.ebeln
                                    and _mat2.ebelp = _ek.ebelp
    inner join eket   as _et   on  _ek.ebeln = _et.ebeln
                                    and _ek.ebelp = _et.ebelp
    inner join resb   as _rs   on _et.rsnum = _rs.rsnum
{
  key _mat.key1,
  key _mat.key2,
  key _mat.key3,
  key _mat.key4,
  key _mat.key5,
  key _mat.key6,
  case
  when _ek.menge is not initial
  then
(division(cast(_rs.bdmng as abap.dec( 13, 2)) , cast(_ek.menge as abap.dec( 13, 2)), 2) * cast(_mat2.menge as abap.dec( 13, 2) )) end as LvQtdePed
}
//group by
//_mat.key1,
//_mat.key2,
//_mat.key3,
//_mat.key4,
//_mat.key5,
//_mat.key6
