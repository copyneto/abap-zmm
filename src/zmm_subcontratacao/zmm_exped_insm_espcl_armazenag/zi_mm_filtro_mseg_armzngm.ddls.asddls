@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro de MSEG'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_FILTRO_mseg_armzngm
  as select from    nsdm_e_mseg as Mseg

    left outer join nsdm_e_mseg as Mseg_flt on  Mseg_flt.xauto = 'X'
                                            and Mseg_flt.shkzg = 'H'
                                            and Mseg_flt.smbln = Mseg.mblnr
                                            and Mseg_flt.smblp = Mseg.zeile
                                            and Mseg_flt.sjahr = Mseg.mjahr

{
  key max(Mseg.mblnr) as Mblnr,
  key min(Mseg.mjahr) as Mjahr,
  key min(Mseg.zeile) as Zeile,
      Mseg.vbeln_im   as VBELN_IM,
      //      Mseg.vbelp_im       as VBELP_IM,
      case
      when Mseg_flt.xauto is not null
      then 'X'
      else '' end     as Cancelad
}
where
      Mseg.xauto    =  'X'
  and Mseg.shkzg    <> 'H'
//  and Mseg.ebeln    is not initial
  and Mseg.vbeln_im is not initial

group by
  Mseg.vbeln_im,
  Mseg_flt.xauto
//  Mseg.vbelp_im
