@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Item Monitor de Serviço'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_MONIT_SERV_ITEM
  as select from    ztmm_monit_item as Item

    left outer join ekpo            as Ekpo on  ekpo.ebeln = Item.nr_pedido
                                            and ekpo.ebelp = Item.itm_pedido

  association        to parent ZI_MM_MONIT_SERV_HEADER as _Header      on  _Header.Empresa = $projection.Empresa
                                                                       and _Header.Filial  = $projection.Filial
                                                                       and _Header.Lifnr   = $projection.Lifnr
                                                                       and _Header.NrNf    = $projection.NrNf

  association [0..1] to I_ServiceEntrySheetItem        as _ServiceItem on  _ServiceItem.PurchaseOrder     = $projection.NrPedido
                                                                       and _ServiceItem.PurchaseOrderItem = $projection.ItmPedido

  association [0..1] to t007a                          as _Iva         on  _Iva.mwskz = $projection.Iva
                                                                       and _Iva.kalsm = 'TAXBRA'

  association [0..1] to ekko                           as _Ekko        on  _Ekko.ebeln = ekpo.ebeln

  association [0..1] to ZI_CA_VH_WERKS                 as _Werks       on  _Werks.WerksCode = $projection.Werks
  association [0..1] to ZI_CA_VH_MATERIAL              as _Matnr       on  _Matnr.Material = $projection.Matnr

{

  key Item.empresa                                                                                                                     as Empresa,
  key Item.filial                                                                                                                      as Filial,
  key Item.lifnr                                                                                                                       as Lifnr,
  key Item.nr_nf                                                                                                                       as NrNf,
  key Item.nr_pedido                                                                                                                   as NrPedido,
  key Item.itm_pedido                                                                                                                  as ItmPedido,
//      Item.nr_nf                                                                                                                       as NrNf2,
      ekpo.werks                                                                                                                       as Werks,
      ekpo.sakto                                                                                                                       as CntContb,
      Item.iva                                                                                                                         as Iva,
      Item.categ                                                                                                                       as CtgNf,
      cast(Item.cfop as abap.char(10))                                                                                                 as Cfop,
      _Iva.j_1btaxlw1                                                                                                                  as CstIcms,
      _Iva.j_1btaxlw2                                                                                                                  as CstIpi,
      _Iva.j_1btaxlw5                                                                                                                  as CstPis,
      _Iva.j_1btaxlw4                                                                                                                  as CstCofins,
      ekpo.matnr                                                                                                                       as Matnr,
      ekpo.j_1bnbm                                                                                                                     as Lc,
      _ServiceItem.ServiceEntrySheet,
      _ServiceItem.ServiceEntrySheetItem,
      @Semantics.quantity.unitOfMeasure: 'Unid'
      Item.qtdade                                                                                                                      as Qtdade,
      @Semantics.quantity.unitOfMeasure: 'Unid'
      Item.qtdade_lcto                                                                                                                 as Qtdade_Lcto,
      @Semantics.amount.currencyCode: 'Currency'
      ekpo.netpr                                                                                                                       as VlUnit,
      ( cast(ekpo.netpr as abap.fltp( 15, 2 )) / cast(ekpo.menge as abap.fltp( 15,2 )) * cast( Item.qtdade_lcto as abap.fltp(15,2) ) ) as VlTotUn,
      //      ( cast(ekpo.netpr as abap.fltp( 15, 2 )) / cast(ekpo.menge as abap.fltp( 15,2 )) * cast( Item.qtdade_lcto as abap.fltp(15,2) ) ) as VlTotalComImposto,
      ekpo.kostl                                                                                                                       as CentroCust,
      Item.unid                                                                                                                        as Unid,
      @Semantics.user.createdBy: true
      Item.created_by                                                                                                                  as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      Item.created_at                                                                                                                  as CreatedAt,
      @Semantics.user.lastChangedBy: true
      Item.last_changed_by                                                                                                             as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      Item.last_changed_at                                                                                                             as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      Item.local_last_changed_at                                                                                                       as LocalLastChangedAt,
      _Ekko.waers                                                                                                                      as Currency,
      _Header,
      _Werks,
      _Matnr

}
