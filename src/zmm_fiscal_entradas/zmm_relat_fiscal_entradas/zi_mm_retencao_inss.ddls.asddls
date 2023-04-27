@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Retenção INSS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_RETENCAO_INSS
  as select from ZI_MM_NFDOC_I              as INSS
  
    inner join   ZI_MM_RETENC_FILT_REFKEY  as _Refkey  on _Refkey.BR_NotaFiscal = INSS.Docnum
    
    inner join   bseg                      as _Contab  on  _Contab.awkey = _Refkey.Refkey
//                                                       and _Contab.hkont = _Param.Hkont
                                                       and _Contab.qsskz = 'IJ' -- INSS
                                                       
    inner join   ESH_N_ACCOUNTING_DOC_BKPF as _Bkpf    on  _Bkpf.bukrs = _Contab.bukrs
                                                       and _Bkpf.belnr = _Contab.belnr
                                                       and _Bkpf.gjahr = _Contab.gjahr
                                                       
//    inner join   FNDEI_LFBW_FILTER         as _Filter  on  _Filter.lifnr     = INSS.Parid
//                                                       and _Filter.bukrs     = INSS.Bukrs
//                                                       and _Filter.witht     = 'IJ' -- INSS - PJ
//                                                       and _Filter.wt_subjct = 'X'

    inner join   ZI_MM_RETENC_REL_NF_INSS  as _Param   on _Param.Active = 'X'
    
    inner join   j_1btxwith                as _Percent on  _Percent.country = INSS.Land1
                                                       and _Percent.value   = INSS.Parid
                                                       and _Percent.coll_ir = _Param.CollIR
                                                       
    inner join I_BR_NFItem  as _NFItem on INSS.Docnum = _NFItem.BR_NotaFiscal                                                         

{
  key INSS.Docnum      as Docnum,
  key min(_NFItem.BR_NotaFiscalItem) as BR_NotaFiscalItem,
      _Bkpf.waers      as hwaer,
      @Semantics.amount.currencyCode: 'hwaer'
      _Contab.wrbtr    as dmbtr_shl,
      _Percent.rate_ir as INSSPercent

}
where
      INSS.Nfesrv = 'X'
  and INSS.Partyp = 'V'
group by
    INSS.Docnum,
    _Bkpf.waers,
    _Contab.wrbtr,
    _Percent.rate_ir
