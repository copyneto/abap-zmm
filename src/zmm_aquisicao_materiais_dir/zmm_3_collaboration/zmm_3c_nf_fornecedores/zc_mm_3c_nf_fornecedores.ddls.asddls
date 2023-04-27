@EndUserText.label: '3Collaboration  NF Forn - JOB'
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.semanticKey: ['LogExternalId']
@Metadata.allowExtensions: true
define root view entity ZC_MM_3C_NF_FORNECEDORES
  as projection on ZI_MM_3C_NF_FORNECEDORES
{
      @EndUserText.label: 'Job UUId'
  key JobUUId,
      @EndUserText.label: 'Objeto'
      @ObjectModel.text.element: ['ObjectText']
      Object,
      @EndUserText.label: 'Nome Objeto'
      ObjectText,
      @EndUserText.label: 'SubObjeto'
      @ObjectModel.text.element: ['SubObjectText']
      SubObject,
      @EndUserText.label: 'Nome SubObjeto'
      SubObjectText,
      @EndUserText.label: 'Nome da Variante'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_3C_JOB_VARIANTE', element: 'LogExternalId' } }]
      LogExternalId,
      @EndUserText.label: 'Criado por'
      @ObjectModel.text.element: ['CreatedByName']
      @UI.textArrangement: #TEXT_FIRST
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DADOS_USUARIO', element: 'ContactCardID' } }]
      CreatedBy,
      @EndUserText.label: 'Nome Criado por'
      CreatedByName,
      @EndUserText.label: 'Criado em'
      CreatedAt,
      @EndUserText.label: 'Criado em'
      CreatedAtTs,
      @EndUserText.label: 'Alterado por'
      @ObjectModel.text.element: ['ChangedByName']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DADOS_USUARIO', element: 'ContactCardID' } }]
      ChangedBy,
      @EndUserText.label: 'Nome Alterado por'
      ChangedByName,
      @EndUserText.label: 'Alterado em'
      ChangedAt,
      @EndUserText.label: 'Alterado em'
      ChangedAtTs,
      @EndUserText.label: 'Última alteração'
      LocalLastChangedAt,

      //      /* Associations */
      _Variant : redirected to composition child ZC_MM_3C_NF_FORN_VARIANT,
      _Log     : redirected to ZC_MM_3C_NF_FORN_LOG,
      _ObjectText,
      _SubObjectText,
      _CreatedBy,
      _ChangedBy
}
