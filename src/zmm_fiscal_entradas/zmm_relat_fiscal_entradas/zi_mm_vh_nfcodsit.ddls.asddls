@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Código Situação NF'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_MM_VH_NFCODSIT
  as select from dd07l as Domain
  association to dd07t as _Text on  Domain.domname  = _Text.domname
                                and Domain.as4local = _Text.as4local
                                and Domain.valpos   = _Text.valpos
                                and Domain.as4vers  = _Text.as4vers
                                and _Text.ddlanguage     = $session.system_language
{
      @ObjectModel.text.element: ['Text']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @EndUserText.label: ' Código da situação NF'
  key cast( Domain.domvalue_l as j_1b_status_fisc_doc ) as NFCodSit,

      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Descrição'
      _Text.ddtext                                      as Text

}
where
      Domain.domname  = 'J_1B_STATUS_FISC_DOC'
  and Domain.as4local = 'A';
