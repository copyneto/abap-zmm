@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'NFE - Último Evento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_3C_NF_ULTIMO_EVENT 
as select from /xnfe/events as _Event
{        
    
    key _Event.chnfe as ChaveNFe,                
    max(_Event.dhevento) as DtEvento,
    max(_Event.createtime) as Createtime 
}
group by        
    _Event.chnfe    
