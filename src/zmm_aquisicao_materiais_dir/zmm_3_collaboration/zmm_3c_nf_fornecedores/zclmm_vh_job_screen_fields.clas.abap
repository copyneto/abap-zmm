"!<p><h2>Classe para Custom Entity - JOB 3Collaboration</h2></p>
"!<p>Tratamento de Custom Entity - JOB 3Collaboration</p>
"!<p><strong>Autor:</strong>Jefferson Fujii</p>
"!<p><strong>Data:</strong>05 de ago de 2022</p>
CLASS zclmm_vh_job_screen_fields DEFINITION PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_rap_query_provider.


  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zclmm_vh_job_screen_fields IMPLEMENTATION.

  METHOD if_rap_query_provider~select.

    DATA: lt_text_symbols TYPE TABLE OF textpool,
          lt_selc         TYPE TABLE OF rselc,
          lt_sscr         TYPE TABLE OF rsscr,
          lt_result       TYPE TABLE OF zc_mm_vh_3c_job_field_screen.

    TRY.
        IF io_request->is_data_requested( ).
          DATA(lv_entity_id) = io_request->get_entity_id( ).

          DATA(lv_top)     = io_request->get_paging( )->get_page_size( ).
          DATA(lv_skip)    = io_request->get_paging( )->get_offset( ).
          DATA(lv_max_rows) = COND #( WHEN lv_top = if_rap_query_paging=>page_size_unlimited THEN 0 ELSE lv_top ).

*          TRY.
*              DATA(lt_filtro_ranges) = io_request->get_filter( )->get_as_ranges( ).
*              SORT gt_filtro_ranges BY name.
*            CATCH cx_rap_query_filter_no_range.
*              RETURN.
*          ENDTRY.

          DATA(lv_progname) = SWITCH progname( lv_entity_id
                                WHEN 'ZC_MM_VH_3C_JOB_FIELD_SCREEN' THEN 'ZMMR_3C_NF_FORNECEDORES'
                                WHEN 'ZC_MM_VH_3C_JOB_FIELD_SCR_PO' THEN 'ZMMR_3C_PEDIDO_COMPRAS'
                                ELSE sy-repid  ).


          READ TEXTPOOL lv_progname INTO lt_text_symbols LANGUAGE sy-langu.
          SORT lt_text_symbols BY id key.

          LOAD REPORT lv_progname PART 'SSCR' INTO lt_sscr.
          SORT lt_sscr BY name.

          LOAD REPORT lv_progname PART 'SELC' INTO lt_selc.

          LOOP AT lt_selc ASSIGNING FIELD-SYMBOL(<fs_selc>).
            CHECK <fs_selc>-no_display IS INITIAL.

            READ TABLE lt_sscr INTO DATA(ls_sscr)
              WITH KEY name = <fs_selc>-name BINARY SEARCH.
            CHECK ls_sscr-kind EQ 'S'
               OR ls_sscr-kind EQ 'P'.

            READ TABLE lt_text_symbols INTO DATA(ls_texts)
              WITH KEY id  = 'S'
                       key = ls_sscr-name BINARY SEARCH.

            APPEND VALUE #( programname   = lv_progname
                            fieldname     = ls_sscr-name
                            fieldtext     = condense( ls_texts-entry )
                            fieldtype     = ls_sscr-kind
                            fieldtypetext = COND #( WHEN ls_sscr-kind = 'S' THEN TEXT-002
                                                    WHEN ls_sscr-kind = 'S' THEN TEXT-003 )
                          ) TO lt_result.

            FREE: ls_sscr,
                  ls_texts.
          ENDLOOP.

          DATA(lt_sortorder) = CORRESPONDING abap_sortorder_tab( io_request->get_sort_elements( ) MAPPING name = element_name ).
          SORT lt_result BY (lt_sortorder).

          io_response->set_total_number_of_records( lines( lt_result ) ).
          io_response->set_data( lt_result  ).

        ENDIF.
      CATCH cx_rfc_dest_provider_error  INTO DATA(lv_dest).

    ENDTRY.
  ENDMETHOD.

ENDCLASS.
