@EndUserText.label: 'Buscar Variantes'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_MM_PLANLOG_VARI as projection on ZI_MM_PLANLOG_VARI as Vari {
    key  report,
    key  vari,
    key field,
    key cont,
    low,
    opti,
    high
} 
