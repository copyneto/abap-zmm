@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS seleciona Documentos'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_INSUMOS_DOC 
as select from matdoc as _mat
inner join matdoc as _mat2   on _mat.mblnr = _mat2.mblnr
                            and _mat.mjahr = _mat2.mjahr
                            and _mat2.bwart = '101'
left outer join rseg as _rg       on _mat2.mblnr = _rg.lfbnr
                                 and _mat2.mjahr = _rg.lfgja
                                 and _mat2.zeile = _rg.lfpos
inner join j_1bnfdoc as _jb      on _rg.belnr = _jb.belnr and _jb.cancel <> 'X' and _jb.doctyp <> '5'


 {
    
key _mat.key1 as Key1,
key _mat.key2 as Key2,
key _mat.key3 as Key3,
key _mat.key4 as Key4,
key _mat.key5 as Key5,
key _mat.key6 as Key6,
_mat2.mblnr,
_mat2.mjahr,
_rg.lfbnr,
_rg.lfgja,
_rg.lfpos,
_rg.belnr,
_jb.docnum,
_jb.nfenum
}
//where _mat.record_type = 'MDOC'
//and (_mat.bwart = '543' or _mat.bwart = '544')
//and _mat.shkzg <> 'S'
