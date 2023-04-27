@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Filtro INNFEIT para Retorno Industrial'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_FILTRO_INNFEIT_INDUST
  as select from /xnfe/innfeit
{
  key guid_header as GuidHeader,
      cfop        as Cfop
}

where
     cfop = '6125'
  or cfop = '5125'
  or cfop = '5124'
  or cfop = '6124'
  or cfop = '5925'
  or cfop = '6925'
  or cfop = '5902'
  or cfop = '6902'
group by
  guid_header,
  cfop
