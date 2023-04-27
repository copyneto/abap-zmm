@AbapCatalog.sqlViewName: 'ZVMM_IVHSTATUS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Estoque Classificado - Status'

@ObjectModel.resultSet.sizeCategory: #XS

define view ZI_MM_NRM_APR_STATUS
  as select from ZI_PP_NRM_APR_STATUS
{
  key StatusId,
      Language,
      StatusText
}
