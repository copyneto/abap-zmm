class ZCLMM_PRE_REGISTRO_F_MPC_EXT definition
  public
  inheriting from ZCLMM_PRE_REGISTRO_F_MPC
  create public .

public section.

  methods DEFINE
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_PRE_REGISTRO_F_MPC_EXT IMPLEMENTATION.


  METHOD define.

    CONSTANTS :
      lc_entity_file_upload TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name VALUE 'FileUpload' ##NO_TEXT,
      lc_property_mimetype  TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name VALUE 'Mimetype' ##NO_TEXT.

    DATA:
      lo_entity   TYPE REF TO /iwbep/if_mgw_odata_entity_typ,
      lo_property TYPE REF TO /iwbep/if_mgw_odata_property.

    super->define( ).

    lo_entity = model->get_entity_type( iv_entity_name = lc_entity_file_upload ).

    IF lo_entity IS BOUND.
      lo_property = lo_entity->get_property( iv_property_name = lc_property_mimetype ).
      lo_property->set_as_content_type( ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
