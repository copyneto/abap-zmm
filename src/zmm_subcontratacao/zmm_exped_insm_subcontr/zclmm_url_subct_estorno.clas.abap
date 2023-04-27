class ZCLMM_URL_SUBCT_ESTORNO definition
  public
  final
  create public .

public section.

  interfaces IF_SADL_EXIT .
  interfaces IF_SADL_EXIT_CALC_ELEMENT_READ .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_URL_SUBCT_ESTORNO IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_key TYPE zctgmm_subc_saveatrib.

    CONSTANTS: lc_param_doc     TYPE ihttpnam VALUE 'DOCNUM-LOW',
               lc_param_dat     TYPE ihttpnam VALUE 'DATE0-LOW',
               lc_param_buk     TYPE ihttpnam VALUE 'BUKRS-LOW',
               lc_object_vbln2  TYPE char30   VALUE 'OutboundDelivery',
               lc_action_vbln2  TYPE char60   VALUE 'zzreverseInWebGUI',
               lc_param_vbln2   TYPE ihttpnam VALUE 'NumeroRemessa',
               lc_object        TYPE char30   VALUE 'NotaFiscal',
               lc_action        TYPE char60   VALUE 'monitor',
               lc_param_docnum  TYPE ihttpnam VALUE 'BR_NotaFiscal',
               lc_object_docnum TYPE char30   VALUE 'NotaFiscal',
               lc_action_docnum TYPE char60   VALUE 'display',
               lc_param_vbeln   TYPE ihttpnam VALUE 'OutboundDelivery',
               lc_object_vbeln  TYPE char30   VALUE 'OutboundDelivery',
               lc_action_vbeln  TYPE char60   VALUE 'changeInWebGUI'.

    CHECK NOT it_original_data IS INITIAL.

    DATA lt_calculated_data TYPE STANDARD TABLE OF zc_mm_exped_subcontrat WITH DEFAULT KEY.

    MOVE-CORRESPONDING it_original_data TO lt_calculated_data.

    DATA(lt_parameters) = VALUE tihttpnvp( ).

    IF lt_calculated_data[] IS NOT INITIAL.

      SELECT bwkey,
             bukrs
        FROM t001k
         FOR ALL ENTRIES IN @lt_calculated_data
       WHERE bwkey = @lt_calculated_data-werks
        INTO TABLE @DATA(lt_t001w).

      IF sy-subrc IS INITIAL.
        SORT lt_t001w BY bwkey.
      ENDIF.

    ENDIF.

    LOOP AT lt_calculated_data ASSIGNING FIELD-SYMBOL(<fs_calculated>).

      FREE: lt_parameters[].

      IF <fs_calculated>-status EQ TEXT-001
      OR <fs_calculated>-status EQ TEXT-002.

        READ TABLE lt_t001w ASSIGNING FIELD-SYMBOL(<fs_t001w>)
                                          WITH KEY bwkey = <fs_calculated>-werks
                                          BINARY SEARCH.
        IF sy-subrc IS INITIAL
       AND <fs_calculated>-br_notafiscal IS NOT INITIAL.
          FREE: lt_parameters[].
          APPEND VALUE #( name = lc_param_doc
                          value = <fs_calculated>-br_notafiscal ) TO lt_parameters.

          APPEND VALUE #( name = lc_param_dat
                          value = space ) TO lt_parameters.

          APPEND VALUE #( name = lc_param_buk
                          value = <fs_t001w>-bukrs ) TO lt_parameters.

          <fs_calculated>-url_est = cl_lsapi_manager=>create_flp_url( object     = lc_object
                                                                      action     = lc_action
                                                                      parameters = lt_parameters ).
        ELSEIF <fs_calculated>-vbeln IS NOT INITIAL.
          APPEND VALUE #( name  = lc_param_vbln2
                          value = <fs_calculated>-vbeln ) TO lt_parameters.

          <fs_calculated>-url_est = cl_lsapi_manager=>create_flp_url( object     = lc_object_vbln2
                                                                      action     = lc_action_vbln2
                                                                      parameters = lt_parameters ).
        ENDIF.
      ENDIF.

      IF <fs_calculated>-br_notafiscal IS NOT INITIAL.
        FREE: lt_parameters[].
        APPEND VALUE #( name = lc_param_docnum
                        value = <fs_calculated>-br_notafiscal ) TO lt_parameters.

        <fs_calculated>-url_docnum = cl_lsapi_manager=>create_flp_url( object     = lc_object_docnum
                                                                       action     = lc_action_docnum
                                                                       parameters = lt_parameters ).
      ENDIF.

      IF <fs_calculated>-vbeln IS NOT INITIAL.
        FREE: lt_parameters[].
        APPEND VALUE #( name = lc_param_vbeln
                        value = <fs_calculated>-vbeln ) TO lt_parameters.

        <fs_calculated>-url_remessa = cl_lsapi_manager=>create_flp_url( object     = lc_object_vbeln
                                                                        action     = lc_action_vbeln
                                                                        parameters = lt_parameters ).
      ENDIF.

    ENDLOOP.

    MOVE-CORRESPONDING lt_calculated_data TO ct_calculated_data.

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    IF et_requested_orig_elements IS INITIAL.
*    APPEND 'REQNUMBER' TO et_requested_orig_elements.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
