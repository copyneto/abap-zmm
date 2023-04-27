@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Processo Depósito Fechado - Mensagens'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_ADMINISTRAR_MSG
  as select from ZI_MM_DF_EMISSAO_NF as _Documentos
    
    inner join   ztmm_his_dep_msg                 as _msg on  _msg.material                  = _Documentos.Material
                                                       and _msg.plant                     = _Documentos.OriginPlant
                                                       and _msg.storage_location          = _Documentos.OriginStorageLocation
                                                       and _msg.batch                     = _Documentos.Batch
                                                       and _msg.plant_dest                = _Documentos.DestinyPlant
                                                       and _msg.storage_location_dest     = _Documentos.DestinyStorageLocation
                                                       and _msg.guid                      = _Documentos.Guid
                                                       
   inner join  ZI_MM_VH_DF_TIPO_EAN         as _MM_VH_DF_TIPO_EAN on _MM_VH_DF_TIPO_EAN.EANType = _MM_VH_DF_TIPO_EAN.EANType
                                                                 and _MM_VH_DF_TIPO_EAN.EANType = _Documentos.EANType  

 

 association to parent ZI_MM_ADMINISTRAR_EMISSAO_NF as _Emissao on  _Emissao.Material               = $projection.Material
                                                                 and _Emissao.OriginPlant           = $projection.OriginPlant
                                                                 and _Emissao.OriginStorageLocation = $projection.OriginStorageLocation
                                                                 and _Emissao.Batch                 = $projection.Batch
                                                                 and _Emissao.OriginUnit            = $projection.OriginUnit
                                                                 and _Emissao.Unit                  = $projection.Unit
                                                                 and _Emissao.Guid                  = $projection.Guid
                                                                 and _Emissao.ProcessStep           = $projection.ProcessStep
                                                                 and _Emissao.PrmDepFecId           = $projection.PrmDepFecId
                                                                 and _Emissao.DestinyPlant           = $projection.DestinyPlant
                                                                 and _Emissao.DestinyStorageLocation = $projection.DestinyStorageLocation
                                                                 and _Emissao.EANType               = $projection.EANType

                                                               
{
  key _Documentos.Material,
  key _Documentos.OriginPlant,
  key _Documentos.OriginStorageLocation,
  key _Documentos.Batch,
  key _Documentos.OriginUnit,
  key _Documentos.Unit,
  key _Documentos.Guid,
  key _Documentos.ProcessStep,
  key _Documentos.PrmDepFecId,
  key _Documentos.DestinyPlant,
  key _Documentos.DestinyStorageLocation,
  key cast( _MM_VH_DF_TIPO_EAN.EANType as ze_mm_df_ean_type ) as EANType,
  key _msg.sequencial as Sequencial,
_msg.type as Type,
_msg.msg as Msg,
_msg.created_by as CreatedBy,
_msg.created_at as CreatedAt,
_msg.last_changed_by as LastChangedBy,
_msg.last_changed_at as LastChangedAt,
_msg.local_last_changed_at as LocalLastChangedAt,

      /* associations */
       _Emissao
}
