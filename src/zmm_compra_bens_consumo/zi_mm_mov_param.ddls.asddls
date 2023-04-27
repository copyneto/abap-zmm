@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'DD - Parâmetros direitos fiscais'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_MOV_PARAM
  as select from ztmm_mov_param as MovParam
  
  association [0..1] to I_BR_ICMSTaxSituation as _BR_ICMSTaxSituation  on _BR_ICMSTaxSituation.BR_ICMSTaxSituation = $projection.Taxsit
  
  association [0..1] to dd07l as _Domain  on _Domain.domname = 'ZD_PARAM_ATIVO'
 
{
  key shipfrom              as Shipfrom,
  key direcao               as Direcao,
  key cast(cfop as logbr_cfopcode preserving type) as Cfop,
  key matnr                 as Matnr,
  key matkl                 as Matkl,
  key taxlw1                as Taxlw1,
  key taxlw2                as Taxlw2,
  key taxlw5                as Taxlw5,
  key taxlw4                as Taxlw4,
  //key taxsit                as Taxsit,
  key cast(taxsit as abap.char( 1 )) as Taxsit,
      ativo                 as Ativo,      
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
      
      _BR_ICMSTaxSituation,
      _Domain
}
