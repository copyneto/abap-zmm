@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Valores/Quantidades do Pedido de Compras'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_MONIT_SERV_PO_VALUES
  as select from    ekpo            as _POItem
    left outer join ztmm_monit_item as _NFItem on  _POItem.ebeln = _NFItem.nr_pedido
                                               and _POItem.ebelp = _NFItem.itm_pedido
{
  _POItem.ebeln,
  _POItem.ebelp,
  _POItem.meins,
  sum(distinct cast( _POItem.menge as abap.dec(15, 3)))                                                                         as QtdadePedido,
  sum(cast(_NFItem.qtdade_lcto as abap.dec(15, 3)))                                                                             as QtdadeLancada,
  coalesce(sum(distinct cast( _POItem.menge as abap.dec(15, 3))), 0) - coalesce(sum(distinct cast(_NFItem.qtdade_lcto as abap.dec(15, 3))), 0) as QtdadeDisponivel
  
}
group by
  _POItem.ebeln,
  _POItem.ebelp,
  _POItem.meins
