CLASS zclmm_url_mat_estoc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS: BEGIN OF gc_values,
                 Romaneio TYPE ihttpnam VALUE 'Romaneio',
                 object   TYPE char30   VALUE 'admordemdescarga',
                 action   TYPE char60   VALUE 'manage',
               END OF gc_values.

ENDCLASS.



CLASS zclmm_url_mat_estoc IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.

    CHECK NOT it_original_data IS INITIAL.

    DATA lt_calculated_data TYPE STANDARD TABLE OF zc_mm_01_cafe WITH DEFAULT KEY.

    MOVE-CORRESPONDING it_original_data TO lt_calculated_data.

    DATA(lt_parameters) = VALUE tihttpnvp( ).

    LOOP AT lt_calculated_data ASSIGNING FIELD-SYMBOL(<fs_calculated>).

      FREE: lt_parameters[].

      lt_parameters = VALUE #( BASE lt_parameters
              ( name  = gc_values-Romaneio   value = <fs_calculated>-sequence ) ).


      <fs_calculated>-URL_sequence = cl_lsapi_manager=>create_flp_url( object     = gc_values-object
                                                                       action     = gc_values-action
                                                                       parameters = lt_parameters ).

    ENDLOOP.

    MOVE-CORRESPONDING lt_calculated_data TO ct_calculated_data.

  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.

ENDCLASS.
