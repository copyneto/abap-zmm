@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro Saídas Mercadorias'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_RLTPED_FILT_FORN_SM 
  as select from ekbe

    inner join   ekpo on  ekpo.ebeln = ekbe.ebeln
                      and ekpo.ebelp = ekbe.ebelp                      
{

  key ekbe.ebeln      as Ebeln,
  key ekbe.ebelp      as Ebelp,
      ekbe.waers      as Waers,
      ekpo.meins      as Meins,

      @Semantics.quantity.unitOfMeasure: 'Meins'
      sum(ekbe.menge) as Menge,
      @Semantics.amount.currencyCode: 'Waers'
      sum(ekbe.wrbtr) as Wrbtr

}
where
  ekbe.vgabe  = '1' and
  ekbe.shkzg = 'H' and
  ekbe.waers = 'BRL'
group by
  ekbe.ebeln,
  ekbe.ebelp,
  ekbe.waers,
  ekpo.meins
