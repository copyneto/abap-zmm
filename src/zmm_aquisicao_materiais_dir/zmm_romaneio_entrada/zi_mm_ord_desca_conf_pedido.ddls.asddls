@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Confirmações pedido para Ordem Descarga'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_ORD_DESCA_CONF_PEDIDO
  as select from ekes
    inner join   ekpo as _ItemPedido on  _ItemPedido.ebeln = ekes.ebeln
                                     and _ItemPedido.ebelp = ekes.ebelp
    inner join   ekko as _Pedido     on _Pedido.ebeln = ekes.ebeln
    inner join   mara as _Material   on _Material.matnr = _ItemPedido.matnr
    inner join   makt as _DescMate   on  _DescMate.matnr = _Material.matnr
                                     and _DescMate.spras = $session.system_language                                           
    
    left outer to one join ZI_MM_CONF_PEDIDO_NF_FORMART as _Formart on  ekes.ebeln = _Formart.ebeln 
                                                                    and ekes.ebelp = _Formart.ebelp
                                                                    and ekes.etens = _Formart.etens                                                                     
{
  key ekes.ebeln,
  key ekes.ebelp,
  key ekes.etens,
      ekes.vbeln,
      ekes.vbelp,
      ekes.xblnr,                
      ltrim( _Formart.xblnr_format, '0' ) as xblnr_format,
      @Semantics.quantity.unitOfMeasure : 'meins'
      ekes.menge,
      _ItemPedido.matnr,
      _DescMate.maktx,
      ekes.charg,
      _ItemPedido.meins,
      @Semantics.quantity.unitOfMeasure:'meins'
      ekes.ormng,
      _Material.meins   as MEINS_out,
      _ItemPedido.werks as Werks,
      _ItemPedido.lgort as Lgort
}
