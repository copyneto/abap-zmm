@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interface Faturas Totais'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_LIB_PGTO_FAT_TOT as 
select from 
    ZI_MM_LIB_PGTO_FAT as _fat
inner join
    ztmm_pag_gv_fat as _fatCheck on  _fat.Empresa = _fatCheck.bukrs
                                 and _fat.NumDocumentoRef = _fatCheck.ebeln
                                 and _fat.NumDocumento = _fatCheck.belnr
                                 and _fat.Item = _fatCheck.buzei
                                 and _fat.Ano = _fatCheck.gjahr
                                 and  _fatCheck.marcado = 'X'
    
    
{
    key _fat.Empresa,
    key _fat.Ano,
    key _fat.NumDocumentoRef,
    //key _fat.NumDocumento,
    _fat.Moeda,            
    @Semantics.amount.currencyCode: 'Moeda'
    sum(_fat.VlMontante) as VlMontanteFatura    
}
group by
    _fat.Empresa,
    _fat.Ano,
    _fat.NumDocumentoRef,    
    //_fat.NumDocumento,
    _fat.Moeda
