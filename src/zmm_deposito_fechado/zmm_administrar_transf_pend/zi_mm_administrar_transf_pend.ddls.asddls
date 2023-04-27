@EndUserText.label: 'Administrar Transf. Pendentes'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_ADMINISTRAR_TRANSF_PEND

  as select from           ztmm_his_dep_fec       as HistoricoDepFechado

    left outer to one join I_MaterialDocumentItem as _MaterialDocument             on  HistoricoDepFechado.main_material_document      = _MaterialDocument.MaterialDocument
                                                                                   and HistoricoDepFechado.main_material_document_year = _MaterialDocument.MaterialDocumentYear
                                                                                   and HistoricoDepFechado.main_material_document_item = _MaterialDocument.MaterialDocumentItem

    left outer to one join I_MaterialDocumentItem as _MaterialDocumentRem          on  HistoricoDepFechado.out_material_document      = _MaterialDocumentRem.MaterialDocument
                                                                                   and HistoricoDepFechado.out_material_document_year = _MaterialDocumentRem.MaterialDocumentYear
                                                                                   and HistoricoDepFechado.out_material_document_item = _MaterialDocumentRem.MaterialDocumentItem

    left outer to one join I_PurchaseOrderAPI01   as _PurchaseOrderAPI01           on  _PurchaseOrderAPI01.PurchaseOrder     = HistoricoDepFechado.main_purchase_order
                                                                                   and _PurchaseOrderAPI01.PurchaseOrderType = 'ZDF'

    left outer to one join I_BR_NFDocument        as _NotaFiscal_EscEntDF          on  HistoricoDepFechado.rep_br_nota_fiscal = _NotaFiscal_EscEntDF.BR_NotaFiscal
                                                                                   and 'MG'                                   = _NotaFiscal_EscEntDF.BR_NFPartnerRegionCode

    left outer to one join I_BR_NFDocument        as _NotaFiscal_DocRemessaDF      on HistoricoDepFechado.out_br_nota_fiscal = _NotaFiscal_DocRemessaDF.BR_NotaFiscal

    left outer to one join I_BR_NFDocument        as _NotaFiscal_DocEntradaRemessa on HistoricoDepFechado.in_br_nota_fiscal = _NotaFiscal_DocEntradaRemessa.BR_NotaFiscal

  association [0..1] to I_BR_NFeDocumentStatusText     as _NomeStatusDocRemessaDF      on  _NotaFiscal_DocRemessaDF.BR_NFeDocumentStatus = _NomeStatusDocRemessaDF.BR_NFeDocumentStatus
                                                                                       and _NomeStatusDocRemessaDF.Language              = $session.system_language

  association [0..1] to I_BR_NFeDocumentStatusText     as _NomeStatusDocEntradaRemessa on  _NotaFiscal_DocEntradaRemessa.BR_NFeDocumentStatus = _NomeStatusDocEntradaRemessa.BR_NFeDocumentStatus
                                                                                       and _NomeStatusDocEntradaRemessa.Language              = $session.system_language

  //  association [0..1] to ZI_CA_VH_MATERIAL              as _Material                    on  _Material.Material = $projection.Material
  association [0..1] to ZI_MM_VH_CENTRO_ORIGEM_DEP_FEC as _OriginPlant                 on  _OriginPlant.Plant = $projection.OriginPlant
  association [0..1] to ZI_CA_VH_LGORT                 as _OriginStorageLocation       on  _OriginStorageLocation.Plant           = $projection.OriginPlant
                                                                                       and _OriginStorageLocation.StorageLocation = $projection.OriginStorageLocation
  association [0..1] to ZI_MM_VH_CENTRO_DEST_DEP_FEC   as _DestinyPlant                on  _DestinyPlant.Plant = $projection.DestinyPlant
  association [0..1] to ZI_CA_VH_LGORT                 as _DestinyStorageLocation      on  _DestinyStorageLocation.Plant           = $projection.DestinyPlant
                                                                                       and _DestinyStorageLocation.StorageLocation = $projection.DestinyStorageLocation
  association [0..1] to ZI_MM_VH_PROCESS_STEP          as _ProcessStep                 on  _ProcessStep.ProcessStep = $projection.ProcessStep
  association [0..1] to ZI_MM_VH_DF_STATUS             as _Status                      on  _Status.Status = $projection.Status
  association [0..1] to ZI_CA_VH_USER                  as _CriadoPor                   on  _CriadoPor.Bname = $projection.CriadoPor

