@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Retenção ISS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_RETENCAO_ISS
  as select from ZI_MM_NFDOC_I      as ISS

    inner join   FNDEI_LFBW_FILTER as _Filter on  _Filter.lifnr     = ISS.Parid
                                              and _Filter.bukrs     = ISS.Bukrs
                                              and (
                                                 _Filter.witht      = 'IS'
                                                 or _Filter.witht   = 'IW'
                                               )
                                              and _Filter.wt_subjct = 'X'
{
  key ISS.Docnum,
      ISS.Pstdat,
      ISS.Parid,
      ISS.Bukrs,
      'X' as ISS
}
where
      ISS.Nfesrv = 'X'
  and ISS.Partyp = 'V'
