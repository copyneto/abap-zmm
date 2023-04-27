@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ekpo bstkd'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity zi_mm_ekpo_bstkd as select from ekpo 
    left outer join ekpa                   as _Ekpa               on  _Ekpa.ebeln = ekpo.ebeln
                                                                  and _Ekpa.parvw = 'ZU'
{
  key ekpo.ebeln,
  //coalesce( _Ekpa.lifn2 , ekpo.werks ) as werks
  key case when _Ekpa.lifn2 is not initial
            then _Ekpa.lifn2 
            else ekpo.werks end as werks
} group by ekpo.ebeln, ekpo.werks, _Ekpa.lifn2
