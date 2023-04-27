@EndUserText.label: 'CDS Consumo ALV Account'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_ALV_ACCOUNT as projection on ZI_MM_ALV_ACCOUNT {
    key Processo,
    key Bwart,
    key Grupo,
    key Newbs,
    Newko
}
