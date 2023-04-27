@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Parâmetro determinação IVA/CFOP/CTG'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_PARAM_MON_SERV
  as select from ztmm_param_monse

  association [0..1] to ZI_MM_PARAM_VH_BRANCH as _Branch on _Branch.BusinessPlace = $projection.Branch
  association [0..1] to ZI_CA_VH_WERKS        as _Werks  on _Werks.WerksCode = $projection.Werks
  association [0..1] to ZI_CA_VH_MATERIAL     as _Matnr  on _Matnr.Material = $projection.Matnr
  association [0..1] to ZI_CA_VH_MATKL        as _Matkl  on _Matkl.Matkl = $projection.Matkl
  //  association [0..1] to Zi_ca_vh_skat       as _Skat   on _Skat.Saknr = $projection.Hkont
  association [0..1] to ZI_MM_PARAM_VH_OPER   as _Oper   on _Oper.Operacao = $projection.Operacao
  association [0..1] to ZI_CA_VH_NFTYPE       as _Nftyp  on _Nftyp.BR_NFType = $projection.J1bnftype

{
      @EndUserText.label: 'Local de negócio'
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_PARAM_VH_BRANCH', element: 'BusinessPlace' } }]
  key branch                as Branch,
      @EndUserText.label: 'Centro'
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } }]
  key werks                 as Werks,
      @EndUserText.label: 'Material'
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_MATERIAL', element: 'Material' } }]
  key matnr                 as Matnr,
      @EndUserText.label: 'Grupo de mercadoria'
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_MATKL', element: 'Matkl' } }]
  key matkl                 as Matkl,
      @EndUserText.label: 'Conta contábil'
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'Zi_ca_vh_skat', element: 'Saknr' } }]
  key hkont                 as Hkont,
      @EndUserText.label: 'Tipo de operação'
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_PARAM_VH_OPER', element: 'Operacao' } }]
  key z_op                  as Operacao,
      @EndUserText.label: 'IVA'
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_MWSKZ', element: 'IVACode' } }]
      mwskz                 as Mwskz,
      @EndUserText.label: 'CFOP'
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_CFOP', element: 'Cfop' } }]
      cfop                  as Cfop,
      @EndUserText.label: 'Categoria de Nota'
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_NFTYPE', element: 'BR_NFType' } }]
      j_1bnftype            as J1bnftype,
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

      _Branch,
      _Werks,
      _Matnr,
      _Matkl,
      //      _Skat,
      _Oper,
      _Nftyp
}
