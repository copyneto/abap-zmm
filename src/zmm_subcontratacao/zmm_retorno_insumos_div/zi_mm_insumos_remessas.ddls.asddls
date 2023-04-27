@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS seleciona REMESSAS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity  ZI_MM_INSUMOS_REMESSAS 
as select from eket as _ek      

inner join eket as _et       on _ek.ebeln = _et.ebeln
                            and _ek.ebelp = _et.ebelp
                            
inner join resb as _rs       on _rs.rsnum = _et.rsnum
                            
{
key _ek.ebeln,
key _ek.ebelp,
_et.rsnum,
_rs.matnr,
_rs.lifnr,
cast (_ek.menge as abap.dec(13,3)) as Menge,
//@Semantics.quantity.unitOfMeasure : 'meins'
//cast (sum(_rs.bdmng) as abap.dec(13,2)) as Bdmng
cast (sum(_rs.bdmng) as abap.dec(13,3)) as Bdmng,
_rs.meins
}
//where _ek.ebeln = '4500000199'
//and  _ek.ebelp = '00010'
group by
_ek.ebeln,
_ek.ebelp,
_et.rsnum,
_ek.menge,
_rs.matnr,
_rs.lifnr,
_rs.meins
