
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Buscar Variantes'
@Metadata.allowExtensions: true

define root view entity ZI_MM_PLANLOG_VARI as select from ztplanlog_vari {
    key report,
    key vari,
    key field,
    key cont,
    low,
    opti,
    high
} where ( report = 'ZC_MM_TRANSFERENCIA'
        or report = 'MB52'
        or report = 'ZWMSCONFPROD' 
        or report = 'ZSDR319' )
   

