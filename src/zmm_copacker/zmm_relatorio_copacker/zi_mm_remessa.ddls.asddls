@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS de Interface - Remessa'
//@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.modelCategory: #BUSINESS_OBJECT
define root view entity ZI_MM_REMESSA
  as select from ZI_MM_FORNECIMENTO4 as Remessa

  association [0..*] to ZI_MM_RETORNO                as _Retorno on $projection.ReferenceSDDocument = _Retorno.ReferenceSDDocument

  association [1..1] to ZI_MM_VH_STATUS_PRAZO_FISCAL as _Status  on $projection.Status = _Status.Id
{

  key Remessa.ReferenceSDDocument,
      @EndUserText.label: 'Item documento referência'
  key Remessa.ReferenceSDDocumentItem,
      @EndUserText.label: 'Nº documento'
  key Remessa.ReferenceDocument,
  key Remessa.BR_NotaFiscalItem,
      //      Remessa.MaterialDocumentYear,
      //      Remessa.MaterialDocument,
      //      Remessa.MaterialDocumentItem,
      //      Remessa.DeliveryDocument,
      //      Remessa.DeliveryDocumentItem,
      Remessa.StorageLocation,
      Remessa.InventorySpecialStockType,
      Remessa.GoodsMovementType,
      //      Remessa.DeliveryDocumentItemCategory,
      //      Remessa.ReversedMaterialDocument,
      Remessa.BR_NotaFiscal,
      Remessa.Plant,
      Remessa.BR_CFOPCode,
      Remessa.Material,
      Remessa.MaterialName,
      Remessa.BR_TaxCode,
      Remessa.MaterialGroup,
      Remessa.NetPriceAmount,
      Remessa.SalesDocumentCurrency,
      Remessa.NetValueAmount,
      Remessa.BR_CFOPCategory,
      Remessa.BR_NFSourceDocumentNumber,
      Remessa.BaseUnit,
      Remessa.QuantityInBaseUnit,
      Remessa.Batch,
      Remessa.NCMCode,
      //      Remessa.BR_NFSourceDocumentItem,
      Remessa.BR_NFPostingDate,
      Remessa.BR_NFIssueDate,
      Remessa.CompanyCode,
      Remessa.BusinessPlace,
      Remessa.BR_NFPartner,
      Remessa.BR_NFeNumber,
      Remessa.BR_NFNumber,
      Remessa.BR_NFPartnerName1,
      Remessa.BR_NFType,
      Remessa.PurchasingGroup,
      @EndUserText.label: 'Número de série'
      Remessa.SerialNumber2,
      Remessa.BR_NFItemBaseAmount,
      Remessa.BR_NFItemTaxRate,
      Remessa.BR_NFItemTaxAmount,
      @EndUserText.label: 'Dias em aberto'
      Remessa.DiasAberto,
      @ObjectModel.text.element: ['Valor']
      Remessa.Status,
      _Status.Valor,

      case Remessa.Status
          when '1' then 3
          when '2' then 2
          when '3' then 1
          else 0
      end as StatusCriticality,
      /* Associations */
      //      Remessa._MaterialDocumentRecord2,
      //      Remessa._NFDocument,
      //      Remessa._NFItem,
      //      Remessa._NFTax,
      //      Remessa._Operacao,
      //      Remessa._PurchasingDocumentItem

      _Retorno

}
//where
//  Remessa._Operacao.Tipo = '1'
//and  Remessa.DeliveryDocumentItemCategory = 'LBN'
