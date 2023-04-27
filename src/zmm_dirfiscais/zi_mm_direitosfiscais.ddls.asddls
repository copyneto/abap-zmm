@EndUserText.label: 'CDS Interface - Direitos Fiscais'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZI_MM_DIREITOSFISCAIS as select from ztmm_dirfiscais {
    key shipfrom as Shipfrom,
    key direcao as Direcao,
    key cfop as Cfop,
    ativo as Ativo,
    taxlw1 as Taxlw1,
    taxlw2 as Taxlw2,
    taxlw4 as Taxlw4,
    taxlw5 as Taxlw5,
    taxsit as Taxsit,
    cbenef as Cbenef,
    motdesicms as Motdesicms,
    ztipo_calc as ZtipoCalc,
    @Semantics.user.createdBy: true
    created_by as CreatedBy,
    @Semantics.systemDateTime.createdAt: true
    created_at as CreatedAt,
    @Semantics.user.lastChangedBy: true
    last_changed_by as LastChangedBy,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at as LastChangedAt,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    local_last_changed_at as LocalLastChangedAt
}
