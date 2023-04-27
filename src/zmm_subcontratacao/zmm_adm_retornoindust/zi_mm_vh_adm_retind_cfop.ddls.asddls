@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Seach Help CFOP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_VH_ADM_RETIND_CFOP as select from /xnfe/innfeit {
      @EndUserText.label: 'Chave de Acesso'
      key cfop
}

group by cfop

