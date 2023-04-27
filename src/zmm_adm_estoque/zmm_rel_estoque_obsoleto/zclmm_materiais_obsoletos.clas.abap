CLASS zclmm_materiais_obsoletos DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider .
    INTERFACES if_rap_query_filter .
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      "! Tipo para ranges
      BEGIN OF ty_filters,
        Material                     TYPE if_rap_query_filter=>tt_range_option,
        OrgVendas                    TYPE if_rap_query_filter=>tt_range_option,
        Plant                        TYPE if_rap_query_filter=>tt_range_option,
        CompanyCode                  TYPE if_rap_query_filter=>tt_range_option,
        StorageLocation              TYPE if_rap_query_filter=>tt_range_option,
        DataAnalise                  TYPE if_rap_query_filter=>tt_range_option,
        UltimoConsumo                TYPE if_rap_query_filter=>tt_range_option,
        DiasUltimoConsumo            TYPE int4,
        GrupoMaterial                TYPE if_rap_query_filter=>tt_range_option,
        MaterialType                 TYPE if_rap_query_filter=>tt_range_option,
        MaterialName                 TYPE if_rap_query_filter=>tt_range_option,
        MaterialTypeName             TYPE if_rap_query_filter=>tt_range_option,
        Segmento                     TYPE if_rap_query_filter=>tt_range_option,
        MatlWrhsStkQtyInMatlBaseUnit TYPE if_rap_query_filter=>tt_range_option,
        StockValueInCCCrcy           TYPE if_rap_query_filter=>tt_range_option,
        AnaliseDias                  TYPE if_rap_query_filter=>tt_range_option,
        PeriodoCorrente              TYPE if_rap_query_filter=>tt_range_option,
        Exercicio                    TYPE if_rap_query_filter=>tt_range_option,
        GLAccount                    TYPE if_rap_query_filter=>tt_range_option,
        GLAccountName                TYPE if_rap_query_filter=>tt_range_option,
        PostingDate                  TYPE if_rap_query_filter=>tt_range_option,
        MaterialBaseUnit             TYPE if_rap_query_filter=>tt_range_option,
        CompanyCodeCurrency          TYPE if_rap_query_filter=>tt_range_option,
      END OF ty_filters,

      "Tipo de retorno de dados à custom entity
      ty_relat TYPE STANDARD TABLE OF zc_mm_materiais_obsoleto WITH EMPTY KEY.

    DATA:
        "! Estrutura com ranges
        gs_range TYPE ty_filters.

    METHODS:
      "! Configura os filtros que serão utilizados no relatório
      "! @parameter it_filters | Filtros do Aplicativo
      set_filters
        IMPORTING
          it_filters TYPE if_rap_query_filter=>tt_name_range_pairs.

    METHODS:
      "! Logica para buscar dados e apresentar relatorio
      "! @parameter et_relat |Retorna tabela relatório
      build
        EXPORTING et_relat TYPE ty_relat.


    METHODS:
      "! Verificação de autorização para campo query
      check_authorization.


ENDCLASS.



CLASS ZCLMM_MATERIAIS_OBSOLETOS IMPLEMENTATION.


  METHOD if_rap_query_filter~get_as_ranges.
    RETURN.
  ENDMETHOD.


  METHOD if_rap_query_filter~get_as_sql_string.
    RETURN.
  ENDMETHOD.


  METHOD if_rap_query_provider~select.

** ---------------------------------------------------------------------------
** Verifica se informação foi solicitada
** ---------------------------------------------------------------------------
*    TRY.
*        CHECK io_request->is_data_requested( ).
*      CATCH cx_rfc_dest_provider_error  INTO DATA(lo_ex_dest).
*        DATA(lv_exp_msg) = lo_ex_dest->get_longtext( ).
*        RETURN.
*    ENDTRY.

* ---------------------------------------------------------------------------
* Recupera informações de entidade, paginação, etc
* ---------------------------------------------------------------------------
    DATA(lv_top)       = io_request->get_paging( )->get_page_size( ).
    DATA(lv_skip)      = io_request->get_paging( )->get_offset( ).
    DATA(lv_max_rows)  = COND #( WHEN lv_top = if_rap_query_paging=>page_size_unlimited THEN 0 ELSE lv_top ).

    " Ao navegar pra Object Page, devemos setar como um registro .
    lv_top      = COND #( WHEN lv_top <= 0 THEN 1 ELSE lv_top ).
    lv_max_rows = COND #( WHEN lv_max_rows <= 0 THEN 1 ELSE lv_max_rows ).

* ---------------------------------------------------------------------------
* Recupera e seta filtros de seleção
* ---------------------------------------------------------------------------
    TRY.
        me->set_filters( EXPORTING it_filters = io_request->get_filter( )->get_as_ranges( ) ). "#EC CI_CONV_OK
      CATCH cx_rap_query_filter_no_range INTO DATA(lo_ex_filter).
        DATA(lv_exp_msg) = lo_ex_filter->get_longtext( ).
    ENDTRY.

