@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro REFKEY'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_RETENC_FILT_REFKEY
  as select from I_BR_NFDocument
{
  key BR_NotaFiscal                                 as BR_NotaFiscal,

      concat( AccountingDocument, BR_NFFiscalYear ) as Refkey

}
