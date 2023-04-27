@EndUserText.label: 'Anexo Monitor de Serviço'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_MM_MONIT_SERV_ANEXO
  as projection on ZI_MM_MONIT_SERV_ANEXO
{
  key Empresa,
  key FilialH,
  key Lifnr,
  key NrNf,
  key CnpjCpf,
      @EndUserText.label: 'Linha'
  key Linha,
      Filename,
      Mimetype,
      @EndUserText.label: 'Conteúdo'
      Conteudo,
      @ObjectModel.text.element: ['CreatName']
      CreatedBy,
      CreatedAt,
      @ObjectModel.text.element: ['ChangName']
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      _User1.Text as CreatName,
      _User2.Text as ChangName,

      /* Associations */
      _Header : redirected to parent ZC_MM_MONIT_SERV_HEADER,
      _User1,
      _User2
}
