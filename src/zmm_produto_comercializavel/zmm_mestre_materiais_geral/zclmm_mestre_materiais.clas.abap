"! <p>Dados Mestre de Materiais</p>
CLASS zclmm_mestre_materiais DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS:
      "! Configura os filtros que serão utilizados no relatório
      "! @parameter it_filters | Filtros do Aplicativo
      set_filters
        IMPORTING
          it_filters  TYPE if_rap_query_filter=>tt_name_range_pairs
          io_instance TYPE REF TO zclmm_dados_metre_materiais.
ENDCLASS.



CLASS zclmm_mestre_materiais IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    "Cria instancia
    DATA(lo_mm) = zclmm_dados_metre_materiais=>get_instance( ).
* ---------------------------------------------------------------------------
* Verifica se informação foi solicitada
* ---------------------------------------------------------------------------
    TRY.
        CHECK io_request->is_data_requested( ).
      CATCH cx_rfc_dest_provider_error  INTO DATA(lo_ex_dest).
        DATA(lv_exp_msg) = lo_ex_dest->get_longtext( ).
        RETURN.
    ENDTRY.
* ---------------------------------------------------------------------------
* Recupera informações de entidade, paginação, etc
* ---------------------------------------------------------------------------
*    DATA(lv_entity_id) = io_request->get_entity_id( ).
    DATA(lv_top)       = io_request->get_paging( )->get_page_size( ).
    DATA(lv_skip)      = io_request->get_paging( )->get_offset( ).
    DATA(lv_max_rows)  = COND #( WHEN lv_top = if_rap_query_paging=>page_size_unlimited THEN 0 ELSE lv_top ).
** ---------------------------------------------------------------------------
** Recupera e seta filtros de seleção
** ---------------------------------------------------------------------------
    TRY.
        me->set_filters( EXPORTING it_filters = io_request->get_filter( )->get_as_ranges( ) io_instance = lo_mm ). "#EC CI_CONV_OK
      CATCH cx_rap_query_filter_no_range INTO DATA(lo_ex_filter).
        lv_exp_msg = lo_ex_filter->get_longtext( ).
    ENDTRY.
** ---------------------------------------------------------------------------
** Monta relatório
** ---------------------------------------------------------------------------
    DATA(lt_result) = lo_mm->build(  ).
* ---------------------------------------------------------------------------
* Realiza ordenação de acordo com parâmetros de entrada
* ---------------------------------------------------------------------------
    DATA(lt_requested_sort) = io_request->get_sort_elements( ).
    IF lines( lt_requested_sort ) > 0.
      DATA(lt_sort) = VALUE abap_sortorder_tab( FOR ls_sort IN lt_requested_sort ( name = ls_sort-element_name descending = ls_sort-descending ) ).
      SORT lt_result BY (lt_sort).
    ENDIF.
** ---------------------------------------------------------------------------
** Realiza as agregações de acordo com as annotatios na custom entity
** ---------------------------------------------------------------------------
    DATA(lt_req_elements) = io_request->get_requested_elements( ).

    DATA(lt_aggr_element) = io_request->get_aggregation( )->get_aggregated_elements( ).
    IF lt_aggr_element IS NOT INITIAL.
      LOOP AT lt_aggr_element ASSIGNING FIELD-SYMBOL(<fs_aggr_element>).
        DELETE lt_req_elements WHERE table_line = <fs_aggr_element>-result_element. "#EC CI_STDSEQ
        DATA(lv_aggregation) = |{ <fs_aggr_element>-aggregation_method }( { <fs_aggr_element>-input_element } ) as { <fs_aggr_element>-result_element }|.
        APPEND lv_aggregation TO lt_req_elements.
      ENDLOOP.
    ENDIF.

    DATA(lv_req_elements)  = concat_lines_of( table = lt_req_elements sep = ',' ).

    DATA(lt_grouped_element) = io_request->get_aggregation( )->get_grouped_elements( ).
    DATA(lv_grouping) = concat_lines_of(  table = lt_grouped_element sep = ',' ).

    SELECT (lv_req_elements) FROM @lt_result AS dados
                             GROUP BY (lv_grouping)
                             INTO CORRESPONDING FIELDS OF TABLE @lt_result.
* ---------------------------------------------------------------------------
* Controla paginação (Adiciona registros de 20 em 20 )
* ---------------------------------------------------------------------------
    DATA(lt_result_page) = lt_result[].
    lt_result_page = VALUE #( FOR ls_result_aux IN lt_result FROM ( lv_skip + 1 ) TO ( lv_skip + lv_max_rows ) ( ls_result_aux ) ).
