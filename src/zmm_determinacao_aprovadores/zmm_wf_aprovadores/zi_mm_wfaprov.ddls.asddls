@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cds Interface Aprovadores'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_WFAPROV as select from ztmm_wfaprov 
    association [0..1] to ZI_CA_VH_WERKS as _Centro on _Centro.WerksCode = $projection.Werks
    association [0..1] to ZI_CA_VH_USER  as _User   on  _User.Bname = $projection.Usnam
    association [0..1] to ZI_CA_VH_LGORT as _Dep    on  _Dep.Plant  = $projection.Werks and
                                                        _Dep.StorageLocation = $projection.Lgort
{
    key guid as Guid,
    @EndUserText.label: 'Centro'
    werks as Werks,
    @EndUserText.label: 'Depósito'
    lgort as Lgort,
    @EndUserText.label: 'Usuário'
    usnam as Usnam,
    @Semantics.user.createdBy: true
    created_by as CreatedBy,
    @Semantics.systemDateTime.createdAt: true
    created_at as CreatedAt,
    @Semantics.user.lastChangedBy: true
    last_changed_by as LastChangedBy,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at as LastChangedAt,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    local_last_changed_at as LocalLastChangedAt,
    
    _Centro,
    _User,
    _Dep
    
}
