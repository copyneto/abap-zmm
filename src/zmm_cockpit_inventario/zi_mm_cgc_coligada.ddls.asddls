@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CGC das Coligadas por Empresa'
define root view entity ZI_MM_CGC_COLIGADA
  as select from ztmm_cgccoligada
{
  key bukrs                 as Bukrs,
  key bupla                 as Bupla,
  key cgc                   as Cgc,
      kunnr                 as Kunnr,
      lifnr                 as Lifnr,
      filial                as Filial,
      vkorg                 as Vkorg,
      col_ci                as ColCi,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt
}
