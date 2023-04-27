@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Buscar Variantes'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_PLANLOG_VARIANTS as select from ztplanlog_vari {
    key report,
    key vari as variant
} where (  report = 'ZTRANICMSNFE'
        or report = 'MB52' 
        or report = 'ZWMSCONFPROD' 
        or report = 'ZSDR319' ) 
        and cont = 1  
   

