@EndUserText.label: 'Buscar Variantes'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_MM_PLANLOG_VARIANTS as projection on ZI_MM_PLANLOG_VARIANTS {
    key  report,
    key variant as vari
 
}
 