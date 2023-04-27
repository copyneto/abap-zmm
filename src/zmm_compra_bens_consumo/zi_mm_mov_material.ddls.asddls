@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Controle de Mercadoria'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_MOV_MATERIAL
  as select from mara
 association [0..1] to makt as _Makt on _Makt.matnr = $projection.Material
 association [0..1] to mard as _Mard on _Mard.matnr = $projection.Material
{
    matnr as Material,
    _Mard.werks as Centro,
    _Mard.lgort as Deposito,
    _Makt.maktx as DescricaoMaterial,
    @Semantics.quantity.unitOfMeasure : 'MeinsUtilizacaoLivre'
    _Mard.labst as UtilizacaoLivre,
    meins as MeinsUtilizacaoLivre,
    _Makt,
    _Mard
}
where _Makt.spras = 'P'
