@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'View - NRI Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zi_mm_02_nri_item
  as select from    I_PurchaseOrderItem        as f
    inner join      C_PurchaseOrderTP          as a on f.PurchaseOrder = a.PurchaseOrder
    left outer join zi_mm_03_nri_forn          as b on a.Supplier = b.Supplier
    left outer join I_BusinessPartnerAddressTP as h on h.BusinessPartner = b.Supplier
    left outer join I_BusinessPartnerAddressTP as c on c.BusinessPartner = b.BusinessPartner
    left outer join C_PurOrdSupplierAddressTP  as e on e.PurchaseOrder = a.PurchaseOrder
    left outer join rbkp                       as g on g.belnr = a.PurchaseOrder
    left outer join ZI_MM_04_NRI_INFO          as l on  l.PurchaseOrder     = a.PurchaseOrder
                                                    and l.PurchaseOrderItem = f.PurchaseOrderItem
  //    left outer join rseg                       as i on i.belnr = a.PurchaseOrder
  //    left outer join ekpo                       as h on  h.belnr = f.PurchaseOrder
  //                                                    and h.ebelp = f.PurchaseOrderItem
{
  key   f.PurchaseOrder,
  key   f.PurchaseOrderItem,
  key   b.BusinessPartner,
  key   b.Supplier,
  key   cast( '' as bptaxtype )                as BPTaxType,
  key   c.AddressNumber,
  key   cast( ''  as bptaxtype )               as belnr_rbkp,
  key   cast( '' as bptaxtype )                as belnr_rseg,
  key   cast( '' as bptaxtype )                as ebeln,
  key   cast( '' as bptaxtype )                as ebelp,
        //  key   g.belnr                                as belnr_rbkp,
        //  key   i.belnr                                as belnr_rseg,
        //  key   h.ebeln,
        //  key   h.ebelp,
        f.Material,
        f.PurchaseOrderItemText,
        f.PurchaseOrderQuantityUnit,
        a.CreationDate,
        b.PhoneNumber1,
//        l.SupplierInvoiceIDByInvcgParty        as xblnr,
//        l.MaterialBaseUnit,
//        @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'
//        l.QuantityInBaseUnit                   as menge,
        l.Batch                                as charg,
//        l.StorageLocation                      as lgort,
        f.StorageLocation                      as lgort,
        f.RequisitionerName                    as afnam,
        //        g.xblnr,
        //        i.bstme,
        //        @Semantics.quantity.unitOfMeasure : 'bstme'
        //        i.menge,
        //        i.charg,
        //        h.lgort,
        //        h.afnam,

        // Cabeçalho
        b.PersonFullName,
        c.StreetName,
        c.CityName,
        c.FaxNumber,
        c.District,
        c.Region,
        c.Country,
        c.PostalCode,
        cast( '' as bptaxnumxl   )             as CNPJ,
        cast( '' as bptaxnumxl   )             as CPF,
        c.PhoneNumber,
        cast( '' as bptaxnumxl   )             as InsEstadual,
        cast( '' as bptaxnumxl   )             as InsMunicipal,


        //Fornecedor
        e.FullName                             as F_FullName,
        cast( '' as bptaxnumxl   )             as F_CNPJ,
        a._PurOrdSupplierAddressTP.StreetName  as F_StreetName,
        a._PurOrdSupplierAddressTP.PostalCode  as F_PostalCode,
        a._PurOrdSupplierAddressTP.CityName    as F_CityName,
        h.District                             as F_District,
        a._PurOrdSupplierAddressTP.PhoneNumber as F_PhoneNumber,
        a._PurOrdSupplierAddressTP.Region      as F_Region,
        a._PurOrdSupplierAddressTP.Country     as F_Country,
        cast( '' as bptaxnumxl   )             as F_InsEstadual,
        cast( '' as abap.sstring( 1333 )   )   as filePdf,
        f.CompanyCode
}
