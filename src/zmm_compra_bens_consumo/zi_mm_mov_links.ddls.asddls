@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Links'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_MOV_LINKS
  as select from ztmm_mov_cntrl
{
    id as Id,
    mblnr_sai as MovMatSaida,
    mblnr_ent as MovMatEntrada,
    docnum_s  as NFSaida,
    docnum_ent as NFEntrada   
    
}
