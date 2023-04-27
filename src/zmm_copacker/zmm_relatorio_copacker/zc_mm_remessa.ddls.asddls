@EndUserText.label: 'CDS de Projeção - Remessa'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_MM_REMESSA
  as projection on ZI_MM_REMESSA
{
  key ReferenceSDDocument,
  key ReferenceSDDocumentItem,
  key ReferenceDocument,
  key BR_NotaFiscalItem,
      //      MaterialDocumentYear,
      //      MaterialDocument,
      //      MaterialDocumentItem,
      //      DeliveryDocument,
      //      DeliveryDocumentItem,
      StorageLocation,
      InventorySpecialStockType,
      GoodsMovementType,
      //      DeliveryDocumentItemCategory,
      //      ReversedMaterialDocument,
      @Consumption.hidden: true
      BR_NotaFiscal,
      Plant,
      BR_CFOPCode,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'C_Materialvh', element: 'Material' } } ]
      Material,
      MaterialName,
      BR_TaxCode,
      MaterialGroup,
      NetPriceAmount,
      SalesDocumentCurrency,
      NetValueAmount,
      BR_CFOPCategory,
      BR_NFSourceDocumentNumber,
      BaseUnit,
      QuantityInBaseUnit,
      Batch,
      NCMCode,
      //      BR_NFSourceDocumentItem,
      @Consumption.filter.selectionType: #INTERVAL
      BR_NFPostingDate,
      @Consumption.filter.selectionType: #INTERVAL
      BR_NFIssueDate,
      CompanyCode,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_PaytReceiptBusinessPlaceVH', element: 'BusinessPlace' } } ]
      BusinessPlace,
      BR_NFPartner,
      BR_NFeNumber,
      BR_NFNumber,
      BR_NFPartnerName1,
      BR_NFType,
      PurchasingGroup,
      SerialNumber2,
      BR_NFItemBaseAmount,
      BR_NFItemTaxRate,
      BR_NFItemTaxAmount,
      DiasAberto,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_STATUS_PRAZO_FISCAL', element: 'Id' } } ]
      Status,
      Valor,
      StatusCriticality,
      /* Associations */

      _Retorno : redirected to ZC_MM_RETORNO
}
