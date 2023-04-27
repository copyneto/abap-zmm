@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Base INSS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_FIS_ENT_BASE_INSS 
as 
    select from 
        I_BR_NFDocument as _Doc 
    inner join 
        I_BR_NFItem as _Item on _Doc.BR_NotaFiscal = _Item.BR_NotaFiscal
{
    key _Doc.BR_NotaFiscal,
    key min(_Item.BR_NotaFiscalItem) as BR_NotaFiscalItem,
    min(_Doc.BR_NFNetAmount) as BR_NFNetAmount
}
group by
    _Doc.BR_NotaFiscal
    
