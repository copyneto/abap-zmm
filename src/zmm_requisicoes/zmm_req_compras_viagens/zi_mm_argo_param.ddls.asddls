@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface View ZTMM_ARGO_PARAM'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_ARGO_PARAM
  as select from ztmm_argo_param
  association to ZI_CA_VH_COMPANY as _Company    on $projection.BUKRS = _Company.CompanyCode
  association to ZI_CA_VH_WERKS   as _Werks      on $projection.WERKS = _Werks.WerksCode
  association to ZI_CA_VH_KNTTP   as _Categoria  on $projection.KNTTP = _Categoria.CategoriaCode
  association to ZI_CA_VH_LIFNR   as _Fornecedor on $projection.LIFNR = _Fornecedor.LifnrCode
  association to ZI_CA_VH_EKGRP   as _CompGroup  on $projection.BKGRP = _CompGroup.CompGroupCode
  association to ZI_CA_VH_ZTERM   as _CondPgto   on $projection.ZTERM = _CondPgto.CndPgtoCode
  association to ZC_MM_VH_MWSKZ   as _IVA        on $projection.MWSKZ = _IVA.IVACode
{

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_COMPANY', element: 'CompanyCode' } }]
  key bukrs                        as BUKRS,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } }]
  key werks                        as WERKS,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_KNTTP', element: 'CategoriaCode' } }]
  key knttp                        as KNTTP,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_LIFNR', element: 'LifnrCode' } }]
  key lifnr                        as LIFNR,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_EKGRP', element: 'CompGroupCode' } }]
  key bkgrp                        as BKGRP,

  key begda                        as BEGDA,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_ZTERM', element: 'CndPgtoCode' } }]
      zterm                        as ZTERM,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZC_MM_VH_MWSKZ', element: 'IVACode' } }]
      mwskz                        as MWSKZ,
      active                       as ACTIVE,
      case active
       when 'X' then 3
       else 1
       end                         as StatusCriticality,

      _Company.CompanyCodeName     as Empresa,
      _Werks.WerksCodeName         as Centro,
      _Categoria.CategoriaCodeName as Categoria,
      _Fornecedor.LifnrCodeName    as Fornecedor,
      _CompGroup.CompGroupCode     as GrupoCompras,
      _CondPgto.CndPgtoCodeName    as CondPgto,
      _IVA.IVACodeName             as IVACodeName,

      @Semantics.user.createdBy: true
      created_by                   as CREATEDBY,
      @Semantics.systemDateTime.createdAt: true
      created_at                   as CREATEDAT,
      @Semantics.user.lastChangedBy: true
      last_changed_by              as LASTCHANGEDBY,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at              as LASTCHANGEDAT,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at        as LOCALLASTCHANGEDAT,

      _Company,
      _Werks,
      _Categoria,
      _Fornecedor,
      _CompGroup,
      _CondPgto,
      _IVA

}