* ---------------------------------------------------------------------------
* Monta relatório
* ---------------------------------------------------------------------------

    DATA lt_result TYPE STANDARD TABLE OF zc_mm_materiais_obsoleto WITH EMPTY KEY.
    me->build( IMPORTING et_relat = lt_result ).

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

    SORT lt_req_elements BY table_line.

    IF lt_aggr_element IS NOT INITIAL.
      LOOP AT lt_aggr_element ASSIGNING FIELD-SYMBOL(<fs_aggr_element>).
        DELETE lt_req_elements WHERE table_line = <fs_aggr_element>-result_element. "#EC CI_STDSEQ
        DATA(lv_aggregation) = |{ <fs_aggr_element>-aggregation_method }( { <fs_aggr_element>-input_element } ) as { <fs_aggr_element>-result_element }|.
        APPEND lv_aggregation TO lt_req_elements.
      ENDLOOP.
    ENDIF.

    DATA(lv_req_elements)    = concat_lines_of( table = lt_req_elements sep = ',' ).
    DATA(lt_grouped_element) = io_request->get_aggregation( )->get_grouped_elements( ).
    DATA(lv_grouping)        = concat_lines_of(  table = lt_grouped_element sep = ',' ).

    TRY.
        SELECT (lv_req_elements) FROM @lt_result AS dados
                                 GROUP BY (lv_grouping)
*                             ORDER BY ('primary key')
                                 INTO CORRESPONDING FIELDS OF TABLE @lt_result.
      CATCH cx_root INTO DATA(lo_root).
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

*    IF lv_grouping IS NOT INITIAL.
*
*      LOOP AT lt_result REFERENCE INTO DATA(ls_result1).
*        ls_result1->MatlWrhsStkQtyInMatlBaseUnit = 0.
*        ls_result1->StockValueInCCCrcy = 0.
*      ENDLOOP.
*
*    ENDIF.
* ---------------------------------------------------------------------------
* Controla paginação (Adiciona registros de 20 em 20 )
* ---------------------------------------------------------------------------
    DATA(lt_result_page) = lt_result[].
    lt_result_page = VALUE #( FOR ls_result IN lt_result FROM ( lv_skip + 1 ) TO ( lv_skip + lv_max_rows ) ( ls_result ) ).

