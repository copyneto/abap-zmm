@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cadastro Fiscal - item'
define view entity ZI_MM_CADASTRO_FISCAL_ITEM
  as select from    ztmm_monit_item as _Item

    left outer join ekpo            as _Ekpo on  _Ekpo.ebeln = _Item.nr_pedido
                                             and _Ekpo.ebelp = _Item.itm_pedido

  association [0..1] to I_ServiceEntrySheetItem            as _ServiceItem on  _ServiceItem.PurchaseOrder     = $projection.NrPedido
                                                                           and _ServiceItem.PurchaseOrderItem = $projection.ItmPedido

  association [1..1] to ZI_MM_MONIT_SERV_PO_VALUES         as _ItemQty     on  _ItemQty.ebeln = $projection.NrPedido
                                                                           and _ItemQty.ebelp = $projection.ItmPedido

  association        to parent ZI_MM_CADASTRO_FISCAL_CABEC as _Header      on  $projection.Empresa = _Header.Empresa
                                                                           and $projection.Filial  = _Header.Filial
                                                                           and $projection.Lifnr   = _Header.Lifnr
                                                                           and $projection.NrNf    = _Header.NrNf
{
  key _Item.empresa                                                                          as Empresa,
  key _Item.filial                                                                           as Filial,
  key _Item.lifnr                                                                            as Lifnr,
  key _Item.nr_nf                                                                            as NrNf,
  key _Item.nr_pedido                                                                        as NrPedido,
  key _Item.itm_pedido                                                                       as ItmPedido,
      _Ekpo.matnr                                                                            as Material,
      _Ekpo.txz01                                                                            as Descricao,
      cast( _Item.cfop as abap.char(10) )                                                    as Cfop,
      _Item.iva                                                                              as Iva,
      _Item.categ                                                                            as NFtype,
      _Item.unid                                                                             as Unid,
      _Ekpo.txjcd                                                                            as DomicilioFiscalPO,
      _Header.DomicilioFiscal                                                                as DomicilioFiscalNF,
      _Ekpo.j_1bnbm                                                                          as LcPO,
      _Header.Lc                                                                             as LcNF,
      _ServiceItem.ServiceEntrySheet,
      _ServiceItem.ServiceEntrySheetItem,
      @Semantics.quantity.unitOfMeasure : 'Unid'
      @EndUserText.label: 'Qtd. Pedido'
      _ItemQty.QtdadePedido                                                                  as Qtdade,
      @Semantics.quantity.unitOfMeasure : 'Unid'
      @EndUserText.label: 'Qtd. Utilizada'
      _ItemQty.QtdadeLancada                                                                 as QtdadeUtilizada,
      @Semantics.quantity.unitOfMeasure : 'Unid'
      @EndUserText.label: 'Qtd. Lançamento'
      _Item.qtdade_lcto                                                                      as Qtdade_Lcto,
      @Semantics.amount.currencyCode: 'Currency'
      _Ekpo.netpr                                                                            as VlUnit,
      @Semantics.amount.currencyCode: 'Currency'
      cast(_Ekpo.netpr as abap.fltp( 15, 2 )) * cast( _Item.qtdade_lcto as abap.fltp(15,2) ) as VlTotUn,
      //      _Item.categ                                                                                                                         as Categ,
      //      _Item.movimento                                                                                                                     as Movimento,
      //      _Item.cst_icms                                                                                                                      as CstIcms,
      //      _Item.cst_ipi                                                                                                                       as CstIpi,
      //      _Item.cst_pis                                                                                                                       as CstPis,
      //      _Item.cst_cofins                                                                                                                    as CstCofins,
      _Item.created_by                                                                       as CreatedBy,
      _Item.created_at                                                                       as CreatedAt,
      _Item.last_changed_by                                                                  as LastChangedBy,
      _Item.last_changed_at                                                                  as LastChangedAt,
      _Item.local_last_changed_at                                                            as LocalLastChangedAt,
      _Header.Currency,
      /*Associations*/
      _Header
}
