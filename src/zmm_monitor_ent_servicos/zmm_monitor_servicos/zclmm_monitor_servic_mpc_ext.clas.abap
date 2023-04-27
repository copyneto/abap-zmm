class ZCLMM_MONITOR_SERVIC_MPC_EXT definition
  public
  inheriting from ZCLMM_MONITOR_SERVIC_MPC
  create public .

public section.

  methods DEFINE
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_MONITOR_SERVIC_MPC_EXT IMPLEMENTATION.


  METHOD define.

    super->define( ).

    DATA: lo_entity   TYPE REF TO /iwbep/if_mgw_odata_entity_typ,
          lo_property TYPE REF TO /iwbep/if_mgw_odata_property.

    DATA: lv_upload    TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name,
          lv_filenamen TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name.

    lv_upload = TEXT-t01.

    lo_entity = model->get_entity_type( iv_entity_name = lv_upload ).

    IF lo_entity IS BOUND.

      lv_filenamen = text-t02.

      lo_property = lo_entity->get_property( iv_property_name = lv_filenamen ).

      lo_property->set_as_content_type( ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
