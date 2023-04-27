@AbapCatalog.sqlViewName: 'ZVCMMNFITMDOC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Dados de Nota Fiscal'
define view ZC_MM_BR_NF_DOCUMENT
  as select from    ZI_MM_BR_NF_DOCUMENT as _Document
    inner join      I_BR_NFDocument      as _BRDocument    on _BRDocument.BR_NotaFiscal = _Document.BR_NotaFiscal
    left outer join I_BR_BusinessPlace_C as _BusinessPlace on  _BusinessPlace.Branch      = _BRDocument.BusinessPlace
                                                           and _BusinessPlace.CompanyCode = _BRDocument.CompanyCode

{
  key PurchaseOrder,
  key PurchaseOrderItem,
  key _Document.BR_NotaFiscal,
  key BR_ReferenceNFNumber,
      ReferencedDocument,
      Nfnum,
      _Document.BR_NFeNumber,
      _Document.BR_NFSeries,

      //      Supplier,

      case BR_NFDirection
        when '1' then BR_NFPartner else BusinessPlace
      end as Supplier,

      case BR_NFDirection
        when '1' then concat_with_space(BR_NFPartnerName1, BR_NFPartnerName2, 1)
        else _BusinessPlace.BusinessPlaceName
      end as SupplierName,

      NFTotalAmount,
      NFTotalQuantity,
      NFTotalReversalValue,
      NFBaseUnit,
      NFCurrency      

}
