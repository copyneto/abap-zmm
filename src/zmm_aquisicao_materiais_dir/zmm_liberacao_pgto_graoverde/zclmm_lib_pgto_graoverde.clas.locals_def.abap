*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

CONSTANTS: BEGIN OF gc_status,
             desconto_financeiro(3)   TYPE c VALUE 'BEC',
             retorno_comercial(3)     TYPE c VALUE 'BEC',
             desconto_contabilizar(3) TYPE c VALUE 'EC',
             liberado_financeiro(3)   TYPE c VALUE 'BEC',
             finalizado(3)            TYPE c VALUE 'BEC',
           END OF gc_status,

           BEGIN OF gc_authority,
            desconto_financeiro   TYPE activ_auth VALUE '02',    " Desconto Financeiro
            liberar_financeiro    TYPE activ_auth VALUE '43',    " Liberar Financeiro
            retornar_comercial    TYPE activ_auth VALUE '85',    " Retornar Comercial
            contabilizar_desconto TYPE activ_auth VALUE '16',    " Contabilizar Descontos
            finalizar             TYPE activ_auth VALUE 'D9',    " Finalizar
           END OF gc_authority,

           gc_status_pendente      TYPE c VALUE 'X',
           gc_status_revComercial  TYPE c VALUE 'A',
           gc_status_libComercial  TYPE c VALUE 'B',
           gc_status_revFinanceiro TYPE c VALUE 'C',
           gc_status_retComercial  TYPE c VALUE 'D',
           gc_status_libFinanceiro TYPE c VALUE 'E',
           gc_status_finalizado    TYPE c VALUE 'F'.
