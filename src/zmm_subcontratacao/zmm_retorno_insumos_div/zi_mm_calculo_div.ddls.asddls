@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Calculo Div'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_CALCULO_DIV 
as select from ZI_MM_INSUMOS_MATDOC101 
{
    key Key1,
    key Key2,
    key Key3,
    key Key4,
    key Key5,
    key Key6,
    MatMenge,
    MatMenge101,
    bwart,
    ebeln,
    ebelp,
    matnr,
    lifnr,
    Menge,
    Bdmng,
    meins,
    cast( LvQtdePed as abap.dec( 13, 3 ) )  as LvQtdePed,
    cast( LvQtdeRet as abap.dec( 13, 3 ) )  as LvQtdeRet,
    cast( (LvQtdePed - LvQtdeRet) as abap.dec( 13, 3 ) )  as Divergencia
    //LvQtdePed,
    //LvQtdeRet,
    //(LvQtdePed - LvQtdeRet) as Divergencia
}
