@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Imposto retido'
define root view entity ZI_MM_RETENCAO
  as select from bseg      as Item
    inner join   bkpf      as _Header on  _Header.bukrs = Item.bukrs
                                      and _Header.belnr = Item.belnr
                                      and _Header.gjahr = Item.gjahr
    inner join   with_item as _WItem  on  _WItem.bukrs = Item.bukrs
                                      and _WItem.belnr = Item.belnr
                                      and _WItem.gjahr = Item.gjahr
                                      and _WItem.buzei = Item.buzei

{
  key Item.bukrs       as Bukrs,
  key Item.belnr       as Belnr,
  key Item.gjahr       as Gjahr,
      _WItem.wt_withcd as WtWithcd,
      //_WItem.wt_qsshh as WtQsshh,
      //_WItem.wt_qsshb as WtQsshb,
      //_WItem.wt_qssh2 as WtQssh2,
      //_WItem.wt_qssh3 as WtQssh3,
      //_WItem.wt_basman as WtBasman,
      //_WItem.wt_qsshhc as WtQsshhc,
      //_WItem.wt_qsshbc as WtQsshbc,
      //_WItem.wt_qssh2c as WtQssh2c,
      //_WItem.wt_qssh3c as WtQssh3c,
      //_WItem.wt_qbshh as WtQbshh,
      //_WItem.wt_qbshb as WtQbshb,
      //_WItem.wt_qbsh2 as WtQbsh2,
      //_WItem.wt_qbsh3 as WtQbsh3,
      //_WItem.wt_amnman as WtAmnman,
      //_WItem.wt_qbshha as WtQbshha,
      //_WItem.wt_qbshhb as WtQbshhb,
      //_WItem.wt_stat as WtStat,
      //_WItem.wt_qsfhh as WtQsfhh,
      //_WItem.wt_qsfhb as WtQsfhb,
      //_WItem.wt_qsfh2 as WtQsfh2,
      //_WItem.wt_qsfh3 as WtQsfh3,
      //_WItem.wt_wtexmn as WtWtexmn,
      //_WItem.koart as Koart,
      //_WItem.wt_acco as WtAcco,
      //_WItem.hkont as Hkont,
      //_WItem.hkont_opp as HkontOpp,
      //_WItem.qsrec as Qsrec,
      //_WItem.augbl as Augbl,
      //_WItem.augdt as Augdt,
      //_WItem.wt_qszrt as WtQszrt,
      //_WItem.wt_wdmbtr as WtWdmbtr,
      //_WItem.wt_wwrbtr as WtWwrbtr,
      //_WItem.wt_wdmbt2 as WtWdmbt2,
      //_WItem.wt_wdmbt3 as WtWdmbt3,
      //_WItem.text15 as Text15,
      //_WItem.wt_qbuihh as WtQbuihh,
      //_WItem.wt_qbuihb as WtQbuihb,
      //_WItem.wt_qbuih2 as WtQbuih2,
      //_WItem.wt_qbuih3 as WtQbuih3,
      //_WItem.wt_accbs as WtAccbs,
      //_WItem.wt_accwt as WtAccwt,
      //_WItem.wt_accwta as WtAccwta,
      //_WItem.wt_accwtha as WtAccwtha,
      //_WItem.wt_accbs1 as WtAccbs1,
      //_WItem.wt_accwt1 as WtAccwt1,
      //_WItem.wt_accwta1 as WtAccwta1,
      //_WItem.wt_accwtha1 as WtAccwtha1,
      //_WItem.wt_accbs2 as WtAccbs2,
      //_WItem.wt_accwt2 as WtAccwt2,
      //_WItem.wt_accwta2 as WtAccwta2,
      //_WItem.wt_accwtha2 as WtAccwtha2,
      //_WItem.qsatz as Qsatz,
      //_WItem.wt_slfwtpd as WtSlfwtpd,
      //_WItem.wt_gruwtpd as WtGruwtpd,
      //_WItem.wt_opowtpd as WtOpowtpd,
      //_WItem.wt_givenpd as WtGivenpd,
      //_WItem.ctnumber as Ctnumber,
      //_WItem.wt_downc as WtDownc,
      //_WItem.wt_resitem as WtResitem,
      //_WItem.ctissuedate as Ctissuedate,
      //_WItem.j_1af_wt_repbs as J1afWtRepbs,
      //_WItem.wt_calc as WtCalc,
      //_WItem.wt_logsys as WtLogsys,
      //_WItem._dataaging as Dataaging,
      //_WItem.fiwtco_pen_vol_dedo as FiwtcoPenVolDedo,
      //_WItem.vol_contribution as VolContribution,
      //_WItem.co_max_deduction as CoMaxDeduction,
      //_WItem.fiwtco_mand_base as FiwtcoMandBase,
      //_WItem.j_1bwhtcollcode as J1bwhtcollcode,
      //_WItem.j_1bwhtrate as J1bwhtrate,
      //_WItem.j_1bwht_bs as J1bwhtBs,
      //_WItem.j_1bwhtaccbs as J1bwhtaccbs,
      //_WItem.j_1bwhtaccbs1 as J1bwhtaccbs1,
      //_WItem.j_1bwhtaccbs2 as J1bwhtaccbs2,
      //_WItem.j_1iintchln as J1iintchln,
      //_WItem.j_1iintchdt as J1iintchdt,
      //_WItem.j_1iewtrec as J1iewtrec,
      //_WItem.j_1ibuzei as J1ibuzei,
      //_WItem.j_1icertdt as J1icertdt,
      //_WItem.j_1iclramt as J1iclramt,
      //_WItem.j_1irebzg as J1irebzg,
      //_WItem.j_1isuramt as J1isuramt,
      //_WItem.fiwtin_par_exem as FiwtinParExem,

      @Semantics.amount.currencyCode:'Moeda'
      Item.dmbtr       as Valor,
      _Header.waers    as Moeda
}

//    inner join   rbws  as _RBWS   on  _RBWS.belnr = Item.belnr
//                                  and _RBWS.gjahr = Item.gjahr
//                                  and _RBWS.witht = Item.qsskz
//    inner join   t059z as _t059z  on  _t059z.land1     = 'BR'
//                                  and _t059z.witht     = _RBWS.witht
//                                  and _t059z.wt_withcd = _RBWS.wt_withcd
//{
//  key Item.bukrs      as Bukrs,
//  key Item.belnr      as Belnr,
//  key Item.gjahr      as Gjahr,
//      _RBWS.wt_withcd as CodImp,
//      _RBWS.witht     as CatImp,
//      @Semantics.amount.currencyCode:'MoedaImp'
//      Item.dmbtr      as VlrImp,
//      _Header.waers   as MoedaImp,
//      _t059z.qsatz    as TaxaImp
//}
