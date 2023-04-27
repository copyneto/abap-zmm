class ZCLMM_WF_CONTRATO_DEF definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_SWF_FLEX_IFS_CONDITION_DEF .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_WF_CONTRATO_DEF IMPLEMENTATION.


  method IF_SWF_FLEX_IFS_CONDITION_DEF~GET_CONDITIONS.

    ct_condition = VALUE #(
                          ( id = 'ZBukrs'  subject = 'Badi: Empresa'            type = if_swf_flex_ifs_condition_def=>cs_condtype-start_step )
                          ( id = 'ZBsart'  subject = 'Badi: Tipo Documento'     type = if_swf_flex_ifs_condition_def=>cs_condtype-start_step )
                          ( id = 'ZEkgrp'  subject = 'Badi: Grupo comprador'    type = if_swf_flex_ifs_condition_def=>cs_condtype-start_step )
                          ).

    ct_parameter = VALUE #(
                          ( id = 'ZBukrs'   name = 'Empresa'        xsd_type = if_swf_flex_ifs_condition_def=>cs_xstype-string   mandatory = abap_true ) ##NO_TEXT
                          ( id = 'ZBsart'   name = 'TipoDoc'        xsd_type = if_swf_flex_ifs_condition_def=>cs_xstype-string   mandatory = abap_true ) ##NO_TEXT
                          ( id = 'ZEkgrp'   name = 'GrupoComprador' xsd_type = if_swf_flex_ifs_condition_def=>cs_xstype-string   mandatory = abap_true ) ##NO_TEXT
                          ).

  endmethod.
ENDCLASS.
