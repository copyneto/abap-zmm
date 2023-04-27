"! <p class="short text synchronized" lang="pt">Classe implementação Custom Entity</p>
CLASS zclmm_download_xml DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider .

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA lt_records TYPE TABLE OF zc_mm_xml_mass.

ENDCLASS.



CLASS ZCLMM_DOWNLOAD_XML IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    DATA lv_error_pst TYPE abap_bool.
    DATA lv_error_doc TYPE abap_bool.
*    DATA exception_message TYPE string.

    IF io_request->is_data_requested( ).

      TRY.

          DATA(lt_filtro_ranges) = io_request->get_filter( )->get_as_ranges( ).

***          TRY.
***              DATA(lt_pstdat) = lt_filtro_ranges[ name = 'PSTDAT' ]-range.
***            CATCH cx_root INTO DATA(lr_ex_pst).
***              lv_error_pst = abap_true.
***              MESSAGE e001(zmm_mc_download_xml) INTO exception_message.
****             RAISE EXCEPTION TYPE zcxmm_download_xml
****              exporting
****                iv_textid   = zcxmm_download_xml=>gc_mandatory
****                iv_previous = lr_ex_pst.
***          ENDTRY.
***
***          TRY.
***              DATA(lt_docdat) = lt_filtro_ranges[ name = 'DOCDAT' ]-range.
***            CATCH cx_root INTO DATA(lr_ex_doc).
***              lv_error_doc = abap_true.
***              MESSAGE e001(zmm_mc_download_xml) INTO exception_message.
****              RAISE EXCEPTION TYPE zcxmm_download_xml
****                EXPORTING
****                  iv_textid   = zcxmm_download_xml=>gc_mandatory
****                  iv_previous = lr_ex_doc.
***          ENDTRY.
***
*****          IF lv_error_pst = abap_true AND lv_error_doc = abap_true.
*****            RAISE EXCEPTION TYPE zcxmm_download_xml
*****              EXPORTING
*****                iv_textid = zcxmm_download_xml=>gc_mandatory.
*****          ENDIF.

          DATA(lv_top)    = COND int8( WHEN io_request->get_paging( )->get_page_size( ) = if_rap_query_paging=>page_size_unlimited THEN 0 ELSE io_request->get_paging( )->get_page_size( ) ). "io_request->get_paging( )->get_page_size( ).
          DATA(lv_skip)   = io_request->get_paging( )->get_offset( ).
          DATA(lt_clause) = io_request->get_filter( )->get_as_sql_string( ).
          DATA(lt_fields) = io_request->get_requested_elements( ).
          DATA(lt_sort)   = io_request->get_sort_elements( ).

          IF lines( lt_filtro_ranges ) GT 0.

            lt_records = NEW lcl_download(
                      it_emi_tax = VALUE #( lt_filtro_ranges[ name = 'EMISSOR_NFIS' ]-range OPTIONAL )
                      it_emi_reg = VALUE #( lt_filtro_ranges[ name = 'EMISSOR_UF' ]-range OPTIONAL )
                      it_rec_tax = VALUE #( lt_filtro_ranges[ name = 'RECEBE_NFIS' ]-range OPTIONAL )
                      it_rec_reg = VALUE #( lt_filtro_ranges[ name = 'RECEBE_UF' ]-range OPTIONAL )
                      it_pstdat  = VALUE #( lt_filtro_ranges[ name = 'PSTDAT' ]-range OPTIONAL )
                      it_docdat  = VALUE #( lt_filtro_ranges[ name = 'DOCDAT' ]-range OPTIONAL )
                      it_nfenum  = VALUE #( lt_filtro_ranges[ name = 'NFENUM' ]-range OPTIONAL )
                      it_docnum  = VALUE #( lt_filtro_ranges[ name = 'DOCNUM' ]-range OPTIONAL )
                      it_bukrs   = VALUE #( lt_filtro_ranges[ name = 'BUKRS' ]-range OPTIONAL )
                      it_branch  = VALUE #( lt_filtro_ranges[ name = 'BRANCH' ]-range OPTIONAL )
            )->get_data( EXPORTING iv_sort = COND #( WHEN lt_sort IS INITIAL THEN `primary key`
                                                     ELSE concat_lines_of( table = VALUE string_table( FOR ls_sort IN lt_sort
                                                                                                       ( ls_sort-element_name && COND #( WHEN ls_sort-descending EQ abap_true THEN ` DESCENDING` ELSE ` ASCENDING` ) )
                                                                                                     ) sep = `,` ) ) ).

          ENDIF.

          DATA lt_data LIKE lt_records.

          LOOP AT lt_records INTO DATA(ls_record) FROM CONV #( lv_skip + 1 ) TO CONV #( lv_top + lv_skip ).
            APPEND ls_record TO lt_data.
          ENDLOOP.

          io_response->set_total_number_of_records( iv_total_number_of_records = lines( lt_records ) ).
          io_response->set_data( it_data = lt_data ).

        CATCH cx_sy_itab_line_not_found INTO DATA(lr_itabx).
*          RAISE EXCEPTION TYPE zcxmm_download_xml
*            EXPORTING
*              textid = zcxmm_download_xml=>gc_mandatory.
**              previous = lr_itabx.
        CATCH cx_root INTO DATA(lr_ex).
*          RAISE EXCEPTION lr_ex. "TYPE zcxmm_download_xml
*            EXPORTING
*              previous = lr_ex.
      ENDTRY.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
