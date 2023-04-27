@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS para calcular a quantidade RET'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_QTDE_RET 
as select from matdoc as _mat
inner join matdoc as _mat2 on _mat.mblnr   = _mat2.mblnr
                               and _mat2.bwart  = '101' 
{
    key _mat.key1,
    key _mat.key2,
    key _mat.key3,
    key _mat.key4,
    key _mat.key5,
    key _mat.key6,
    case 
    when _mat2.menge is not initial
    then
    division( cast(_mat.menge as abap.dec( 13, 2)) ,cast(_mat2.menge as abap.dec( 13, 2)) , 2) end as LvQtdeRet
}


