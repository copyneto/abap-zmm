@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Exped. Insumos - Subcontratação - Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity zi_mm_tab_resb
  as select from ztmm_sb_picking as _Picking
    inner join   resb            as _Resb on  _Resb.rsnum    = _Picking.rsnum
                                          and _Resb.rspos    = _Picking.rspos
    //                                      and _Resb.charg <> _Picking.charg
                                          and _Picking.charg is not initial
{
  key _Picking.rsnum                                as Rsnum,
  key _Picking.rspos                                as Rspos,
  key _Picking.item                                 as Item,
      _Picking.charg                                as Charg,
      _Resb.matnr                                   as Matnr,
      _Resb.werks                                   as Werks,

      _Picking.lgort                                as Lgort,
      cast(_Picking.fornecida as abap.dec( 13, 3 )) as Quantidade,
      cast(_Picking.picking as abap.dec( 13, 3 ))   as QtdePicking,

      _Picking.meins                                as Meins,
      _Picking.bwtar                                as Bwtar
}
