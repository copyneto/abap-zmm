@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'View Conta Contábil Material'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_ESTQ_OBS_CC as select from bkpf as _docContabil 
inner join bseg as _segContabil on ( _docContabil.belnr = _segContabil.belnr and
                                     _docContabil.bukrs = _segContabil.bukrs and
                                     _docContabil.gjahr = _segContabil.gjahr ) 
//inner join I_GLAccountText as _TextAcc on (_segContabil.hkont = _TextAcc.GLAccount)
inner join ZI_PM_VH_CONTA as _TextAcc on (_segContabil.hkont = _TextAcc.Conta)                                     
{
    key _docContabil.awkey as Chave,
    key _segContabil.hkont as NumeroConta,
        _TextAcc.NomeConta as NomeConta
}
where
    (( _segContabil.koart = 'M' ) or ( _segContabil.koart = 'S' and _segContabil.shkzg = 'S' ))
group by 
    _docContabil.awkey,
    _segContabil.hkont,
    _TextAcc.NomeConta
         
