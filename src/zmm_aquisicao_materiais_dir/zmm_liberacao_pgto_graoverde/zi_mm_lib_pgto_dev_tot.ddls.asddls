@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interface Devoluções Totais'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_LIB_PGTO_DEV_TOT as 
select from 
    ZI_MM_LIB_PGTO_DEV as _dev
inner join
    ztmm_pag_gv_dev as _devCheck on  _dev.Empresa = _devCheck.bukrs
                                 and _dev.NumDocumentoRef = _devCheck.ebeln
                                 and _dev.NumDocumento = _devCheck.belnr
                                 and _dev.Item = _devCheck.buzei
                                 and _dev.Ano = _devCheck.gjahr
                                 and _devCheck.marcado = 'X'
    
    
{
    key _dev.Empresa,
    key _dev.Ano,
    key _dev.NumDocumentoRef,
    //key _dev.NumDocumento,
    _dev.Moeda,
    @Semantics.amount.currencyCode: 'Moeda'                    
    sum(_dev.VlMontante) as VlMontanteDevolucao    
}
group by
    _dev.Empresa,
    _dev.Ano,
    _dev.NumDocumentoRef,
    //_dev.NumDocumento,
    _dev.Moeda
