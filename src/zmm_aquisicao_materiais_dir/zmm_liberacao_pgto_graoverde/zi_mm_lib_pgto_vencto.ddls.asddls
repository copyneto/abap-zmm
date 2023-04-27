@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interface Vencimento Líquido'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_LIB_PGTO_VENCTO as 
select from bseg as _bseg 
{
  key _bseg.bukrs                  as Empresa,
  key _bseg.gjahr                  as Ano,
  key _bseg.belnr                  as NumDocumento,   
  max(_bseg.netdt)                 as DtVencimentoLiquido
}    
where
  _bseg.netdt is not initial and
  _bseg.koart = 'K'   
group by
  _bseg.bukrs,
  _bseg.gjahr,
  _bseg.belnr  
