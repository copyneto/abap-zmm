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
      @ObjectModel.text.element: ['CreatName']
      CreatedBy,
      CreatedAt,
      @ObjectModel.text.element: ['ModName']
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      _UsrCret.Text as CreatName,
      _UsrMod.Text  as ModName,
      /* Associations */
      _Mara,
      _Oper
}
