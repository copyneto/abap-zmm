@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro Montante de Adiantamento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_CLA_MONT_ADIANT
  as select from    ekbe as _Ekbe

    inner join      bseg as _Bseg on  _Bseg.gjahr = _Ekbe.gjahr
                                  and _Bseg.belnr = _Ekbe.belnr
    //                                  and _BsegA.bukrs = _AccDoc.CompanyCode
                                  and _Bseg.buzei = substring(
      _Ekbe.buzei, 2, 3
    )

    left outer join t001 as _T001 on _T001.bukrs = _Bseg.bukrs

{
  key _Ekbe.ebeln      as Ebeln,
  key _Ekbe.ebelp      as Ebelp,
  key _Bseg.bukrs      as Bukrs,
      _T001.waers      as Waers,
      @Semantics.amount.currencyCode: 'Waers'
      sum(_Bseg.dmbtr) as MontanteAdiantamento

}
group by
  _Ekbe.ebeln,
  _Ekbe.ebelp,
  _Bseg.bukrs,
  _T001.waers
