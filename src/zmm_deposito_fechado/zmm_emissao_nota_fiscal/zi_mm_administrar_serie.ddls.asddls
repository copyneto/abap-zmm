@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Processo Depósito Fechado - Série'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_ADMINISTRAR_SERIE
//  as select from ZI_MM_RET_ARMAZENAGEM_UNION as _Documentos
  as select from ZI_MM_DF_EMISSAO_NF as _Documentos
    
//    inner join   ZI_MM_DF_EMISSAO_NF as _Documentos1 on   _Documentos.Material               = _Documentos1.Material
//                                                     and  _Documentos.OriginPlant            = _Documentos1.OriginPlant
//                                                     and  _Documentos.OriginStorageLocation  = _Documentos1.OriginStorageLocation 
//                                                     and  _Documentos.Batch                  = _Documentos1.Batch                
//                                                     and  _Documentos.OriginUnit             = _Documentos1.OriginUnit           
//                                                     and  _Documentos.Unit                   = _Documentos1.Unit                 
//                                                     and  _Documentos.Guid                   = _Documentos1.Guid                 
//                                                     and  _Documentos.ProcessStep            = _Documentos1.ProcessStep          
//                                                     and  _Documentos.PrmDepFecId            = _Documentos1.PrmDepFecId
//                                                     and  _Documentos1.Status                 <> '01' 
                                                               
    
    inner join   ztmm_his_dep_ser            as _Serie on  _Serie.material                  = _Documentos.Material
                                                       and _Serie.plant                     = _Documentos.OriginPlant
                                                       and _Serie.storage_location          = _Documentos.OriginStorageLocation
                                                       and _Serie.batch                     = _Documentos.Batch
                                                       and _Serie.plant_dest                = _Documentos.DestinyPlant
                                                       and _Serie.storage_location_dest     = _Documentos.DestinyStorageLocation
                                                       and _Serie.guid                      = _Documentos.Guid
                                                       
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
                                                                 and _Emissao.DestinyStorageLocation  = $projection.DestinyStorageLocation
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
  key cast( _Serie.serialno as abap.char(18) ) as SerialNo,
      ltrim( _Serie.serialno, '0')             as SerialNoText,

      @Semantics.user.createdBy: true
      _Serie.created_by                        as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      _Serie.created_at                        as CreatedAt,
      @Semantics.user.lastChangedBy: true
      _Serie.last_changed_by                   as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      _Serie.last_changed_at                   as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      _Serie.local_last_changed_at             as LocalLastChangedAt,
      
      _Documentos.Status,

      /* associations */
       _Emissao
}
group by 
_Documentos.Material,
_Documentos.OriginPlant,
_Documentos.OriginStorageLocation,
_Documentos.Batch,
_Documentos.OriginUnit,
_Documentos.Unit,
_Documentos.Guid,
_Documentos.ProcessStep,
_Documentos.PrmDepFecId,
_Documentos.DestinyPlant,
_Documentos.DestinyStorageLocation,  
_Documentos.EANType,
_Serie.serialno,
_Serie.serialno,
_Documentos.CreatedBy,
_Documentos.CreatedAt,
_Documentos.LastChangedBy,
_Documentos.LastChangedAt,
_Documentos.LocalLastChangedAt,
_Documentos.Status,
_MM_VH_DF_TIPO_EAN.EANType,
_Serie.created_by,
_Serie.created_at,
_Serie.last_changed_by,
_Serie.last_changed_at,
_Serie.local_last_changed_at

 
