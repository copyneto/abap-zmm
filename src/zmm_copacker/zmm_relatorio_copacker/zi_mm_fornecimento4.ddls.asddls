@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Fornec. sem estorno'
//@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_FORNECIMENTO4
  as select from ZI_MM_FORNECIMENTO3 as Fornecimento3

  //    left outer join ZI_MM_COPACKER      as _NFItem on  Fornecimento3.ReferenceSDDocument     = _NFItem.PurchaseOrder
  //                                                   and Fornecimento3.ReferenceSDDocumentItem = _NFItem.PurchaseOrderItem
  //                                                   and Fornecimento3.DeliveryDocumentItemAux = _NFItem.BR_NotaFiscalItem2
  //                                                   and Fornecimento3.ReferenceDocumentAux    = _NFItem.BR_NFeNumber
  //  association [0..1] to ZI_MM_COPACKER as _NFItem on  $projection.ReferenceDocument = _NFItem.BR_NotaFiscal
  association [0..1] to ZI_MM_COPACKER as _NFItem on  $projection.ReferenceSDDocument       = _NFItem.PurchaseOrder
                                                  and Fornecimento3.ReferenceSDDocumentItem = _NFItem.PurchaseOrderItem
                                                  and Fornecimento3.DeliveryDocumentItemAux = _NFItem.BR_NotaFiscalItem2
                                                  and Fornecimento3.ReferenceDocumentAux    = _NFItem.BR_NFeNumber

{
  key  Fornecimento3.ReferenceDocument,
  key  _NFItem.BR_NotaFiscalItem,
  key  Fornecimento3.ReferenceSDDocument,
  key  Fornecimento3.ReferenceSDDocumentItem,
  key  Fornecimento3.MaterialDocumentYear,
  key  Fornecimento3.MaterialDocument,
       Fornecimento3.MaterialDocumentItem,
       Fornecimento3.DeliveryDocument,
       Fornecimento3.DeliveryDocumentItem,
       Fornecimento3.StorageLocation,
       Fornecimento3.InventorySpecialStockType,
       Fornecimento3.GoodsMovementType,
       Fornecimento3.DeliveryDocumentItemCategory,
       Fornecimento3.ReversedMaterialDocument,

       /* Associations */
       _NFItem.BR_NotaFiscal,
       _NFItem.Plant,
       _NFItem.BR_CFOPCode,
       _NFItem.Material,
       //      _NFItem.PurchaseOrder,
       _NFItem.MaterialName,
       _NFItem.BR_TaxCode,
       _NFItem.MaterialGroup,
       _NFItem.NetPriceAmount,
       _NFItem.SalesDocumentCurrency,
       _NFItem.NetValueAmount,
       _NFItem.BR_CFOPCategory,
       _NFItem.BR_NFSourceDocumentNumber,
       _NFItem.BaseUnit,
       _NFItem.QuantityInBaseUnit,
       _NFItem.Batch,
       _NFItem.NCMCode,
       _NFItem.BR_NFSourceDocumentItem,
       _NFItem.BR_NFPostingDate,
       _NFItem.BR_NFIssueDate,
       _NFItem.CompanyCode,
       _NFItem.BusinessPlace,
       _NFItem.BR_NFPartner,
       _NFItem.BR_NFeNumber,
       _NFItem.BR_NFNumber,
       _NFItem.BR_NFPartnerName1,
       _NFItem.BR_NFType,
       _NFItem.PurchasingGroup,
       //      _NFItem.SerialNumber,
       _NFItem.SerialNumber2,
       _NFItem.BR_NFItemBaseAmount,
       _NFItem.BR_NFItemTaxRate,
       _NFItem.BR_NFItemTaxAmount,
       _NFItem.DiasAberto,
       _NFItem._NFTax,
       _NFItem._Operacao,
       //      _NFItem._PurchaseOrder,

       case
         when Fornecimento3.Estado = Fornecimento3.Estado2 then
         case
             when  _NFItem.BR_NFPostingDate  > dats_add_days($session.system_date,-90,'INITIAL') then '1'
             when  _NFItem.BR_NFPostingDate  = dats_add_days($session.system_date,-90,'INITIAL') then '2'
             else '3'
         end
       else
         case
             when  _NFItem.BR_NFPostingDate  > dats_add_days($session.system_date,-180,'INITIAL') then '1'
             when  _NFItem.BR_NFPostingDate  = dats_add_days($session.system_date,-180,'INITIAL') then '2'
             else '3'
          end
        end as Status,

       Fornecimento3._MaterialDocumentRecord2,
       Fornecimento3._PurchasingDocumentItem
       //_NFItem
}
where
      Fornecimento3.IsEstorno                =  'N'
  and Fornecimento3.ReversedMaterialDocument =  ''
  and _NFItem.BR_NotaFiscal                  <> '0000000000'
