@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro na tabela MSEG'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_FILTRO_MSEG_CALC
  as select from    nsdm_e_mseg as Mseg

    left outer join nsdm_e_mseg as Mseg_flt on  Mseg_flt.xauto = 'X'
                                            and Mseg_flt.shkzg = 'H'
                                            and Mseg_flt.smbln = Mseg.mblnr
                                            and Mseg_flt.smblp = Mseg.zeile
                                            and Mseg_flt.sjahr = Mseg.mjahr

{
  key Mseg.mblnr                     as Mblnr,
  key Mseg.mjahr                     as Mjahr,
  key Mseg.zeile                     as Zeile,
      Mseg.ebeln                     as Ebeln,
      Mseg.ebelp                     as Ebelp,
      Mseg.vbeln_im                  as VBELN_IM,
      Mseg.vbelp_im                  as VBELP_IM,
      Mseg.meins                     as Meins,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      Mseg.menge                     as Menge,
      case
      when Mseg_flt.xauto is not null 
      then 'X'
      else '' end                    as Cancelad,

      concat(Mseg.mblnr, Mseg.mjahr) as refkey
}
where
      Mseg.xauto    = 'X'
  and Mseg.shkzg    <> 'H'
  and Mseg.ebeln    is not initial
  and Mseg.vbeln_im is not initial
