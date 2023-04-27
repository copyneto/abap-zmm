@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interface Totais'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_LIB_PGTO_TOT as 
select from 
    ZI_MM_LIB_PGTO_CAB as _cab                                            
left outer join
    ZI_MM_LIB_PGTO_FAT_TOT         as _fatTot on  _cab.Empresa      = _fatTot.Empresa
                                              and _cab.Ano          = _fatTot.Ano
                                              and _cab.NumDocumento = _fatTot.NumDocumentoRef                                                                                     
    
left outer join
    ZI_MM_LIB_PGTO_ADI_TOT         as _adiTot on  _cab.Empresa      = _adiTot.Empresa
                                              and _cab.Ano          = _adiTot.Ano
                                              and _cab.NumDocumento = _adiTot.NumDocumentoRef                                               

left outer join
    ZI_MM_LIB_PGTO_DEV_TOT         as _devTot on  _cab.Empresa      = _devTot.Empresa
                                              and _cab.Ano          = _devTot.Ano
                                              and _cab.NumDocumento = _devTot.NumDocumentoRef                                                

left outer join
    ZI_MM_LIB_PGTO_DES_TOT         as _desTotFin on  _cab.Empresa       = _desTotFin.Empresa
                                                 and _cab.Ano           = _desTotFin.Ano
                                                 and _cab.NumDocumento  = _desTotFin.NumDocumentoRef
                                                 and _desTotFin.TextoCab= 'DESCONTO FINANCEIRO'
                                                 
left outer join
    ZI_MM_LIB_PGTO_DES_TOT         as _desTotCom on  _cab.Empresa       = _desTotCom.Empresa
                                                 and _cab.Ano           = _desTotCom.Ano
                                                 and _cab.NumDocumento  = _desTotCom.NumDocumentoRef
                                                 and _desTotCom.TextoCab= 'DESCONTO COMERCIAL'                                                 

{
    key _cab.Empresa,
    key _cab.Ano,
    key _cab.NumDocumento,
    case when
        _fatTot.Moeda is null  
        then cast( 'BRL' as waers ) 
        else _fatTot.Moeda end as MoedaFat,    
    //_fatTot.Moeda as MoedaFat,
    
    @Semantics.amount.currencyCode: 'MoedaFat'
    //_fatTot.VlMontanteFatura,
    case when
        _fatTot.VlMontanteFatura is initial 
        then cast('0' as abap.dec( 23, 2 ) ) 
        else cast(_fatTot.VlMontanteFatura as abap.dec( 23, 2 )) * -1 end as VlMontanteFatura,
    
    case when
        _fatTot.Moeda is null  
        then cast( 'BRL' as waers ) 
        else _fatTot.Moeda end as MoedaAdi,      
        
    //_adiTot.Moeda as MoedaAdi,
    @Semantics.amount.currencyCode: 'MoedaAdi'
    _adiTot.VlMontanteAdiantamento,
    
    case when
        _devTot.Moeda is null  
        then cast( 'BRL' as waers ) 
        else _devTot.Moeda end as MoedaDev,      
    //_devTot.Moeda as MoedaDev,
    @Semantics.amount.currencyCode: 'MoedaDev'
    
    //_devTot.VlMontanteDevolucao 
    case when
        _devTot.VlMontanteDevolucao is initial 
        then cast('0' as abap.dec( 23, 2 ) ) 
        else cast(_devTot.VlMontanteDevolucao as abap.dec( 23, 2 )) * -1 end as VlMontanteDevolucao,
        
    case when
        _desTotFin.Moeda is null  
        then cast( 'BRL' as waers ) 
        else _desTotFin.Moeda end as MoedaDesFin,          
    @Semantics.amount.currencyCode: 'MoedaDesFin'
    
    //_devTot.VlMontanteDevolucao 
    case when
        _desTotFin.VlMontanteDesconto is initial 
        then cast('0' as abap.dec( 23, 2 ) ) 
        else cast(_desTotFin.VlMontanteDesconto as abap.dec( 23, 2 )) * -1 end as VlMontanteDescontoFinanceiro,
        
    case when
        _desTotCom.Moeda is null  
        then cast( 'BRL' as waers ) 
        else _desTotCom.Moeda end as MoedaDesCom,          
    @Semantics.amount.currencyCode: 'MoedaDesCom'
    
    //_devTot.VlMontanteDevolucao 
    case when
        _desTotCom.VlMontanteDesconto is initial 
        then cast('0' as abap.dec( 23, 2 ) ) 
        else cast(_desTotCom.VlMontanteDesconto as abap.dec( 23, 2 )) * -1 end as VlMontanteDescontoComercial,   
        
     cast( 'BRL' as waers ) as MoedaTot,
     @Semantics.amount.currencyCode: 'MoedaTot'
     case when _fatTot.VlMontanteFatura > 0
     then     
    (   
        case when _fatTot.VlMontanteFatura is initial or _fatTot.VlMontanteFatura is null then cast('0' as abap.dec(23,2)) else cast(_fatTot.VlMontanteFatura as abap.dec(23,2)) end -
        case when _adiTot.VlMontanteAdiantamento is initial or _adiTot.VlMontanteAdiantamento is null then cast('0' as abap.dec(23,2)) else cast(_adiTot.VlMontanteAdiantamento as abap.dec(23,2)) end - 
        case when _devTot.VlMontanteDevolucao is initial or _devTot.VlMontanteDevolucao is null then cast('0' as abap.dec(23,2)) else cast(_devTot.VlMontanteDevolucao as abap.dec(23,2)) end -
        case when _desTotFin.VlMontanteDesconto is initial or _desTotFin.VlMontanteDesconto is null then cast('0' as abap.dec(23,2)) else cast(_desTotFin.VlMontanteDesconto as abap.dec(23,2)) end -
        case when _desTotCom.VlMontanteDesconto is initial or _desTotCom.VlMontanteDesconto is null then cast('0' as abap.dec(23,2)) else cast(_desTotCom.VlMontanteDesconto as abap.dec(23,2)) end                   
     )
     else             
        case when _adiTot.VlMontanteAdiantamento is initial or _adiTot.VlMontanteAdiantamento is null then cast('0' as abap.dec(23,2)) else cast(_adiTot.VlMontanteAdiantamento as abap.dec(23,2)) end -
        case when _fatTot.VlMontanteFatura is initial or _fatTot.VlMontanteFatura is null then cast('0' as abap.dec(23,2)) else cast(_fatTot.VlMontanteFatura as abap.dec(23,2)) end - 
        case when _devTot.VlMontanteDevolucao is initial or _devTot.VlMontanteDevolucao is null then cast('0' as abap.dec(23,2)) else cast(_devTot.VlMontanteDevolucao as abap.dec(23,2)) end -
        case when _desTotFin.VlMontanteDesconto is initial or _desTotFin.VlMontanteDesconto is null then cast('0' as abap.dec(23,2)) else cast(_desTotFin.VlMontanteDesconto as abap.dec(23,2)) end -
        case when _desTotCom.VlMontanteDesconto is initial or _desTotCom.VlMontanteDesconto is null then cast('0' as abap.dec(23,2)) else cast(_desTotCom.VlMontanteDesconto as abap.dec(23,2)) end                
                     
     end  * -1 as VlTotal                                  
}
