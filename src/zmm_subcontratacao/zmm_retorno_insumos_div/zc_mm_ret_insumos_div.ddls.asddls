@EndUserText.label: 'Projection para ZI_MM_RET_INSUMOS_DIV'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_RET_INSUMOS_DIV 
as projection on ZI_MM_RET_INSUMOS_DIV 
{
    key lifnr,
    key werks,
    key matnr,
    key ebeln,
    key ebelp,
    budat,
    LifnrCodeName,
    WerksCodeName,
    maktx,
    shkzg,
    zeile,
    mjahr,
    LvQtdePed,
    LvQtdeRet,
    Divergencia,
    meins,
    docnum,
    nfenum,
    mblnr,
    /* Associations */
    _Lifnr,
    _MaterialText,
    _Werks
}
where
Marca = 'X' 
