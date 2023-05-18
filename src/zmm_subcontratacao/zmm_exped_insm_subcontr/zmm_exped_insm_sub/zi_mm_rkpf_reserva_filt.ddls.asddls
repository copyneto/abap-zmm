@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro Cabeçalho Reserva - RESB'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_mm_rkpf_reserva_filt
  as select from resb
{
  key rsnum as Rsnum,
  key ebeln as Ebeln

}
group by
  rsnum,
  ebeln
