@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interface Adiantamentos Totais'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_LIB_PGTO_ADI_TOT as 
select from 
    ZI_MM_LIB_PGTO_ADI as _adi
inner join
    ztmm_pag_gv_adi as _adiCheck on  _adi.Empresa = _adiCheck.bukrs
                                 and _adi.NumDocumentoRef = _adiCheck.ebeln
                                 and _adi.NumDocumento = _adiCheck.belnr
                                 and _adi.Item = _adiCheck.buzei
                                 and _adi.Ano = _adiCheck.gjahr
                                 and _adiCheck.marcado = 'X'
    
    
{
    key _adi.Empresa,
    key _adi.Ano,
    key _adi.NumDocumentoRef,
    //key _adi.NumDocumento,
    _adi.Moeda,
    @Semantics.amount.currencyCode: 'Moeda'                
    sum(_adi.VlMontante) as VlMontanteAdiantamento    
}
group by
    _adi.Empresa,
    _adi.Ano,
    _adi.NumDocumentoRef,
    //_adi.NumDocumento,
    _adi.Moeda
