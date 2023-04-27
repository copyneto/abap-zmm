"!<p>Essa classe é utilizada para Disponibilizar condições adicionais para cenários
"!<p><strong>Autor:</strong> Bruno Costa - Meta</p>
"!<p><strong>Data:</strong> 11/02/2022</p>
CLASS zclmm_wf_condition_def DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_swf_flex_ifs_condition_def .

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS ZCLMM_WF_CONDITION_DEF IMPLEMENTATION.


  METHOD if_swf_flex_ifs_condition_def~get_conditions.

    ct_condition = VALUE #(
                          ( id = 'ZCostCenter'  subject = 'Badi: Centro de Custo'(001)    type = if_swf_flex_ifs_condition_def=>cs_condtype-start_step )
                          ( id = 'ZOrder'       subject = 'Badi: Ordem'(002)              type = if_swf_flex_ifs_condition_def=>cs_condtype-start_step )
                          ( id = 'ZPepType'     subject = 'Badi: Tipo de PEP'(003)        type = if_swf_flex_ifs_condition_def=>cs_condtype-start_step )
                          ( id = 'ZStorage'     subject = 'Badi: Centro e Depósito'(004)  type = if_swf_flex_ifs_condition_def=>cs_condtype-start_step )
                          ( id = 'ZBsart'       subject = 'Badi: Tipo Documento'(006)     type = if_swf_flex_ifs_condition_def=>cs_condtype-start_step )
                          ).

    ct_parameter = VALUE #(
                          ( id = 'ZCostCenter'  name = 'IsUsed'(007)    xsd_type = if_swf_flex_ifs_condition_def=>cs_xstype-string   mandatory = abap_true ) ##NO_TEXT
                          ( id = 'ZOrder'       name = 'IsUsed'(007)    xsd_type = if_swf_flex_ifs_condition_def=>cs_xstype-string   mandatory = abap_true ) ##NO_TEXT
                          ( id = 'ZPepType'     name = 'IsUsed'(007)    xsd_type = if_swf_flex_ifs_condition_def=>cs_xstype-string   mandatory = abap_true ) ##NO_TEXT
                          ( id = 'ZStorage'     name = 'IsUsed'(007)    xsd_type = if_swf_flex_ifs_condition_def=>cs_xstype-string   mandatory = abap_true ) ##NO_TEXT
                          ( id = 'ZBsart'       name = 'IsUsed'(007)    xsd_type = if_swf_flex_ifs_condition_def=>cs_xstype-string   mandatory = abap_true ) ##NO_TEXT
                          ).

  ENDMETHOD.
ENDCLASS.
