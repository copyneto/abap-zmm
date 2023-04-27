@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interface ALV Account'
define root view entity ZI_MM_ALV_ACCOUNT as select from ztmm_alv_account {
    key processo as Processo,
    key bwart as Bwart,
    key grupo as Grupo,
    key newbs as Newbs,
    newko as Newko
}
