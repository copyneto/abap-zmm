@EndUserText.label: 'Consumption View ZTMM_ARGO_OP_PARAM'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_ARGO_OP_PARAM
  as projection on ZI_MM_ARGO_OP_PARAM as Oper
{
      @ObjectModel.text.element: ['OperText']
  key Operacao,
      @ObjectModel.text.element: ['MatnrText']
  key Matnr,
  key Begda,
      @EndUserText.label: 'Ativo'
      Active,
      StatusCriticality,
      MatnrText,
      OperText,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      /* Associations */
      _Mara,
      _Oper
}
