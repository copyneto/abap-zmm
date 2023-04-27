@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro dos materiais do Grão Verde'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_FILTRO_MATNR_GRAVERD
  as select from    mara

    left outer join ekpo on mara.matnr = ekpo.matnr

{

  key ekpo.ebeln,
  key mara.matnr,

      case
      when mara.spart = '05' and ekpo.ebeln is null
      then 'X'
      when mara.spart = '05' and ekpo.ebeln is not null
      then ' '
      else ' ' end as Descons

}
