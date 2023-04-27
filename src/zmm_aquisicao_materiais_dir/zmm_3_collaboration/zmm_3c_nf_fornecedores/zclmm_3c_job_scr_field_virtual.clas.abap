"!<p><h2>Classe para Campo Virtual de JOB 3Collaboration</h2></p>
"!<p>Tratamento para Campo Virtual 3Collaboration</p>
"!<p><strong>Autor:</strong>Jefferson Fujii</p>
"!<p><strong>Data:</strong>05 de ago de 2022</p>
CLASS zclmm_3c_job_scr_field_virtual DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclmm_3c_job_scr_field_virtual IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA: lt_text_symbols TYPE TABLE OF textpool,
          lt_selc         TYPE TABLE OF rselc,
          lt_sscr         TYPE TABLE OF rsscr.

    FIELD-SYMBOLS: <fs_original_tab>   TYPE table,
                   <fs_calculated_tab> TYPE table.

    CHECK NOT it_original_data IS INITIAL.

    ASSIGN it_original_data TO <fs_original_tab>.

    READ TABLE <fs_original_tab> ASSIGNING FIELD-SYMBOL(<fs_original_data>) INDEX 1.
    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    ASSIGN COMPONENT 'PROGRAMNAME' OF STRUCTURE <fs_original_data> TO FIELD-SYMBOL(<fs_programname>).
    IF <fs_programname> IS NOT ASSIGNED.
      RETURN.
    ENDIF.

    READ TEXTPOOL <fs_programname> INTO lt_text_symbols LANGUAGE sy-langu.
    SORT lt_text_symbols BY id key.

    LOAD REPORT <fs_programname> PART 'SSCR' INTO lt_sscr.
    SORT lt_sscr BY name.

    LOAD REPORT <fs_programname> PART 'SELC' INTO lt_selc.
    SORT lt_selc BY name.

    LOOP AT <fs_original_tab> ASSIGNING <fs_original_data>.
      data(lv_tabix) = sy-tabix.

      ASSIGN COMPONENT 'DATAELEMENT' OF STRUCTURE <fs_original_data> TO FIELD-SYMBOL(<fs_dataelement>).
      CHECK sy-subrc IS INITIAL.

      READ TABLE lt_selc INTO DATA(ls_selc)
        WITH KEY name = <fs_dataelement> BINARY SEARCH.
      CHECK ls_selc-no_display IS INITIAL.

      READ TABLE lt_sscr INTO DATA(ls_sscr)
        WITH KEY name = <fs_dataelement> BINARY SEARCH.
      CHECK ls_sscr-kind EQ 'S'
         OR ls_sscr-kind EQ 'P'.


      ASSIGN ct_calculated_data[ lv_tabix ] TO FIELD-SYMBOL(<fs_calculated_data>).
      CHECK sy-subrc EQ 0.

      ASSIGN COMPONENT 'TYPE' OF STRUCTURE <fs_calculated_data> TO FIELD-SYMBOL(<fs_type>).
      IF sy-subrc EQ 0.
        <fs_type> = ls_sscr-kind.
      ENDIF.

      READ TABLE lt_text_symbols INTO DATA(ls_texts)
        WITH KEY id  = 'S'
                 key = ls_sscr-name BINARY SEARCH.
      CHECK sy-subrc EQ 0.

      ASSIGN COMPONENT 'DATAELEMENTNAME' OF STRUCTURE <fs_calculated_data> TO FIELD-SYMBOL(<fs_dataelementname>).
      IF sy-subrc EQ 0.
        <fs_dataelementname> = condense( ls_texts-entry ).
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    DATA: lv_field TYPE string.

    lv_field = 'PROGRAMNAME'.
    INSERT lv_field INTO TABLE et_requested_orig_elements.
    lv_field = 'DATAELEMENT'.
    INSERT lv_field INTO TABLE et_requested_orig_elements.
  ENDMETHOD.

ENDCLASS.
