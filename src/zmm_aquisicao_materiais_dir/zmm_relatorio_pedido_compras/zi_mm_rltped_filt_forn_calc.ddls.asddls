@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro Calculo Mercadorias'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_RLTPED_FILT_FORN_CALC 
as
    select from ekpo

    left outer join ZI_MM_RLTPED_FILT_FORN_EM      as _VlrForEm                 on  _VlrForEm.Ebeln = ekpo.ebeln
                                                                                and _VlrForEm.Ebelp = ekpo.ebelp
                                                                                
    left outer join ZI_MM_RLTPED_FILT_FORN_SM      as _VlrForSm                 on  _VlrForSm.Ebeln = ekpo.ebeln
                                                                                and _VlrForSm.Ebelp = ekpo.ebelp   
{
    key ekpo.ebeln,
    key ekpo.ebelp,
    case when ekpo.elikz = 'X' 
        then 0
        else sum( cast(ekpo.menge as abap.dec(13,3)) - coalesce(cast(_VlrForEm.Menge as abap.dec(13,3)),0) + coalesce(cast(_VlrForSm.Menge as abap.dec(13,3)),0)) 
    end as A_Ser_For    
}
group by
    ekpo.ebeln,
    ekpo.ebelp,
    ekpo.elikz
