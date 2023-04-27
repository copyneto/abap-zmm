@AbapCatalog.sqlViewName: 'ZVMM_RESBITM'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Item Reserva - RESB'
@Metadata.ignorePropagatedAnnotations: true
//@ObjectModel.usageType:{
//  serviceQuality: #X,
//  sizeCategory: #S,
//  dataClass: #MIXED
//}
define view zi_mm_resb_reserva_item_union
  as select from zi_mm_resb_tab
{
  key Rsnum,
  key Rspos,
  key Item,
      Charg,
      Matnr,
      Werks,
      Lgort,
      Quantidade,
      QtdePicking,
      Meins,
      Bwtar
} where Quantidade > 0

//union
//
//select from zi_mm_tab_resb
//{
//  key Rsnum,
//  key Rspos,
//  key Item,
//      Charg,
//      Matnr,
//      Werks,
//      Lgort,
//      Quantidade,
//      QtdePicking,
//      Meins,
//      Bwtar
//}

//  select from    resb                   as _Resb
//
//    left outer join ZI_MM_SUM_LIPS_SUBCTRT as Lips     on  Lips.vgbel = _Resb.ebeln
//                                                       and Lips.vgpos = _Resb.ebelp
//                                                       and Lips.Matnr = _Resb.matnr
//
//    left outer join ztmm_sb_picking        as _Picking on  _Picking.rsnum = _Resb.rsnum
//                                                       and _Picking.rspos = _Resb.rspos
//                                                       and _Picking.charg = _Resb.charg
//{
////  key _Resb.ebeln                                 as Rsnum,
//  key _Resb.rsnum                                 as Rsnum,
//  key _Resb.rspos                                 as Rspos,
//  key _Picking.item as Item,
//
//      case
//        when _Picking.charg is not initial
//        then _Picking.charg
//        else _Resb.charg
//      end                                         as Charg,
//      _Resb.matnr                                 as Matnr,
//      _Resb.werks                                 as Werks,
//
//      case
//        when _Picking.lgort is not initial
//        then _Picking.lgort
//        else _Resb.lgort
//      end                                         as Lgort,
//
//      case
//        when _Picking.fornecida is not initial
//        then cast(_Picking.fornecida as abap.dec( 13, 3 ))
//        else
//          case
//          when Lips.LFIMG is not null
//          then cast(_Resb.bdmng as abap.dec( 13, 3 )) - cast(Lips.LFIMG as abap.dec( 13, 3 ))
//          else cast(_Resb.bdmng as abap.dec( 13, 3 ))
//          end
//      end                                         as Quantidade,
//
//      cast(_Picking.picking as abap.dec( 13, 3 )) as QtdePicking,
//
//      case
//        when _Picking.meins is not initial
//        then _Picking.meins
//        else _Resb.meins
//      end                                         as Meins,
//      case
//        when _Picking.bwtar is not initial
//        then _Picking.bwtar
//        else Lips.Bwtar
//      end                                         as Bwtar
//}
//where
//      _Resb.bdart = 'BB'
//  and _Resb.ebeln is not initial
//
//union
//
//select from  ztmm_sb_picking as _Picking
//  inner join resb            as _Resb on  _Resb.rsnum =  _Picking.rsnum
//                                      and _Resb.rspos =  _Picking.rspos
////                                      and _Resb.charg <> _Picking.charg
//                                      and _Picking.charg is not initial
//{
//  key _Picking.rsnum                                as Rsnum,
//  key _Picking.rspos                                as Rspos,
//  key _Picking.item as Item,
//      _Picking.charg                                as Charg,
//      _Resb.matnr                                   as Matnr,
//      _Resb.werks                                   as Werks,
//
//      _Picking.lgort                                as Lgort,
//      cast(_Picking.fornecida as abap.dec( 13, 3 )) as Quantidade,
//      cast(_Picking.picking as abap.dec( 13, 3 ))   as QtdePicking,
//
//      _Picking.meins                                as Meins,
//      _Picking.bwtar as Bwtar
//}
