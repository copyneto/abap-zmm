@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Adm Retorno de Insumos Divergentes'
define view entity ZI_MM_RET_INSUMOS_DIV2 
as select from matdoc as _mat

left outer join  ZI_MM_INSUMOS_ESTORNO as _mat2  on _mat.key1 = _mat2.Key1
                                                and _mat.key2 = _mat2.Key2
                                                //and _mat.key3 = _mat2.Key3
                                                //and _mat.key4 = _mat2.Key4
                                                //and _mat.key5 = _mat2.Key5
                                                //and _mat.key6 = _mat2.Key6
                                               and _mat.mblnr = _mat2.mblnr
                                                and _mat.zeile = _mat2.smblp
//                                               and _mat.mjahr = _mat2.sjahr

//inner join matdoc as _mat2 on _mat.key1 = _mat2.key1
//                                           and _mat.key2 = _mat2.key2
//                                           and _mat.key3 = _mat2.key3
//                                           and _mat.key4 = _mat2.key4
//                                           and _mat.key5 = _mat2.key5
//                                           and _mat.key6 = _mat2.key6
//                                           and _mat.mblnr = _mat2.smbln
 {
    
key _mat.key1 as Key1,
key _mat.key2 as Key2,
key _mat.key3 as Key3,
key _mat.key4 as Key4,
key _mat.key5 as Key5,
key _mat.key6 as Key6,

//_mat.shkzg,
_mat.mblnr,
_mat.zeile,
_mat.mjahr,
//_mat.smbln,
//_mat.smblp,
//_mat.sjahr,

//_mat2.shkzg as shkzg2,
//_mat2.mblnr as mblnr2,
//_mat2.zeile as zeile2,
//_mat2.mjahr as mjahr2,
_mat2.smbln as smbln2,
_mat2.smblp as smblp2,
_mat2.sjahr as sjahr2,
case
when _mat.mblnr = _mat2.smbln and _mat.zeile = _mat2.smblp and _mat.mjahr = _mat2.sjahr 
then 'X'
else ' ' end as Teste
}
where _mat.record_type = 'MDOC'
and (_mat.bwart = '543' or _mat.bwart = '544')
and _mat.shkzg <>'S'
