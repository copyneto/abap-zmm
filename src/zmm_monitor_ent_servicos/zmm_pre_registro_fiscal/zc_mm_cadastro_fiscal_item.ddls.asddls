@EndUserText.label: 'Proj. Cadastro Fiscal - Item'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_MM_CADASTRO_FISCAL_ITEM
  as projection on ZI_MM_CADASTRO_FISCAL_ITEM
  
{
  key Empresa,
  key Filial,
  key Lifnr,
//  @UI.hidden: true
//  key NrNf,
  key NrNf,
  key NrPedido,
  key ItmPedido,
//      NrNf2,
      Material,
      Descricao,
      Cfop,
      Iva,
      NFtype,
      Unid,
      Qtdade,
      QtdadeUtilizada,
      Qtdade_Lcto,
      VlUnit,
      VlTotUn,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      Currency,
      /* Associations */
      _Header : redirected to parent ZC_MM_CADASTRO_FISCAL_CABEC
}
