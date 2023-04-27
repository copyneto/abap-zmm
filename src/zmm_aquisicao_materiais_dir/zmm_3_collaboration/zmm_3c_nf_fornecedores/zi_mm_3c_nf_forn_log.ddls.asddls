@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '3Collaboration JOB Log'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define root view entity ZI_MM_3C_NF_FORN_LOG
  as select from ztmm_3c_job_log as _JobLog
    
  left outer join   balhdr          as _Appl on _Appl.log_handle = _JobLog.loghandle

  association [0..1] to balobjt                       as _ObjectText    on  _ObjectText.object = $projection.LogObjectId
                                                                        and _ObjectText.spras  = $session.system_language
  association [0..1] to balsubt                       as _SubObjectText on  _SubObjectText.object    = $projection.LogObjectId
                                                                        and _SubObjectText.subobject = $projection.LogObjectSubId
                                                                        and _SubObjectText.spras     = $session.system_language
  association [0..1] to I_CmmdtyDrvtvOrderUserDetails as _CreatedBy     on  _CreatedBy.UserID = $projection.aluser
{
  key _JobLog.loghandle,
      _JobLog.jobuuid,
      _Appl.object             as LogObjectId,
      _ObjectText.objtxt       as ObjectText,
      _Appl.subobject          as LogObjectSubId,
      _SubObjectText.subobjtxt as SubObjectText,
      _Appl.extnumber          as LogExternalId,
      _Appl.aldate             as DateFrom,
      _Appl.altime,
      _Appl.aluser,
      _CreatedBy.FullName,
      'Exibir Log'             as ExibirLog,
      _CreatedBy,
      _ObjectText,
      _SubObjectText
}
