CLASS zclmm_inventario_nfe_mpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zclmm_inventario_nfe_mpc
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS define REDEFINITION.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclmm_inventario_nfe_mpc_ext IMPLEMENTATION.

  METHOD define.

    super->define(  ).

    TRY.

        DATA(lo_entity) = model->get_entity_type( iv_entity_name = gc_entity-name ).

        CHECK lo_entity IS BOUND.

        DATA(lo_property) = lo_entity->get_property( iv_property_name = gc_entity-node ).
        DATA(lo_annotation) = lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( iv_annotation_namespace =  /iwbep/if_mgw_med_odata_types=>gc_sap_namespace ).
        lo_annotation->add( iv_key   = /iwbep/if_ana_odata_types=>gcs_ana_odata_annotation_key-hierarchy_node_for
                            iv_value = CONV #( gc_entity-anno_key ) ).



        lo_property = lo_entity->get_property( iv_property_name = gc_entity-level ).
        lo_annotation = lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation(
                               iv_annotation_namespace =  /iwbep/if_mgw_med_odata_types=>gc_sap_namespace ).
        lo_annotation->add( iv_key   =  /iwbep/if_ana_odata_types=>gcs_ana_odata_annotation_key-hierarchy_level_for
                            iv_value = CONV #( gc_entity-anno_key ) ).


        lo_property = lo_entity->get_property( iv_property_name = gc_entity-parent  ).
        lo_annotation = lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation(
                                iv_annotation_namespace =  /iwbep/if_mgw_med_odata_types=>gc_sap_namespace ).
        lo_annotation->add( iv_key   = /iwbep/if_ana_odata_types=>gcs_ana_odata_annotation_key-hierarchy_parent_node_for
                            iv_value = CONV #( gc_entity-anno_key ) ).


        lo_property = lo_entity->get_property( iv_property_name = gc_entity-drill  ).
        lo_annotation = lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation(
                                iv_annotation_namespace =  /iwbep/if_mgw_med_odata_types=>gc_sap_namespace ).
        lo_annotation->add( iv_key   = /iwbep/if_ana_odata_types=>gcs_ana_odata_annotation_key-hierarchy_drill_state_for
                            iv_value = CONV #( gc_entity-anno_key ) ).

      CATCH /iwbep/cx_mgw_med_exception.
      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
