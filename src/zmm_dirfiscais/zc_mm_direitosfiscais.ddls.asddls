@EndUserText.label: 'CDS Consumo - Direitos Fiscais'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_DIREITOSFISCAIS as projection on ZI_MM_DIREITOSFISCAIS {
    key Shipfrom,
    key Direcao,
    key Cfop,
    Ativo,
    Taxlw1,
    Taxlw2,
    Taxlw4,
    Taxlw5,
    Taxsit,
    Cbenef,
    Motdesicms,
    ZtipoCalc,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt
}
