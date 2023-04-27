@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Filtro campo DEMI /XNFE/INNFEHD'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_FILTRO_DEMI 
as select from /xnfe/innfehd
{
    key guid_header as GuidHeader,
    substring (demi,3,2) as NFYEAR,
    substring (demi,5,2) as NFMONTH
    }
