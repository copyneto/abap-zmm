@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interface Descontos'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_LIB_PGTO_DESC as 
select from 
    ztmm_desc_pag_gv 
{
    key ebeln as Ebeln,    
    key docnum as Docnum,
    status as Status,
    waers as Waers,   
    @Semantics.amount.currencyCode : 'waers'
    vlr_desconto_fin as VlrDescontoFin,    
    observacao_fin as ObservacaoFin,
    usuario_fin as UsuarioFin,
    data_fin as DataFin,
    last_changed_by as LastChangedBy,
    last_changed_at as LastChangedAt,
    local_last_changed_at as LocalLastChangedAt    
}
