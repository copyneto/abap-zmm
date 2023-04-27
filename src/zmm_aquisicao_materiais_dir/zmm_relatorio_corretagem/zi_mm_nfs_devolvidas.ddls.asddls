@AbapCatalog.sqlViewName: 'ZVMM_NFSDEVOLVID'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interface Notas Fiscais Devolvidas'
@ObjectModel.usageType.serviceQuality: #C
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
//@ObjectModel.semanticKey: 'NotasDevolvidas'
//@ObjectModel.representativeKey: 'NotasDevolvidas'

define view ZI_MM_NFS_DEVOLVIDAS as select from I_BR_NFItemDocumentFlowFirst_C as _NFITEMDOC
  inner join C_BR_VerifyNotaFiscal          as _VERIFYnf  on _NFITEMDOC.BR_NotaFiscal   = _VERIFYnf.BR_NotaFiscal
                                                         and _VERIFYnf.BR_NFIsCanceled  = ''
  inner join ZI_MM_PARAM_NF_DEVOL_NFTYPE    as _Param     on _Param.NfType = _VERIFYnf.BR_NFType
{
    key _NFITEMDOC.BR_ReferenceNFNumber,
    sum( BR_ICMSBaseTotalAmount)            as ValorDevolucao
}
group by _NFITEMDOC.BR_ReferenceNFNumber
