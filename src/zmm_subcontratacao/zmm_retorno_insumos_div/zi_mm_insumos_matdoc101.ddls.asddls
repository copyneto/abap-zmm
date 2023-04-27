@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS seleciona MATDOC 101'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_INSUMOS_MATDOC101 
as select from matdoc as _mat
inner join matdoc as _mat2   on _mat.mblnr = _mat2.mblnr
                            and _mat.mjahr = _mat2.mjahr
                            and _mat2.bwart = '101'
//inner join ekpo as _ek      on _mat2.ebeln = _ek.ebeln
//                            and _mat2.ebelp = _ek.ebelp
//inner join eket as _et       on _ek.ebeln = _et.ebeln
//                            and _ek.ebelp = _et.ebelp
inner join ZI_MM_INSUMOS_REMESSAS  as _rs on _mat2.ebeln = _rs.ebeln
                                         and _mat2.ebelp = _rs.ebelp
                                         and _mat.matnr = _rs.matnr

 {
    
key _mat.key1 as Key1,
key _mat.key2 as Key2,
key _mat.key3 as Key3,
key _mat.key4 as Key4,
key _mat.key5 as Key5,
key _mat.key6 as Key6,
cast(_mat.menge as abap.dec(13,3)) as MatMenge,
cast(_mat2.menge as abap.dec(13,3)) as MatMenge101,
_mat2.bwart,
_mat2.ebeln,
_mat2.ebelp,
_rs.matnr,
_rs.lifnr,
_rs.Menge,
_rs.Bdmng,
_rs.meins,
//_rs.Bdmng as LvQtdePed,
//case
//when _rs.Menge is not initial
//then (cast(_rs.Bdmng as abap.fltp) / cast(_rs.Menge as abap.fltp)) * cast(_mat2.menge as abap.fltp)
//then division(_rs.Bdmng, _rs.Menge,2) * cast(_mat2.menge as abap.dec(13,2))
//end as LvQtdePed,
//division(_rs.Bdmng, _rs.Menge, 2) as test,
//cast(_rs.Bdmng as abap.fltp ) / cast(_rs.Menge as abap.fltp ) as test2,

/*case when _rs.Menge is not initial
then 
    fltp_to_dec( ((cast(_rs.Bdmng as abap.fltp ) / cast(_rs.Menge as abap.fltp )) * (cast(_mat2.menge as abap.fltp))) as abap.dec(18,2))        
else
    _rs.Bdmng end as LvQtdePed,*/
//_rs.Bdmng as LvQtdePed,
cast(_rs.Bdmng as abap.dec(13,3)) as  LvQtdePed,
--(division(cast(_rs.Bdmng as abap.dec( 13, 3)) , cast(_rs.Menge as abap.dec( 13, 3)), 3) * cast(_mat2.menge as abap.dec( 13, 3) )) as LvQtdePed,



//cast(_rs.Bdmng as abap.dec(13,2)) as LvQtdePed,    
//then division(_rs.Bdmng, _rs.Menge, 2)

//case
//when _mat2.menge is not initial
//then division(cast(_mat.menge as abap.dec(13,2)), cast(_mat2.menge as abap.dec(13,2)), 2) 
//end as LvQtdeRet
cast(_mat.menge as abap.dec(13,3)) as  LvQtdeRet

}
where _mat.record_type = 'MDOC'
and (_mat.bwart = '543' or _mat.bwart = '544')

