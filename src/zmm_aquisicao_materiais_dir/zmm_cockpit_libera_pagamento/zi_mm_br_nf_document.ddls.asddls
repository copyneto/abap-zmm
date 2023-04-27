@AbapCatalog.sqlViewName: 'ZVIMMNFITMDOC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Dados de Nota Fiscal'
define view ZI_MM_BR_NF_DOCUMENT
  as select from ZI_MM_DOC_HISTORY              as _History
    inner join   I_BR_NFItemDocumentFlowFirst_C as _BRNFItem     on _History.ReferencedDocument = _BRNFItem.ReferenceDocument
    inner join   I_BR_NFItem_C                  as _NFItem       on _BRNFItem.BR_NotaFiscal = _NFItem.BR_NotaFiscal
    inner join   C_BR_VerifyNotaFiscal          as _BRNotaFiscal on  _BRNFItem.BR_NotaFiscal       = _BRNotaFiscal.BR_NotaFiscal
                                                                 and _BRNotaFiscal.BR_NFIsCanceled is initial
    inner join   I_BR_NFDocument                as _NFDoc        on _NFDoc.BR_NotaFiscal = _BRNotaFiscal.BR_NotaFiscal
  //    inner join   ZI_CA_PARAM_VAL                as _Tvarv        on  _BRNotaFiscal.BR_NFType = _Tvarv.Low
  //                                                                 and _Tvarv.Chave1           = 'GRAOVERDE'
  //                                                                 and _Tvarv.Chave2           = 'BR_NFTYPE'
  //                                                                 and _Tvarv.Chave3           = 'DEVOL'
{
  key _History.PurchaseOrder,
  key _History.PurchaseOrderItem,
  key _BRNotaFiscal.BR_NotaFiscal,
  key _BRNFItem.BR_ReferenceNFNumber,
      _NFDoc.BR_NFeNumber,
      _NFDoc.BR_NFSeries,

      _History.ReferencedDocument,

      concat_with_space( _BRNotaFiscal.BR_NFeNumber, concat_with_space( '-', _BRNotaFiscal.BR_NFeSeries, 1 ), 1 ) as Nfnum,
      _BRNotaFiscal.BR_NFIssuerNameFrmtdDesc                                                                      as Supplier,
      @Semantics.amount.currencyCode: 'NFCurrency'
      sum( _BRNotaFiscal.BR_NFTotalAmount )                                                                       as NFTotalAmount,
      @Semantics.quantity.unitOfMeasure: 'NFBaseUnit'
      cast( sum( _NFItem.QuantityInBaseUnit ) as menge_d )                                                        as NFTotalQuantity,
      @Semantics.amount.currencyCode: 'NFCurrency'
      sum( _BRNotaFiscal.BR_ICMSBaseTotalAmount ) * ( -1 )                                                        as NFTotalReversalValue,
      _NFItem.BaseUnit                                                                                            as NFBaseUnit,
      _NFItem.SalesDocumentCurrency                                                                               as NFCurrency

}
group by
  _NFDoc.BR_NFeNumber,
  _NFDoc.BR_NFSeries,
  _History.PurchaseOrder,
  _History.PurchaseOrderItem,
  _BRNotaFiscal.BR_NotaFiscal,
  _BRNFItem.BR_ReferenceNFNumber,
  _History.ReferencedDocument,
  _BRNotaFiscal.BR_NFeNumber,
  _BRNotaFiscal.BR_NFeSeries,
  _BRNotaFiscal.BR_NFIssuerNameFrmtdDesc,
  _NFItem.BaseUnit,
  _NFItem.SalesDocumentCurrency
