@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '3Collaboration Variante JOB'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZI_MM_3C_PED_COMP_VARIANT
  as select from ztmm_3c_variant

  association        to parent ZI_MM_3C_PEDIDO_COMPRAS as _JOB       on _JOB.JobUUId = $projection.JobUUId


  //  association [1]    to I_DataElementLabelText          as _DataElement on  _DataElement.ABAPDataElement = $projection.DataElement
  //                                                                        and _DataElement.Language        = $session.system_language
  association [1..1] to ZI_CA_PARAM_SIGN               as _Sign      on _Sign.DomvalueL = $projection.Sign
  association [1..1] to ZI_CA_PARAM_DDOPTION           as _Option    on _Option.DomvalueL = $projection.Opti
  association [0..1] to I_CmmdtyDrvtvOrderUserDetails  as _CreatedBy on _CreatedBy.UserID = $projection.CreatedBy
  association [0..1] to I_CmmdtyDrvtvOrderUserDetails  as _ChangedBy on _ChangedBy.UserID = $projection.ChangedBy
{
  key scruuid                                      as ScrUUId,
      jobuuid                                      as JobUUId,
      dataelement                                  as DataElement,
      sign                                         as Sign,
      _Sign.Text                                   as SignText,
      opti                                         as Opti,
      _Option.Text                                 as OptiText,
      low                                          as Low,
      high                                         as High,
      @Semantics.user.createdBy: true
      created_by                                   as CreatedBy,
      _CreatedBy.FullName                          as CreatedByName,
      @Semantics.systemDateTime.createdAt: true
      created_at                                   as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by                              as ChangedBy,
      _ChangedBy.FullName                          as ChangedByName,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at                              as ChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at                        as LocalLastChangedAt,
      cast( 'ZMMR_3C_PEDIDO_COMPRAS' as progname ) as ProgramName,

      _JOB,
      //      _DataElement,
      _Sign,
      _Option,
      _CreatedBy,
      _ChangedBy
}
