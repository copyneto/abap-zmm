@AbapCatalog.sqlViewName: 'ZVMM_PURORDQUANT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Quantitade total do Pedido'

@ObjectModel.usageType.serviceQuality: #C
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.semanticKey: 'PurchaseOrder'
@ObjectModel.representativeKey: 'PurchaseOrder'
define view ZI_MM_QUANT_TOTAL_PEDIDO
  as select from I_PurchaseOrderItem
  association [1..1] to I_PurchaseOrder as _PurchaseOrder     on $projection.PurchaseOrder = _PurchaseOrder.PurchaseOrder
  association [0..1] to I_UnitOfMeasure as _OrderQuantityUnit on $projection.PurchaseOrderQuantityUnit = _OrderQuantityUnit.UnitOfMeasure

{
  key PurchaseOrder,
  key PurchaseOrderItem,

      @Semantics.unitOfMeasure: true
      PurchaseOrderQuantityUnit,

      @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
      @DefaultAggregation: #SUM
      sum(
          case PurchasingDocumentDeletionCode
              when 'L' then cast(0 as bstmg )
              when 'X' then cast(0 as bstmg )
              when 'S' then cast(0 as bstmg )
              else case IsStatisticalItem
                  when 'X' then cast(0 as bstmg )
                  else case IsReturnsItem
                      when 'X' then cast(-OrderQuantity as bstmg )
                      else OrderQuantity
                  end
              end
          end
      ) as PurchaseOrderQuantity,

      _OrderQuantityUnit,
      _PurchaseOrder

}
group by
  PurchaseOrder,
  PurchaseOrderItem,
  PurchaseOrderQuantityUnit
