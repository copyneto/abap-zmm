"! <p>Log Dados Mestre de Materiais</p>
CLASS zclmm_mestre_materiais_log DEFINITION PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_rap_query_provider,
      if_rap_query_filter .
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      "! Tipo para tabelas de seleções
      BEGIN OF ty_tabela_sel,
        product    TYPE mara-matnr,
        mtart      TYPE mara-mtart,
        spart      TYPE mara-spart,
        werks      TYPE marc-werks,
        vkorg      TYPE mvke-vkorg,
        vtweg      TYPE mvke-vtweg,
        lgort      TYPE mard-lgort,
        bwtar      TYPE mbew-bwtar,
        maktx      TYPE makt-maktx,
        udate      TYPE cdhdr-udate,
        utime      TYPE cdhdr-utime,
        username   TYPE cdhdr-username,
        tabkey     TYPE cdpos-tabkey,
        tabname    TYPE cdpos-tabname,
        fname      TYPE cdpos-fname,
        chngind    TYPE cdpos-chngind,
        value_new  TYPE cdpos-value_new,
        value_old  TYPE cdpos-value_old,
        chngindtxt TYPE i_changedocchangeindt-text,
        ddtext     TYPE dd04t-ddtext,
        objectclas TYPE cdhdr-objectclas,
        objectid   TYPE cdhdr-objectid,
        changenr   TYPE cdhdr-changenr,
      END OF ty_tabela_sel,

      "! Tipo para ranges
      BEGIN OF ty_filters,
        vpsta        TYPE if_rap_query_filter=>tt_range_option,
*        tables       TYPE if_rap_query_filter=>tt_range_option,
        tables_k     TYPE if_rap_query_filter=>tt_range_option,
        tables_v     TYPE if_rap_query_filter=>tt_range_option,
        tables_v_key TYPE if_rap_query_filter=>tt_range_option,
        tables_e     TYPE if_rap_query_filter=>tt_range_option,
        tables_e_key TYPE if_rap_query_filter=>tt_range_option,
        tables_c     TYPE if_rap_query_filter=>tt_range_option,
        tables_b     TYPE if_rap_query_filter=>tt_range_option,
        tables_d     TYPE if_rap_query_filter=>tt_range_option,
        tables_q     TYPE if_rap_query_filter=>tt_range_option,
        matnr        TYPE if_rap_query_filter=>tt_range_option,
        mtart        TYPE if_rap_query_filter=>tt_range_option,
        udate        TYPE if_rap_query_filter=>tt_range_option,
        username     TYPE if_rap_query_filter=>tt_range_option,
        werks        TYPE if_rap_query_filter=>tt_range_option,
        lgort        TYPE if_rap_query_filter=>tt_range_option,
        vkorg        TYPE if_rap_query_filter=>tt_range_option,
        vtweg        TYPE if_rap_query_filter=>tt_range_option,
        spart        TYPE if_rap_query_filter=>tt_range_option,
        bwtar        TYPE if_rap_query_filter=>tt_range_option,
        utime        TYPE if_rap_query_filter=>tt_range_option,
        maktx        TYPE if_rap_query_filter=>tt_range_option,
        fname        TYPE if_rap_query_filter=>tt_range_option,
        fname_k      TYPE if_rap_query_filter=>tt_range_option,
        fname_v      TYPE if_rap_query_filter=>tt_range_option,
        fname_e      TYPE if_rap_query_filter=>tt_range_option,
        fname_c      TYPE if_rap_query_filter=>tt_range_option,
        fname_b      TYPE if_rap_query_filter=>tt_range_option,
        fname_d      TYPE if_rap_query_filter=>tt_range_option,
        fname_q      TYPE if_rap_query_filter=>tt_range_option,
        chngind      TYPE if_rap_query_filter=>tt_range_option,
        value_new    TYPE if_rap_query_filter=>tt_range_option,
        value_old    TYPE if_rap_query_filter=>tt_range_option,
        ddtext       TYPE if_rap_query_filter=>tt_range_option,
      END OF ty_filters,

      "Tipo de retorno de dados à custom entity
      ty_relat TYPE STANDARD TABLE OF zc_mm_mestre_material_log WITH EMPTY KEY. "WITH DEFAULT KEY.

    DATA:
      "! Lista de filtros range da tela
      gt_filtro_ranges TYPE if_rap_query_filter=>tt_name_range_pairs,

      "! Estrutura com ranges
      gs_range         TYPE ty_filters.

    METHODS:
      "! Buscar range do filtro da tela
      "! @parameter iv_name        | Nome do campo
      "! @parameter rt_retorno     | Range de dados do campo
      buscar_range_filtro
        IMPORTING
          iv_name           TYPE string
        RETURNING
          VALUE(rt_retorno) TYPE if_rap_query_filter~tt_range_option,
      "! Buscar valor low do filtro da tela
      "! @parameter iv_name        | Nome do campo
      "! @parameter rv_retorno     | Valor string do campo
      buscar_valor_low_filtro
        IMPORTING
          iv_name           TYPE string
        RETURNING
          VALUE(rv_retorno) TYPE string,
      "! Filtro das tabelas
      "! @parameter ir_vpsta   | Tipo da seleção
      "! @parameter rt_retorno | Range com as tabelas para filtro
      filtro_tabelas
        IMPORTING
          ir_vpsta          TYPE if_rap_query_filter~tt_range_option
        RETURNING
          VALUE(rt_retorno) TYPE if_rap_query_filter~tt_range_option,

      "! Configura os filtros que serão utilizados no relatório
      "! @parameter it_filters | Filtros do Aplicativo
      set_filters
        IMPORTING
          it_filters TYPE if_rap_query_filter=>tt_name_range_pairs,

      "! Logica para buscar dados e apresentar relatorio
      "! @parameter rt_relat |Retorna tabela relatório
      build
        RETURNING VALUE(rt_relat) TYPE ty_relat,

      "! Logica para converter numeral para extenso
      "! @parameter iv_num   |Numero a ser convertido
      "! @parameter rv_word |Retorna dados por extenso
      conv_num_to_extenso
        IMPORTING
                  iv_num         TYPE any
        RETURNING VALUE(rv_word) TYPE in_words,

      "! Verificação de autorização para campo query
      check_authorization.
ENDCLASS.



CLASS zclmm_mestre_materiais_log IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
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
    DATA(lv_top)       = io_request->get_paging( )->get_page_size( ).
    DATA(lv_skip)      = io_request->get_paging( )->get_offset( ).
    DATA(lv_max_rows)  = COND #( WHEN lv_top = if_rap_query_paging=>page_size_unlimited THEN 0 ELSE lv_top ).
** ---------------------------------------------------------------------------
** Recupera e seta filtros de seleção
** ---------------------------------------------------------------------------
    TRY.
        me->set_filters( EXPORTING it_filters = io_request->get_filter( )->get_as_ranges( ) ). "#EC CI_CONV_OK
      CATCH cx_rap_query_filter_no_range INTO DATA(lo_ex_filter).
        lv_exp_msg = lo_ex_filter->get_longtext( ).
    ENDTRY.
** ---------------------------------------------------------------------------
** Monta relatório
** ---------------------------------------------------------------------------
    DATA(lt_result) = me->build(  ).
** ---------------------------------------------------------------------------
** Realiza ordenação de acordo com parâmetros de entrada
** ---------------------------------------------------------------------------
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
    IF io_request->is_total_numb_of_rec_requested(  ).
      io_response->set_total_number_of_records( CONV #( lines( lt_result[] ) ) ).
    ENDIF.

    IF io_request->is_data_requested( ).
      io_response->set_data( lt_result_page[] ).
    ENDIF.
  ENDMETHOD.


  METHOD buscar_range_filtro.
    READ TABLE me->gt_filtro_ranges ASSIGNING FIELD-SYMBOL(<fs_filtro_ranges>) WITH KEY name = iv_name BINARY SEARCH.
    IF sy-subrc = 0.
      rt_retorno = <fs_filtro_ranges>-range.
    ENDIF.
  ENDMETHOD.


  METHOD buscar_valor_low_filtro.
    DATA(lt_valor_range) = buscar_range_filtro( iv_name ).
    rv_retorno = VALUE #( lt_valor_range[ 1 ]-low  OPTIONAL ).
  ENDMETHOD.


  METHOD if_rap_query_filter~get_as_ranges.
    RETURN.
  ENDMETHOD.


  METHOD if_rap_query_filter~get_as_sql_string.
    RETURN.
  ENDMETHOD.


  METHOD filtro_tabelas.

    LOOP AT ir_vpsta ASSIGNING FIELD-SYMBOL(<fs_vpsta>).
      CASE <fs_vpsta>-low.
        WHEN 'K'.

          APPEND VALUE #( sign   = 'I'
                          option = 'EQ'
                          low    = 'MARA' ) TO gs_range-tables_k.

          APPEND VALUE #( sign   = 'I'
                          option = 'EQ'
                          low    = 'DMAKT' ) TO gs_range-tables_k.

          APPEND VALUE #( sign   = 'I'
                          option = 'EQ'
                          low    = 'DMARM' ) TO gs_range-tables_k.

          APPEND VALUE #( sign   = 'I'
                          option = 'EQ'
                          low    = 'DMEAN' ) TO gs_range-tables_k.

        WHEN 'V'.

          APPEND VALUE #( sign   = 'I'
                          option = 'EQ'
                          low    = 'MVKE' ) TO gs_range-tables_v_key.

          APPEND VALUE #( sign   = 'I'
                          option = 'EQ'
                          low    = 'DMLAN' ) TO gs_range-tables_v.

        WHEN 'E'.

          APPEND VALUE #( sign   = 'I'
                            option = 'EQ'
                            low    = 'MARC' ) TO gs_range-tables_e_key.

          APPEND VALUE #( sign   = 'I'
                          option = 'EQ'
                          low    = 'DMKAL' ) TO gs_range-tables_e.

          APPEND VALUE #( sign   = 'I'
                          option = 'EQ'
                          low    = 'DQMAT' ) TO gs_range-tables_e.


        WHEN 'B'.

          APPEND VALUE #( sign   = 'I'
                          option = 'EQ'
                          low    = 'MBEW' ) TO gs_range-tables_b.

*          APPEND VALUE #( sign   = 'I'
*                          option = 'EQ'
*                          low    = 'MARC' ) TO gs_range-tables.
        WHEN 'C'.

*          APPEND VALUE #( sign   = 'I'
*                          option = 'EQ'
*                          low    = 'ABAUSP' ) TO gs_range-tables_c.
*
*          APPEND VALUE #( sign   = 'I'
*                          option = 'EQ'
*                          low    = 'ABKSSK' ) TO gs_range-tables_c.


        WHEN 'D'.

          APPEND VALUE #( sign   = 'I'
                          option = 'EQ'
