@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Valor das Características do material de um item de pedido'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_VALOR_CARAC_DIV
  as select from ZI_MM_VALOR_CARAC
{
  key Ebeln,
  key Ebelp,
      division( Peneira10, Registros, 2 )      as Peneira10Div,
      division( Peneira11, Registros, 2 )      as Peneira11Div,
      division( Peneira12, Registros, 2 )      as Peneira12Div,
      division( Peneira13, Registros, 2 )      as Peneira13Div,
      division( Peneira14, Registros, 2 )      as Peneira14Div,
      division( Peneira15, Registros, 2 )      as Peneira15Div,
      division( Peneira16, Registros, 2 )      as Peneira16Div,
      division( Peneira17, Registros, 2 )      as Peneira17Div,
      division( Peneira18, Registros, 2 )      as Peneira18Div,
      division( Peneira19, Registros, 2 )      as Peneira19Div,
      division( CatacaoChegada, Registros, 2 ) as CatacaoChegadaDiv,
      CatacaoCompra,
      Registros
}
