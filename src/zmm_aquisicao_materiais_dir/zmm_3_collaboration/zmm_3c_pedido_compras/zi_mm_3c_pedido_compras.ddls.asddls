@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '3Collaboration JOB - Pedido Compras'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_3C_PEDIDO_COMPRAS
  as select from ztmm_3c_job as _Job

  composition [0..*] of ZI_MM_3C_PED_COMP_VARIANT      as _Variant

  association [0..1] to balobjt                       as _ObjectText    on  _ObjectText.object = $projection.Object
                                                                        and _ObjectText.spras  = $session.system_language
  association [0..1] to balsubt                       as _SubObjectText on  _SubObjectText.object    = $projection.Object
                                                                        and _SubObjectText.subobject = $projection.SubObject
                                                                        and _SubObjectText.spras     = $session.system_language
  association [0..1] to I_CmmdtyDrvtvOrderUserDetails as _CreatedBy     on  _CreatedBy.UserID = $projection.CreatedBy
  association [0..1] to I_CmmdtyDrvtvOrderUserDetails as _ChangedBy     on  _ChangedBy.UserID = $projection.ChangedBy

  association [0..*] to ZI_MM_3C_NF_FORN_LOG          as _Log           on  _Log.jobuuid = $projection.JobUUId

{
  key _Job.jobuuid               as JobUUId,
      //      _Handle.aldate             as aldate,
      //      _Handle.altime             as altime,
      //      _Handle.aluser             as aluser,
      _Job.object                as Object,
      _ObjectText.objtxt         as ObjectText,
      _Job.subobject             as SubObject,
      _SubObjectText.subobjtxt   as SubObjectText,
      _Job.jobname               as LogExternalId,
      @Semantics.user.createdBy: true
      _Job.created_by            as CreatedBy,
      _CreatedBy.FullName        as CreatedByName,
      @Semantics.systemDateTime.createdAt: true
      _Job.created_at            as CreatedAtTs,
      @Semantics.user.lastChangedBy: true
      _Job.last_changed_by       as ChangedBy,
      _ChangedBy.FullName        as ChangedByName,
      @Semantics.systemDateTime.lastChangedAt: true
      _Job.last_changed_at       as ChangedAtTs,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      _Job.local_last_changed_at as LocalLastChangedAt,

      tstmp_to_dats( cast( _Job.created_at as tzntstmps ),
                     abap_system_timezone( $session.client,'NULL' ),
                     $session.client,
                     'NULL' )    as CreatedAt,

      tstmp_to_dats( cast( _Job.last_changed_at as tzntstmps ),
                     abap_system_timezone( $session.client,'NULL' ),
                     $session.client,
                     'NULL' )    as ChangedAt,

      _Variant,
      _ObjectText,
      _SubObjectText,
      _CreatedBy,
      _ChangedBy,
      _Log
}
where
      _Job.object    = 'Z3COLLAB'
  and _Job.subobject = 'PEDCOMP'
