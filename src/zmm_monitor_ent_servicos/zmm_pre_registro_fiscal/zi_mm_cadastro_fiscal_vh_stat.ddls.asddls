@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help Status - Cadastro Fiscal'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.resultSet.sizeCategory: #XS
@Search.searchable: true
define view entity ZI_MM_CADASTRO_FISCAL_VH_STAT
  as select from ZI_MM_CADASTRO_FISCAL_CABEC
{
      @Search.defaultSearchElement: true
  key StatusFiscal as Status
}
group by
  StatusFiscal
