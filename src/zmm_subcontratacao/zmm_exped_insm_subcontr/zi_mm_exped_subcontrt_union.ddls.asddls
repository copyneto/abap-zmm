@AbapCatalog.sqlViewName: 'ZVMM_EXSUBC_UNN'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Exped. Subcontratação - Union de Status'
define view ZI_MM_EXPED_SUBCONTRT_UNION
  as 
  
  select from ZI_MM_RESB_STATUS_PROC as _Proc
  //    left outer join ztmm_sb_picking as _Picking on  _Picking.rsnum = _Proc.Rsnum
  //                                                and _Picking.rspos = '9999'
{
  key _Proc.Rsnum,
  key _Proc.Rspos,
      //  key _Picking.item as Item,
  key hextobin( '00000000000000000000000000000000' ) as Item,
  key _Proc.Vbeln,
      Ebeln,
      Ebelp,
      BDTER,
      Werks,
      Lifnr,
      DescForn,
      Matnr,
      _Proc.Meins,
      _Proc.Charg,
      _Proc.Picking,
      Status,
      StatusCriticality,
      Mblnr,
      BR_NotaFiscal,
      PSTDAT,
      NFENUM,
      Quantidade,
      Transptdr,
      Incoterms1,
      Incoterms2,
      TRAID,
      cast( '' as lgort_d ) as Lgort

}
where
  Status <> 'PENDENTE'

union


//select from ZI_MM_RESB_STATUS_PENDT
//{
//
//  key Rsnum,
//  key Rspos,
//  key Vbeln,
//      Ebeln,
//      Ebelp,
//      BDTER,
//      Werks,
//      Lifnr,
//      DescForn,
//      Matnr,
//      Meins,
//      Charg,
//      Picking,
//      Status,
//      StatusCriticality,
//      Mblnr,
//      BR_NotaFiscal,
//      PSTDAT,
//      NFENUM,
//      Quantidade,
//      Transptdr,
//      Incoterms1,
//      Incoterms2,
//      TRAID
//
//}
//where
//  Quantidade > 0


//select from  zi_mm_resb_reserva_item_union as _Union
////select from       zi_mm_resb_reserva_item_list as _Union
////  left outer join resb on  resb.rsnum = _Union.Rsnum
////                       and resb.rspos = _Union.Rspos
////  left outer join lfa1 on lfa1.lifnr = resb.lifnr
////{
////  key _Union.Rsnum,
////  key _Union.Rspos,
////  key _Union.Item,
////  key ''                          as Vbeln,
////      //  key _Union.Item,
////      resb.ebeln                  as Ebeln,
////      resb.ebelp                  as Ebelp,
////      resb.bdter                  as BDTER,
////      _Union.Werks,
////      resb.lifnr                  as Lifnr,
////      lfa1.name1                  as DescForn,
////      _Union.Matnr,
////      _Union.Meins,
////      _Union.Charg,
////      _Union.QtdePicking          as Picking,
////      'Pendente'                  as Status,
////      2                           as StatusCriticality,
////      ''                          as Mblnr,
////      cast('' as abap.numc( 10 )) as BR_NotaFiscal,
////      '00000000'                  as PSTDAT,
////      ''                          as NFENUM,
////      _Union.Quantidade,
////      ''                          as Transptdr,
////      ''                          as Incoterms1,
////      ''                          as Incoterms2,
////      ''                          as TRAID
////      //      _Union.Lgort,
////
////
////      //      Ebeln,
////      //      Ebelp,
////      //      BDTER,
////      //      Mblnr,
////}
////union

select from       zi_mm_resb_tab as _Resb_Tab
  left outer join resb on  resb.rsnum = _Resb_Tab.Rsnum
                       and resb.rspos = _Resb_Tab.Rspos
  left outer join lfa1 on lfa1.lifnr = resb.lifnr
{
  key _Resb_Tab.Rsnum,
  key _Resb_Tab.Rspos,
  key _Resb_Tab.Item,
  key ''                          as Vbeln,
      resb.ebeln                  as Ebeln,
      resb.ebelp                  as Ebelp,
      resb.bdter                  as BDTER,
      _Resb_Tab.Werks,
      resb.lifnr                  as Lifnr,
      lfa1.name1                  as DescForn,
      _Resb_Tab.Matnr,
      _Resb_Tab.Meins,
      _Resb_Tab.Charg,
      QtdePicking                 as Picking,
      //      _Resb_Tab.Lgort,
      //Bwtar
      'Pendente'                  as Status,
      2                           as StatusCriticality,
      ''                          as Mblnr,
      cast('' as abap.numc( 10 )) as BR_NotaFiscal,
      '00000000'                  as PSTDAT,
      ''                          as NFENUM,
      _Resb_Tab.Quantidade,
      ''                          as Transptdr,
      ''                          as Incoterms1,
      ''                          as Incoterms2,
      ''                          as TRAID,
      _Resb_Tab.Lgort as Lgort
} where _Resb_Tab.Quantidade > 0
//union 
//
//select from zi_mm_tab_resb as _Tab_Resb
//  left outer join resb on  resb.rsnum = _Tab_Resb.Rsnum
//                       and resb.rspos = _Tab_Resb.Rspos
//  left outer join lfa1 on lfa1.lifnr = resb.lifnr
//{
//  key _Tab_Resb.Rsnum,
//  key _Tab_Resb.Rspos,
//  key Item,
//  key ''                          as Vbeln,
//      resb.ebeln                  as Ebeln,
//      resb.ebelp                  as Ebelp,
//      resb.bdter                  as BDTER,
//      _Tab_Resb.Werks,
//      resb.lifnr                  as Lifnr,
//      lfa1.name1                  as DescForn,
//      _Tab_Resb.Matnr,
//      _Tab_Resb.Meins,
//      _Tab_Resb.Charg,
//      //Lgort,
//      QtdePicking                 as Picking,
//      //Bwtar
//
//      'Pendente'                  as Status,
//      2                           as StatusCriticality,
//      ''                          as Mblnr,
//      cast('' as abap.numc( 10 )) as BR_NotaFiscal,
//      '00000000'                  as PSTDAT,
//      ''                          as NFENUM,
//      Quantidade,
//      ''                          as Transptdr,
//      ''                          as Incoterms1,
//      ''                          as Incoterms2,
//      ''                          as TRAID
//}
