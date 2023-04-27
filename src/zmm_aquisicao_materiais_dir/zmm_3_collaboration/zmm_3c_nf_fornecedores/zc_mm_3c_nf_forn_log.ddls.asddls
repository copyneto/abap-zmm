@EndUserText.label: '3Collaboration NF Forn - JOB Log'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_3C_NF_FORN_LOG
  as projection on ZI_MM_3C_NF_FORN_LOG
{
      @EndUserText.label: 'Log Handle'
  key loghandle,
      @EndUserText.label: 'Job UUId'
      jobuuid,
      @EndUserText.label: 'Objeto'
      @ObjectModel.text.element: ['ObjectText']
      LogObjectId,
      @EndUserText.label: 'Nome Objeto'
      ObjectText,
      @EndUserText.label: 'SubObjeto'
      @ObjectModel.text.element: ['SubObjectText']
      LogObjectSubId,
      @EndUserText.label: 'Nome SubObjeto'
      SubObjectText,
      @EndUserText.label: 'Nome da Variante'
      LogExternalId,
      @EndUserText.label: 'Data Execução'
      DateFrom,
      @EndUserText.label: 'Hora Execução'
      altime,
      @EndUserText.label: 'Usuário Execução'
      @ObjectModel.text.element: ['FullName']
      @UI.textArrangement: #TEXT_FIRST
      aluser,
      @EndUserText.label: 'Nome Usuário'
      FullName,
      @EndUserText.label: 'Exibir Log'
      ExibirLog,

      /* Associations */
      _CreatedBy,
      _ObjectText,
      _SubObjectText

}