* ---------------------------------------------------------------------------
* Exibe registros
* ---------------------------------------------------------------------------
    IF io_request->is_total_numb_of_rec_requested(  ).
      io_response->set_total_number_of_records( CONV #( lines( lt_result[] ) ) ).
    ENDIF.

    IF io_request->is_data_requested( ).
      io_response->set_data( lt_result_page[] ).
    ENDIF.

  ENDMETHOD.


  METHOD set_filters.
    IF it_filters IS NOT INITIAL.

      TRY.
          gs_range-material   = it_filters[ name = 'MATERIAL' ]-range ##NO_TEXT. "#EC CI_STDSEQ
        CATCH cx_root INTO DATA(lo_root).
          DATA(lv_exp_msg) = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-orgvendas   = it_filters[ name = 'ORGVENDAS' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-plant   = it_filters[ name = 'PLANT' ]-range ##NO_TEXT. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-companycode   = it_filters[ name = 'COMPANYCODE' ]-range ##NO_TEXT. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-storagelocation   = it_filters[ name = 'STORAGELOCATION' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-dataanalise   = it_filters[ name = 'DATAANALISE' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-ultimoconsumo   = it_filters[ name = 'ULTIMOCONSUMO' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-diasultimoconsumo = VALUE #( it_filters[ name = 'DIASULTIMOCONSUMO' ]-range[ option = 'EQ' ]-low OPTIONAL ). "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-grupomaterial   = it_filters[ name = 'GRUPOMATERIAL' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-materialtype   = it_filters[ name = 'MATERIALTYPE' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-materialname   = it_filters[ name = 'MATERIALNAME' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-materialtypename   = it_filters[ name = 'MATERIALTYPENAME' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-segmento   = it_filters[ name = 'SEGMENTO' ]-range ##NO_TEXT. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-matlwrhsstkqtyinmatlbaseunit   = it_filters[ name = 'MATLWRHSSTKQTYINMATLBASEUNIT' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-stockvalueincccrcy   = it_filters[ name = 'STOCKVALUEINCCCRCY' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-analisedias   = it_filters[ name = 'ANALISEDIAS' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
*          gs_range-periodocorrente = VALUE #( it_filters[ name = 'PERIODOCORRENTE' ]-range[ option = 'EQ' ]-low OPTIONAL ).
          gs_range-periodocorrente   = it_filters[ name = 'PERIODOCORRENTE' ]-range.
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-exercicio   = it_filters[ name = 'EXERCICIO' ]-range ##NO_TEXT. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-glaccount   = it_filters[ name = 'GLACCOUNT' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-glaccountname   = it_filters[ name = 'GLACCOUNTNAME' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-postingdate   = it_filters[ name = 'POSTINGDATE' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-materialbaseunit   = it_filters[ name = 'MATERIALBASEUNIT' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-companycodecurrency   = it_filters[ name = 'COMPANYCODECURRENCY' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

    ENDIF.
  ENDMETHOD.


  METHOD build.

*    TYPES: ty_t_ok TYPE STANDARD TABLE OF yi_teste_03 WITH DEFAULT KEY.

    DATA: lr_corrente TYPE RANGE OF char2.

    DATA: lv_days          TYPE i,
          lv_data_i        TYPE sy-datum,
          lv_DataAnalise   TYPE sy-datum,
*          lt_result        TYPE ty_t_ok,
          lt_ESTQ_OBSOLETO TYPE STANDARD TABLE OF zi_mm_estq_obsoleto.

    LOOP AT gs_range-periodocorrente ASSIGNING FIELD-SYMBOL(<fs_per>).

      CONDENSE <fs_per>-low NO-GAPS.

      IF strlen( <fs_per>-low ) EQ 1.
        <fs_per>-low = 0 && <fs_per>-low.
      ENDIF.

      APPEND VALUE #(  sign  = <fs_per>-sign  option = <fs_per>-option low = <fs_per>-low ) TO lr_corrente.
    ENDLOOP.

    TRY.
        lv_DataAnalise = VALUE sy-datum( gs_range-DataAnalise[ 1 ]-low OPTIONAL ).
      CATCH cx_root.
        lv_DataAnalise = sy-datum.
    ENDTRY.

    lv_data_i = COND #( WHEN gs_range-diasultimoconsumo IS INITIAL
                        THEN lv_dataanalise - 180
                        ELSE lv_dataanalise - gs_range-diasultimoconsumo ).

    CALL FUNCTION 'HR_99S_INTERVAL_BETWEEN_DATES'
      EXPORTING
        begda = lv_data_i
        endda = lv_DataAnalise
      IMPORTING
        days  = lv_days.

    lv_days = lv_days - 1.

*    SELECT Material, plant
*        FROM zi_mm_del_mov
*        WHERE AnaliseDias LT @lv_days
*         AND Material     IN @gs_range-material
*         AND Plant        IN @gs_range-Plant
*        GROUP BY Material, plant
*        INTO TABLE @DATA(lt_deletar).
*
*    IF sy-subrc NE 0.
*      FREE lt_deletar.
*    ENDIF.
*
*    SELECT      a~Material,
*                a~Plant,
*           MAX( a~MaterialDocumentYear ) AS MaterialDocumentYear,
*           MAX( a~MaterialDocument )     AS MaterialDocument,
*           MAX( a~MaterialDocumentItem ) AS MaterialDocumentItem,
*           MIN( a~AnaliseDias )          AS AnaliseDias
*     FROM zi_mm_tipo_mov AS a
*     WHERE AnaliseDias  GE @lv_days
*     GROUP BY Material, Plant
*     INTO TABLE @DATA(lt_base).
*
*   LOOP AT lt_base ASSIGNING FIELD-SYMBOL(<fs_base>).
*
*      IF NOT line_exists( lt_deletar[ Material = <fs_base>-Material Plant = <fs_base>-Plant ] ).
*        lt_result = VALUE #( BASE lt_result (
*                         MaterialDocumentYear  = <fs_base>-materialdocumentyear
*                         MaterialDocument      = <fs_base>-materialdocument
*                         MaterialDocumentItem  = <fs_base>-materialdocumentitem
*                         Material       = <fs_base>-Material
*                         Plant          = <fs_base>-Plant
*                         AnaliseDias    = <fs_base>-AnaliseDias  ) ).
*      ENDIF.
*
*    ENDLOOP.
*
*    IF lt_result IS NOT INITIAL.
*
*      SELECT * FROM zi_mm_estq_obsoleto
*      FOR ALL ENTRIES IN @lt_result
*      WHERE MaterialDocumentYear            EQ @lt_result-materialdocumentyear
*          AND MaterialDocument              EQ @lt_result-materialdocument
*          AND MaterialDocumentItem          EQ @lt_result-materialdocumentitem
*          AND Material                      IN @gs_range-material
*          AND OrgVendas                     IN @gs_range-OrgVendas
*          AND Plant                         IN @gs_range-Plant
*          AND CompanyCode                   IN @gs_range-CompanyCode
*          AND StorageLocation               IN @gs_range-StorageLocation
*          AND GrupoMaterial                 IN @gs_range-GrupoMaterial
*          AND MaterialType                  IN @gs_range-MaterialType
*          AND MaterialName                  IN @gs_range-MaterialName
*          AND MaterialTypeName              IN @gs_range-MaterialTypeName
*          AND Segmento                      IN @gs_range-Segmento
*          AND MatlWrhsStkQtyInMatlBaseUnit  IN @gs_range-MatlWrhsStkQtyInMatlBaseUnit
*          AND StockValueInCCCrcy            IN @gs_range-StockValueInCCCrcy
*          AND Exercicio                     IN @gs_range-Exercicio
*          AND GLAccount                     IN @gs_range-GLAccount
*          AND GLAccountName                 IN @gs_range-GLAccountName
*          AND PostingDate                   IN @gs_range-PostingDate
*          AND PeriodoCorrente               IN @lr_corrente
*      INTO TABLE @lt_ESTQ_OBSOLETO.
*
*    ENDIF.

    SELECT *
      FROM zi_mm_estq_obsoleto
      WHERE Material                      IN @gs_range-material
        AND OrgVendas                     IN @gs_range-OrgVendas
        AND Plant                         IN @gs_range-Plant
        AND CompanyCode                   IN @gs_range-CompanyCode
        AND StorageLocation               IN @gs_range-StorageLocation
        AND GrupoMaterial                 IN @gs_range-GrupoMaterial
        AND MaterialType                  IN @gs_range-MaterialType
        AND MaterialName                  IN @gs_range-MaterialName
        AND MaterialTypeName              IN @gs_range-MaterialTypeName
        AND Segmento                      IN @gs_range-Segmento
        AND MatlWrhsStkQtyInMatlBaseUnit  IN @gs_range-MatlWrhsStkQtyInMatlBaseUnit
        AND StockValueInCCCrcy            IN @gs_range-StockValueInCCCrcy
        AND Exercicio                     IN @gs_range-Exercicio
        AND GLAccount                     IN @gs_range-GLAccount
        AND GLAccountName                 IN @gs_range-GLAccountName
        AND PostingDate                   IN @gs_range-PostingDate
        AND PeriodoCorrente               IN @lr_corrente
    INTO TABLE @lt_ESTQ_OBSOLETO.

    " Transfere dados para relatório
    et_relat = CORRESPONDING #( lt_ESTQ_OBSOLETO ).

    " Atualiza campos calculáveis
    LOOP AT et_relat REFERENCE INTO DATA(ls_relat).

      ls_relat->DataAnalise       = lv_DataAnalise.
      ls_relat->analisedias       = lv_DataAnalise - ls_relat->PostingDate.
      ls_relat->DataUltimoConsumo = lv_data_i.
      ls_relat->DiasUltimoConsumo = lv_days.

    ENDLOOP.

    " Ordena e elimina duplicatas
    SORT et_relat BY CompanyCode ASCENDING
                     Plant       ASCENDING
                     Material    ASCENDING
                     AnaliseDias ASCENDING.

    DELETE ADJACENT DUPLICATES FROM et_relat COMPARING CompanyCode Plant Material.

    " Remove os materiais que ainda nã são obsoletos
    LOOP AT et_relat REFERENCE INTO ls_relat.

      DATA(lv_tabix) = sy-tabix.

      IF ls_relat->analisedias LT lv_days.
        DELETE et_relat INDEX lv_tabix.
      ENDIF.

    ENDLOOP.

    " Ordenação para exibição do relatório
    SORT et_relat BY Material    DESCENDING
                     Plant       DESCENDING
                     CompanyCode DESCENDING.

  ENDMETHOD.


  METHOD check_authorization.
    DATA lr_auth_werks TYPE if_rap_query_filter=>tt_range_option.

    "Verificar autorização para centro
    SELECT werks
      FROM t001w
      INTO TABLE @DATA(lt_werks_list).

    LOOP AT lt_werks_list ASSIGNING FIELD-SYMBOL(<fs_werks_list>).
      IF zclmm_auth_zmmwerks=>check_custom(
           iv_werks = <fs_werks_list>-werks
           iv_actvt = zclmm_auth_zmmwerks=>gc_actvt-exibir
         ) = abap_true.
        APPEND VALUE #( sign = 'I' option = 'EQ' low = <fs_werks_list>-werks ) TO lr_auth_werks.
      ENDIF.
    ENDLOOP.

    IF me->gs_range-plant IS NOT INITIAL.
      DELETE me->gs_range-plant WHERE low  NOT IN lr_auth_werks
                                  AND low  IS NOT INITIAL. "#EC CI_STDSEQ
      DELETE me->gs_range-plant WHERE high NOT IN lr_auth_werks
                                  AND high IS NOT INITIAL. "#EC CI_STDSEQ
    ELSE.
      me->gs_range-plant = lr_auth_werks.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
