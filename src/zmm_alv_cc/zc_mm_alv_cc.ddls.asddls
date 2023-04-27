@EndUserText.label: 'CDS Consumo - ALV CC'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_MM_ALV_CC as projection on ZI_MM_ALV_CC {
    key Bukrs,
    Kostl
}
