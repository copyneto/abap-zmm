*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

CONSTANTS:
  BEGIN OF gc_log,
    object    TYPE balobj_d VALUE 'ZMM',
    subobject TYPE balsubobj VALUE 'ZMM_LIB_PGTO',
  END OF gc_log,

   gc_status_pendente      TYPE c VALUE 'X',
   gc_status_revComercial  TYPE c VALUE 'A',
   gc_status_libComercial  TYPE c VALUE 'B',
   gc_status_revFinanceiro TYPE c VALUE 'C',
   gc_status_retComercial  TYPE c VALUE 'D',
   gc_status_libFinanceiro TYPE c VALUE 'E',
   gc_status_finalizado    TYPE c VALUE 'F'.
