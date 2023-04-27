@EndUserText.label: 'CDS Consumo'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_COLIGADA as projection on ZI_MM_COLIGADA {
    key Bukrs,
    key Bupla,
    key Cgc,
    key Filial,
    Kunnr,
    Lifnr,
//    Filial,
    Vkorg,
    ColCi
}
