@EndUserText.label: 'Proj.Cadastro Fiscal - anexos'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_MM_CADASTRO_FISCAL_ANEXO
  as projection on ZI_MM_CADASTRO_FISCAL_ANEXO
{
  key Empresa,
  key FilialHeader,
  key Lifnr,
//  key NrNf,
  key NrNf,
  key CnpjCpf,
  key Linha,
//      NrNf2,
   @EndUserText.label: 'Descrição arquivo'
      Filename,
      Mimetype,
      Conteudo,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      /* Associations */
      _Header : redirected to parent ZC_MM_CADASTRO_FISCAL_CABEC

}
