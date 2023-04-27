*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
  TYPES:
    BEGIN OF ty_data,
      NumDocumento  TYPE char10,
      Empresa TYPE char4,
      Ano TYPE numc4,
      DocNumFinanceiro TYPE numc10,
      DocNumComercial TYPE numc10,
      URL_NumDocumento TYPE eso_longtext,
      URL_DocNumFinanceiro TYPE eso_longtext,
      URL_DocContabilComercial TYPE eso_longtext,
      TipoDocumento TYPE char2,
      Item TYPE numc3,
    END OF ty_data .
  TYPES:
    ty_table_data TYPE TABLE OF ty_data.
