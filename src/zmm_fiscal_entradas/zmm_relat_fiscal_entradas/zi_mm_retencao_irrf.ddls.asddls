@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Retenção IRRF'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_RETENCAO_IRRF
  as select from ZI_MM_NFDOC_I      as IRRF

    inner join   FNDEI_LFBW_FILTER as _Filter on  _Filter.lifnr     = IRRF.Parid
                                              and _Filter.bukrs     = IRRF.Bukrs
                                              and _Filter.witht     = 'IC'
                                              and _Filter.wt_subjct = 'X'
{
  key IRRF.Docnum,
      IRRF.Pstdat,
      IRRF.Parid,
      IRRF.Bukrs,
      'X' as IRRF
}
where
      IRRF.Nfesrv = 'X'
  and IRRF.Partyp = 'V'
