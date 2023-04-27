@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro Entrada de Fatura Débito'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_RLTPED_FILT_FAT_EF 
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
  ekbe.vgabe  = '2' and
  ekbe.shkzg = 'S' and
  ekbe.waers = 'BRL'
group by
  ekbe.ebeln,
  ekbe.ebelp,
  ekbe.waers,
  ekpo.meins
