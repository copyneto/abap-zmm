class ZCLMM_WF_CONDITION_PEDIDO_DEF definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_SWF_FLEX_IFS_CONDITION_DEF .
ENDCLASS.



CLASS ZCLMM_WF_CONDITION_PEDIDO_DEF IMPLEMENTATION.


  METHOD if_swf_flex_ifs_condition_def~get_conditions.

    ct_condition = VALUE #(
                          ( id = 'ZBsart'  subject = 'Badi: Tipo Documento'  type = if_swf_flex_ifs_condition_def=>cs_condtype-start_step )
                          ( id = 'ZEkgrp'  subject = 'Badi: Grupo comprador' type = if_swf_flex_ifs_condition_def=>cs_condtype-start_step )
                          ( id = 'ZWerks'  subject = 'Badi: Centro'          type = if_swf_flex_ifs_condition_def=>cs_condtype-start_step )
                          ).

    ct_parameter = VALUE #(
                          ( id = 'ZBsart'   name = 'TipoDoc'           xsd_type = if_swf_flex_ifs_condition_def=>cs_xstype-string   mandatory = abap_true ) ##NO_TEXT
                          ( id = 'ZEkgrp'   name = 'GrupoComprador'    xsd_type = if_swf_flex_ifs_condition_def=>cs_xstype-string   mandatory = abap_true ) ##NO_TEXT
                          ( id = 'ZWerks'   name = 'Centro'            xsd_type = if_swf_flex_ifs_condition_def=>cs_xstype-string   mandatory = abap_true ) ##NO_TEXT
                          ).

*    ct_condition = VALUE #(
*               ( id = 'ZPlant' subject = 'O Centro do pedido é'(003) type = if_swf_flex_ifs_condition_def=>cs_condtype-start_step ) ).
*
*    ct_parameter = VALUE #(
*                            ( id           = 'ZPlant'(004)
*                              name         = 'Centro'(005)
*                              xsd_type     = if_swf_flex_ifs_condition_def=>cs_xstype-string
*                              mandatory    = abap_true
*                              service_path = '/sap/opu/odata/sap/S_MMPURWorkflowVH_CDS'(006)
*                              entity       = 'S_MMPURWorkflowVH'(007)
*                              property     = 'Plant'(008)
*                          ) ).

  ENDMETHOD.
ENDCLASS.
