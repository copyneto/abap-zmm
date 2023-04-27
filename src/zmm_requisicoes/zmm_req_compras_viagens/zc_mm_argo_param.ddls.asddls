@EndUserText.label: 'Consumption View ZTMM_ARGO_PARAM'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_ARGO_PARAM
  as projection on ZI_MM_ARGO_PARAM as Argo
{
      @ObjectModel.text.element: ['Empresa']
  key BUKRS,
      @ObjectModel.text.element: ['Centro']
  key WERKS,
      @ObjectModel.text.element: ['Categoria']
  key KNTTP,
      @ObjectModel.text.element: ['Fornecedor']
  key LIFNR,
      @ObjectModel.text.element: ['GrupoCompras']
  key BKGRP,
  key BEGDA,
      @ObjectModel.text.element: ['CondPgto']
      ZTERM,
      @ObjectModel.text.element: ['IVACodeName']
      MWSKZ,
      @EndUserText.label: 'Ativo'
      ACTIVE,
      StatusCriticality,
      Empresa,
      Centro,
      Categoria,
      Fornecedor,
      GrupoCompras,
      CondPgto,
      IVACodeName,
      CREATEDBY,
      CREATEDAT,
      LASTCHANGEDBY,
      LASTCHANGEDAT,
      LOCALLASTCHANGEDAT,
      /* Associations */
      _Categoria,
      _Company,
      _CompGroup,
      _CondPgto,
      _Fornecedor,
      _Werks
}
