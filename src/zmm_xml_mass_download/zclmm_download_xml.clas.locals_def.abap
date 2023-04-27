*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section
CLASS lcl_download DEFINITION.
  PUBLIC SECTION.
"! Construtor
    METHODS constructor IMPORTING it_emi_tax TYPE if_rap_query_filter=>tt_range_option OPTIONAL
                                  it_emi_reg TYPE if_rap_query_filter=>tt_range_option OPTIONAL
                                  it_rec_tax TYPE if_rap_query_filter=>tt_range_option OPTIONAL
                                  it_rec_reg TYPE if_rap_query_filter=>tt_range_option OPTIONAL
                                  it_pstdat  TYPE if_rap_query_filter=>tt_range_option OPTIONAL
                                  it_docdat  TYPE if_rap_query_filter=>tt_range_option OPTIONAL
                                  it_nfenum  TYPE if_rap_query_filter=>tt_range_option OPTIONAL
                                  it_docnum  TYPE if_rap_query_filter=>tt_range_option OPTIONAL
                                  it_bukrs   TYPE if_rap_query_filter=>tt_range_option OPTIONAL
                                  it_branch  TYPE if_rap_query_filter=>tt_range_option OPTIONAL.
"! Tabela interna para armazenamento dos dados
    DATA gt_data TYPE STANDARD TABLE OF zc_mm_xml_mass.
"! Método para realizar a busca dos dados
    METHODS get_data
      IMPORTING iv_sort TYPE string OPTIONAL
    returning value(rt_result) like gt_data.

  PROTECTED SECTION.
  PRIVATE SECTION.
"! Constante indicando o tipo de NF - Entrada
    CONSTANTS gc_direct TYPE j_1bdirect VALUE '1'.

    DATA: gt_emissor_tax   TYPE if_rap_query_filter=>tt_range_option,
"!Tabelas internas para tratamento do filtro Região Emissor
          gt_emissor_regio TYPE if_rap_query_filter=>tt_range_option,
"!Tabelas internas para tratamento do filtro CNPJ Recebedor
          gt_recebe_tax    TYPE if_rap_query_filter=>tt_range_option,
"!Tabelas internas para tratamento do filtro Região Recebedor
          gt_recebe_regio  TYPE if_rap_query_filter=>tt_range_option,
"!Tabelas internas para tratamento do filtro Data de Lançamento
          gt_pstdat        TYPE if_rap_query_filter=>tt_range_option,
"!Tabelas internas para tratamento do filtro Data do Documento
          gt_docdat        TYPE if_rap_query_filter=>tt_range_option,
"!Tabelas internas para tratamento do filtro Número da Nota
          gt_nfenum        TYPE if_rap_query_filter=>tt_range_option,
"!Tabelas internas para tratamento do filtro Número do Documento
          gt_docnum        TYPE if_rap_query_filter=>tt_range_option,
"!Tabelas internas para tratamento do filtro Empresa
          gt_bukrs         TYPE if_rap_query_filter=>tt_range_option,
"!Tabelas internas para tratamento do filtro Local de Negócio
          gt_branch        TYPE if_rap_query_filter=>tt_range_option.

"!Variável para utilização na ordenação definida na CDS View
    DATA gv_sort TYPE string.

ENDCLASS.
