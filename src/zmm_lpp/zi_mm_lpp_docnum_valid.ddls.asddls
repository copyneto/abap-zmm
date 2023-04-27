@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Documentos válidos para LPP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_LPP_DOCNUM_VALID
  as select from I_BR_NFDocument as Doc
    inner join   ZI_MM_LPP_PARAM as LPP_PARAM on LPP_PARAM.Low = Doc.BR_NFType
{
  key Doc.BR_NotaFiscal as br_notafiscal
}
where
       Doc.BR_NFPostingDate     <= $session.user_date
  and  Doc.BR_NFDirection       =  '1'
  and  Doc.BR_NFDocumentType    =  '1'
  and(
       Doc.BR_NFPartnerFunction =  'LF'
    or Doc.BR_NFPartnerFunction =  'BR'
  )
  and  Doc.BR_NFIsCanceled      <> 'X'
  and  Doc.BR_NFeDocumentStatus =  '1'
