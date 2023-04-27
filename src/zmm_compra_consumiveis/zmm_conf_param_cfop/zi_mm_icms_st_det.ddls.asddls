@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca dos valores ICMS ST'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_ICMS_ST_DET as select from j_1btcestdet 
{
  key valid_from      as Valid_From,
  key ncm             as Ncm,
  key material        as Material,
      cest            as Cest,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_CDS_BTCESTDET'   
      @EndUserText.label: 'CEST Externo'
      cast ( j_1btcestdet.cest as abap.char( 9 ) )  as Cest_Out
}