* ---------------------------------------------------------------------------
* Exibe registros
* ---------------------------------------------------------------------------
    io_response->set_total_number_of_records( CONV #( lines( lt_result[] ) ) ).
    io_response->set_data( lt_result_page[] ).

  ENDMETHOD.
  METHOD set_filters.
    IF it_filters IS NOT INITIAL.

      TRY.
          DATA(lr_vpsta)   = it_filters[ name = 'VPSTA' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO DATA(lo_root).
          DATA(lv_exp_msg) = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_ersda)   = it_filters[ name = 'ERSDA' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_lvorm)   = it_filters[ name = 'LVORM' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_matnr)   = it_filters[ name = 'PRODUCT' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_mmsta)   = it_filters[ name = 'MMSTA' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_mstae)   = it_filters[ name = 'MSTAE' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_mstav)   = it_filters[ name = 'MSTAV' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_mtart)   = it_filters[ name = 'MTART' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vkorg)   = it_filters[ name = 'VKORG' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vtweg)   = it_filters[ name = 'VTWEG' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_werks)   = it_filters[ name = 'WERKS' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_ernam)   = it_filters[ name = 'ERNAM' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_laeda)   = it_filters[ name = 'LAEDA' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_aenam)   = it_filters[ name = 'AENAM' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_pstat)   = it_filters[ name = 'PSTAT' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_mbrsh)   = it_filters[ name = 'MBRSH' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_matkl)   = it_filters[ name = 'MATKL' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_bismt)   = it_filters[ name = 'BISMT' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_meins)   = it_filters[ name = 'MEINS' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_blanz)   = it_filters[ name = 'BLANZ' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_groes)   = it_filters[ name = 'GROES' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_wrkst)   = it_filters[ name = 'WRKST' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_normt)   = it_filters[ name = 'NORMT' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_brgew)   = it_filters[ name = 'BRGEW' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_ntgew)   = it_filters[ name = 'NTGEW' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_gewei)   = it_filters[ name = 'GEWEI' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_volum)   = it_filters[ name = 'VOLUM' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_raube)   = it_filters[ name = 'RAUBE' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_tragr)   = it_filters[ name = 'TRAGR' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_spart)   = it_filters[ name = 'SPART' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_kunnr)   = it_filters[ name = 'KUNNR' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_eannr)   = it_filters[ name = 'EANNR' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_wesch)   = it_filters[ name = 'WESCH' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_bwvor)   = it_filters[ name = 'BWVOR' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_bwscl)   = it_filters[ name = 'BWSCL' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_saiso)   = it_filters[ name = 'SAISO' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_etiar)   = it_filters[ name = 'ETIAR' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_etifo)   = it_filters[ name = 'ETIFO' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_entar)   = it_filters[ name = 'ENTAR' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_ean11)   = it_filters[ name = 'EAN11' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_numtp)   = it_filters[ name = 'NUMTP' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_laeng)   = it_filters[ name = 'LAENG' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_breit)   = it_filters[ name = 'BREIT' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_hoehe)   = it_filters[ name = 'HOEHE' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_meabm)   = it_filters[ name = 'MEABM' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_prdha)   = it_filters[ name = 'PRDHA' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_aeklk)   = it_filters[ name = 'AEKLK' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_cadkz)   = it_filters[ name = 'CADKZ' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_qmpur)   = it_filters[ name = 'QMPUR' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_ergew)   = it_filters[ name = 'ERGEW' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_ergei)   = it_filters[ name = 'ERGEI' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_ervol)   = it_filters[ name = 'ERVOL' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_ervoe)   = it_filters[ name = 'ERVOE' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_gewto)   = it_filters[ name = 'GEWTO' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_volto)   = it_filters[ name = 'VOLTO' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vabme)   = it_filters[ name = 'VABME' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_kzrev)   = it_filters[ name = 'KZREV' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_kzkfg)   = it_filters[ name = 'KZKFG' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_xchpf)   = it_filters[ name = 'XCHPF' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vhart)   = it_filters[ name = 'VHART' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_fuelg)   = it_filters[ name = 'FUELG' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_stfak)   = it_filters[ name = 'STFAK' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_magrv)   = it_filters[ name = 'MAGRV' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_begru)   = it_filters[ name = 'BEGRU' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_datab)   = it_filters[ name = 'DATAB' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_liqdt)   = it_filters[ name = 'LIQDT' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_saisj)   = it_filters[ name = 'SAISJ' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_plgtp)   = it_filters[ name = 'PLGTP' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_mlgut)   = it_filters[ name = 'MLGUT' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_extwg)   = it_filters[ name = 'EXTWG' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_satnr)   = it_filters[ name = 'SATNR' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_attyp)   = it_filters[ name = 'ATTYP' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_kzkup)   = it_filters[ name = 'KZKUP' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_kznfm)   = it_filters[ name = 'KZNFM' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_pmata)   = it_filters[ name = 'PMATA' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_mstde)   = it_filters[ name = 'MSTDE' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_mstdv)   = it_filters[ name = 'MSTDV' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_taklv)   = it_filters[ name = 'TAKLV' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_rbnrm)   = it_filters[ name = 'RBNRM' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_mhdrz)   = it_filters[ name = 'MHDRZ' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_mhdhb)   = it_filters[ name = 'MHDHB' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_mhdlp)   = it_filters[ name = 'MHDLP' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_inhme)   = it_filters[ name = 'INHME' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_inhal)   = it_filters[ name = 'INHAL' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vpreh)   = it_filters[ name = 'VPREH' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_etiag)   = it_filters[ name = 'ETIAG' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_iprkz)   = it_filters[ name = 'IPRKZ' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_mtpos_mara)   = it_filters[ name = 'MTPOS_MARA' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_bwtty)   = it_filters[ name = 'BWTTY' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_xchar)   = it_filters[ name = 'XCHAR' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_mmstd)   = it_filters[ name = 'MMSTD' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_maabc)   = it_filters[ name = 'MAABC' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_kzkri)   = it_filters[ name = 'KZKRI' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_ekgrp)   = it_filters[ name = 'EKGRP' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_ausme)   = it_filters[ name = 'AUSME' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_dispr)   = it_filters[ name = 'DISPR' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_dismm)   = it_filters[ name = 'DISMM' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_dispo)   = it_filters[ name = 'DISPO' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_kzdie)   = it_filters[ name = 'KZDIE' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_plifz)   = it_filters[ name = 'PLIFZ' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_webaz)   = it_filters[ name = 'WEBAZ' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_perkz)   = it_filters[ name = 'PERKZ' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_ausss)   = it_filters[ name = 'AUSSS' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_disls)   = it_filters[ name = 'DISLS' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_beskz)   = it_filters[ name = 'BESKZ' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_sobsl)   = it_filters[ name = 'SOBSL' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_minbe)   = it_filters[ name = 'MINBE' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_eisbe)   = it_filters[ name = 'EISBE' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_bstmi)   = it_filters[ name = 'BSTMI' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_bstma)   = it_filters[ name = 'BSTMA' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_bstfe)   = it_filters[ name = 'BSTFE' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_bstrf)   = it_filters[ name = 'BSTRF' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_mabst)   = it_filters[ name = 'MABST' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_losfx)   = it_filters[ name = 'LOSFX' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_sbdkz)   = it_filters[ name = 'SBDKZ' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_bearz)   = it_filters[ name = 'BEARZ' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_ruezt)   = it_filters[ name = 'RUEZT' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_tranz)   = it_filters[ name = 'TRANZ' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_basmg)   = it_filters[ name = 'BASMG' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_dzeit)   = it_filters[ name = 'DZEIT' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_maxlz)   = it_filters[ name = 'MAXLZ' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_lzeih)   = it_filters[ name = 'LZEIH' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_kzpro)   = it_filters[ name = 'KZPRO' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_gpmkz)   = it_filters[ name = 'GPMKZ' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_ueeto)   = it_filters[ name = 'UEETO' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_ueetk)   = it_filters[ name = 'UEETK' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_uneto)   = it_filters[ name = 'UNETO' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_wzeit)   = it_filters[ name = 'WZEIT' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_atpkz)   = it_filters[ name = 'ATPKZ' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vzusl)   = it_filters[ name = 'VZUSL' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_herbl)   = it_filters[ name = 'HERBL' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_insmk)   = it_filters[ name = 'INSMK' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_sproz)   = it_filters[ name = 'SPROZ' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_quazt)   = it_filters[ name = 'QUAZT' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_ssqss)   = it_filters[ name = 'SSQSS' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_mpdau)   = it_filters[ name = 'MPDAU' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_kzppv)   = it_filters[ name = 'KZPPV' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_kzdkz)   = it_filters[ name = 'KZDKZ' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_wstgh)   = it_filters[ name = 'WSTGH' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_prfrq)   = it_filters[ name = 'PRFRQ' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_nkmpr)   = it_filters[ name = 'NKMPR' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_umlmc)   = it_filters[ name = 'UMLMC' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_ladgr)   = it_filters[ name = 'LADGR' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_usequ)   = it_filters[ name = 'USEQU' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_lgrad)   = it_filters[ name = 'LGRAD' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_auftl)   = it_filters[ name = 'AUFTL' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_plvar)   = it_filters[ name = 'PLVAR' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_otype)   = it_filters[ name = 'OTYPE' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_objid)   = it_filters[ name = 'OBJID' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_mtvfp)   = it_filters[ name = 'MTVFP' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vrvez)   = it_filters[ name = 'VRVEZ' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vbamg)   = it_filters[ name = 'VBAMG' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vbeaz)   = it_filters[ name = 'VBEAZ' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_lizyk)   = it_filters[ name = 'LIZYK' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_prctr)   = it_filters[ name = 'PRCTR' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_trame)   = it_filters[ name = 'TRAME' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_mrppp)   = it_filters[ name = 'MRPPP' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_sauft)   = it_filters[ name = 'SAUFT' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_fxhor)   = it_filters[ name = 'FXHOR' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vrmod)   = it_filters[ name = 'VRMOD' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vint1)   = it_filters[ name = 'VINT1' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vint2)   = it_filters[ name = 'VINT2' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_losgr)   = it_filters[ name = 'LOSGR' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_sobsk)   = it_filters[ name = 'SOBKS' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_kausf)   = it_filters[ name = 'KAUSF' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_qzgtp)   = it_filters[ name = 'QZGTP' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_qmatv)   = it_filters[ name = 'QMATV' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_takzt)   = it_filters[ name = 'TAKZT' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_rwpro)   = it_filters[ name = 'RWPRO' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_copam)   = it_filters[ name = 'COPAM' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_abcin)   = it_filters[ name = 'ABCIN' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_awsls)   = it_filters[ name = 'AWSLS' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_sernp)   = it_filters[ name = 'SERNP' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_cuobj)   = it_filters[ name = 'CUOBJ' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vrbfk)   = it_filters[ name = 'VRBFK' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_cuobv)   = it_filters[ name = 'CUOBV' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_resvp)   = it_filters[ name = 'RESVP' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_plnty)   = it_filters[ name = 'PLNTY' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_abfac)   = it_filters[ name = 'ABFAC' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_sfcpf)   = it_filters[ name = 'SFCPF' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_shflg)   = it_filters[ name = 'SHFLG' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_shzet)   = it_filters[ name = 'SHZET' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vkumc)   = it_filters[ name = 'VKUMC' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vktrw)   = it_filters[ name = 'VKTRW' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_kzagl)   = it_filters[ name = 'KZAGL' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_glgmg)   = it_filters[ name = 'GLGMG' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vkglg)   = it_filters[ name = 'VKGLG' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_indus)   = it_filters[ name = 'INDUS' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_steuc)   = it_filters[ name = 'STEUC' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_dplho)   = it_filters[ name = 'DPLHO' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_minls)   = it_filters[ name = 'MINLS' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_maxls)   = it_filters[ name = 'MAXLS' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_fixls)   = it_filters[ name = 'FIXLS' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_ltinc)   = it_filters[ name = 'LTINC' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_compl)   = it_filters[ name = 'COMPL' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_mcrue)   = it_filters[ name = 'MCRUE' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_lfmon)   = it_filters[ name = 'LFMON' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_lfgja)   = it_filters[ name = 'LFGJA' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_eislo)   = it_filters[ name = 'EISLO' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_ncost)   = it_filters[ name = 'NCOST' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_bwesb)   = it_filters[ name = 'BWESB' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_gi_pr_time)   = it_filters[ name = 'GI_PR_TIME' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_min_troc)   = it_filters[ name = 'MIN_TROC' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_max_troc)   = it_filters[ name = 'MAX_TROC' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_target_stock)   = it_filters[ name = 'TARGET_STOCK' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_bwkey)   = it_filters[ name = 'BWKEY' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_bwtar)   = it_filters[ name = 'BWTAR' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_lbkum)   = it_filters[ name = 'LBKUM' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_salk3)   = it_filters[ name = 'SALK3' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vprsv)   = it_filters[ name = 'VPRSV' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_verpr)   = it_filters[ name = 'VERPR' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_stprs)   = it_filters[ name = 'STPRS' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_peinh)   = it_filters[ name = 'PEINH' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_bklas)   = it_filters[ name = 'BKLAS' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_salkv)   = it_filters[ name = 'SALKV' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vmkum)   = it_filters[ name = 'VMKUM' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vmsal)   = it_filters[ name = 'VMSAL' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vmvpr)   = it_filters[ name = 'VMVPR' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vmver)   = it_filters[ name = 'VMVER' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vmstp)   = it_filters[ name = 'VMSTP' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vmpei)   = it_filters[ name = 'VMPEI' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vmbkl)   = it_filters[ name = 'VMBKL' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vmsav)   = it_filters[ name = 'VMSAV' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vjkum)   = it_filters[ name = 'VJKUM' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vjsal)   = it_filters[ name = 'VJSAL' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vjvpr)   = it_filters[ name = 'VJVPR' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vjver)   = it_filters[ name = 'VJVER' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vjstp)   = it_filters[ name = 'VJSTP' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vjbkl)   = it_filters[ name = 'VJBKL' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vjsav)   = it_filters[ name = 'VJSAV' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_stprv)   = it_filters[ name = 'STPRV' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_laepr)   = it_filters[ name = 'LAEPR' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_zkprs)   = it_filters[ name = 'ZKPRS' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_zkdat)   = it_filters[ name = 'ZKDAT' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_timestamp)   = it_filters[ name = 'TIMESTAMP' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_bwprs)   = it_filters[ name = 'BWPRS' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_bwprh)   = it_filters[ name = 'BWPRH' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vjbws)   = it_filters[ name = 'VJWS' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vjbwh)   = it_filters[ name = 'VJBWH' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vvjsl)   = it_filters[ name = 'VVJSL' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vvjlb)   = it_filters[ name = 'VVJLB' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vvmlb)   = it_filters[ name = 'VVMLB' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vvsal)   = it_filters[ name = 'VVSAL' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_zplpr)   = it_filters[ name = 'ZPLPR' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_zplp1)   = it_filters[ name = 'ZPLP1' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_zplp2)   = it_filters[ name = 'ZPLP2' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_zplp3)   = it_filters[ name = 'ZPLP3' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_zpld1)   = it_filters[ name = 'ZPLD1' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_zpld2)   = it_filters[ name = 'ZPLD2' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_zpld3)   = it_filters[ name = 'ZPLD3' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_pperz)   = it_filters[ name = 'PPERZ' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_pperl)   = it_filters[ name = 'PPERL' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_pperv)   = it_filters[ name = 'PPERV' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_kalkz)   = it_filters[ name = 'KALKZ' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_kalkl)   = it_filters[ name = 'KALKL' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_kalkv)   = it_filters[ name = 'KALKV' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_kalsc)   = it_filters[ name = 'KALSC' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_xlifo)   = it_filters[ name = 'XLIFO' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_mypol)   = it_filters[ name = 'MYPOL' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_bwph1)   = it_filters[ name = 'BWPH1' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_bwps1)   = it_filters[ name = 'BWPS1' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_abwkz)   = it_filters[ name = 'ABWKZ' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_kaln1)   = it_filters[ name = 'KALN1' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_kalnr)   = it_filters[ name = 'KALNR' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_bwva1)   = it_filters[ name = 'BWVA1' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_bwva2)   = it_filters[ name = 'BWVA2' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_bwva3)   = it_filters[ name = 'BWVA3' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vers1)   = it_filters[ name = 'VERS1' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vers2)   = it_filters[ name = 'VERS2' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vers3)   = it_filters[ name = 'VERS3' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_hrkft)   = it_filters[ name = 'HRKFT' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_kosgr)   = it_filters[ name = 'KOSGR' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_pprdz)   = it_filters[ name = 'PPRDZ' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_pprdl)   = it_filters[ name = 'PPRDL' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_pprdv)   = it_filters[ name = 'PPRDV' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_pdatz)   = it_filters[ name = 'PDATZ' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_pdatl)   = it_filters[ name = 'PDATL' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_pdatv)   = it_filters[ name = 'PDATV' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_ekalr)   = it_filters[ name = 'EKALR' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vplpr)   = it_filters[ name = 'VPLPR' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_mlmaa)   = it_filters[ name = 'MLMAA' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_mlast)   = it_filters[ name = 'MLAST' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_lplpr)   = it_filters[ name = 'LPLPR' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vksal)   = it_filters[ name = 'VKSAL' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_hkmat)   = it_filters[ name = 'HKMAT' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_sperw)   = it_filters[ name = 'SPERW' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_kziwl)   = it_filters[ name = 'KZIWL' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_wlinl)   = it_filters[ name = 'WLINL' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_abciw)   = it_filters[ name = 'ABCIW' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_bwspa)   = it_filters[ name = 'BWSPA' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_lplpx)   = it_filters[ name = 'LPLPX' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vplpx)   = it_filters[ name = 'VPLPX' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_fplpx)   = it_filters[ name = 'FPLPX' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_lbwst)   = it_filters[ name = 'LBWST' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vbwst)   = it_filters[ name = 'VBWST' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_fbwst)   = it_filters[ name = 'FBWST' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_eklas)   = it_filters[ name = 'EKLAS' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_qklas)   = it_filters[ name = 'QKLAS' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_mtuse)   = it_filters[ name = 'MTUSE' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_mtorg)   = it_filters[ name = 'MTORG' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_ownpr)   = it_filters[ name = 'OWNPR' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_xbewm)   = it_filters[ name = 'XBEWM' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_bwpei)   = it_filters[ name = 'BWPEI' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_mbrue)   = it_filters[ name = 'MBRUE' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_oklas)   = it_filters[ name = 'OKLAS' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_oippinv)   = it_filters[ name = 'OIPPINV' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_versg)   = it_filters[ name = 'VERSG' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_bonus)   = it_filters[ name = 'BONUS' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_provg)   = it_filters[ name = 'PROVG' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_sktof)   = it_filters[ name = 'SKTOF' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vmsta)   = it_filters[ name = 'VMSTA' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vmstd)   = it_filters[ name = 'VMSTD' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_aumng)   = it_filters[ name = 'AUMNG' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_lfmng)   = it_filters[ name = 'LFMNG' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_efmng)   = it_filters[ name = 'EFMNG' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_scmng)   = it_filters[ name = 'SCMNG' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_schme)   = it_filters[ name = 'SCHME' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_vrkme)   = it_filters[ name = 'VRKME' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_mtpos)   = it_filters[ name = 'MTPOS' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_dwerk)   = it_filters[ name = 'DWERK' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_prodh)   = it_filters[ name = 'PRODH' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_pmatn)   = it_filters[ name = 'PMATN' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_kondm)   = it_filters[ name = 'KONDM' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_ktgrm)   = it_filters[ name = 'KTGRM' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_mvgr1)   = it_filters[ name = 'MVGR1' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_prat1)   = it_filters[ name = 'PRAT1' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_lfmax)   = it_filters[ name = 'LFMAX' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_pvmso)   = it_filters[ name = 'PVMSO' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_/bev1/emdrckspl)   = it_filters[ name = '/BEV1/EMDRCKSPL' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_idrfb)   = it_filters[ name = 'IDRFB' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      LOOP AT lr_vpsta ASSIGNING FIELD-SYMBOL(<fs_range>).
        <fs_range>-option = 'CP'.
        <fs_range>-low = |*{ <fs_range>-low }*|.
      ENDLOOP.

      "Export referencias
      GET REFERENCE OF: lr_matnr           INTO io_instance->gr_matnr          .
      GET REFERENCE OF: lr_werks           INTO io_instance->gr_werks          .
      GET REFERENCE OF: lr_bwtar           INTO io_instance->gr_bwtar          .
      GET REFERENCE OF: lr_idrfb           INTO io_instance->gr_idrfb          .
      GET REFERENCE OF: lr_vtweg           INTO io_instance->gr_vtweg          .
      GET REFERENCE OF: lr_vkorg           INTO io_instance->gr_vkorg          .
      GET REFERENCE OF: lr_mtart           INTO io_instance->gr_mtart          .
      GET REFERENCE OF: lr_ersda           INTO io_instance->gr_ersda          .
      GET REFERENCE OF: lr_ernam           INTO io_instance->gr_ernam          .
      GET REFERENCE OF: lr_laeda           INTO io_instance->gr_laeda          .
      GET REFERENCE OF: lr_aenam           INTO io_instance->gr_aenam          .
      GET REFERENCE OF: lr_mstae           INTO io_instance->gr_mstae          .
      GET REFERENCE OF: lr_mmsta           INTO io_instance->gr_mmsta          .
      GET REFERENCE OF: lr_vmsta           INTO io_instance->gr_vmsta          .
      GET REFERENCE OF: lr_vpsta           INTO io_instance->gr_vpsta          .
      GET REFERENCE OF: lr_mstav           INTO io_instance->gr_mstav          .
      GET REFERENCE OF: lr_lvorm           INTO io_instance->gr_lvorm          .
      GET REFERENCE OF: lr_pstat           INTO io_instance->gr_pstat          .
      GET REFERENCE OF: lr_mbrsh           INTO io_instance->gr_mbrsh          .
      GET REFERENCE OF: lr_matkl           INTO io_instance->gr_matkl          .
      GET REFERENCE OF: lr_bismt           INTO io_instance->gr_bismt          .
      GET REFERENCE OF: lr_meins           INTO io_instance->gr_meins          .
      GET REFERENCE OF: lr_blanz           INTO io_instance->gr_blanz          .
      GET REFERENCE OF: lr_groes           INTO io_instance->gr_groes          .
      GET REFERENCE OF: lr_wrkst           INTO io_instance->gr_wrkst          .
      GET REFERENCE OF: lr_normt           INTO io_instance->gr_normt          .
      GET REFERENCE OF: lr_brgew           INTO io_instance->gr_brgew          .
      GET REFERENCE OF: lr_ntgew           INTO io_instance->gr_ntgew          .
      GET REFERENCE OF: lr_gewei           INTO io_instance->gr_gewei          .
      GET REFERENCE OF: lr_volum           INTO io_instance->gr_volum          .
      GET REFERENCE OF: lr_raube           INTO io_instance->gr_raube          .
      GET REFERENCE OF: lr_tragr           INTO io_instance->gr_tragr          .
      GET REFERENCE OF: lr_spart           INTO io_instance->gr_spart          .
      GET REFERENCE OF: lr_kunnr           INTO io_instance->gr_kunnr          .
      GET REFERENCE OF: lr_eannr           INTO io_instance->gr_eannr          .
      GET REFERENCE OF: lr_wesch           INTO io_instance->gr_wesch          .
      GET REFERENCE OF: lr_bwvor           INTO io_instance->gr_bwvor          .
      GET REFERENCE OF: lr_bwscl           INTO io_instance->gr_bwscl          .
      GET REFERENCE OF: lr_saiso           INTO io_instance->gr_saiso          .
      GET REFERENCE OF: lr_etiar           INTO io_instance->gr_etiar          .
      GET REFERENCE OF: lr_etifo           INTO io_instance->gr_etifo          .
      GET REFERENCE OF: lr_entar           INTO io_instance->gr_entar          .
      GET REFERENCE OF: lr_ean11           INTO io_instance->gr_ean11          .
      GET REFERENCE OF: lr_numtp           INTO io_instance->gr_numtp          .
      GET REFERENCE OF: lr_laeng           INTO io_instance->gr_laeng          .
      GET REFERENCE OF: lr_breit           INTO io_instance->gr_breit          .
      GET REFERENCE OF: lr_hoehe           INTO io_instance->gr_hoehe          .
      GET REFERENCE OF: lr_meabm           INTO io_instance->gr_meabm          .
      GET REFERENCE OF: lr_prdha           INTO io_instance->gr_prdha          .
      GET REFERENCE OF: lr_aeklk           INTO io_instance->gr_aeklk          .
      GET REFERENCE OF: lr_cadkz           INTO io_instance->gr_cadkz          .
      GET REFERENCE OF: lr_qmpur           INTO io_instance->gr_qmpur          .
      GET REFERENCE OF: lr_ergew           INTO io_instance->gr_ergew          .
      GET REFERENCE OF: lr_ergei           INTO io_instance->gr_ergei          .
      GET REFERENCE OF: lr_ervol           INTO io_instance->gr_ervol          .
      GET REFERENCE OF: lr_ervoe           INTO io_instance->gr_ervoe          .
      GET REFERENCE OF: lr_gewto           INTO io_instance->gr_gewto          .
      GET REFERENCE OF: lr_volto           INTO io_instance->gr_volto          .
      GET REFERENCE OF: lr_vabme           INTO io_instance->gr_vabme          .
      GET REFERENCE OF: lr_kzrev           INTO io_instance->gr_kzrev          .
      GET REFERENCE OF: lr_kzkfg           INTO io_instance->gr_kzkfg          .
      GET REFERENCE OF: lr_xchpf           INTO io_instance->gr_xchpf          .
      GET REFERENCE OF: lr_vhart           INTO io_instance->gr_vhart          .
      GET REFERENCE OF: lr_fuelg           INTO io_instance->gr_fuelg          .
      GET REFERENCE OF: lr_stfak           INTO io_instance->gr_stfak          .
      GET REFERENCE OF: lr_magrv           INTO io_instance->gr_magrv          .
      GET REFERENCE OF: lr_begru           INTO io_instance->gr_begru          .
      GET REFERENCE OF: lr_datab           INTO io_instance->gr_datab          .
      GET REFERENCE OF: lr_liqdt           INTO io_instance->gr_liqdt          .
      GET REFERENCE OF: lr_saisj           INTO io_instance->gr_saisj          .
      GET REFERENCE OF: lr_plgtp           INTO io_instance->gr_plgtp          .
      GET REFERENCE OF: lr_mlgut           INTO io_instance->gr_mlgut          .
      GET REFERENCE OF: lr_extwg           INTO io_instance->gr_extwg          .
      GET REFERENCE OF: lr_satnr           INTO io_instance->gr_satnr          .
      GET REFERENCE OF: lr_attyp           INTO io_instance->gr_attyp          .
      GET REFERENCE OF: lr_kzkup           INTO io_instance->gr_kzkup          .
      GET REFERENCE OF: lr_kznfm           INTO io_instance->gr_kznfm          .
      GET REFERENCE OF: lr_pmata           INTO io_instance->gr_pmata          .
      GET REFERENCE OF: lr_mstde           INTO io_instance->gr_mstde          .
      GET REFERENCE OF: lr_mstdv           INTO io_instance->gr_mstdv          .
      GET REFERENCE OF: lr_taklv           INTO io_instance->gr_taklv          .
      GET REFERENCE OF: lr_rbnrm           INTO io_instance->gr_rbnrm          .
      GET REFERENCE OF: lr_mhdrz           INTO io_instance->gr_mhdrz          .
      GET REFERENCE OF: lr_mhdhb           INTO io_instance->gr_mhdhb          .
      GET REFERENCE OF: lr_mhdlp           INTO io_instance->gr_mhdlp          .
      GET REFERENCE OF: lr_inhme           INTO io_instance->gr_inhme          .
      GET REFERENCE OF: lr_inhal           INTO io_instance->gr_inhal          .
      GET REFERENCE OF: lr_vpreh           INTO io_instance->gr_vpreh          .
      GET REFERENCE OF: lr_etiag           INTO io_instance->gr_etiag          .
      GET REFERENCE OF: lr_mtpos_mara      INTO io_instance->gr_mtpos_mara     .
      GET REFERENCE OF: lr_bwtty           INTO io_instance->gr_bwtty          .
      GET REFERENCE OF: lr_xchar           INTO io_instance->gr_xchar          .
      GET REFERENCE OF: lr_mmstd           INTO io_instance->gr_mmstd          .
      GET REFERENCE OF: lr_maabc           INTO io_instance->gr_maabc          .
      GET REFERENCE OF: lr_kzkri           INTO io_instance->gr_kzkri          .
      GET REFERENCE OF: lr_ekgrp           INTO io_instance->gr_ekgrp          .
      GET REFERENCE OF: lr_ausme           INTO io_instance->gr_ausme          .
      GET REFERENCE OF: lr_dispr           INTO io_instance->gr_dispr          .
      GET REFERENCE OF: lr_dismm           INTO io_instance->gr_dismm          .
      GET REFERENCE OF: lr_dispo           INTO io_instance->gr_dispo          .
      GET REFERENCE OF: lr_kzdie           INTO io_instance->gr_kzdie          .
      GET REFERENCE OF: lr_plifz           INTO io_instance->gr_plifz          .
      GET REFERENCE OF: lr_webaz           INTO io_instance->gr_webaz          .
      GET REFERENCE OF: lr_perkz           INTO io_instance->gr_perkz          .
      GET REFERENCE OF: lr_ausss           INTO io_instance->gr_ausss          .
      GET REFERENCE OF: lr_disls           INTO io_instance->gr_disls          .
      GET REFERENCE OF: lr_beskz           INTO io_instance->gr_beskz          .
      GET REFERENCE OF: lr_sobsl           INTO io_instance->gr_sobsl          .
      GET REFERENCE OF: lr_minbe           INTO io_instance->gr_minbe          .
      GET REFERENCE OF: lr_eisbe           INTO io_instance->gr_eisbe          .
      GET REFERENCE OF: lr_bstmi           INTO io_instance->gr_bstmi          .
      GET REFERENCE OF: lr_bstma           INTO io_instance->gr_bstma          .
      GET REFERENCE OF: lr_bstfe           INTO io_instance->gr_bstfe          .
      GET REFERENCE OF: lr_bstrf           INTO io_instance->gr_bstrf          .
      GET REFERENCE OF: lr_mabst           INTO io_instance->gr_mabst          .
      GET REFERENCE OF: lr_losfx           INTO io_instance->gr_losfx          .
      GET REFERENCE OF: lr_sbdkz           INTO io_instance->gr_sbdkz          .
      GET REFERENCE OF: lr_bearz           INTO io_instance->gr_bearz          .
      GET REFERENCE OF: lr_ruezt           INTO io_instance->gr_ruezt          .
      GET REFERENCE OF: lr_tranz           INTO io_instance->gr_tranz          .
      GET REFERENCE OF: lr_basmg           INTO io_instance->gr_basmg          .
      GET REFERENCE OF: lr_dzeit           INTO io_instance->gr_dzeit          .
      GET REFERENCE OF: lr_maxlz           INTO io_instance->gr_maxlz          .
      GET REFERENCE OF: lr_lzeih           INTO io_instance->gr_lzeih          .
      GET REFERENCE OF: lr_kzpro           INTO io_instance->gr_kzpro          .
      GET REFERENCE OF: lr_gpmkz           INTO io_instance->gr_gpmkz          .
      GET REFERENCE OF: lr_ueeto           INTO io_instance->gr_ueeto          .
      GET REFERENCE OF: lr_ueetk           INTO io_instance->gr_ueetk          .
      GET REFERENCE OF: lr_uneto           INTO io_instance->gr_uneto          .
      GET REFERENCE OF: lr_wzeit           INTO io_instance->gr_wzeit          .
      GET REFERENCE OF: lr_atpkz           INTO io_instance->gr_atpkz          .
      GET REFERENCE OF: lr_vzusl           INTO io_instance->gr_vzusl          .
      GET REFERENCE OF: lr_herbl           INTO io_instance->gr_herbl          .
      GET REFERENCE OF: lr_insmk           INTO io_instance->gr_insmk          .
      GET REFERENCE OF: lr_sproz           INTO io_instance->gr_sproz          .
      GET REFERENCE OF: lr_quazt           INTO io_instance->gr_quazt          .
      GET REFERENCE OF: lr_ssqss           INTO io_instance->gr_ssqss          .
      GET REFERENCE OF: lr_mpdau           INTO io_instance->gr_mpdau          .
      GET REFERENCE OF: lr_kzppv           INTO io_instance->gr_kzppv          .
      GET REFERENCE OF: lr_kzdkz           INTO io_instance->gr_kzdkz          .
      GET REFERENCE OF: lr_wstgh           INTO io_instance->gr_wstgh          .
      GET REFERENCE OF: lr_prfrq           INTO io_instance->gr_prfrq          .
      GET REFERENCE OF: lr_nkmpr           INTO io_instance->gr_nkmpr          .
      GET REFERENCE OF: lr_umlmc           INTO io_instance->gr_umlmc          .
      GET REFERENCE OF: lr_ladgr           INTO io_instance->gr_ladgr          .
      GET REFERENCE OF: lr_usequ           INTO io_instance->gr_usequ          .
      GET REFERENCE OF: lr_lgrad           INTO io_instance->gr_lgrad          .
      GET REFERENCE OF: lr_auftl           INTO io_instance->gr_auftl          .
      GET REFERENCE OF: lr_plvar           INTO io_instance->gr_plvar          .
      GET REFERENCE OF: lr_otype           INTO io_instance->gr_otype          .
      GET REFERENCE OF: lr_objid           INTO io_instance->gr_objid          .
      GET REFERENCE OF: lr_mtvfp           INTO io_instance->gr_mtvfp          .
      GET REFERENCE OF: lr_vrvez           INTO io_instance->gr_vrvez          .
      GET REFERENCE OF: lr_vbamg           INTO io_instance->gr_vbamg          .
      GET REFERENCE OF: lr_vbeaz           INTO io_instance->gr_vbeaz          .
      GET REFERENCE OF: lr_lizyk           INTO io_instance->gr_lizyk          .
      GET REFERENCE OF: lr_prctr           INTO io_instance->gr_prctr          .
      GET REFERENCE OF: lr_trame           INTO io_instance->gr_trame          .
      GET REFERENCE OF: lr_mrppp           INTO io_instance->gr_mrppp          .
      GET REFERENCE OF: lr_sauft           INTO io_instance->gr_sauft          .
      GET REFERENCE OF: lr_fxhor           INTO io_instance->gr_fxhor          .
      GET REFERENCE OF: lr_vrmod           INTO io_instance->gr_vrmod          .
      GET REFERENCE OF: lr_vint1           INTO io_instance->gr_vint1          .
      GET REFERENCE OF: lr_vint2           INTO io_instance->gr_vint2          .
      GET REFERENCE OF: lr_losgr           INTO io_instance->gr_losgr          .
      GET REFERENCE OF: lr_sobsk           INTO io_instance->gr_sobsk          .
      GET REFERENCE OF: lr_kausf           INTO io_instance->gr_kausf          .
      GET REFERENCE OF: lr_qzgtp           INTO io_instance->gr_qzgtp          .
      GET REFERENCE OF: lr_qmatv           INTO io_instance->gr_qmatv          .
      GET REFERENCE OF: lr_takzt           INTO io_instance->gr_takzt          .
      GET REFERENCE OF: lr_rwpro           INTO io_instance->gr_rwpro          .
      GET REFERENCE OF: lr_copam           INTO io_instance->gr_copam          .
      GET REFERENCE OF: lr_abcin           INTO io_instance->gr_abcin          .
      GET REFERENCE OF: lr_awsls           INTO io_instance->gr_awsls          .
      GET REFERENCE OF: lr_sernp           INTO io_instance->gr_sernp          .
      GET REFERENCE OF: lr_cuobj           INTO io_instance->gr_cuobj          .
      GET REFERENCE OF: lr_vrbfk           INTO io_instance->gr_vrbfk          .
      GET REFERENCE OF: lr_cuobv           INTO io_instance->gr_cuobv          .
      GET REFERENCE OF: lr_resvp           INTO io_instance->gr_resvp          .
      GET REFERENCE OF: lr_plnty           INTO io_instance->gr_plnty          .
      GET REFERENCE OF: lr_abfac           INTO io_instance->gr_abfac          .
      GET REFERENCE OF: lr_sfcpf           INTO io_instance->gr_sfcpf          .
      GET REFERENCE OF: lr_shflg           INTO io_instance->gr_shflg          .
      GET REFERENCE OF: lr_shzet           INTO io_instance->gr_shzet          .
      GET REFERENCE OF: lr_vkumc           INTO io_instance->gr_vkumc          .
      GET REFERENCE OF: lr_vktrw           INTO io_instance->gr_vktrw          .
      GET REFERENCE OF: lr_kzagl           INTO io_instance->gr_kzagl          .
      GET REFERENCE OF: lr_glgmg           INTO io_instance->gr_glgmg          .
      GET REFERENCE OF: lr_vkglg           INTO io_instance->gr_vkglg          .
      GET REFERENCE OF: lr_indus           INTO io_instance->gr_indus          .
      GET REFERENCE OF: lr_steuc           INTO io_instance->gr_steuc          .
      GET REFERENCE OF: lr_dplho           INTO io_instance->gr_dplho          .
      GET REFERENCE OF: lr_minls           INTO io_instance->gr_minls          .
      GET REFERENCE OF: lr_maxls           INTO io_instance->gr_maxls          .
      GET REFERENCE OF: lr_fixls           INTO io_instance->gr_fixls          .
      GET REFERENCE OF: lr_ltinc           INTO io_instance->gr_ltinc          .
      GET REFERENCE OF: lr_compl           INTO io_instance->gr_compl          .
      GET REFERENCE OF: lr_mcrue           INTO io_instance->gr_mcrue          .
      GET REFERENCE OF: lr_lfmon           INTO io_instance->gr_lfmon          .
      GET REFERENCE OF: lr_lfgja           INTO io_instance->gr_lfgja          .
      GET REFERENCE OF: lr_eislo           INTO io_instance->gr_eislo          .
      GET REFERENCE OF: lr_ncost           INTO io_instance->gr_ncost          .
      GET REFERENCE OF: lr_bwesb           INTO io_instance->gr_bwesb          .
      GET REFERENCE OF: lr_gi_pr_time      INTO io_instance->gr_gi_pr_time     .
      GET REFERENCE OF: lr_min_troc        INTO io_instance->gr_min_troc       .
      GET REFERENCE OF: lr_max_troc        INTO io_instance->gr_max_troc       .
      GET REFERENCE OF: lr_target_stock    INTO io_instance->gr_target_stock   .
      GET REFERENCE OF: lr_bwkey           INTO io_instance->gr_bwkey          .
      GET REFERENCE OF: lr_lbkum           INTO io_instance->gr_lbkum          .
      GET REFERENCE OF: lr_salk3           INTO io_instance->gr_salk3          .
      GET REFERENCE OF: lr_vprsv           INTO io_instance->gr_vprsv          .
      GET REFERENCE OF: lr_verpr           INTO io_instance->gr_verpr          .
      GET REFERENCE OF: lr_stprs           INTO io_instance->gr_stprs          .
      GET REFERENCE OF: lr_peinh           INTO io_instance->gr_peinh          .
      GET REFERENCE OF: lr_bklas           INTO io_instance->gr_bklas          .
      GET REFERENCE OF: lr_salkv           INTO io_instance->gr_salkv          .
      GET REFERENCE OF: lr_vmkum           INTO io_instance->gr_vmkum          .
      GET REFERENCE OF: lr_vmsal           INTO io_instance->gr_vmsal          .
      GET REFERENCE OF: lr_vmvpr           INTO io_instance->gr_vmvpr          .
      GET REFERENCE OF: lr_vmver           INTO io_instance->gr_vmver          .
      GET REFERENCE OF: lr_vmstp           INTO io_instance->gr_vmstp          .
      GET REFERENCE OF: lr_vmpei           INTO io_instance->gr_vmpei          .
      GET REFERENCE OF: lr_vmbkl           INTO io_instance->gr_vmbkl          .
      GET REFERENCE OF: lr_vmsav           INTO io_instance->gr_vmsav          .
      GET REFERENCE OF: lr_vjkum           INTO io_instance->gr_vjkum          .
      GET REFERENCE OF: lr_vjsal           INTO io_instance->gr_vjsal          .
      GET REFERENCE OF: lr_vjvpr           INTO io_instance->gr_vjvpr          .
      GET REFERENCE OF: lr_vjver           INTO io_instance->gr_vjver          .
      GET REFERENCE OF: lr_vjstp           INTO io_instance->gr_vjstp          .
      GET REFERENCE OF: lr_vjbkl           INTO io_instance->gr_vjbkl          .
      GET REFERENCE OF: lr_vjsav           INTO io_instance->gr_vjsav          .
      GET REFERENCE OF: lr_stprv           INTO io_instance->gr_stprv          .
      GET REFERENCE OF: lr_laepr           INTO io_instance->gr_laepr          .
      GET REFERENCE OF: lr_zkprs           INTO io_instance->gr_zkprs          .
      GET REFERENCE OF: lr_zkdat           INTO io_instance->gr_zkdat          .
      GET REFERENCE OF: lr_timestamp       INTO io_instance->gr_timestamp      .
      GET REFERENCE OF: lr_bwprs           INTO io_instance->gr_bwprs          .
      GET REFERENCE OF: lr_bwprh           INTO io_instance->gr_bwprh          .
      GET REFERENCE OF: lr_vjbws           INTO io_instance->gr_vjbws          .
      GET REFERENCE OF: lr_vjbwh           INTO io_instance->gr_vjbwh          .
      GET REFERENCE OF: lr_vvjsl           INTO io_instance->gr_vvjsl          .
      GET REFERENCE OF: lr_vvjlb           INTO io_instance->gr_vvjlb          .
      GET REFERENCE OF: lr_vvmlb           INTO io_instance->gr_vvmlb          .
      GET REFERENCE OF: lr_vvsal           INTO io_instance->gr_vvsal          .
      GET REFERENCE OF: lr_zplpr           INTO io_instance->gr_zplpr          .
      GET REFERENCE OF: lr_zplp1           INTO io_instance->gr_zplp1          .
      GET REFERENCE OF: lr_zplp2           INTO io_instance->gr_zplp2          .
      GET REFERENCE OF: lr_zplp3           INTO io_instance->gr_zplp3          .
      GET REFERENCE OF: lr_zpld1           INTO io_instance->gr_zpld1          .
      GET REFERENCE OF: lr_zpld2           INTO io_instance->gr_zpld2          .
      GET REFERENCE OF: lr_zpld3           INTO io_instance->gr_zpld3          .
      GET REFERENCE OF: lr_kalkz           INTO io_instance->gr_kalkz          .
      GET REFERENCE OF: lr_kalkl           INTO io_instance->gr_kalkl          .
      GET REFERENCE OF: lr_kalkv           INTO io_instance->gr_kalkv          .
      GET REFERENCE OF: lr_kalsc           INTO io_instance->gr_kalsc          .
      GET REFERENCE OF: lr_xlifo           INTO io_instance->gr_xlifo          .
      GET REFERENCE OF: lr_mypol           INTO io_instance->gr_mypol          .
      GET REFERENCE OF: lr_bwph1           INTO io_instance->gr_bwph1          .
      GET REFERENCE OF: lr_bwps1           INTO io_instance->gr_bwps1          .
      GET REFERENCE OF: lr_abwkz           INTO io_instance->gr_abwkz          .
      GET REFERENCE OF: lr_kaln1           INTO io_instance->gr_kaln1          .
      GET REFERENCE OF: lr_kalnr           INTO io_instance->gr_kalnr          .
      GET REFERENCE OF: lr_bwva1           INTO io_instance->gr_bwva1          .
      GET REFERENCE OF: lr_bwva2           INTO io_instance->gr_bwva2          .
      GET REFERENCE OF: lr_bwva3           INTO io_instance->gr_bwva3          .
      GET REFERENCE OF: lr_vers1           INTO io_instance->gr_vers1          .
      GET REFERENCE OF: lr_vers2           INTO io_instance->gr_vers2          .
      GET REFERENCE OF: lr_vers3           INTO io_instance->gr_vers3          .
      GET REFERENCE OF: lr_hrkft           INTO io_instance->gr_hrkft          .
      GET REFERENCE OF: lr_kosgr           INTO io_instance->gr_kosgr          .
      GET REFERENCE OF: lr_pprdz           INTO io_instance->gr_pprdz          .
      GET REFERENCE OF: lr_pprdl           INTO io_instance->gr_pprdl          .
      GET REFERENCE OF: lr_pprdv           INTO io_instance->gr_pprdv          .
      GET REFERENCE OF: lr_pdatz           INTO io_instance->gr_pdatz          .
      GET REFERENCE OF: lr_pdatl           INTO io_instance->gr_pdatl          .
      GET REFERENCE OF: lr_pdatv           INTO io_instance->gr_pdatv          .
      GET REFERENCE OF: lr_ekalr           INTO io_instance->gr_ekalr          .
      GET REFERENCE OF: lr_vplpr           INTO io_instance->gr_vplpr          .
      GET REFERENCE OF: lr_mlmaa           INTO io_instance->gr_mlmaa          .
      GET REFERENCE OF: lr_mlast           INTO io_instance->gr_mlast          .
      GET REFERENCE OF: lr_lplpr           INTO io_instance->gr_lplpr          .
      GET REFERENCE OF: lr_vksal           INTO io_instance->gr_vksal          .
      GET REFERENCE OF: lr_hkmat           INTO io_instance->gr_hkmat          .
      GET REFERENCE OF: lr_sperw           INTO io_instance->gr_sperw          .
      GET REFERENCE OF: lr_kziwl           INTO io_instance->gr_kziwl          .
      GET REFERENCE OF: lr_wlinl           INTO io_instance->gr_wlinl          .
      GET REFERENCE OF: lr_abciw           INTO io_instance->gr_abciw          .
      GET REFERENCE OF: lr_bwspa           INTO io_instance->gr_bwspa          .
      GET REFERENCE OF: lr_lplpx           INTO io_instance->gr_lplpx          .
      GET REFERENCE OF: lr_vplpx           INTO io_instance->gr_vplpx          .
      GET REFERENCE OF: lr_fplpx           INTO io_instance->gr_fplpx          .
      GET REFERENCE OF: lr_lbwst           INTO io_instance->gr_lbwst          .
      GET REFERENCE OF: lr_vbwst           INTO io_instance->gr_vbwst          .
      GET REFERENCE OF: lr_fbwst           INTO io_instance->gr_fbwst          .
      GET REFERENCE OF: lr_eklas           INTO io_instance->gr_eklas          .
      GET REFERENCE OF: lr_qklas           INTO io_instance->gr_qklas          .
      GET REFERENCE OF: lr_mtuse           INTO io_instance->gr_mtuse          .
      GET REFERENCE OF: lr_mtorg           INTO io_instance->gr_mtorg          .
      GET REFERENCE OF: lr_ownpr           INTO io_instance->gr_ownpr          .
      GET REFERENCE OF: lr_xbewm           INTO io_instance->gr_xbewm          .
      GET REFERENCE OF: lr_bwpei           INTO io_instance->gr_bwpei          .
      GET REFERENCE OF: lr_mbrue           INTO io_instance->gr_mbrue          .
      GET REFERENCE OF: lr_oklas           INTO io_instance->gr_oklas          .
      GET REFERENCE OF: lr_oippinv         INTO io_instance->gr_oippinv        .
      GET REFERENCE OF: lr_versg           INTO io_instance->gr_versg          .
      GET REFERENCE OF: lr_bonus           INTO io_instance->gr_bonus          .
      GET REFERENCE OF: lr_provg           INTO io_instance->gr_provg          .
      GET REFERENCE OF: lr_sktof           INTO io_instance->gr_sktof          .
      GET REFERENCE OF: lr_vmstd           INTO io_instance->gr_vmstd          .
      GET REFERENCE OF: lr_aumng           INTO io_instance->gr_aumng          .
      GET REFERENCE OF: lr_lfmng           INTO io_instance->gr_lfmng          .
      GET REFERENCE OF: lr_efmng           INTO io_instance->gr_efmng          .
      GET REFERENCE OF: lr_scmng           INTO io_instance->gr_scmng          .
      GET REFERENCE OF: lr_schme           INTO io_instance->gr_schme          .
      GET REFERENCE OF: lr_vrkme           INTO io_instance->gr_vrkme          .
      GET REFERENCE OF: lr_mtpos           INTO io_instance->gr_mtpos          .
      GET REFERENCE OF: lr_dwerk           INTO io_instance->gr_dwerk          .
      GET REFERENCE OF: lr_prodh           INTO io_instance->gr_prodh          .
      GET REFERENCE OF: lr_pmatn           INTO io_instance->gr_pmatn          .
      GET REFERENCE OF: lr_kondm           INTO io_instance->gr_kondm          .
      GET REFERENCE OF: lr_ktgrm           INTO io_instance->gr_ktgrm          .
      GET REFERENCE OF: lr_mvgr1           INTO io_instance->gr_mvgr1          .
      GET REFERENCE OF: lr_prat1           INTO io_instance->gr_prat1          .
      GET REFERENCE OF: lr_lfmax           INTO io_instance->gr_lfmax          .
      GET REFERENCE OF: lr_pvmso           INTO io_instance->gr_pvmso          .
      GET REFERENCE OF: lr_/bev1/emdrckspl INTO io_instance->gr_/bev1/emdrckspl.

      io_instance->set_ref_data(  ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