{


      //  key HistoricoDepFechado.material                   as Material,
  key ''                                                     as Material,
  key HistoricoDepFechado.plant                              as OriginPlant,
  key HistoricoDepFechado.storage_location                   as OriginStorageLocation,
  key HistoricoDepFechado.plant_dest                         as DestinyPlant,
  key HistoricoDepFechado.storage_location_dest              as DestinyStorageLocation,
  key HistoricoDepFechado.freight_order_id                   as FreightOrder,
  key HistoricoDepFechado.delivery_document                  as OutboundDelivery,
  key HistoricoDepFechado.process_step                       as ProcessStep,
  key min( bintohex( HistoricoDepFechado.guid ) )            as Guid,
      HistoricoDepFechado.status                             as Status,
      _Status.StatusText                                     as StatusText,

      case HistoricoDepFechado.status
      when '00' then 0 -- Inicial
      when '01' then 2 -- Em processamento
      when '02' then 1 -- Incompleto
      when '03' then 3 -- Completo
                else 0
      end                                                    as StatusCriticality,

      //      _Material.Text                                        as MaterialName,
      _OriginPlant.PlantName                                 as OriginPlantName,
      _OriginStorageLocation.StorageLocationText             as OriginStorageLocationName,
      _DestinyPlant.PlantName                                as DestinyPlantName,
      _DestinyStorageLocation.StorageLocationText            as DestinyStorageLocationName,
      _ProcessStep.ProcessStepText                           as ProcessStepName,

      case when HistoricoDepFechado.main_material_document is not initial
           then concat( HistoricoDepFechado.main_material_document,
                        HistoricoDepFechado.main_material_document_year )
           else '' end                                       as EntradaTransf,

      HistoricoDepFechado.main_purchase_order                as NumPedido,


      HistoricoDepFechado.main_material_document             as DocMaterialOriginal,
      HistoricoDepFechado.main_material_document_year        as AnoDocMaterialOriginal,
      min( HistoricoDepFechado.main_material_document_item ) as ItemDocMaterialOriginal,

      HistoricoDepFechado.created_by                         as CriadoPor,
      //      _PurchaseOrderAPI01.CreatedByUser                     as CriadoPor,
      _CriadoPor.Text                                        as CriadoPorNome,

      HistoricoDepFechado.rep_br_nota_fiscal                 as EscEntDF,

      HistoricoDepFechado.out_br_nota_fiscal                 as DocRemessaDF,

      HistoricoDepFechado.purchase_order                     as NumPedidoSaidaRemessa,

      case when HistoricoDepFechado.out_material_document is not initial
           then concat( HistoricoDepFechado.out_material_document,
                HistoricoDepFechado.out_material_document_year )
           else '' end                                       as NumMovSaidaRemessa,

      HistoricoDepFechado.out_material_document              as OutMaterialDocument,
      HistoricoDepFechado.out_material_document_year         as OutMaterialDocumentYear,

      HistoricoDepFechado.out_material_document              as DocMaterialRemOriginal,
      HistoricoDepFechado.out_material_document_year         as AnoDocMaterialRemOriginal,
      min( HistoricoDepFechado.out_material_document_item )  as ItemDocMaterialRemOriginal,

      _NotaFiscal_DocRemessaDF.BR_NFeDocumentStatus          as StatusSefaz_DocRemessaDF,
      _NomeStatusDocRemessaDF.BR_NFeDocumentStatusDesc       as NomeStatusDocRemessaDF,

      case when _NotaFiscal_DocRemessaDF.BR_NFeDocumentStatus = '1'
           then 3
           when _NotaFiscal_DocRemessaDF.BR_NFeDocumentStatus = '2'
             or _NotaFiscal_DocRemessaDF.BR_NFeDocumentStatus = '3'
           then 1
           else 0 end                                        as StatusDocRemessaDFCritic,

      HistoricoDepFechado.in_br_nota_fiscal                  as DocEntradaRemessa,

      _NotaFiscal_DocEntradaRemessa.BR_NFeDocumentStatus     as StatusSefaz_DocEntradaRemessa,
      _NomeStatusDocEntradaRemessa.BR_NFeDocumentStatusDesc  as NomeStatusDocEntradaRemessa,

      case when _NotaFiscal_DocEntradaRemessa.BR_NFeDocumentStatus = '1'
           then 3
           when _NotaFiscal_DocEntradaRemessa.BR_NFeDocumentStatus = '2'
             or _NotaFiscal_DocEntradaRemessa.BR_NFeDocumentStatus = '3'
           then 1
           else 9 end                                        as StatusDocEntradaRemessaCritic,

      case when HistoricoDepFechado.in_material_document is not initial
           then concat( HistoricoDepFechado.in_material_document,
                        HistoricoDepFechado.in_material_document_year )
           else '' end                                       as DocMaterialEntradaRemessa,

      HistoricoDepFechado.in_material_document               as InMaterialDocument,
      HistoricoDepFechado.in_material_document_year          as InMaterialDocumentYear,

      case when HistoricoDepFechado.in_br_nota_fiscal is initial
           then cast( ''  as boole_d )
           else cast( 'X' as boole_d ) end                   as Processado


}
group by
//  HistoricoDepFechado.material,
  HistoricoDepFechado.plant,
  HistoricoDepFechado.storage_location,
  HistoricoDepFechado.plant_dest,
  HistoricoDepFechado.storage_location_dest,
  HistoricoDepFechado.freight_order_id,
  HistoricoDepFechado.delivery_document,
  HistoricoDepFechado.process_step,
  //  HistoricoDepFechado.guid,
  HistoricoDepFechado.status,
  _Status.StatusText,
  //  _Material.Text,
  _OriginPlant.PlantName,
  _OriginStorageLocation.StorageLocationText,
  _DestinyPlant.PlantName,
  _DestinyStorageLocation.StorageLocationText,
  _ProcessStep.ProcessStepText,
  HistoricoDepFechado.main_purchase_order,
  HistoricoDepFechado.main_material_document,
  HistoricoDepFechado.main_material_document_year,
  //  HistoricoDepFechado.main_material_document_item,
  HistoricoDepFechado.created_by,
  _CriadoPor.Text,
  HistoricoDepFechado.rep_br_nota_fiscal,
  HistoricoDepFechado.out_br_nota_fiscal,
  HistoricoDepFechado.purchase_order,
  HistoricoDepFechado.out_material_document,
  HistoricoDepFechado.out_material_document_year,
  HistoricoDepFechado.out_material_document,
  HistoricoDepFechado.out_material_document_year,
  //  HistoricoDepFechado.out_material_document_item,
  _NotaFiscal_DocRemessaDF.BR_NFeDocumentStatus,
  _NomeStatusDocRemessaDF.BR_NFeDocumentStatusDesc,
  HistoricoDepFechado.in_br_nota_fiscal,
  _NotaFiscal_DocEntradaRemessa.BR_NFeDocumentStatus,
  _NomeStatusDocEntradaRemessa.BR_NFeDocumentStatusDesc,
  HistoricoDepFechado.in_material_document,
  HistoricoDepFechado.in_material_document_year


//where
//  HistoricoDepFechado.destiny_plant_type = '01'
