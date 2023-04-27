@AbapCatalog.sqlViewName: 'ZVMM_IREPORDER'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Dados de Ordem de Produção'
define view ZI_MM_RELATORIO_ORDEM
  as select from ZI_PP_NRM_APR_H                as _Header
    inner join   ZI_PP_NRM_APR_ORD              as _Order    on _Header.DocUuidH = _Order.DocUuidH
    inner join   I_MfgOrderMaterialDocumentItem as _MfgOrder on  _Order.ProcessOrder           = _MfgOrder.ManufacturingOrder
                                                             and _Order.OrderType              = _MfgOrder.ManufacturingOrderType
                                                             and _Order.Plant                  = _MfgOrder.Plant
                                                             and (
                                                                _MfgOrder.GoodsMovementType    = '101'
                                                                or _MfgOrder.GoodsMovementType = '102'
                                                                or _MfgOrder.GoodsMovementType = '531'
                                                                or _MfgOrder.GoodsMovementType = '532'
                                                              )
  //    inner join   I_MaterialStock                as _Stock    on  _MfgOrder.Material        = _Stock.Material
  //                                                             and _MfgOrder.Plant           = _Stock.Plant
  //                                                             and _MfgOrder.StorageLocation = _Stock.StorageLocation
  //                                                             and _MfgOrder.Batch           = _Stock.Batch
    inner join   ZI_MM_STOCK_CALC_TOTAL         as _Stock    on  _MfgOrder.Material        = _Stock.Material
                                                             and _MfgOrder.Plant           = _Stock.Plant
                                                             and _MfgOrder.StorageLocation = _Stock.StorageLocation
                                                             and _MfgOrder.Batch           = _Stock.Batch

{
  key _MfgOrder.Material                  as Material,
  key _MfgOrder.Plant                     as Plant,
  key _MfgOrder.StorageLocation           as StorageLocation,
  key _MfgOrder.Batch                     as Batch,
      //      _MfgOrder.ManufacturingOrder              as Ordem,
      /*_Header.Status               as Status,
      _Header.StatusTxt            as StatusTxt,
      _Header.StatusCriticality    as StatusCrit,*/
      //      @Semantics.quantity.unitOfMeasure: 'Meins'
      //      sum(
      //          case _MfgOrder.GoodsMovementType
      //            when '102'
      //              then _MfgOrder.QuantityInBaseUnit * (-1)
      //            else
      //              _MfgOrder.QuantityInBaseUnit
      //          end )                    as TotalOrdem,
      //      _MfgOrder.BaseUnit           as Meins,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      //      sum( _Stock.MatlWrhsStkQtyInMatlBaseUnit) as TotalOrdem,
      _Stock.MatlWrhsStkQtyInMatlBaseUnit as TotalOrdem,
      _Stock.MaterialBaseUnit             as Meins,
      'O'                                 as Opt,
      _Header.Documentno                  as Documentno

}
group by
  _MfgOrder.Material,
  _MfgOrder.Plant,
  _MfgOrder.StorageLocation,
  _MfgOrder.Batch,
  //  _MfgOrder.ManufacturingOrder,
  /*_Header.Status,
  _Header.StatusTxt,
  _Header.StatusCriticality,*/
  //  _MfgOrder.BaseUnit,
  _Stock.MatlWrhsStkQtyInMatlBaseUnit,
  _Stock.MaterialBaseUnit,
  _Header.Documentno