*                          low    = 'MARD' ) TO gs_range-tables.
                          low    = 'MARC' ) TO gs_range-tables_d.

          APPEND VALUE #( sign   = 'I'
                          option = 'EQ'
                          low    = 'RMMZU' ) TO gs_range-tables_d.
        WHEN 'Q'.

          APPEND VALUE #( sign   = 'I'
                          option = 'EQ'
                          low    = 'DQMAT' ) TO gs_range-tables_q.

          APPEND VALUE #( sign   = 'I'
                          option = 'EQ'
                          low    = 'MARC' ) TO gs_range-tables_q.

          APPEND VALUE #( sign   = 'I'
                          option = 'EQ'
                          low    = 'MARA' ) TO gs_range-tables_q.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.


  METHOD set_filters.
    IF it_filters IS NOT INITIAL.

      TRY.
          gs_range-vpsta   = it_filters[ name = 'VPSTA' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO DATA(lo_root).
          DATA(lv_exp_msg) = lo_root->get_longtext( ).
      ENDTRY.

      me->filtro_tabelas( gs_range-vpsta ).

      TRY.
          gs_range-matnr   = it_filters[ name = 'PRODUCT' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-mtart   = it_filters[ name = 'MTART' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-udate   = it_filters[ name = 'UDATE' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-username   = it_filters[ name = 'USERNAME' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-werks   = it_filters[ name = 'WERKS' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-lgort   = it_filters[ name = 'LGORT' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-vkorg   = it_filters[ name = 'VKORG' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-vtweg   = it_filters[ name = 'VTWEG' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-spart   = it_filters[ name = 'SPART' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-bwtar   = it_filters[ name = 'BWTAR' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-utime   = it_filters[ name = 'UTIME' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-maktx   = it_filters[ name = 'MAKTX' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-fname   = it_filters[ name = 'FNAME' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-chngind   = it_filters[ name = 'CHNGIND' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-value_new   = it_filters[ name = 'VALUE_NEW' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-value_old   = it_filters[ name = 'VALUE_OLD' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_range-ddtext   = it_filters[ name = 'DDTEXT' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      LOOP AT gs_range-vpsta ASSIGNING FIELD-SYMBOL(<fs_range>).
        <fs_range>-option = 'CP'.
        <fs_range>-low = |*{ <fs_range>-low }*|.
      ENDLOOP.

    ENDIF.

*    me->filtro_campos(  ).

  ENDMETHOD.


  METHOD build.
*
*
**    DATA ls_relat TYPE zc_mm_mestre_material_log.
*    DATA  lv_unit TYPE char3.
*    DATA: lt_vendas  TYPE TABLE OF ty_tabela_sel,
*          lt_tables  TYPE TABLE OF ty_tabela_sel,
*          lt_classif TYPE TABLE OF ty_tabela_sel,
*          lt_relat   TYPE TABLE OF ty_tabela_sel.
*
*    me->check_authorization( ).
*
*    IF line_exists( gs_range-vpsta[ low = '*V*' ] ).     "#EC CI_STDSEQ
*
*      SELECT DISTINCT mara~matnr AS Product, mara~mtart, mara~spart,
*            makt~maktx,
*            mvke~vkorg, mvke~vtweg,
*            cdhdr~udate, cdhdr~utime, cdhdr~username,
*            cdpos~tabkey, cdpos~tabname, cdpos~fname,
*            cdpos~chngind, cdpos~value_new, cdpos~value_old,
*            i_changedocchangeindt~text AS chngindtxt,
*            dd04t~ddtext
*           FROM mara
*           LEFT OUTER JOIN   makt  ON makt~matnr = mara~matnr AND makt~spras = @sy-langu
*           LEFT OUTER JOIN   cdhdr ON  cdhdr~objectclas = 'MATERIAL' AND mara~matnr = cdhdr~objectid
*           LEFT OUTER JOIN   cdpos ON cdpos~objectclas = cdhdr~objectclas AND cdpos~objectid = cdhdr~objectid AND cdpos~changenr = cdhdr~changenr
*           INNER JOIN        dd02l ON dd02l~tabname = cdpos~tabname AND as4local = 'A' AND as4vers = 0
*           LEFT OUTER JOIN   i_changedocchangeindt ON i_changedocchangeindt~value = cdpos~chngind AND i_changedocchangeindt~language = @sy-langu
*           LEFT OUTER JOIN   dd03l ON dd03l~tabname = cdpos~tabname AND dd03l~fieldname = cdpos~fname
*           LEFT OUTER JOIN   dd04t ON dd04t~rollname = dd03l~rollname AND dd04t~ddlanguage = @sy-langu AND dd04t~as4local = 'A' AND dd04t~as4vers = 0
*           LEFT OUTER JOIN   mvke  ON mara~matnr = mvke~matnr
*
*      WHERE cdpos~tabname IN @gs_range-tables_v
*      AND   mara~matnr    IN @gs_range-matnr
*      AND   mtart         IN @gs_range-mtart
*      AND   udate         IN @gs_range-udate
*      AND   username      IN @gs_range-username
*      AND   spart         IN @gs_range-spart
*      AND   utime         IN @gs_range-utime
*      AND   maktx         IN @gs_range-maktx
*      AND   fname         IN @gs_range-fname
*      AND   chngind       IN @gs_range-chngind
*      AND   value_new     IN @gs_range-value_new
*      AND   value_old     IN @gs_range-value_old
*      AND   vkorg         IN @gs_range-vkorg
*      AND   vtweg         IN @gs_range-vtweg
*      AND   dd04t~ddtext  IN @gs_range-ddtext
*      INTO CORRESPONDING FIELDS OF TABLE @lt_vendas.
*
*      SELECT DISTINCT mara~matnr AS Product, mara~mtart, mara~spart,
*            makt~maktx,
*            mvke~vkorg, mvke~vtweg,
*            cdhdr~udate, cdhdr~utime, cdhdr~username,
*            cdpos~tabkey, cdpos~tabname, cdpos~fname,
*            cdpos~chngind, cdpos~value_new, cdpos~value_old,
*            i_changedocchangeindt~text AS chngindtxt,
*            dd04t~ddtext
*           FROM mara
*           LEFT OUTER JOIN   makt  ON makt~matnr = mara~matnr AND makt~spras = @sy-langu
*           LEFT OUTER JOIN   mvke  ON mara~matnr = mvke~matnr
*           LEFT OUTER JOIN   cdhdr ON  cdhdr~objectclas = 'MATERIAL' AND mara~matnr = cdhdr~objectid
*           LEFT OUTER JOIN   zi_mm_cdpos_mvke_mat AS cdpos ON cdpos~objectclas = cdhdr~objectclas
*                                                  AND cdpos~objectid = cdhdr~objectid
*                                                  AND cdpos~changenr = cdhdr~changenr
*                                                  AND cdpos~matnr    = mara~matnr
*                                                  AND cdpos~vkorg    = mvke~vkorg
*                                                  AND cdpos~vtweg    = mvke~vtweg
*           INNER JOIN        dd02l ON dd02l~tabname = cdpos~tabname AND as4local = 'A' AND as4vers = 0
*           LEFT OUTER JOIN   i_changedocchangeindt ON i_changedocchangeindt~value = cdpos~chngind AND i_changedocchangeindt~language = @sy-langu
*           LEFT OUTER JOIN   dd03l ON dd03l~tabname = cdpos~tabname AND dd03l~fieldname = cdpos~fname
*           LEFT OUTER JOIN   dd04t ON dd04t~rollname = dd03l~rollname AND dd04t~ddlanguage = @sy-langu AND dd04t~as4local = 'A' AND dd04t~as4vers = 0
*
*      WHERE cdpos~tabname IN @gs_range-tables_v_key
*      AND   mara~matnr    IN @gs_range-matnr
*      AND   mtart         IN @gs_range-mtart
*      AND   udate         IN @gs_range-udate
*      AND   username      IN @gs_range-username
*      AND   spart         IN @gs_range-spart
*      AND   utime         IN @gs_range-utime
*      AND   maktx         IN @gs_range-maktx
*      AND   fname         IN @gs_range-fname
*      AND   chngind       IN @gs_range-chngind
*      AND   value_new     IN @gs_range-value_new
*      AND   value_old     IN @gs_range-value_old
*      AND   mvke~vkorg    IN @gs_range-vkorg
*      AND   mvke~vtweg    IN @gs_range-vtweg
*      AND   dd04t~ddtext  IN @gs_range-ddtext
*      APPENDING CORRESPONDING FIELDS OF TABLE @lt_vendas.
*
**      rt_relat = CORRESPONDING #( lt_vendas ).
*    ENDIF.
*
*    IF line_exists( gs_range-vpsta[ low = '*K*' ] ).     "#EC CI_STDSEQ
*
*      SELECT DISTINCT mara~matnr AS product, mara~mtart, mara~spart,
*              makt~maktx,
*              cdhdr~udate, cdhdr~utime, cdhdr~username,
*              cdpos~tabkey, cdpos~tabname, cdpos~fname,
*              cdpos~chngind, cdpos~value_new, cdpos~value_old,
*              i_changedocchangeindt~text AS chngindtxt,
*              dd04t~ddtext
*             FROM mara
*             LEFT OUTER JOIN   makt  ON mara~matnr = makt~matnr  AND makt~spras = @sy-langu
*             LEFT OUTER JOIN   cdhdr ON  cdhdr~objectclas = 'MATERIAL' AND mara~matnr = cdhdr~objectid
*             LEFT OUTER JOIN   cdpos ON cdpos~objectclas = cdhdr~objectclas AND cdpos~objectid = cdhdr~objectid AND cdpos~changenr = cdhdr~changenr
*                                     AND (  cdpos~fname <> 'AUSME'    AND cdpos~fname <> 'QMATA'      AND cdpos~fname <> 'QMATV' AND cdpos~fname <> 'INSMK'
*                                        AND cdpos~fname <> 'KZDKZ'    AND cdpos~fname <> 'RBNRM'      AND cdpos~fname <> 'WEBAZ' AND cdpos~fname <> 'PRFRQ'
*                                        AND cdpos~fname <> 'MMSTA'    AND cdpos~fname <> 'MMSTD'      AND cdpos~fname <> 'QMPUR' AND cdpos~fname <> 'SSQSS'
*                                        AND cdpos~fname <> 'QZGTP'    AND cdpos~fname <> 'QSSYS'      AND cdpos~fname <> 'ART'   AND cdpos~fname <> 'APA'
*                                        AND cdpos~fname <> 'AKTIV'    AND cdpos~fname <> 'STICHPRVER' AND cdpos~fname <> 'EIN'   AND cdpos~fname <> 'HPZ'
*                                        AND cdpos~fname <> 'MPDAU'    AND cdpos~fname <> 'SPEZUEBER'  AND cdpos~fname <> 'SPROZ' AND cdpos~fname <> 'QKZVERF'
*                                        AND cdpos~fname <> 'PPL'      AND cdpos~fname <> 'MST'        AND cdpos~fname <> 'QPMAT' AND cdpos~fname <> 'MPB'
*                                        AND cdpos~fname <> 'DYNREGEL' AND cdpos~fname <> 'KZPRFKOST'  AND cdpos~fname <> 'APP'   AND cdpos~fname <> 'DYN'
*                                        AND cdpos~fname <> 'AUFNR_CO' AND cdpos~fname <> 'MER'        AND cdpos~fname <> 'AVE'   AND cdpos~fname <> 'KEY'  )
**                                     AND ( cdpos~fname <> 'AUSME' AND cdpos~fname <> 'QMATA' AND cdpos~fname <> 'QMATV' AND cdpos~fname <> 'INSMK'
**                                       AND cdpos~fname <> 'KZDKZ' AND cdpos~fname <> 'RBNRM' AND cdpos~fname <> 'WEBAZ' AND cdpos~fname <> 'PRFRQ'
**                                       AND cdpos~fname <> 'MMSTA' AND cdpos~fname <> 'MMSTD' AND cdpos~fname <> 'QMPUR' AND cdpos~fname <> 'SSQSS'
**                                       AND cdpos~fname <> 'QZGTP' AND cdpos~fname <> 'QSSYS')
*             INNER JOIN        dd02l ON dd02l~tabname = cdpos~tabname AND as4local = 'A' AND as4vers = 0
*             LEFT OUTER JOIN   i_changedocchangeindt ON i_changedocchangeindt~value = cdpos~chngind AND i_changedocchangeindt~language = @sy-langu
*             LEFT OUTER JOIN   dd03l ON dd03l~tabname = cdpos~tabname AND dd03l~fieldname = cdpos~fname
*             LEFT OUTER JOIN   dd04t ON dd04t~rollname = dd03l~rollname AND dd04t~ddlanguage = @sy-langu AND dd04t~as4local = 'A' AND dd04t~as4vers = 0
*        WHERE cdpos~tabname IN @gs_range-tables_k
*        AND   mara~matnr    IN @gs_range-matnr
*        AND   mtart         IN @gs_range-mtart
*        AND   udate         IN @gs_range-udate
*        AND   username      IN @gs_range-username
*        AND   spart         IN @gs_range-spart
*        AND   utime         IN @gs_range-utime
*        AND   maktx         IN @gs_range-maktx
*        AND   cdpos~fname   IN @gs_range-fname
*        AND   chngind       IN @gs_range-chngind
*        AND   value_new     IN @gs_range-value_new
*        AND   value_old     IN @gs_range-value_old
*        AND   dd04t~ddtext  IN @gs_range-ddtext
*        AND   mara~vpsta    IN @gs_range-vpsta
*        INTO CORRESPONDING FIELDS OF TABLE @lt_tables.  "#EC CI_SEL_DEL
*
*    ENDIF.
*
*    IF line_exists( gs_range-vpsta[ low = '*D*' ] ).     "#EC CI_STDSEQ
*
*      SELECT DISTINCT mara~matnr AS product, mara~mtart, mara~spart,
*              marc~werks,
**              mard~lgort,
**              mbew~bwtar,
*              makt~maktx,
*              cdhdr~udate, cdhdr~utime, cdhdr~username,
*              cdpos~tabkey, cdpos~tabname, cdpos~fname,
*              cdpos~chngind, cdpos~value_new, cdpos~value_old,
*              i_changedocchangeindt~text AS chngindtxt,
*              dd04t~ddtext
*             FROM mara
*             LEFT OUTER JOIN   marc  ON mara~matnr = marc~matnr
*             LEFT OUTER JOIN   makt  ON mara~matnr = makt~matnr  AND makt~spras = @sy-langu
**             LEFT OUTER JOIN   mbew  ON mara~matnr = mbew~matnr  AND marc~werks = mbew~bwkey
**             LEFT OUTER JOIN   mard  ON mara~matnr = mard~matnr  AND marc~werks = mard~werks
*             LEFT OUTER JOIN   cdhdr ON  cdhdr~objectclas = 'MATERIAL' AND mara~matnr = cdhdr~objectid
**             LEFT OUTER JOIN   cdpos ON cdpos~objectclas = cdhdr~objectclas AND cdpos~objectid = cdhdr~objectid AND cdpos~changenr = cdhdr~changenr
*             LEFT OUTER JOIN   zi_mm_cdpos_marc_mat AS cdpos ON cdpos~objectclas = cdhdr~objectclas
*                                                            AND cdpos~objectid = cdhdr~objectid
*                                                            AND cdpos~changenr = cdhdr~changenr
*                                                            AND cdpos~matnr    = mara~matnr
*                                                            AND cdpos~werks    = marc~werks
*                                                            AND ( cdpos~fname = 'DISGR' OR cdpos~fname = 'MAABC' OR cdpos~fname = 'DISMM' OR cdpos~fname = 'MINBE'  OR cdpos~fname = 'FXHOR'
*                                                               OR cdpos~fname = 'LFRHY' OR cdpos~fname = 'DISPO' OR cdpos~fname = 'DISLS' OR cdpos~fname = 'BSTMI'  OR cdpos~fname = 'BSTMA'
*                                                               OR cdpos~fname = 'BSTFE' OR cdpos~fname = 'MABST' OR cdpos~fname = 'AUSSS' OR cdpos~fname = 'TAKZT'  OR cdpos~fname = 'RDPRF'
*                                                               OR cdpos~fname = 'BSTRF' OR cdpos~fname = 'BESKZ' OR cdpos~fname = 'SOBSL' OR cdpos~fname = 'RGEKZ'  OR cdpos~fname = 'VSPVB'
*                                                               OR cdpos~fname = 'FABKZ' OR cdpos~fname = 'LGFSB' OR cdpos~fname = 'KZKUP' OR cdpos~fname = 'SCHGT'  OR cdpos~fname = 'EPRIO'
*                                                               OR cdpos~fname = 'PLIFZ' OR cdpos~fname = 'FHORI' OR cdpos~fname = 'MRPPP' OR cdpos~fname = 'EISBE'  OR cdpos~fname = 'EISLO'
*                                                               OR cdpos~fname = 'RWPRO' OR cdpos~fname = 'SHFLG' OR cdpos~fname = 'SHZET' OR cdpos~fname = 'PERKZ'  OR cdpos~fname = 'PERIV'
*                                                               OR cdpos~fname = 'AUFTL' OR cdpos~fname = 'AUTRU' OR cdpos~fname = 'KZKFK' OR cdpos~fname = 'STRGR'  OR cdpos~fname = 'VRMOD'
*                                                               OR cdpos~fname = 'VINT1' OR cdpos~fname = 'VINT2' OR cdpos~fname = 'MISKZ' OR cdpos~fname = 'PRGRP'  OR cdpos~fname = 'PRWRK'
*                                                               OR cdpos~fname = 'UMREF' OR cdpos~fname = 'WZEIT' OR cdpos~fname = 'KZPSP' OR cdpos~fname = 'ALTSL'  OR cdpos~fname = 'SBDKZ'
*                                                               OR cdpos~fname = 'KAUSF' OR cdpos~fname = 'KZBED' OR cdpos~fname = 'AHDIS' OR cdpos~fname = 'KZAUS'  OR cdpos~fname = 'AUSDT'
*                                                               OR cdpos~fname = 'NFMAT' OR cdpos~fname = 'SAUFT' OR cdpos~fname = 'SFEPR' OR cdpos~fname = 'FRTME'  OR cdpos~fname = 'SFCPF'
*                                                               OR cdpos~fname = 'FEVOR' OR cdpos~fname = 'UEETO' OR cdpos~fname = 'UEETK' OR cdpos~fname = 'UNETO'  OR cdpos~fname = 'BEARZ'
*                                                               OR cdpos~fname = 'RUEZT' OR cdpos~fname = 'TRANZ' OR cdpos~fname = 'DZEIT' OR cdpos~fname = 'BASMG'  OR cdpos~fname = 'MAXLZ'
*                                                               OR cdpos~fname = 'LZEIH' OR cdpos~fname = 'XMCNG' OR cdpos~fname = 'MMSTD' OR cdpos~fname = 'KZECH'  OR cdpos~fname = 'STDPD'
*                                                               OR cdpos~fname = 'XLTYP' OR cdpos~fname = 'XVPLB' OR cdpos~fname = 'AUSME' OR cdpos~fname = 'GROUP'  OR cdpos~fname = 'XCHPF'
*                                                               OR cdpos~fname = 'SERNP' OR cdpos~fname = 'MMSTA' OR cdpos~fname = 'MMSTD' OR cdpos~fname = 'MTVFP'  OR cdpos~fname = 'KZECH'
*                                                               OR cdpos~fname = 'KZKRI' OR cdpos~fname = 'WEBAZ' OR cdpos~fname = 'LGPRO' OR cdpos~fname = 'INSMK' )
*
*             INNER JOIN        dd02l ON dd02l~tabname = cdpos~tabname AND as4local = 'A' AND as4vers = 0
*             LEFT OUTER JOIN   i_changedocchangeindt ON i_changedocchangeindt~value = cdpos~chngind AND i_changedocchangeindt~language = @sy-langu
*             LEFT OUTER JOIN   dd03l ON dd03l~tabname = cdpos~tabname AND dd03l~fieldname = cdpos~fname
*             LEFT OUTER JOIN   dd04t ON dd04t~rollname = dd03l~rollname AND dd04t~ddlanguage = @sy-langu AND dd04t~as4local = 'A' AND dd04t~as4vers = 0
*        WHERE cdpos~tabname IN @gs_range-tables_d
*        AND   mara~matnr    IN @gs_range-matnr
*        AND   mtart         IN @gs_range-mtart
*        AND   udate         IN @gs_range-udate
*        AND   username      IN @gs_range-username
*        AND   marc~werks    IN @gs_range-werks
**        AND   lgort         IN @gs_range-lgort
*        AND   spart         IN @gs_range-spart
**        AND   mbew~bwtar    IN @gs_range-bwtar
*        AND   utime         IN @gs_range-utime
*        AND   maktx         IN @gs_range-maktx
*        AND   fname         IN @gs_range-fname
*        AND   chngind       IN @gs_range-chngind
*        AND   value_new     IN @gs_range-value_new
*        AND   value_old     IN @gs_range-value_old
*        AND   dd04t~ddtext  IN @gs_range-ddtext
*        AND   mara~vpsta    IN @gs_range-vpsta
*        APPENDING CORRESPONDING FIELDS OF TABLE @lt_tables. "#EC CI_SEL_DEL
*
*    ENDIF.
*
*    IF line_exists( gs_range-vpsta[ low = '*Q*' ] ).     "#EC CI_STDSEQ
**      SELECT DISTINCT mara~matnr AS product, mara~mtart, mara~spart,
**              marc~werks,
***              mard~lgort,
***              mbew~bwtar,
**              makt~maktx,
**              cdhdr~udate, cdhdr~utime, cdhdr~username,
**              cdpos~tabkey, cdpos~tabname, cdpos~fname,
**              cdpos~chngind, cdpos~value_new, cdpos~value_old,
**              i_changedocchangeindt~text AS chngindtxt,
**              dd04t~ddtext
**             FROM mara
**             LEFT OUTER JOIN   marc  ON mara~matnr = marc~matnr
**             LEFT OUTER JOIN   makt  ON mara~matnr = makt~matnr  AND makt~spras = @sy-langu
***             LEFT OUTER JOIN   mbew  ON mara~matnr = mbew~matnr  AND marc~werks = mbew~bwkey
***             LEFT OUTER JOIN   mard  ON mara~matnr = mard~matnr  AND marc~werks = mard~werks
**             LEFT OUTER JOIN   cdhdr ON cdhdr~objectclas = 'MATERIAL' AND mara~matnr = cdhdr~objectid
**             LEFT OUTER JOIN   cdpos ON cdpos~objectclas = cdhdr~objectclas AND cdpos~objectid = cdhdr~objectid AND cdpos~changenr = cdhdr~changenr
**                                                                            AND ( cdpos~fname = 'AUSME'    OR cdpos~fname = 'QMATA'      OR cdpos~fname = 'QMATV' OR cdpos~fname = 'INSMK'
**                                                                               OR cdpos~fname = 'KZDKZ'    OR cdpos~fname = 'RBNRM'      OR cdpos~fname = 'WEBAZ' OR cdpos~fname = 'PRFRQ'
**                                                                               OR cdpos~fname = 'MMSTA'    OR cdpos~fname = 'MMSTD'      OR cdpos~fname = 'QMPUR' OR cdpos~fname = 'SSQSS'
**                                                                               OR cdpos~fname = 'QZGTP'    OR cdpos~fname = 'QSSYS'      OR cdpos~fname = 'ART'   OR cdpos~fname = 'APA'
**                                                                               OR cdpos~fname = 'AKTIV'    OR cdpos~fname = 'STICHPRVER' OR cdpos~fname = 'EIN'   OR cdpos~fname = 'HPZ'
**                                                                               OR cdpos~fname = 'MPDAU'    OR cdpos~fname = 'SPEZUEBER'  OR cdpos~fname = 'SPROZ' OR cdpos~fname = 'QKZVERF'
**                                                                               OR cdpos~fname = 'PPL'      OR cdpos~fname = 'MST'        OR cdpos~fname = 'QPMAT' OR cdpos~fname = 'MPB'
**                                                                               OR cdpos~fname = 'DYNREGEL' OR cdpos~fname = 'KZPRFKOST'  OR cdpos~fname = 'APP'   OR cdpos~fname = 'DYN'
**                                                                               OR cdpos~fname = 'AUFNR_CO' OR cdpos~fname = 'MER'        OR cdpos~fname = 'AVE'   OR cdpos~fname = 'KEY'
**                                                                               OR cdpos~fname = 'PSTAT' )
**             INNER JOIN        dd02l ON dd02l~tabname = cdpos~tabname AND as4local = 'A' AND as4vers = 0
**             LEFT OUTER JOIN   i_changedocchangeindt ON i_changedocchangeindt~value = cdpos~chngind AND i_changedocchangeindt~language = @sy-langu
**             LEFT OUTER JOIN   dd03l ON dd03l~tabname = cdpos~tabname AND dd03l~fieldname = cdpos~fname
**             LEFT OUTER JOIN   dd04t ON dd04t~rollname = dd03l~rollname AND dd04t~ddlanguage = @sy-langu AND dd04t~as4local = 'A' AND dd04t~as4vers = 0
**        WHERE cdpos~tabname IN @gs_range-tables_q
**        AND   mara~matnr    IN @gs_range-matnr
**        AND   mtart         IN @gs_range-mtart
**        AND   udate         IN @gs_range-udate
**        AND   username      IN @gs_range-username
**        AND   marc~werks    IN @gs_range-werks
***        AND   lgort         IN @gs_range-lgort
**        AND   spart         IN @gs_range-spart
***        AND   mbew~bwtar    IN @gs_range-bwtar
**        AND   utime         IN @gs_range-utime
**        AND   maktx         IN @gs_range-maktx
**        AND   fname         IN @gs_range-fname
**        AND   chngind       IN @gs_range-chngind
**        AND   value_new     IN @gs_range-value_new
**        AND   value_old     IN @gs_range-value_old
**        AND   dd04t~ddtext  IN @gs_range-ddtext
**        AND   mara~vpsta    IN @gs_range-vpsta
**        APPENDING CORRESPONDING FIELDS OF TABLE @lt_tables."#EC CI_SEL_DEL
**
**
**      IF lt_tables IS NOT INITIAL.
**        SORT lt_tables BY tabname fname.
**        DELETE lt_tables WHERE tabname = 'MARA' AND fname = 'KEY'.   "#EC CI_STDSEQ
**        DELETE lt_tables WHERE tabname = 'MARC' AND fname = 'KEY'.   "#EC CI_STDSEQ
**        DELETE lt_tables WHERE tabname = 'MARA' AND fname = 'PSTAT'. "#EC CI_STDSEQ
**        DELETE lt_tables WHERE tabname = 'MARC' AND fname = 'PSTAT'. "#EC CI_STDSEQ
**
**      ENDIF.
*      SELECT DISTINCT mara~matnr AS product, mara~mtart, mara~spart,
*              marc~werks,
*              makt~maktx,
*              cdhdr~udate, cdhdr~utime, cdhdr~username,
**              cdpos~tabkey, cdpos~tabname, cdpos~fname,
**              cdpos~chngind, cdpos~value_new, cdpos~value_old,
**              i_changedocchangeindt~text AS chngindtxt,
**              dd04t~ddtext,
*               cdhdr~objectclas, cdhdr~objectid, cdhdr~changenr
*             FROM mara
*             LEFT OUTER JOIN   marc  ON mara~matnr = marc~matnr
*             LEFT OUTER JOIN   makt  ON mara~matnr = makt~matnr  AND makt~spras = @sy-langu
*             LEFT OUTER JOIN   cdhdr ON cdhdr~objectclas = 'MATERIAL' AND mara~matnr = cdhdr~objectid
**             LEFT OUTER JOIN   cdpos ON cdpos~objectclas = cdhdr~objectclas AND cdpos~objectid = cdhdr~objectid AND cdpos~changenr = cdhdr~changenr
**             LEFT OUTER JOIN   zi_mm_cdpos_marc_mat AS cdpos_marc ON cdpos_marc~objectclas = cdhdr~objectclas
**                                                                 AND cdpos_marc~objectid   = cdhdr~objectid
**                                                                 AND cdpos_marc~changenr   = cdhdr~changenr
**                                                                 AND cdpos_marc~matnr      = mara~matnr
**                                                                 AND cdpos_marc~werks      = marc~werks
**
**             LEFT OUTER JOIN zi_mm_cdpos_dqmat AS cdpos_dqmat ON cdpos_dqmat~objectclas   = cdhdr~objectclas
**                                                                 AND cdpos_dqmat~objectid = cdhdr~objectid
**                                                                 AND cdpos_dqmat~changenr = cdhdr~changenr
**                                                                 AND cdpos_dqmat~werks    = marc~werks
*
**             INNER JOIN        dd02l ON dd02l~tabname = cdpos~tabname AND as4local = 'A' AND as4vers = 0
**             LEFT OUTER JOIN   i_changedocchangeindt ON i_changedocchangeindt~value = cdpos~chngind AND i_changedocchangeindt~language = @sy-langu
**             LEFT OUTER JOIN   dd03l ON dd03l~tabname = cdpos~tabname AND dd03l~fieldname = cdpos~fname
**             LEFT OUTER JOIN   dd04t ON dd04t~rollname = dd03l~rollname AND dd04t~ddlanguage = @sy-langu AND dd04t~as4local = 'A' AND dd04t~as4vers = 0
*        WHERE
**        cdpos~tabname IN @gs_range-tables_q
*              mara~matnr    IN @gs_range-matnr
*        AND   mtart         IN @gs_range-mtart
*        AND   udate         IN @gs_range-udate
*        AND   username      IN @gs_range-username
*        AND   marc~werks    IN @gs_range-werks
**        AND   lgort         IN @gs_range-lgort
*        AND   spart         IN @gs_range-spart
**        AND   mbew~bwtar    IN @gs_range-bwtar
*        AND   utime         IN @gs_range-utime
*        AND   maktx         IN @gs_range-maktx
**        AND   fname         IN @gs_range-fname
**        AND   chngind       IN @gs_range-chngind
**        AND   value_new     IN @gs_range-value_new
**        AND   value_old     IN @gs_range-value_old
**        AND   dd04t~ddtext  IN @gs_range-ddtext
*        AND   mara~vpsta    IN @gs_range-vpsta
*        APPENDING CORRESPONDING FIELDS OF TABLE @lt_tables. "#EC CI_SEL_DEL
*
*
*      SELECT objectclas, objectid, changenr, matnr, werks, tabkey, cdpos~tabname, fname,
*              chngind, value_new, value_old,
*              i_changedocchangeindt~text AS chngindtxt,
*              dd04t~ddtext
*      FROM zi_mm_cdpos_marc_mat AS cdpos
*
*      INNER JOIN        dd02l ON dd02l~tabname = cdpos~tabname AND as4local = 'A' AND as4vers = 0
*      LEFT OUTER JOIN   i_changedocchangeindt ON i_changedocchangeindt~value = cdpos~chngind AND i_changedocchangeindt~language = @sy-langu
*      LEFT OUTER JOIN   dd03l ON dd03l~tabname = cdpos~tabname AND dd03l~fieldname = cdpos~fname
*      LEFT OUTER JOIN   dd04t ON dd04t~rollname = dd03l~rollname AND dd04t~ddlanguage = @sy-langu AND dd04t~as4local = 'A' AND dd04t~as4vers = 0
*      FOR ALL ENTRIES IN @lt_tables
*      WHERE objectclas    EQ @lt_tables-objectclas
*      AND   objectid      EQ @lt_tables-objectid
*      AND   changenr      EQ @lt_tables-changenr
*      AND   matnr         EQ @lt_tables-product
*      AND   werks         EQ @lt_tables-werks
*      AND   fname         IN @gs_range-fname
*      AND   chngind       IN @gs_range-chngind
*      AND   value_new     IN @gs_range-value_new
*      AND   value_old     IN @gs_range-value_old
*      AND   dd04t~ddtext  IN @gs_range-ddtext
*      INTO TABLE @DATA(lt_marc).
*
*      SELECT objectclas, objectid, changenr, werks, tabkey, cdpos~tabname, fname,
*              chngind, value_new, value_old,
*              i_changedocchangeindt~text AS chngindtxt,
*              dd04t~ddtext
*      FROM zi_mm_cdpos_dqmat AS cdpos
*      INNER JOIN        dd02l ON dd02l~tabname = cdpos~tabname AND as4local = 'A' AND as4vers = 0
*      LEFT OUTER JOIN   i_changedocchangeindt ON i_changedocchangeindt~value = cdpos~chngind AND i_changedocchangeindt~language = @sy-langu
*      LEFT OUTER JOIN   dd03l ON dd03l~tabname = cdpos~tabname AND dd03l~fieldname = cdpos~fname
*      LEFT OUTER JOIN   dd04t ON dd04t~rollname = dd03l~rollname AND dd04t~ddlanguage = @sy-langu AND dd04t~as4local = 'A' AND dd04t~as4vers = 0
*      FOR ALL ENTRIES IN @lt_tables
*      WHERE objectclas    EQ @lt_tables-objectclas
*      AND   objectid      EQ @lt_tables-objectid
*      AND   changenr      EQ @lt_tables-changenr
*      AND   werks         EQ @lt_tables-werks
*      AND   fname         IN @gs_range-fname
*      AND   chngind       IN @gs_range-chngind
*      AND   value_new     IN @gs_range-value_new
*      AND   value_old     IN @gs_range-value_old
*      AND   dd04t~ddtext  IN @gs_range-ddtext
*      INTO TABLE @DATA(lt_dqmat).
*
*      SELECT objectclas, objectid, changenr, matnr, tabkey, cdpos~tabname, fname,
*              chngind, value_new, value_old,
*              i_changedocchangeindt~text AS chngindtxt,
*              dd04t~ddtext
*      FROM zi_mm_cdpos_mara AS cdpos
*      INNER JOIN        dd02l ON dd02l~tabname = cdpos~tabname AND as4local = 'A' AND as4vers = 0
*      LEFT OUTER JOIN   i_changedocchangeindt ON i_changedocchangeindt~value = cdpos~chngind AND i_changedocchangeindt~language = @sy-langu
*      LEFT OUTER JOIN   dd03l ON dd03l~tabname = cdpos~tabname AND dd03l~fieldname = cdpos~fname
*      LEFT OUTER JOIN   dd04t ON dd04t~rollname = dd03l~rollname AND dd04t~ddlanguage = @sy-langu AND dd04t~as4local = 'A' AND dd04t~as4vers = 0
*      FOR ALL ENTRIES IN @lt_tables
*      WHERE objectclas    EQ @lt_tables-objectclas
*      AND   objectid      EQ @lt_tables-objectid
*      AND   changenr      EQ @lt_tables-changenr
*      AND   matnr         EQ @lt_tables-product
*      AND   fname         IN @gs_range-fname
*      AND   chngind       IN @gs_range-chngind
*      AND   value_new     IN @gs_range-value_new
*      AND   value_old     IN @gs_range-value_old
*      AND   dd04t~ddtext  IN @gs_range-ddtext
*      INTO TABLE @DATA(lt_mara).
*
*
*      DATA: lt_tab_aux TYPE TABLE OF ty_tabela_sel,
*            ls_tab_aux TYPE ty_tabela_sel.
*
*
*      LOOP AT lt_marc ASSIGNING FIELD-SYMBOL(<fs_marc>).
*        READ TABLE lt_tables ASSIGNING FIELD-SYMBOL(<fs_tables_aux>) WITH KEY objectclas = <fs_marc>-objectclas
*                                                                              objectid   = <fs_marc>-objectid
*                                                                              changenr   = <fs_marc>-changenr
*                                                                              product    = <fs_marc>-matnr
*                                                                              werks      = <fs_marc>-werks.
*        IF sy-subrc = 0.
*          MOVE-CORRESPONDING <fs_tables_aux> TO ls_tab_aux.
*          ls_tab_aux-tabkey     = <fs_marc>-tabkey.
*          ls_tab_aux-tabname    = <fs_marc>-tabname.
*          ls_tab_aux-fname      = <fs_marc>-fname.
*          ls_tab_aux-chngind    = <fs_marc>-chngind.
*          ls_tab_aux-value_new  = <fs_marc>-value_new.
*          ls_tab_aux-value_old  = <fs_marc>-value_old.
*          ls_tab_aux-chngindtxt = <fs_marc>-chngindtxt.
*          ls_tab_aux-ddtext     = <fs_marc>-ddtext.
*
*          APPEND ls_tab_aux TO lt_tab_aux.
*        ENDIF.
*
*      ENDLOOP.
*
*      LOOP AT lt_dqmat ASSIGNING FIELD-SYMBOL(<fs_dqmat>).
*        READ TABLE lt_tables ASSIGNING <fs_tables_aux> WITH KEY objectclas = <fs_dqmat>-objectclas
*                                                                objectid   = <fs_dqmat>-objectid
*                                                                changenr   = <fs_dqmat>-changenr
*                                                                werks      = <fs_dqmat>-werks.
*        IF sy-subrc = 0.
*          MOVE-CORRESPONDING <fs_tables_aux> TO ls_tab_aux.
*          ls_tab_aux-tabkey     = <fs_dqmat>-tabkey.
*          ls_tab_aux-tabname    = <fs_dqmat>-tabname.
*          ls_tab_aux-fname      = <fs_dqmat>-fname.
*          ls_tab_aux-chngind    = <fs_dqmat>-chngind.
*          ls_tab_aux-value_new  = <fs_dqmat>-value_new.
*          ls_tab_aux-value_old  = <fs_dqmat>-value_old.
*          ls_tab_aux-chngindtxt = <fs_dqmat>-chngindtxt.
*          ls_tab_aux-ddtext     = <fs_dqmat>-ddtext.
*
*          APPEND ls_tab_aux TO lt_tab_aux.
*        ENDIF.
*      ENDLOOP.
*
*      LOOP AT lt_mara ASSIGNING FIELD-SYMBOL(<fs_mara>).
*        READ TABLE lt_tables ASSIGNING <fs_tables_aux> WITH KEY objectclas = <fs_mara>-objectclas
*                                                                objectid   = <fs_mara>-objectid
*                                                                changenr   = <fs_mara>-changenr
*                                                                product    = <fs_mara>-matnr.
*        IF sy-subrc = 0.
*          MOVE-CORRESPONDING <fs_tables_aux> TO ls_tab_aux.
*          ls_tab_aux-tabkey     = <fs_mara>-tabkey.
*          ls_tab_aux-tabname    = <fs_mara>-tabname.
*          ls_tab_aux-fname      = <fs_mara>-fname.
*          ls_tab_aux-chngind    = <fs_mara>-chngind.
*          ls_tab_aux-value_new  = <fs_mara>-value_new.
*          ls_tab_aux-value_old  = <fs_mara>-value_old.
*          ls_tab_aux-chngindtxt = <fs_mara>-chngindtxt.
*          ls_tab_aux-ddtext     = <fs_mara>-ddtext.
*
*          APPEND ls_tab_aux TO lt_tab_aux.
*        ENDIF.
*      ENDLOOP.
*
*      SORT lt_tab_aux BY fname.
*      DELETE lt_tab_aux WHERE fname <> 'AUSME'    AND fname <> 'QMATA'      AND fname <> 'QMATV' AND fname <> 'INSMK'
*                          AND fname <> 'KZDKZ'    AND fname <> 'RBNRM'      AND fname <> 'WEBAZ' AND fname <> 'PRFRQ'
*                          AND fname <> 'MMSTA'    AND fname <> 'MMSTD'      AND fname <> 'QMPUR' AND fname <> 'SSQSS'
*                          AND fname <> 'QZGTP'    AND fname <> 'QSSYS'      AND fname <> 'ART'   AND fname <> 'APA'
*                          AND fname <> 'AKTIV'    AND fname <> 'STICHPRVER' AND fname <> 'EIN'   AND fname <> 'HPZ'
*                          AND fname <> 'MPDAU'    AND fname <> 'SPEZUEBER'  AND fname <> 'SPROZ' AND fname <> 'QKZVERF'
*                          AND fname <> 'PPL'      AND fname <> 'MST'        AND fname <> 'QPMAT' AND fname <> 'MPB'
*                          AND fname <> 'DYNREGEL' AND fname <> 'KZPRFKOST'  AND fname <> 'APP'   AND fname <> 'DYN'
*                          AND fname <> 'AUFNR_CO' AND fname <> 'MER'        AND fname <> 'AVE'   AND fname <> 'KEY'
*                          AND fname <> 'PSTAT'.
*
*      CLEAR lt_tables.
*      lt_tables[] = lt_tab_aux[].
*
*    ENDIF.
*
*    IF line_exists( gs_range-vpsta[ low = '*E*' ] ).     "#EC CI_STDSEQ
*      SELECT DISTINCT mara~matnr AS product, mara~mtart, mara~spart,
*              marc~werks,
**              mard~lgort,
**              mbew~bwtar,
*              makt~maktx,
*              cdhdr~udate, cdhdr~utime, cdhdr~username,
*              cdpos~tabkey, cdpos~tabname, cdpos~fname,
*              cdpos~chngind, cdpos~value_new, cdpos~value_old,
*              i_changedocchangeindt~text AS chngindtxt,
*              dd04t~ddtext
*             FROM mara
*             LEFT OUTER JOIN   marc  ON mara~matnr = marc~matnr
*             LEFT OUTER JOIN   makt  ON mara~matnr = makt~matnr  AND makt~spras = @sy-langu
**             LEFT OUTER JOIN   mbew  ON mara~matnr = mbew~matnr  AND marc~werks = mbew~bwkey
**             LEFT OUTER JOIN   mard  ON mara~matnr = mard~matnr  AND marc~werks = mard~werks
**             LEFT OUTER JOIN ztmm_paletizacao AS palet ON palet~material = mara~matnr AND palet~centro = marc~werks
*             LEFT OUTER JOIN   cdhdr ON  cdhdr~objectclas = 'MATERIAL' AND mara~matnr = cdhdr~objectid
*             LEFT OUTER JOIN   cdpos ON cdpos~objectclas = cdhdr~objectclas AND cdpos~objectid = cdhdr~objectid AND cdpos~changenr = cdhdr~changenr
*                                                               AND ( cdpos~fname <> 'DISGR'      AND cdpos~fname <> 'MAABC'    AND cdpos~fname <> 'DISMM'      AND cdpos~fname <> 'MINBE'  AND cdpos~fname <> 'FXHOR'
*                                                                 AND cdpos~fname <> 'LFRHY'      AND cdpos~fname <> 'DISPO'    AND cdpos~fname <> 'DISLS'      AND cdpos~fname <> 'BSTMI'  AND cdpos~fname <> 'BSTMA'
*                                                                 AND cdpos~fname <> 'BSTFE'      AND cdpos~fname <> 'MABST'    AND cdpos~fname <> 'AUSSS'      AND cdpos~fname <> 'TAKZT'  AND cdpos~fname <> 'RDPRF'
*                                                                 AND cdpos~fname <> 'BSTRF'      AND cdpos~fname <> 'BESKZ'    AND cdpos~fname <> 'SOBSL'      AND cdpos~fname <> 'RGEKZ'  AND cdpos~fname <> 'VSPVB'
*                                                                 AND cdpos~fname <> 'FABKZ'      AND cdpos~fname <> 'LGFSB'    AND cdpos~fname <> 'KZKUP'      AND cdpos~fname <> 'SCHGT'  AND cdpos~fname <> 'EPRIO'
*                                                                 AND cdpos~fname <> 'PLIFZ'      AND cdpos~fname <> 'FHORI'    AND cdpos~fname <> 'MRPPP'      AND cdpos~fname <> 'EISBE'  AND cdpos~fname <> 'EISLO'
*                                                                 AND cdpos~fname <> 'RWPRO'      AND cdpos~fname <> 'SHFLG'    AND cdpos~fname <> 'SHZET'      AND cdpos~fname <> 'PERKZ'  AND cdpos~fname <> 'PERIV'
*                                                                 AND cdpos~fname <> 'AUFTL'      AND cdpos~fname <> 'AUTRU'    AND cdpos~fname <> 'KZKFK'      AND cdpos~fname <> 'STRGR'  AND cdpos~fname <> 'VRMOD'
*                                                                 AND cdpos~fname <> 'VINT1'      AND cdpos~fname <> 'VINT2'    AND cdpos~fname <> 'MISKZ'      AND cdpos~fname <> 'PRGRP'  AND cdpos~fname <> 'PRWRK'
*                                                                 AND cdpos~fname <> 'UMREF'      AND cdpos~fname <> 'WZEIT'    AND cdpos~fname <> 'KZPSP'      AND cdpos~fname <> 'ALTSL'  AND cdpos~fname <> 'SBDKZ'
*                                                                 AND cdpos~fname <> 'KAUSF'      AND cdpos~fname <> 'KZBED'    AND cdpos~fname <> 'AHDIS'      AND cdpos~fname <> 'KZAUS'  AND cdpos~fname <> 'AUSDT'
*                                                                 AND cdpos~fname <> 'NFMAT'      AND cdpos~fname <> 'SAUFT'    AND cdpos~fname <> 'SFEPR'      AND cdpos~fname <> 'FRTME'  AND cdpos~fname <> 'SFCPF'
*                                                                 AND cdpos~fname <> 'FEVOR'      AND cdpos~fname <> 'UEETO'    AND cdpos~fname <> 'UEETK'      AND cdpos~fname <> 'UNETO'  AND cdpos~fname <> 'BEARZ'
*                                                                 AND cdpos~fname <> 'RUEZT'      AND cdpos~fname <> 'TRANZ'    AND cdpos~fname <> 'DZEIT'      AND cdpos~fname <> 'BASMG'  AND cdpos~fname <> 'MAXLZ'
*                                                                 AND cdpos~fname <> 'LZEIH'      AND cdpos~fname <> 'XMCNG'    AND cdpos~fname <> 'MMSTD'      AND cdpos~fname <> 'KZECH'  AND cdpos~fname <> 'STDPD'
*                                                                 AND cdpos~fname <> 'XLTYP'      AND cdpos~fname <> 'XVPLB'    AND cdpos~fname <> 'ART'        AND cdpos~fname <> 'APA'    AND cdpos~fname <> 'AKTIV'
*                                                                 AND cdpos~fname <> 'STICHPRVER' AND cdpos~fname <> 'EIN'      AND cdpos~fname <> 'HPZ'        AND cdpos~fname <> 'MPDAU'  AND cdpos~fname <> 'SPEZUEBER'
*                                                                 AND cdpos~fname <> 'SPROZ'      AND cdpos~fname <> 'QKZVERF'  AND cdpos~fname <> 'PPL'        AND cdpos~fname <> 'MST'    AND cdpos~fname <> 'QPMAT'
*                                                                 AND cdpos~fname <> 'MPB'        AND cdpos~fname <> 'DYNREGEL' AND cdpos~fname <> 'KZPRFKOST'  AND cdpos~fname <> 'APP'    AND cdpos~fname <> 'DYN'
*                                                                 AND cdpos~fname <> 'AUFNR_CO'   AND cdpos~fname <> 'MER'      AND cdpos~fname <> 'AVE'        AND cdpos~fname <> 'KEY'
*
*                                                                    AND cdpos~fname <> 'QMATA'      AND cdpos~fname <> 'QMATV' AND cdpos~fname <> 'INSMK'
*                                                                    AND cdpos~fname <> 'KZDKZ'    AND cdpos~fname <> 'RBNRM'      AND cdpos~fname <> 'WEBAZ' AND cdpos~fname <> 'PRFRQ'
*                                                                    AND cdpos~fname <> 'MMSTA'    AND cdpos~fname <> 'MMSTD'      AND cdpos~fname <> 'QMPUR' AND cdpos~fname <> 'SSQSS'
*                                                                    AND cdpos~fname <> 'QZGTP'    AND cdpos~fname <> 'QSSYS'      AND cdpos~fname <> 'ART'   AND cdpos~fname <> 'APA'
*                                                                    AND cdpos~fname <> 'AKTIV'    AND cdpos~fname <> 'STICHPRVER' AND cdpos~fname <> 'EIN'   AND cdpos~fname <> 'HPZ'
*                                                                    AND cdpos~fname <> 'MPDAU'    AND cdpos~fname <> 'SPEZUEBER'  AND cdpos~fname <> 'SPROZ' AND cdpos~fname <> 'QKZVERF'
*                                                                    AND cdpos~fname <> 'PPL'      AND cdpos~fname <> 'MST'        AND cdpos~fname <> 'QPMAT' AND cdpos~fname <> 'MPB'
*                                                                    AND cdpos~fname <> 'DYNREGEL' AND cdpos~fname <> 'KZPRFKOST'  AND cdpos~fname <> 'APP'   AND cdpos~fname <> 'DYN'
*                                                                    AND cdpos~fname <> 'AUFNR_CO' AND cdpos~fname <> 'MER'        AND cdpos~fname <> 'AVE'   AND cdpos~fname <> 'KEY'  )
**                                                               AND
**                                                                ( cdpos~fname =  'AUSME' OR cdpos~fname = 'GROUP' OR cdpos~fname = 'XCHPF' OR cdpos~fname =  'SERNP' OR cdpos~fname =  'MMSTA'
**                                                               OR cdpos~fname =  'MMSTD' OR cdpos~fname = 'MTVFP' OR cdpos~fname = 'KZECH' OR cdpos~fname =  'KZKRI' OR cdpos~fname =  'WEBAZ'
**                                                               OR cdpos~fname =  'LGPRO' OR cdpos~fname = 'INSMK' )
*             INNER JOIN        dd02l ON dd02l~tabname = cdpos~tabname AND as4local = 'A' AND as4vers = 0
*             LEFT OUTER JOIN   i_changedocchangeindt ON i_changedocchangeindt~value = cdpos~chngind AND i_changedocchangeindt~language = @sy-langu
*             LEFT OUTER JOIN   dd03l ON dd03l~tabname = cdpos~tabname AND dd03l~fieldname = cdpos~fname
*             LEFT OUTER JOIN   dd04t ON dd04t~rollname = dd03l~rollname AND dd04t~ddlanguage = @sy-langu AND dd04t~as4local = 'A' AND dd04t~as4vers = 0
*        WHERE cdpos~tabname IN @gs_range-tables_e
*        AND   mara~matnr    IN @gs_range-matnr
*        AND   mtart         IN @gs_range-mtart
*        AND   udate         IN @gs_range-udate
*        AND   username      IN @gs_range-username
*        AND   marc~werks    IN @gs_range-werks
**        AND   lgort         IN @gs_range-lgort
*        AND   spart         IN @gs_range-spart
**        AND   mbew~bwtar    IN @gs_range-bwtar
*        AND   utime         IN @gs_range-utime
*        AND   maktx         IN @gs_range-maktx
*        AND   fname         IN @gs_range-fname
*        AND   chngind       IN @gs_range-chngind
*        AND   value_new     IN @gs_range-value_new
*        AND   value_old     IN @gs_range-value_old
*        AND   dd04t~ddtext  IN @gs_range-ddtext
*        AND   mara~vpsta    IN @gs_range-vpsta
*        APPENDING CORRESPONDING FIELDS OF TABLE @lt_tables.
*
*      SELECT DISTINCT mara~matnr AS product, mara~mtart, mara~spart,
*              marc~werks,
**              mard~lgort,
**              mbew~bwtar,
*              makt~maktx,
*              cdhdr~udate, cdhdr~utime, cdhdr~username,
*              cdpos~tabkey, cdpos~tabname, cdpos~fname,
*              cdpos~chngind, cdpos~value_new, cdpos~value_old,
*              i_changedocchangeindt~text AS chngindtxt,
*              dd04t~ddtext
*             FROM mara
*             LEFT OUTER JOIN   marc  ON mara~matnr = marc~matnr
*             LEFT OUTER JOIN   makt  ON mara~matnr = makt~matnr  AND makt~spras = @sy-langu
**             LEFT OUTER JOIN   mbew  ON mara~matnr = mbew~matnr  AND marc~werks = mbew~bwkey
**             LEFT OUTER JOIN   mard  ON mara~matnr = mard~matnr  AND marc~werks = mard~werks
**             LEFT OUTER JOIN ztmm_paletizacao AS palet ON palet~material = mara~matnr AND palet~centro = marc~werks
*             LEFT OUTER JOIN   cdhdr ON  cdhdr~objectclas = 'MATERIAL' AND mara~matnr = cdhdr~objectid
*             LEFT OUTER JOIN   zi_mm_cdpos_marc_mat AS cdpos ON cdpos~objectclas = cdhdr~objectclas
*                                                            AND cdpos~objectid = cdhdr~objectid
*                                                            AND cdpos~changenr = cdhdr~changenr
*                                                            AND cdpos~matnr    = mara~matnr
*                                                            AND cdpos~werks    = marc~werks
*                                                            AND  ( cdpos~fname <> 'DISGR' AND cdpos~fname <> 'MAABC' AND cdpos~fname <> 'DISMM' AND cdpos~fname <> 'MINBE'  AND cdpos~fname <> 'FXHOR'
*                                                               AND cdpos~fname <> 'LFRHY' AND cdpos~fname <> 'DISPO' AND cdpos~fname <> 'DISLS' AND cdpos~fname <> 'BSTMI'  AND cdpos~fname <> 'BSTMA'
*                                                               AND cdpos~fname <> 'BSTFE' AND cdpos~fname <> 'MABST' AND cdpos~fname <> 'AUSSS' AND cdpos~fname <> 'TAKZT'  AND cdpos~fname <> 'RDPRF'
*                                                               AND cdpos~fname <> 'BSTRF' AND cdpos~fname <> 'BESKZ' AND cdpos~fname <> 'SOBSL' AND cdpos~fname <> 'RGEKZ'  AND cdpos~fname <> 'VSPVB'
*                                                               AND cdpos~fname <> 'FABKZ' AND cdpos~fname <> 'LGFSB' AND cdpos~fname <> 'KZKUP' AND cdpos~fname <> 'SCHGT'  AND cdpos~fname <> 'EPRIO'
*                                                               AND cdpos~fname <> 'PLIFZ' AND cdpos~fname <> 'FHORI' AND cdpos~fname <> 'MRPPP' AND cdpos~fname <> 'EISBE'  AND cdpos~fname <> 'EISLO'
*                                                               AND cdpos~fname <> 'RWPRO' AND cdpos~fname <> 'SHFLG' AND cdpos~fname <> 'SHZET' AND cdpos~fname <> 'PERKZ'  AND cdpos~fname <> 'PERIV'
*                                                               AND cdpos~fname <> 'AUFTL' AND cdpos~fname <> 'AUTRU' AND cdpos~fname <> 'KZKFK' AND cdpos~fname <> 'STRGR'  AND cdpos~fname <> 'VRMOD'
*                                                               AND cdpos~fname <> 'VINT1' AND cdpos~fname <> 'VINT2' AND cdpos~fname <> 'MISKZ' AND cdpos~fname <> 'PRGRP'  AND cdpos~fname <> 'PRWRK'
*                                                               AND cdpos~fname <> 'UMREF' AND cdpos~fname <> 'WZEIT' AND cdpos~fname <> 'KZPSP' AND cdpos~fname <> 'ALTSL'  AND cdpos~fname <> 'SBDKZ'
*                                                               AND cdpos~fname <> 'KAUSF' AND cdpos~fname <> 'KZBED' AND cdpos~fname <> 'AHDIS' AND cdpos~fname <> 'KZAUS'  AND cdpos~fname <> 'AUSDT'
*                                                               AND cdpos~fname <> 'NFMAT' AND cdpos~fname <> 'SAUFT' AND cdpos~fname <> 'SFEPR' AND cdpos~fname <> 'FRTME'  AND cdpos~fname <> 'SFCPF'
*                                                               AND cdpos~fname <> 'FEVOR' AND cdpos~fname <> 'UEETO' AND cdpos~fname <> 'UEETK' AND cdpos~fname <> 'UNETO'  AND cdpos~fname <> 'BEARZ'
*                                                               AND cdpos~fname <> 'RUEZT' AND cdpos~fname <> 'TRANZ' AND cdpos~fname <> 'DZEIT' AND cdpos~fname <> 'BASMG'  AND cdpos~fname <> 'MAXLZ'
*                                                               AND cdpos~fname <> 'LZEIH' AND cdpos~fname <> 'XMCNG' AND cdpos~fname <> 'MMSTD' AND cdpos~fname <> 'KZECH'  AND cdpos~fname <> 'STDPD'
*                                                               AND cdpos~fname <> 'XLTYP' AND cdpos~fname <> 'XVPLB'
*
*                                                                    AND cdpos~fname <> 'QMATA'    AND cdpos~fname <> 'QMATV'      AND cdpos~fname <> 'INSMK'
*                                                                    AND cdpos~fname <> 'KZDKZ'    AND cdpos~fname <> 'RBNRM'      AND cdpos~fname <> 'WEBAZ' AND cdpos~fname <> 'PRFRQ'
*                                                                    AND cdpos~fname <> 'MMSTA'    AND cdpos~fname <> 'MMSTD'      AND cdpos~fname <> 'QMPUR' AND cdpos~fname <> 'SSQSS'
*                                                                    AND cdpos~fname <> 'QZGTP'    AND cdpos~fname <> 'QSSYS'      AND cdpos~fname <> 'ART'   AND cdpos~fname <> 'APA'
*                                                                    AND cdpos~fname <> 'AKTIV'    AND cdpos~fname <> 'STICHPRVER' AND cdpos~fname <> 'EIN'   AND cdpos~fname <> 'HPZ'
*                                                                    AND cdpos~fname <> 'MPDAU'    AND cdpos~fname <> 'SPEZUEBER'  AND cdpos~fname <> 'SPROZ' AND cdpos~fname <> 'QKZVERF'
*                                                                    AND cdpos~fname <> 'PPL'      AND cdpos~fname <> 'MST'        AND cdpos~fname <> 'QPMAT' AND cdpos~fname <> 'MPB'
*                                                                    AND cdpos~fname <> 'DYNREGEL' AND cdpos~fname <> 'KZPRFKOST'  AND cdpos~fname <> 'APP'   AND cdpos~fname <> 'DYN'
*                                                                    AND cdpos~fname <> 'AUFNR_CO' AND cdpos~fname <> 'MER'        AND cdpos~fname <> 'AVE'   AND cdpos~fname <> 'KEY'  )
**                                                               AND
**                                                                ( cdpos~fname =  'AUSME' OR cdpos~fname = 'GROUP' OR cdpos~fname = 'XCHPF' OR cdpos~fname =  'SERNP' OR cdpos~fname =  'MMSTA'
**                                                               OR cdpos~fname =  'MMSTD' OR cdpos~fname = 'MTVFP' OR cdpos~fname = 'KZECH' OR cdpos~fname =  'KZKRI' OR cdpos~fname =  'WEBAZ'
**                                                               OR cdpos~fname =  'LGPRO' OR cdpos~fname = 'INSMK' )
*             INNER JOIN        dd02l ON dd02l~tabname = cdpos~tabname AND as4local = 'A' AND as4vers = 0
*             LEFT OUTER JOIN   i_changedocchangeindt ON i_changedocchangeindt~value = cdpos~chngind AND i_changedocchangeindt~language = @sy-langu
*             LEFT OUTER JOIN   dd03l ON dd03l~tabname = cdpos~tabname AND dd03l~fieldname = cdpos~fname
*             LEFT OUTER JOIN   dd04t ON dd04t~rollname = dd03l~rollname AND dd04t~ddlanguage = @sy-langu AND dd04t~as4local = 'A' AND dd04t~as4vers = 0
*        WHERE cdpos~tabname IN @gs_range-tables_e_key
*        AND   mara~matnr    IN @gs_range-matnr
*        AND   mtart         IN @gs_range-mtart
*        AND   udate         IN @gs_range-udate
*        AND   username      IN @gs_range-username
*        AND   marc~werks    IN @gs_range-werks
**        AND   lgort         IN @gs_range-lgort
*        AND   spart         IN @gs_range-spart
**        AND   mbew~bwtar    IN @gs_range-bwtar
*        AND   utime         IN @gs_range-utime
*        AND   maktx         IN @gs_range-maktx
*        AND   fname         IN @gs_range-fname
*        AND   chngind       IN @gs_range-chngind
*        AND   value_new     IN @gs_range-value_new
*        AND   value_old     IN @gs_range-value_old
*        AND   dd04t~ddtext  IN @gs_range-ddtext
*        AND   mara~vpsta    IN @gs_range-vpsta
*        APPENDING CORRESPONDING FIELDS OF TABLE @lt_tables.
*
*    ENDIF.
*
*    IF line_exists( gs_range-vpsta[ low = '*B*' ] ).     "#EC CI_STDSEQ
**    OR line_exists( gs_range-vpsta[ low = 'D' ] ).       "#EC CI_STDSEQ
*
*      SELECT DISTINCT mara~matnr AS product, mara~mtart, mara~spart,
**              marc~werks,
**              mard~lgort,
*              mbew~bwtar,
*              makt~maktx,
*              cdhdr~udate, cdhdr~utime, cdhdr~username,
*              cdpos~tabkey, cdpos~tabname, cdpos~fname,
*              cdpos~chngind, cdpos~value_new, cdpos~value_old,
*              i_changedocchangeindt~text AS chngindtxt,
*              dd04t~ddtext
*             FROM mara
**             LEFT OUTER JOIN   marc  ON mara~matnr = marc~matnr
*             LEFT OUTER JOIN   makt  ON mara~matnr = makt~matnr  AND makt~spras = @sy-langu
*             LEFT OUTER JOIN   mbew  ON mara~matnr = mbew~matnr  "AND marc~werks = mbew~bwkey
**             LEFT OUTER JOIN   mard  ON mara~matnr = mard~matnr  AND marc~werks = mard~werks
*             LEFT OUTER JOIN   cdhdr ON  cdhdr~objectclas = 'MATERIAL' AND mara~matnr = cdhdr~objectid
*             LEFT OUTER JOIN   cdpos ON cdpos~objectclas = cdhdr~objectclas AND cdpos~objectid = cdhdr~objectid AND cdpos~changenr = cdhdr~changenr
**             LEFT OUTER JOIN   zi_mm_cdpos_mard_mat AS cdpos ON cdpos~objectclas = cdhdr~objectclas
**                                                            AND cdpos~objectid = cdhdr~objectid
**                                                            AND cdpos~changenr = cdhdr~changenr
**                                                            AND cdpos~matnr    = mara~matnr
*                                                            "AND cdpos~werks    = marc~werks
*                                                            "AND cdpos~lgort    = mard~lgort
*             INNER JOIN        dd02l ON dd02l~tabname = cdpos~tabname AND as4local = 'A' AND as4vers = 0
*             LEFT OUTER JOIN   i_changedocchangeindt ON i_changedocchangeindt~value = cdpos~chngind AND i_changedocchangeindt~language = @sy-langu
*             LEFT OUTER JOIN   dd03l ON dd03l~tabname = cdpos~tabname AND dd03l~fieldname = cdpos~fname
*             LEFT OUTER JOIN   dd04t ON dd04t~rollname = dd03l~rollname AND dd04t~ddlanguage = @sy-langu AND dd04t~as4local = 'A' AND dd04t~as4vers = 0
*        WHERE cdpos~tabname IN @gs_range-tables_b
*        AND   mara~matnr    IN @gs_range-matnr
*        AND   mtart         IN @gs_range-mtart
*        AND   udate         IN @gs_range-udate
*        AND   username      IN @gs_range-username
**        AND   marc~werks    IN @gs_range-werks
**        AND   mard~lgort    IN @gs_range-lgort
*        AND   spart         IN @gs_range-spart
*        AND   mbew~bwtar    IN @gs_range-bwtar
*        AND   utime         IN @gs_range-utime
*        AND   maktx         IN @gs_range-maktx
*        AND   fname         IN @gs_range-fname
*        AND   chngind       IN @gs_range-chngind
*        AND   value_new     IN @gs_range-value_new
*        AND   value_old     IN @gs_range-value_old
*        AND   dd04t~ddtext  IN @gs_range-ddtext
*        AND   mara~vpsta    IN @gs_range-vpsta
*        APPENDING CORRESPONDING FIELDS OF TABLE @lt_tables.
*
*    ENDIF.
*
*    IF line_exists( gs_range-vpsta[ low = '*C*' ] ).     "#EC CI_STDSEQ
*      SELECT DISTINCT mara~matnr AS product, mara~mtart, mara~spart,
*              marc~werks,
*              mard~lgort,
*              mbew~bwtar,
*              makt~maktx,
*              cdhdr~udate, cdhdr~utime, cdhdr~username,
*              cdpos~tabkey, cdpos~tabname, cdpos~fname,
*              cdpos~chngind, cdpos~value_new, cdpos~value_old,
*              i_changedocchangeindt~text AS chngindtxt,
*              dd04t~ddtext
*             FROM mara
*             LEFT OUTER JOIN   marc  ON mara~matnr = marc~matnr
*             LEFT OUTER JOIN   makt  ON mara~matnr = makt~matnr  AND makt~spras = @sy-langu
*             LEFT OUTER JOIN   mbew  ON mara~matnr = mbew~matnr  AND marc~werks = mbew~bwkey
*             LEFT OUTER JOIN   mard  ON mara~matnr = mard~matnr  AND marc~werks = mard~werks
*
*             LEFT OUTER JOIN   inob  ON mara~matnr = inob~objek AND ( klart = '001' OR klart = '023' )
*             LEFT OUTER JOIN   kssk  ON inob~cuobj = kssk~objek AND kssk~klart = inob~klart AND kssk~mafid = 'O'
*             LEFT OUTER JOIN   cdhdr ON cdhdr~objectclas = 'CLASSIFY' AND cdhdr~objectid = concat( kssk~objek, kssk~mafid )
*
*             LEFT OUTER JOIN   cdpos ON cdpos~objectclas = cdhdr~objectclas AND cdpos~objectid = cdhdr~objectid AND cdpos~changenr = cdhdr~changenr
*             INNER JOIN        dd02l ON dd02l~tabname = cdpos~tabname AND as4local = 'A' AND as4vers = 0
*             LEFT OUTER JOIN   i_changedocchangeindt ON i_changedocchangeindt~value = cdpos~chngind AND i_changedocchangeindt~language = @sy-langu
*             LEFT OUTER JOIN   dd03l ON dd03l~tabname = cdpos~tabname AND dd03l~fieldname = cdpos~fname
*             LEFT OUTER JOIN   dd04t ON dd04t~rollname = dd03l~rollname AND dd04t~ddlanguage = @sy-langu AND dd04t~as4local = 'A' AND dd04t~as4vers = 0
*        WHERE cdpos~tabname IN @gs_range-tables_c
*        AND   mara~matnr    IN @gs_range-matnr
*        AND   mtart         IN @gs_range-mtart
*        AND   udate         IN @gs_range-udate
*        AND   username      IN @gs_range-username
*        AND   marc~werks    IN @gs_range-werks
*        AND   lgort         IN @gs_range-lgort
*        AND   spart         IN @gs_range-spart
*        AND   mbew~bwtar    IN @gs_range-bwtar
*        AND   utime         IN @gs_range-utime
*        AND   maktx         IN @gs_range-maktx
*        AND   fname         IN @gs_range-fname
*        AND   chngind       IN @gs_range-chngind
*        AND   value_new     IN @gs_range-value_new
*        AND   value_old     IN @gs_range-value_old
*        AND   dd04t~ddtext  IN @gs_range-ddtext
*        AND   mara~vpsta    IN @gs_range-vpsta
*        INTO CORRESPONDING FIELDS OF TABLE @lt_classif.
*
*    ENDIF.
*
*    IF lt_vendas IS NOT INITIAL.
*      lt_relat = CORRESPONDING #( lt_vendas ).
*    ENDIF.
*
*    IF lt_tables IS NOT INITIAL AND lt_relat IS NOT INITIAL.
*      LOOP AT lt_tables ASSIGNING FIELD-SYMBOL(<fs_tables>).
**        MOVE-CORRESPONDING <fs_tables> TO ls_relat.
*        APPEND <fs_tables> TO lt_relat.
*      ENDLOOP.
*    ELSEIF lt_tables IS NOT INITIAL AND lt_relat IS INITIAL.
*      lt_relat = CORRESPONDING #( lt_tables ).
*    ENDIF.
*
*    IF lt_classif IS NOT INITIAL AND lt_relat IS NOT INITIAL.
*      LOOP AT lt_classif ASSIGNING FIELD-SYMBOL(<fs_classif>).
**        MOVE-CORRESPONDING <fs_classif> TO ls_relat.
*        APPEND <fs_classif> TO lt_relat.
*      ENDLOOP.
*    ELSEIF lt_classif IS NOT INITIAL AND lt_relat IS INITIAL.
*      lt_relat = CORRESPONDING #( lt_classif ).
*    ENDIF.
*
*    IF lt_relat IS NOT INITIAL.
*      SELECT concat( 'D',tabname ) AS tabname,
*             ddtext
*        FROM dd02t
*        WHERE tabname    IN ( 'MARM','MLAN','MAKT','MEAN','MKAL','QMAT' )
*          AND ddlanguage EQ @sy-langu
*          AND as4local   EQ 'A'
*          AND as4vers    EQ 0
*        INTO TABLE @DATA(lt_tab_texts).
*
*      SELECT tabname,
*             ddtext
*        FROM dd02t
*        WHERE tabname    IN ( 'MARA','MARC','MARD','MBEW','MPOP','MVKE' )
*          AND ddlanguage EQ @sy-langu
*          AND as4local   EQ 'A'
*          AND as4vers    EQ 0
*        APPENDING CORRESPONDING FIELDS OF TABLE @lt_tab_texts.
*      SORT lt_tab_texts BY tabname.
*
*      LOOP AT lt_relat ASSIGNING FIELD-SYMBOL(<fs_result>).
*        CASE <fs_result>-fname.
*
*          WHEN 'KEY'.
*            READ TABLE lt_tab_texts ASSIGNING FIELD-SYMBOL(<fs_tab_texts>)
*              WITH KEY tabname = <fs_result>-tabname BINARY SEARCH.
*            IF sy-subrc EQ 0.
*              <fs_result>-ddtext = <fs_tab_texts>-ddtext.
*            ENDIF.
*
*            CASE <fs_result>-tabname.
*              WHEN 'DMARM'.
*
*                CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
*                  EXPORTING
*                    input          = <fs_result>-tabkey
*                  IMPORTING
*                    output         = lv_unit
*                  EXCEPTIONS
*                    unit_not_found = 1
*                    OTHERS         = 2.
*                IF sy-subrc EQ 0.
*                  IF <fs_result>-chngind EQ'I'.
*                    <fs_result>-value_new = lv_unit.
*                  ELSE.
*                    <fs_result>-value_old = lv_unit.
*                  ENDIF.
*                ENDIF.
*
*              WHEN OTHERS.
*
*                IF <fs_result>-chngind EQ'I'.
*                  <fs_result>-value_new = <fs_result>-tabkey.
*                ELSE.
*                  <fs_result>-value_old = <fs_result>-tabkey.
*                ENDIF.
*
*            ENDCASE.
*
**          WHEN 'UMREZ'.
**
**            <fs_result>-value_old = me->conv_num_to_extenso( <fs_result>-value_old ).
**            <fs_result>-value_new = me->conv_num_to_extenso( <fs_result>-value_new ).
*        ENDCASE.
*      ENDLOOP.
*
**      DATA lt_teste TYPE ty_relat.
**
**      lt_teste = CORRESPONDING #( lt_relat ).
**
**      SORT lt_teste BY table_line.
**      DELETE ADJACENT DUPLICATES FROM lt_teste COMPARING table_line.
*      rt_relat = CORRESPONDING #( lt_relat ).
*
*      SORT rt_relat BY table_line.
*      DELETE ADJACENT DUPLICATES FROM rt_relat COMPARING table_line.
*    ENDIF.
    RETURN.
  ENDMETHOD.


  METHOD conv_num_to_extenso.
    DATA ls_spell TYPE spell.

    CALL FUNCTION 'SPELL_AMOUNT'
      EXPORTING
        amount    = iv_num
      IMPORTING
        in_words  = ls_spell
      EXCEPTIONS
        not_found = 1
        too_large = 2
        OTHERS    = 3.

    IF sy-subrc = 0.
      rv_word = ls_spell-word.
    ENDIF.
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

    IF me->gs_range-werks IS NOT INITIAL.
      DELETE me->gs_range-werks WHERE low  NOT IN lr_auth_werks
                                  AND low  IS NOT INITIAL. "#EC CI_STDSEQ
      DELETE me->gs_range-werks WHERE high NOT IN lr_auth_werks
                                  AND high IS NOT INITIAL. "#EC CI_STDSEQ
    ELSE.
      me->gs_range-werks = lr_auth_werks.
    ENDIF.
  ENDMETHOD.


ENDCLASS.
