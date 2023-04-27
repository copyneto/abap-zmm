@EndUserText.label: 'CDS Consumo'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_DIVISAO as projection on ZI_MM_DIVISAO {
    key Gsber,
    key Bupla,
    key Werks,
    Vkorg,
//    Werks,
    Bukrs,
    Tplst,
    Ativo,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt
}
