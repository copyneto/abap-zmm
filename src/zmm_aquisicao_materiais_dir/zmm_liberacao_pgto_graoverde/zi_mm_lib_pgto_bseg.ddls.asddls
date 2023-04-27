@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interface BSEG'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_LIB_PGTO_BSEG 
as select from bseg 
{    
    key bukrs as Empresa,  
    key belnr as NumDocumento,  
    key ebeln as NumDocumentoRef,
    key gjahr as Ano,      
    koart as TipoConta     
}
group by
    bukrs,
    belnr,
    ebeln,
    gjahr,    
    koart
