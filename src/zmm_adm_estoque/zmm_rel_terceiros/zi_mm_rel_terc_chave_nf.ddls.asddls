@AbapCatalog.sqlViewName: 'ZI_CHAVE_NF'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consulta da J_1BNFE_ACTIVE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view  ZI_MM_REL_TERC_CHAVE_NF as select from C_BR_VerifyNotaFiscal {
    key BR_NotaFiscal as docnum,
    BR_NFeAccessKey    
    
}
