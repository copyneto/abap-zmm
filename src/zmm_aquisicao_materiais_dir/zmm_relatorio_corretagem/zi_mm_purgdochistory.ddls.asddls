@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interface da PurgDocHistory'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_PurgDocHistory
  as select from PurgDocHistory as _PurgDoc
{

  key concat(_PurgDoc.BELNR,_PurgDoc.GJAHR) as ReferenceDocument,
      _PurgDoc.EBELN                        as DocumentoCompra,
      substring(_PurgDoc.BUDAT,5,2)         as Periodo,
      _PurgDoc.WERKS                        as Centro,
      _PurgDoc.BLDAT                        as DataEntrada
}
where
  BEWTP = 'Q'
