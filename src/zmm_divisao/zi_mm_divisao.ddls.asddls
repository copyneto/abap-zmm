@AbapCatalog.sqlViewName: 'ZVMMDIVISAO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interface'
define root view ZI_MM_DIVISAO as select from ztmm_divisao {
    key gsber as Gsber,
    key bupla as Bupla,
    key werks as Werks,
    vkorg as Vkorg,
//    werks as Werks,
    bukrs as Bukrs,
    tplst as Tplst,
    ativo as Ativo,
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
