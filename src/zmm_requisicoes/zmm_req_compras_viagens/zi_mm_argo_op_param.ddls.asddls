@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface View ZTMM_ARGO_OP_PARAM'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_ARGO_OP_PARAM
  as select from ztmm_argo_op_par
  association [1..1] to ZI_CA_VH_MATERIAL as _Mara on $projection.Matnr = _Mara.Material
  association [1..1] to ZI_MM_VH_TP_OPER  as _Oper on $projection.Operacao = _Oper.Code
{
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_TP_OPER', element: 'Code' } }]
  key operacao              as Operacao,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_MATERIAL', element: 'Material' } }]
  key matnr                 as Matnr,
  key begda                 as Begda,
      active                as Active,
      case active
       when 'X' then 3
       else 1
       end                  as StatusCriticality,

      _Mara.Text            as MatnrText,
      _Oper.Text            as OperText,

      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      _Mara,
      _Oper
}
