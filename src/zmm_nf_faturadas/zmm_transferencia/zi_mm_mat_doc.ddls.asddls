@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface Doc.Material'
define root view entity ZI_MM_MAT_DOC
  as select from matdoc as _GoodsMvt
{
  key concat(mblnr,mjahr) as BR_NFSourceDocumentNumber,
      mblnr               as MaterialDocument,
      mjahr               as MaterialDocumentYear,
      bldat               as DocumentDate,
      budat               as PostingDate

}
group by
  mblnr,
  mjahr,
  bldat,
  budat
