@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Calcular Estorno'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_INSUMOS_ESTORNO 
as select from matdoc as _mat
inner join matdoc as _mat2  on _mat.key1 = _mat2.key1
                           and _mat.key2 = _mat2.key2
                           and _mat.key3 = _mat2.key3
                           and _mat.key4 = _mat2.key4
                           and _mat.key5 = _mat2.key5
                           and _mat.key6 = _mat2.key6
                           and _mat2.shkzg = 'S'
//right outer join matdoc as _mat3  on _mat2.key1 = _mat3.key1
//                           and _mat2.key2 = _mat3.key2
//                           and _mat.key3 = _mat3.key3
//                           and _mat.key4 = _mat3.key4
//                           and _mat.key5 = _mat3.key5
//                           and _mat.key6 = _mat3.key6
//                           and (_mat2.mblnr <> _mat3.smbln 
//                           and _mat2.smblp <> _mat3.zeile
//                           and _mat2.sjahr <> _mat3.mjahr)
 {
    
key _mat.key1 as Key1,
key _mat.key2 as Key2,
key _mat.key3 as Key3,
key _mat.key4 as Key4,
key _mat.key5 as Key5,
key _mat.key6 as Key6,
_mat.shkzg,
_mat.mblnr,
_mat.zeile,
_mat.mjahr,
_mat2.smbln,
_mat2.smblp,
_mat2.sjahr
}
where _mat.record_type = 'MDOC'
and (_mat.bwart = '543' or _mat.bwart = '544')
