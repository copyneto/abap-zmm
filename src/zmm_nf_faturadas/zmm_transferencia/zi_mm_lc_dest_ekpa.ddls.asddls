@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Local e Centro Destino'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_LC_DEST_EKPA as 
select from C_BR_VerifyNotaFiscal as _VerifyNotaFiscal 
join vbak as _Vbak on _VerifyNotaFiscal.OriginReferenceDocument = _Vbak.vbeln
join ekpa as _Ekpa on _Vbak.bstnk = _Ekpa.ebeln and _Ekpa.parvw = 'ZU' 
{
    key _VerifyNotaFiscal.BR_NotaFiscal,
    key  cast(substring(_Ekpa.lifn2, 7, 4) as werks_d)  as lifn2              
}
group by
    _VerifyNotaFiscal.BR_NotaFiscal,
    _Ekpa.lifn2
