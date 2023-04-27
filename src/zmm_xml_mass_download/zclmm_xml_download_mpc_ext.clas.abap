CLASS zclmm_xml_download_mpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zclmm_xml_download_mpc
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS define
        REDEFINITION .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLMM_XML_DOWNLOAD_MPC_EXT IMPLEMENTATION.


  METHOD define.

    TRY.
        super->define( ).

        me->model->get_entity_type( iv_entity_name = 'xmlDowloadNfe' )->get_property( iv_property_name = 'docnum' )->set_as_content_type( ).
        me->model->get_entity_type( iv_entity_name = 'xmlDowloadCte' )->get_property( iv_property_name = 'docnum' )->set_as_content_type( ).

      CATCH /iwbep/cx_mgw_med_exception.
      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
