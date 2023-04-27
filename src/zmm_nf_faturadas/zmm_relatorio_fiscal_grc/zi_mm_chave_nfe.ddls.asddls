@AbapCatalog.sqlViewName: 'ZVMM_CHAVENFE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Monta Chave NFE'
define view ZI_MM_CHAVE_NFE as select from j_1bnfe_active {
    key docnum,
    concat(concat(concat(concat(concat(concat(concat(concat(regio, nfyear),nfmonth),stcd1),model),serie),nfnum9),docnum9),cdv) as chaveNFE
}
