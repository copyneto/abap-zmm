@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS de Interface - Retorno'
//@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.modelCategory: #BUSINESS_OBJECT
define root view entity ZI_MM_RETORNO
  as select from ZI_MM_FORNECIMENTO4 as Retorno

  association [1..1] to ZI_MM_REMESSA                as _Remessa on  $projection.ReferenceSDDocument     = _Remessa.ReferenceSDDocument
                                                               //  and $projection.ReferenceSDDocumentItem = _Remessa.ReferenceSDDocumentItem

  association [1..1] to ZI_MM_VH_STATUS_PRAZO_FISCAL as _Status  on  $projection.Status = _Status.Id
{
  key Retorno.ReferenceSDDocument,
      @EndUserText.label: 'Item documento referência'
  key Retorno.ReferenceSDDocumentItem,
      @EndUserText.label: 'Nº documento'
  key Retorno.ReferenceDocument,
  key Retorno.BR_NotaFiscalItem,
      //      Remessa.MaterialDocumentYear,
      //      Remessa.MaterialDocument,
      //      Remessa.MaterialDocumentItem,
      //      Remessa.DeliveryDocument,
      //      Remessa.DeliveryDocumentItem,
      Retorno.StorageLocation,
      Retorno.InventorySpecialStockType,
      Retorno.GoodsMovementType,
      //      Remessa.DeliveryDocumentItemCategory,
      //      Remessa.ReversedMaterialDocument,
      Retorno.BR_NotaFiscal,
      Retorno.Plant,
      Retorno.BR_CFOPCode,
      Retorno.Material,
      Retorno.MaterialName,
      Retorno.BR_TaxCode,
      Retorno.MaterialGroup,
      Retorno.NetPriceAmount,
      Retorno.SalesDocumentCurrency,
      Retorno.NetValueAmount,
      Retorno.BR_CFOPCategory,
      Retorno.BR_NFSourceDocumentNumber,
      Retorno.BaseUnit,
      Retorno.QuantityInBaseUnit,
      Retorno.Batch,
      Retorno.NCMCode,
      //      Remessa.BR_NFSourceDocumentItem,
      Retorno.BR_NFPostingDate,
      Retorno.BR_NFIssueDate,
      Retorno.CompanyCode,
      Retorno.BusinessPlace,
      Retorno.BR_NFPartner,
      Retorno.BR_NFeNumber,
      Retorno.BR_NFNumber,
      Retorno.BR_NFPartnerName1,
      Retorno.BR_NFType,
      Retorno.PurchasingGroup,
      @EndUserText.label: 'Número de série'
      Retorno.SerialNumber2,
      Retorno.BR_NFItemBaseAmount,
      Retorno.BR_NFItemTaxRate,
      Retorno.BR_NFItemTaxAmount,
      @EndUserText.label: 'Dias em aberto'
      Retorno.DiasAberto,
      @ObjectModel.text.element: ['Valor']
      Retorno.Status,
      _Status.Valor,

      case Retorno.Status
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

      _Remessa
}
//where
//  Retorno._Operacao.Tipo = '2'
//  and Retorno.DeliveryDocumentItemCategory = 'ELN'
