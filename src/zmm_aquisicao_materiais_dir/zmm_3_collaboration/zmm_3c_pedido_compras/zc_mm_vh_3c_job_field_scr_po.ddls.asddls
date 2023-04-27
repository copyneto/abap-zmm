@EndUserText.label: 'Value Help - JOB Screen Fields'
@ObjectModel: { query.implementedBy: 'ABAP:ZCLMM_VH_JOB_SCREEN_FIELDS'}
@Search.searchable: true
@ObjectModel.resultSet.sizeCategory: #XS
define root custom entity ZC_MM_VH_3C_JOB_FIELD_SCR_PO
{

      @UI.hidden    : true
  key ProgramName   : progname;
      @EndUserText.label: 'Campo da Tela'
      @ObjectModel.text.element: ['FieldText']
      @UI.textArrangement: #TEXT_FIRST
  key FieldName     : rsscr_name;
      @EndUserText.label: 'Campo da Tela'
      @Search.defaultSearchElement: true
      FieldText     : abap.char(30);
      @UI.hidden    : true
      FieldType     : rsscr_kind;
      @EndUserText.label: 'Tipo de Campo'
      FieldTypeText : abap.char(20);
}
