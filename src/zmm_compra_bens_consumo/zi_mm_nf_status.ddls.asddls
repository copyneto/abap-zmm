@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'NF STATUS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_NF_STATUS
  as select from ZI_MM_MOV_CNTRL
{
  key Id                as Id,
      Etapa             as Etapa,
      case
            when Etapa = 1 then 'Estornar'
            when Etapa = 2 then 'Estornar'
            when Etapa = 3 then 'Estornar'
            when Etapa = 4 then 'Estornar'
            when Etapa = 5 then 'Estornar'
            when Etapa = 6 then 'Estornar'
            else '' end as Estornar
}
