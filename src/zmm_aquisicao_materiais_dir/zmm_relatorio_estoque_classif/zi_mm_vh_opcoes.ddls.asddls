@AbapCatalog.sqlViewName: 'ZVMM_IVHOPCOES'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Estoque Classificado - Opções'

@ObjectModel.resultSet.sizeCategory: #XS

define view ZI_MM_VH_OPCOES
  as select from dd07t
{
      @ObjectModel.text.element: [ 'StatusText' ]
  key domvalue_l as Id,
      @UI.hidden: true
  key ddlanguage as Language,
      @Semantics.text: true
      ddtext     as StatusText
}
where
      domname  = 'ZD_MM_OPCOES'
  and as4local = 'A'
