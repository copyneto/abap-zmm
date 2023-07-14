@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Exped. Insumos - Estorno'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_EXPEDARMAZ_URL_ESTRN
  as select from ZI_MM_EXPED_ARMAZENAGEM
{
  key     Docnum,
  key     Itmnum,
  key     LinAuxDocnum, 
  key     LinAuxItmnum,
  key     ekpoEbeln,
  key     ekpoEbelp,
  key     ActiveDocnum,
  key     ActiveTabdocnum,
  key     XNFEAuxguidHeader,
  key     XNFEguid,
  key     Vbeln,
  key     Mblnr,
  key     MsegMjahr,
  key     MsegZeile,
  key     Concatmblnr,
  key     Concatmjahr,
  key     Concatzeile,
  key     FltrLindocnum,
  key     FltrLinitmnum,
  key     DocDocnum,
  key     ActiveAuDocnum,
  key     FltLinDocnum,
  key     FltLinItmnum,
  key     Lfa1AuxLifnr,
  key     lfa1lifnr,
  key     Kna1AuxKunnr,
  key     ekkoEbeln,
  key     maktMatnr,
  key     maktSpras,
  key     BSDICAauart,
  key     BSDICApstyv,
  key     URLDocnum,
  key     URLItmnum,
  key     T001wshwerks,
          case
          when Status = 'Concluído' or Status = 'Verificar NF-e'
               then 'Estornar'
          else '' end as Estornar

}
