@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interface Descontos Fin./Comer. Totais'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_LIB_PGTO_DES_TOT as 
select from 
    ZI_MM_LIB_PGTO_DES as _des
inner join
    ztmm_pag_gv_des as _desCheck on  _des.Empresa = _desCheck.bukrs
                                 and _des.NumDocumentoRef = _desCheck.ebeln
                                 and _des.NumDocumento = _desCheck.belnr
                                 and _des.Item = _desCheck.buzei
                                 and _des.Ano = _desCheck.gjahr
                                 and _desCheck.marcado = 'X'
    
    
{
    key _des.Empresa,
    key _des.Ano,
    key _des.NumDocumentoRef,
    //key _des.NumDocumento,
    _des.TextoCab,
    _des.Moeda,    
    @Semantics.amount.currencyCode: 'Moeda'                    
    sum(_des.VlMontante) as VlMontanteDesconto    
}
group by
    _des.Empresa,
    _des.Ano,
    _des.NumDocumentoRef,
    //_des.NumDocumento,
    _des.TextoCab,
    _des.Moeda
