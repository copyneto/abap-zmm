@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro Calculo Entrada Fatura'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_RLTPED_FILT_FAT_CALC 
as
    select from ekpo

    left outer join ZI_MM_RLTPED_FILT_FAT_EF      as _VlrFatEf                 on  _VlrFatEf.Ebeln = ekpo.ebeln
                                                                               and _VlrFatEf.Ebelp = ekpo.ebelp
                                                                                
    left outer join ZI_MM_RLTPED_FILT_FAT_SF      as _VlrFatSf                 on  _VlrFatSf.Ebeln = ekpo.ebeln
                                                                               and _VlrFatSf.Ebelp = ekpo.ebelp   
{
    key ekpo.ebeln,
    key ekpo.ebelp,
    case when ekpo.elikz = 'X'
        then 0
        else sum( cast(ekpo.menge as abap.dec(13,3)) - coalesce(cast(_VlrFatEf.Menge as abap.dec(13,3)),0) + coalesce(cast(_VlrFatSf.Menge as abap.dec(13,3)), 0)) 
    end as A_Ser_Fat    
}
group by
    ekpo.ebeln,
    ekpo.ebelp,
    ekpo.elikz
