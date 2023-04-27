@EndUserText.label: 'Relatório Pedido de Café'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define root view entity ZC_MM_PEDIDO_CAFE
  as projection on ZI_MM_PEDIDO_CAFE as RelPedidoCafe
{

  key Ebeln                                       as Pedido,
  key Ebelp                                       as ItemPedido,

      _PurchaseOrder.CompanyCode                  as CompanyCode,
      _PurchaseOrderItemTP.Plant                  as Plant,
      DataClassif,
      @EndUserText.label: 'Descrição do Status'
      Observacao,
      _PurchaseOrderItemTP.Material               as Material,
      @Semantics.quantity.unitOfMeasure: 'PriceUnit'
      _PurchaseOrderItemTP.OrderQuantity          as OrderQuantity,
      _PurchaseOrderItemTP.OrderPriceUnit         as PriceUnit,
      @Semantics.quantity.unitOfMeasure : 'Meins'
      Lagmg,
      Meins,
      @Semantics.amount.currencyCode: 'DocCurrency'
      _PurchaseOrderItemTP.NetPriceAmount         as NetPriceAmount,
      Lifnr,
      _Supplier.SupplierFullName                  as SupplierFullName,
      _Supplier.TaxNumber2                        as TaxNumber2,
      _Supplier.TaxNumber1                        as TaxNumber1,
      _OrdemItem.Region                           as Region,
      _Carac.Paladar                              as Paladar,  
      Corretor,
      NroContrato,
      _PurchaseOrder.CorrespncExternalReference   as CorrExternalRef,

      @Semantics.quantity.unitOfMeasure:'PurcOrderQtdUnit'
      _SheduleLine.RoughGoodsReceiptQty           as RoughGoodsReceiptQty,
      @Semantics.quantity.unitOfMeasure:'PurcOrderQtdUnit'
      _SheduleLine.OpenPurchaseOrderQuantity      as OpenPurcOrderqty,
      _SheduleLine.PurchaseOrderQuantityUnit      as PurcOrderQtdUnit,

      @Semantics.quantity.unitOfMeasure:'HistPurcOrderQtyUnit'
      _History.Quantidade                         as HistQuantidade,
      _History.PurchaseOrderQuantityUnit          as HistPurcOrderQtyUnit,
      _PurchaseOrderItemTP.PurchasingOrganization as PurcOrg,
      @Semantics.amount.currencyCode: 'DocCurrency' 
      _PurchaseOrderItemTP.NetAmount              as NetAmount,
      _PurchaseOrderItemTP.DocumentCurrency       as DocCurrency,
      Corretora,
      _Corretora.SupplierFullName                 as NomeCorretora,
      _ValorCarac.CatacaoCompra                   as CatacaoCompra,
      _ValorCarac.CatacaoChegadaDiv               as CatacaoChegada,
      @EndUserText.label: 'Peneira 10(%)'
      _ValorCarac.Peneira10Div                    as Peneira10,
      @EndUserText.label: 'Peneira 11(%)'
      _ValorCarac.Peneira11Div                    as Peneira11,
      @EndUserText.label: 'Peneira 12(%)'
      _ValorCarac.Peneira12Div                    as Peneira12,
      @EndUserText.label: 'Peneira 13(%)'
      _ValorCarac.Peneira13Div                    as Peneira13,
      @EndUserText.label: 'Peneira 14(%)'
      _ValorCarac.Peneira14Div                    as Peneira14,
      @EndUserText.label: 'Peneira 15(%)'
      _ValorCarac.Peneira15Div                    as Peneira15,
      @EndUserText.label: 'Peneira 16(%)'
      _ValorCarac.Peneira16Div                    as Peneira16,
      @EndUserText.label: 'Peneira 17(%)'
      _ValorCarac.Peneira17Div                    as Peneira17,
      @EndUserText.label: 'Peneira 18(%)'
      _ValorCarac.Peneira18Div                    as Peneira18,
      @EndUserText.label: 'Peneira 19(%)'
      _ValorCarac.Peneira19Div                    as Peneira19,

      /* Associations */
      _History,
      _PurchaseOrder,
      _PurchaseOrderItemTP,
      _SheduleLine,
      _Supplier,
      _ValorCarac,
      _Corretora,
      _OrdemItem,
      _Carac
}
