@EndUserText.label: '3Collaboration Ped. Comp. - Variante JOB'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_MM_3C_PED_COMP_VARIANT
  as projection on ZI_MM_3C_PED_COMP_VARIANT

{
          @EndUserText.label: 'Parâmetro UUId'
  key     ScrUUId,
          @EndUserText.label: 'Job UUId'
          JobUUId,
          @EndUserText.label: 'Nome do Campo'
          @ObjectModel.text.element: ['DataElementName']
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZC_MM_VH_3C_JOB_FIELD_SCR_PO',
                                                         element: 'FieldName' } }]
          DataElement,
          @EndUserText.label: 'Nome do Campo'
          @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLMM_3C_JOB_SCR_FIELD_VIRTUAL' }
  virtual DataElementName : abap.char(30),
          @EndUserText.label: 'Tipo'
          @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLMM_3C_JOB_SCR_FIELD_VIRTUAL' }
  virtual Type            : rsscr_kind,
          @EndUserText.label: 'Sinal'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_PARAM_SIGN',
                                                         element: 'DomvalueL' }}]
          @ObjectModel.text.element: ['SignText']
          @UI.textArrangement: #TEXT_LAST
          Sign,
          @EndUserText.label: 'Nome Sinal'
          SignText,
          @EndUserText.label: 'Opção'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_PARAM_DDOPTION',
                                                         element: 'DomvalueL' }}]
          @ObjectModel.text.element: ['OptiText']
          @UI.textArrangement: #TEXT_LAST
          Opti,
          @EndUserText.label: 'Nome Opção'
          OptiText,
          @EndUserText.label: 'De'
          Low,
          @EndUserText.label: 'Até'
          High,
          @EndUserText.label: 'Criado por'
          @ObjectModel.text.element: ['CreatedByName']
          CreatedBy,
          @EndUserText.label: 'Nome Criado por'
          CreatedByName,
          @EndUserText.label: 'Criado em'
          CreatedAt,
          @EndUserText.label: 'Alterado por'
          @ObjectModel.text.element: ['ChangedByName']
          ChangedBy,
          @EndUserText.label: 'Nome Alterado por'
          ChangedByName,
          @EndUserText.label: 'Alterado em'
          ChangedAt,
          @EndUserText.label: 'Última alteração'
          LocalLastChangedAt,
          @EndUserText.label: 'Programa JOB'
          ProgramName,

          /* Associations */
          _JOB : redirected to parent ZC_MM_3C_PEDIDO_COMPRAS,
          //      _DataElement,
          _Sign,
          _Option,
          _CreatedBy,
          _ChangedBy
}
