@EndUserText.label: 'Projection - NRI Item'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity zc_mm_02_nri_item
  as projection on zi_mm_02_nri_item
{
  key       PurchaseOrder,
  key       PurchaseOrderItem,
  key       BusinessPartner,
  key       Supplier,
            @UI.hidden: true
  key       BPTaxType,
  key       AddressNumber,
  key       belnr_rbkp,
  key       belnr_rseg,
  key       ebeln,
  key       ebelp,
            Material,
            PurchaseOrderItemText,
            PurchaseOrderQuantityUnit,
            CreationDate,
            //            PhoneNumber1,
            //            xblnr,
            //            bstme,
            //            @Semantics.quantity.unitOfMeasure : 'bstme'
            //            menge,
            //            charg,
            //            lgort,
            //            afnam,
            PersonFullName,
            StreetName,
            CityName,
            FaxNumber,
            District,
            Region,
            Country,
            PostalCode,
            CNPJ,
            CPF,
            PhoneNumber,
            InsEstadual,
            InsMunicipal,
            F_FullName,
            F_StreetName,
            F_PostalCode,
            F_CityName,
            F_District,
            F_PhoneNumber,
            F_Region,
            F_Country,
            F_InsEstadual,
            F_CNPJ,
            filePdf,
            CompanyCode
//            @Consumption.filter:{ selectionType: #SINGLE, defaultValue: '1' }
//            @Consumption.filter.hidden: true
//            contador
}
