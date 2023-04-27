@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Emissão de NF (Item)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_ADMIN_EMISSAO_NF_ITM
  as select from ZI_MM_ADMINISTRAR_EMISSAO_NF as Emissao

    inner join   ztmm_his_dep_fec             as _Historico on  _Historico.material              = Emissao.Material
                                                            and _Historico.plant                 = Emissao.OriginPlant
                                                            and _Historico.storage_location      = Emissao.OriginStorageLocation
                                                            and _Historico.batch                 = Emissao.Batch
                                                            and _Historico.plant_dest            = Emissao.DestinyPlant
                                                            and _Historico.storage_location_dest = Emissao.DestinyStorageLocation
                                                            and _Historico.process_step          = Emissao.ProcessStep
                                                            and _Historico.guid                  = Emissao.Guid
                                                            and _Historico.prm_dep_fec_id        = Emissao.PrmDepFecId
                                                            and _Historico.ean_type              = Emissao.EANType

  association to parent ZI_MM_ADMIN_EMISSAO_NF_CAB as _Header on _Header.Status = $projection.Status

{
  key  Emissao.Status, 
  key  Emissao.Material,
  key  Emissao.OriginPlant,
  key  Emissao.OriginStorageLocation,
  key  Emissao.Batch,
  key  Emissao.OriginUnit,
  key  Emissao.Unit,
  key  Emissao.Guid,
  key  Emissao.ProcessStep,
  key  Emissao.PrmDepFecId,
  key  Emissao.EANType,

       Emissao.StatusCriticality,
       Emissao.MaterialType,
       Emissao.Description,
       Emissao.OriginPlantType,
       Emissao.DestinyPlant,
       Emissao.DestinyPlantType,
       Emissao.DestinyStorageLocation,
       Emissao.UseAvailable,
       Emissao.UseAvailableCriticality,
       Emissao.UseAvailableCheckBox,
       Emissao.UseAvailableCheckBoxEnable,
       @Semantics.quantity.unitOfMeasure : 'Unit'
       Emissao.AvailableStock,
       @Semantics.quantity.unitOfMeasure : 'Unit'
       Emissao.AvailableStock_Conve,
       @Semantics.quantity.unitOfMeasure : 'Unit'
       Emissao.UsedStock,
       @Semantics.quantity.unitOfMeasure : 'Unit'
       Emissao.UsedStock_conve,
       Emissao.UsedStockCriticality,
       Emissao.Carrier,
       Emissao.Driver,
       Emissao.Equipment,
       Emissao.ShippingConditions,
       Emissao.ShippingType,
       Emissao.EquipmentTow1,
       Emissao.EquipmentTow2,
       Emissao.EquipmentTow3,
       Emissao.FreightMode,
       Emissao.MainPlant,
       Emissao.MainPurchaseOrder,
       Emissao.MainPurchaseOrderItem,
       Emissao.MainMaterialDocument,
       Emissao.MainMaterialDocumentYear,
       Emissao.MainMaterialDocumentItem,
       @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
       Emissao.OrderQuantity,
       Emissao.OrderQuantityUnit,
       Emissao.PurchaseOrder,
       Emissao.PurchaseOrderItem,
       Emissao.Incoterms1,
       Emissao.Incoterms2,
       Emissao.OutSalesOrder,
       Emissao.OutSalesOrderItem,
       Emissao.OutDeliveryDocument,
       Emissao.OutDeliveryDocumentItem,
       Emissao.OutMaterialDocument,
       Emissao.OutMaterialDocumentYear,
       Emissao.OutMaterialDocumentItem,
       Emissao.OutBR_NotaFiscal,
       Emissao.OutBR_NotaFiscalItem,
       Emissao.RepBR_NotaFiscal,
       Emissao.InDeliveryDocument,
       Emissao.InDeliveryDocumentItem,
       Emissao.InMaterialDocument,
       Emissao.InMaterialDocumentYear,
       Emissao.InMaterialDocumentItem,
       Emissao.InBR_NotaFiscal,
       Emissao.InBR_NotaFiscalItem,
       Emissao.CreatedBy,
       Emissao.CreatedAt,
       Emissao.LastChangedBy,
       Emissao.LastChangedAt,
       Emissao.LocalLastChangedAt,
       Emissao.Marmumren,
       Emissao.MarmUmrez,

       /* Campos navegação */

       Emissao.Pedido,
       Emissao.Pedido2,
       Emissao.NFNum,
       Emissao.NFNum2,

       /* Campos Abstract  */

       //    Emissao.NewCarrier,
       //    Emissao.NewDriver,
       //    Emissao.NewEquipment,
       //    Emissao.NewShippingConditions,
       //    Emissao.NewShippingType,
       //    Emissao.NewEquipmentTow1,
       //    Emissao.NewEquipmentTow2,
       //    Emissao.NewEquipmentTow3,
       //    Emissao.NewFreightMode,
       //    Emissao.NewUsedStock,

       /* Associations */
       _Header,

       Emissao._Carrier,
       Emissao._DestinyPlant,
       Emissao._DestinyPlantType,
       Emissao._DestinyStorageLocation,
       Emissao._Driver,
       Emissao._EANType,
       Emissao._Equipment,
       Emissao._EquipmentTow1,
       Emissao._EquipmentTow2,
       Emissao._EquipmentTow3,
       Emissao._FreightMode,
       Emissao._Material,
       Emissao._MaterialInfo,
       Emissao._MaterialType,
       Emissao._OriginPlant,
       Emissao._OriginPlantType,
       Emissao._OriginStorageLocation,
       Emissao._Serie,
       Emissao._ShippingConditions,
       Emissao._ShippingType,
       Emissao._Status

}
where
      Emissao.ProcessStep = 'F02'
  and Emissao.Status      = '99' -- Rascunho
