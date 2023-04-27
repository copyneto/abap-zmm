@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Montante ST'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_FIS_ENT_MONT_ST 
as 
    select from 
        I_BR_NFDocument as _Doc 
    inner join 
        I_BR_NFItem as _Item on _Doc.BR_NotaFiscal = _Item.BR_NotaFiscal
{
    key _Doc.BR_NotaFiscal,
    key _Item.BR_NotaFiscalItem,
    (cast(_Item.BR_SubstituteICMSAmount as abap.dec(15,2)) + cast(_Item.BR_WithholdingICMSSTAmount as abap.dec(15,2)) - cast(_Item.BR_EffectiveICMSAmount as abap.dec(15,2))) as MontanteST
}
