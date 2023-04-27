CLASS zclmm_estoque_classificado DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_filter .
    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.

    TYPES:

      BEGIN OF ty_filters,
        material         TYPE if_rap_query_filter=>tt_range_option,
        plant            TYPE if_rap_query_filter=>tt_range_option,
        storagelocation  TYPE if_rap_query_filter=>tt_range_option,
        batch            TYPE if_rap_query_filter=>tt_range_option,
        ordem            TYPE if_rap_query_filter=>tt_range_option,
        "Status           TYPE if_rap_query_filter=>tt_range_option,
        options          TYPE if_rap_query_filter=>tt_range_option,
        "BatchManagement  TYPE if_rap_query_filter=>tt_range_option,
        materialbaseunit TYPE if_rap_query_filter=>tt_range_option,
        documentno       TYPE if_rap_query_filter=>tt_range_option,
      END OF ty_filters,

      "Tipo de retorno de dados à custom entity
      ty_relat TYPE STANDARD TABLE OF zc_mm_rep_estoque_classificado WITH DEFAULT KEY.

    DATA:
      "! Estrutura com ranges
      gs_range TYPE ty_filters.
  PRIVATE SECTION.

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

ENDCLASS.



CLASS zclmm_estoque_classificado IMPLEMENTATION.


  METHOD build.

    DATA lt_val_tab TYPE TABLE OF api_vali.

    DATA:
      lv_perc     TYPE ze_fscm_percent,
      lv_perc_aux TYPE p DECIMALS 5,
*           lv_perc   TYPE prz21,
      lv_qtd      TYPE bstmg,
      lv_string   TYPE string,
      lv_int      TYPE i,
      lv_qtd2     TYPE prz21.

    CONSTANTS: lc_param_doc TYPE ihttpnam VALUE 'Documentno',
               lc_param_rom TYPE ihttpnam VALUE 'Romaneio',
               lc_object_1  TYPE char30   VALUE 'apropriacaograos',
               lc_action_1  TYPE char60   VALUE 'create',
               lc_object_2  TYPE char30   VALUE 'arm_cafe',
               lc_action_2  TYPE char60   VALUE 'manage'.

    DATA(lt_parameters) = VALUE tihttpnvp( ).

    DATA(lt_options) = gs_range-options.
    READ TABLE lt_options ASSIGNING FIELD-SYMBOL(<fs_option>) INDEX 1.
    IF sy-subrc IS INITIAL.
      IF <fs_option>-low = 'T'.
        gs_range-options = VALUE #(
         ( sign = 'I'
          option = 'EQ'
          low = 'L' )
          ( sign = 'I'
          option = 'EQ'
          low = 'O' )
        ).
      ENDIF.
      IF <fs_option>-low EQ 'O' OR <fs_option>-low = 'T'.

        "SELECT Material, Plant, StorageLocation, Batch, Ordem, Status, StatusTxt, BatchManagement, Options, TotalOrdem, Meins AS MaterialBaseUnit, Documentno
        SELECT a~material,
               a~plant,
               a~storagelocation,
               a~batch,
*               ordem,
               a~options,
               a~totalordem,
               a~meins AS materialbaseunit,
               a~documentno,
               b~matlwrhsstkqtyinmatlbaseunit
          FROM zc_mm_relatorio_ordem AS a
          INNER JOIN zi_mm_stock_calc_total  AS b ON a~material = b~material
                                           AND a~plant = b~plant
                                           AND a~storagelocation = b~storagelocation
                                           AND a~batch = b~batch
         WHERE a~material        IN @gs_range-material
           AND a~plant           IN @gs_range-plant
           AND a~storagelocation IN @gs_range-storagelocation
           AND a~batch           IN @gs_range-batch
*           AND ordem           IN @gs_range-ordem
            "AND Status          IN @gs_range-status
            "AND BatchManagement IN @gs_range-batchmanagement
           AND a~options         IN @gs_range-options
           AND a~documentno      IN @gs_range-documentno
          INTO TABLE @DATA(lt_relat_lote_1).

        IF sy-subrc IS INITIAL.
          LOOP AT lt_relat_lote_1 ASSIGNING FIELD-SYMBOL(<fs_lotes_1>).

            et_relat = VALUE #( BASE et_relat ( material         = <fs_lotes_1>-material
                                                plant            = <fs_lotes_1>-plant
                                                storagelocation  = <fs_lotes_1>-storagelocation
                                                batch            = <fs_lotes_1>-batch
*                                            ordem            =
                                                options          = 'L'
                                                totalordem       = <fs_lotes_1>-matlwrhsstkqtyinmatlbaseunit
                                                materialbaseunit = 'KG'
                                                documentno       = <fs_lotes_1>-documentno ) ).

          ENDLOOP.
        ENDIF.
      ENDIF.
      IF <fs_option>-low EQ 'L' OR <fs_option>-low = 'T'.

        SELECT a~romaneio,
               a~matnr,
               a~werks,
               a~lgort,
               b~charg,
*               b~qtde
               c~matlwrhsstkqtyinmatlbaseunit
          FROM zi_mm_romaneio_compl AS a
         INNER JOIN ztmm_romaneio_lo AS b ON a~docuuidh = b~doc_uuid_h
         INNER JOIN zi_mm_stock_calc_total  AS c ON a~matnr = c~material
                                           AND a~werks = c~plant
                                           AND a~lgort = c~storagelocation
                                           AND b~charg = c~batch
         WHERE a~matnr  IN @gs_range-material
           AND a~werks  IN @gs_range-plant
           AND a~lgort  IN @gs_range-storagelocation
           AND b~charg  IN @gs_range-batch
           AND romaneio IN @gs_range-documentno
          INTO TABLE @DATA(lt_relat_lote).

        IF sy-subrc IS INITIAL.
          LOOP AT lt_relat_lote ASSIGNING FIELD-SYMBOL(<fs_lotes>).

            et_relat = VALUE #( BASE et_relat ( material         = <fs_lotes>-matnr
                                                plant            = <fs_lotes>-werks
                                                storagelocation  = <fs_lotes>-lgort
                                                batch            = <fs_lotes>-charg
*                                            ordem            =
                                                options          = 'L'
                                                totalordem       = <fs_lotes>-matlwrhsstkqtyinmatlbaseunit
                                                materialbaseunit = 'KG'
                                                documentno       = <fs_lotes>-romaneio ) ).

          ENDLOOP.
        ENDIF.
      ENDIF.
      IF et_relat IS NOT INITIAL.

        SELECT DISTINCT mat~material,
                        mat~materialbaseunit,
                        mtext~materialname,
                        mat~materialgroup,
                        mgrp~materialgrouptext,
                        p~plant,
                        p~plantname,
                        s~storagelocation,
                        s~storagelocationname
          FROM i_material AS mat
         INNER JOIN i_materialtext AS mtext
                 ON mat~material = mtext~material
         INNER JOIN i_materialgrouptext AS mgrp
                 ON mat~materialgroup = mgrp~materialgroup
         INNER JOIN i_materialplant AS mp
                 ON mat~material = mp~material
         INNER JOIN i_plant AS p
                 ON mp~plant = p~plant
         INNER JOIN i_storagelocation AS s
                 ON p~plant = s~plant
           FOR ALL ENTRIES IN @et_relat
         WHERE mat~material      = @et_relat-material
           AND p~plant           = @et_relat-plant
           AND s~storagelocation = @et_relat-storagelocation
          INTO TABLE @DATA(lt_data_add).

        SORT lt_data_add BY material ASCENDING
                            plant ASCENDING
                            storagelocation ASCENDING.

      ENDIF.
      LOOP AT et_relat ASSIGNING FIELD-SYMBOL(<fs_data>).

        <fs_data>-materialbaseunit = CONV meins( gs_range-materialbaseunit[ 1 ]-low ).

        CALL FUNCTION 'QC01_BATCH_VALUES_READ'
          EXPORTING
            i_val_matnr    = <fs_data>-material
            i_val_werks    = <fs_data>-plant
            i_val_charge   = <fs_data>-batch
          TABLES
            t_val_tab      = lt_val_tab
          EXCEPTIONS
            no_class       = 1
            internal_error = 2
            no_values      = 3
            no_chars       = 4
            OTHERS         = 5.
        IF sy-subrc <> 0.

        ENDIF.

*      SELECT SINGLE MaterialBaseUnit
*        FROM I_Material
*       WHERE material = @<fs_data>-Material
*        INTO @DATA(lv_meins).

        READ TABLE lt_data_add ASSIGNING FIELD-SYMBOL(<fs_data_add>)
                                             WITH KEY material        = <fs_data>-material
                                                      plant           = <fs_data>-plant
                                                      storagelocation = <fs_data>-storagelocation
                                                      BINARY SEARCH.
        IF sy-subrc EQ 0.

          DATA(lv_meins) = <fs_data_add>-materialbaseunit.

        ENDIF.

        CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
          EXPORTING
            i_matnr              = <fs_data>-material
            i_in_me              = lv_meins
            i_out_me             = <fs_data>-materialbaseunit
            i_menge              = <fs_data>-totalordem
          IMPORTING
            e_menge              = <fs_data>-quantidade
          EXCEPTIONS
            error_in_application = 1
            error                = 2
            OTHERS               = 3.

        "<fs_data>-Localizacao = |YGV_LOCAL1 YGV_LOCAL2 YGV_LOCAL3 YGV_LOCAL4|.

        LOOP AT lt_val_tab ASSIGNING FIELD-SYMBOL(<fs_val_tab>).

          CLEAR: lv_perc, lv_perc_aux, lv_qtd.

          IF <fs_val_tab>-atflv IS NOT INITIAL.
            TRY.
                lv_perc_aux = ( <fs_val_tab>-atflv / 100 ).
              CATCH cx_sy_conversion_overflow.
            ENDTRY.
          ENDIF.

          lv_qtd = ( lv_perc_aux * <fs_data>-quantidade ).


          CASE <fs_val_tab>-atnam.
            WHEN 'YGV_LOCAL1'.
              <fs_data>-localizacao = <fs_val_tab>-atwrt.

            WHEN 'YGV_LOCAL2'.
              <fs_data>-localizacao2 = <fs_val_tab>-atwrt.

            WHEN 'YGV_LOCAL3'.
              <fs_data>-localizacao3 = <fs_val_tab>-atwrt.

            WHEN 'YGV_LOCAL4'.
              <fs_data>-localizacao4 = <fs_val_tab>-atwrt.

            WHEN 'YGV_QTD_BAG'.
              <fs_data>-qtdbag = lv_qtd.
              "<fs_data>-QtdBag = <fs_val_tab>-atwtb.

            WHEN 'YGV_DEFEITO'.
              lv_perc = lv_perc_aux * 100.
              <fs_data>-defeitos = lv_perc.
*              <fs_data>-qtdedefeitos = lv_qtd.

              IF <fs_val_tab>-atwtb CS ','.
                lv_string = <fs_val_tab>-atwtb.
                TRANSLATE lv_string USING ',.'.
*                lv_int = lv_string.
              ELSE.
                lv_string = <fs_val_tab>-atwtb.
*                lv_int    = lv_string.
              ENDIF.

              <fs_data>-qtdedefeitos = lv_string.
              "<fs_data>-Defeitos = <fs_val_tab>-atwtb.
              "<fs_data>-QtdeDefeitos = <fs_val_tab>-atwtb * <fs_data>-Quantidade.

            WHEN 'YGV_IMPUREZAS'.
              lv_perc = lv_perc_aux * 100.
              <fs_data>-impurezas = lv_perc.
              <fs_data>-qtdeimpurezas = lv_qtd.
              "<fs_data>-Impurezas = <fs_val_tab>-atwtb.
              "<fs_data>-QtdeImpurezas = <fs_val_tab>-atwtb * <fs_data>-Quantidade.

            WHEN 'YGV_FUNDO'.
              lv_perc = lv_perc_aux * 100.
              <fs_data>-fundo = lv_perc.
              <fs_data>-qtdefundo = lv_qtd.
              "<fs_data>-Fundo = <fs_val_tab>-atwtb.
              "<fs_data>-QtdeFundo = <fs_val_tab>-atwtb * <fs_data>-Quantidade.

            WHEN 'YGV_VERDE'.
              lv_perc = lv_perc_aux * 100.
              <fs_data>-verde = lv_perc.
              <fs_data>-qtdeverde = lv_qtd.
              "<fs_data>-Verde = <fs_val_tab>-atwtb.
              "<fs_data>-QtdeVerde = <fs_val_tab>-atwtb * <fs_data>-Quantidade.

            WHEN 'YGV_PRETO-ARDIDO'.
              lv_perc = lv_perc_aux * 100.
              <fs_data>-pretoardido = lv_perc.
              <fs_data>-qtdepretoardido = lv_qtd.
              "<fs_data>-PretoArdido = <fs_val_tab>-atwtb.
              "<fs_data>-QtdePretoArdido = <fs_val_tab>-atwtb * <fs_data>-Quantidade.

            WHEN 'YGV_CATACAO'.
              lv_perc = lv_perc_aux * 100.
              <fs_data>-catacao     = lv_perc.
              <fs_data>-qtdecatacao = lv_qtd.
              "<fs_data>-Catacao = <fs_val_tab>-atwtb.
              "<fs_data>-QtdeCatacao = <fs_val_tab>-atwtb * <fs_data>-Quantidade.

            WHEN 'YGV_UMIDADE'.
              lv_perc = lv_perc_aux * 100.
              <fs_data>-umidade     = lv_perc.
              lv_qtd                = <fs_val_tab>-atflv.
              <fs_data>-qtdeumidade = lv_qtd.

*              <fs_data>-qtdeumidade = lv_qtd.
              "<fs_data>-Umidade = <fs_val_tab>-atwtb.
              "<fs_data>-QtdeUmidade = <fs_val_tab>-atwtb * <fs_data>-Quantidade.

            WHEN 'YGV_MK10'.
              lv_perc = lv_perc_aux * 100.
              <fs_data>-mk10     = lv_perc.
              <fs_data>-qtdemk10 = lv_qtd.
              "<fs_data>-mk10 = <fs_val_tab>-atwtb.
              "<fs_data>-QtdeMk10 = <fs_val_tab>-atwtb * <fs_data>-Quantidade.

            WHEN 'YGV_BROCADOS'.
              lv_perc = lv_perc_aux * 100.
              <fs_data>-brocados = lv_perc.
*              <fs_data>-qtdebrocados = lv_qtd.
              <fs_data>-qtdebrocados = <fs_val_tab>-atflv.
              "<fs_data>-Brocados = <fs_val_tab>-atwtb.
              "<fs_data>-QtdeBrocados = <fs_val_tab>-atwtb * <fs_data>-Quantidade.

            WHEN 'YGV_PALADAR'.
              lv_perc = lv_perc_aux * 100.
              <fs_data>-paladar = lv_perc.
*              <fs_data>-qtdepaladar = lv_qtd.
              <fs_data>-qtdepaladar = <fs_val_tab>-atwtb.
              "<fs_data>-Paladar = <fs_val_tab>-atwtb.
              "<fs_data>-QtdePaladar = <fs_val_tab>-atwtb * <fs_data>-Quantidade.

            WHEN 'YGV_SAFRA'.
              lv_perc = lv_perc_aux * 100.
              <fs_data>-safra = lv_perc.
*              <fs_data>-qtdesafra = lv_qtd.
              <fs_data>-qtdesafra = <fs_val_tab>-atwtb.
              "<fs_data>-Safra = <fs_val_tab>-atwtb.
              "<fs_data>-QtdeSafra = <fs_val_tab>-atwtb * <fs_data>-Quantidade.

            WHEN 'YGV_P19'.
              lv_perc = lv_perc_aux * 100.
              <fs_data>-peneira19 = lv_perc.
              <fs_data>-qtdpeneira19 = lv_qtd.
              "<fs_data>-Peneira19 = <fs_val_tab>-atwtb.
              "<fs_data>-QtdPeneira19 = <fs_val_tab>-atwtb * <fs_data>-Quantidade.

            WHEN 'YGV_P18'.
              lv_perc = lv_perc_aux * 100.
              <fs_data>-peneira18 = lv_perc.
              <fs_data>-qtdpeneira18 = lv_qtd.
              "<fs_data>-Peneira18 = <fs_val_tab>-atwtb.
              "<fs_data>-QtdPeneira18 = <fs_val_tab>-atwtb * <fs_data>-Quantidade.

            WHEN 'YGV_P17'.
              lv_perc = lv_perc_aux * 100.
              <fs_data>-peneira17 = lv_perc.
              <fs_data>-qtdpeneira17 = lv_qtd.
              "<fs_data>-Peneira17 = <fs_val_tab>-atwtb.
              "<fs_data>-QtdPeneira17 = <fs_val_tab>-atwtb * <fs_data>-Quantidade.

            WHEN 'YGV_P16'.
              lv_perc = lv_perc_aux * 100.
              <fs_data>-peneira16 = lv_perc.
              <fs_data>-qtdpeneira16 = lv_qtd.
              "<fs_data>-Peneira16 = <fs_val_tab>-atwtb.
              "<fs_data>-QtdPeneira16 = <fs_val_tab>-atwtb * <fs_data>-Quantidade.

            WHEN 'YGV_P15'.
              lv_perc = lv_perc_aux * 100.
              <fs_data>-peneira15 = lv_perc.
              <fs_data>-qtdpeneira15 = lv_qtd.
              "<fs_data>-Peneira15 = <fs_val_tab>-atwtb.
              "<fs_data>-QtdPeneira15 = <fs_val_tab>-atwtb * <fs_data>-Quantidade.

            WHEN 'YGV_P14'.
              lv_perc = lv_perc_aux * 100.
              <fs_data>-peneira14 = lv_perc.
              <fs_data>-qtdpeneira14 = lv_qtd.
              "<fs_data>-Peneira14 = <fs_val_tab>-atwtb.
              "<fs_data>-QtdPeneira14 = <fs_val_tab>-atwtb * <fs_data>-Quantidade.

            WHEN 'YGV_P13'.
              lv_perc = lv_perc_aux * 100.
              <fs_data>-peneira13 = lv_perc.
              <fs_data>-qtdpeneira13 = lv_qtd.
              "<fs_data>-Peneira13 = <fs_val_tab>-atwtb.
              "<fs_data>-QtdPeneira13 = <fs_val_tab>-atwtb * <fs_data>-Quantidade.

            WHEN 'YGV_P12'.
              lv_perc = lv_perc_aux * 100.
              <fs_data>-peneira12 = lv_perc.
              <fs_data>-qtdpeneira12 = lv_qtd.
              "<fs_data>-Peneira12 = <fs_val_tab>-atwtb.
              "<fs_data>-QtdPeneira12 = <fs_val_tab>-atwtb * <fs_data>-Quantidade.

            WHEN 'YGV_P11'.
              lv_perc = lv_perc_aux * 100.
              <fs_data>-peneira11 = lv_perc.
              <fs_data>-qtdpeneira11 = lv_qtd.
              "<fs_data>-Peneira11 = <fs_val_tab>-atwtb.
              "<fs_data>-QtdPeneira11 = <fs_val_tab>-atwtb * <fs_data>-Quantidade.

            WHEN 'YGV_P10'.
              lv_perc = lv_perc_aux * 100.
              <fs_data>-peneira10 = lv_perc.
              <fs_data>-qtdpeneira10 = lv_qtd.
              "<fs_data>-Peneira10 = <fs_val_tab>-atwtb.
              "<fs_data>-QtdPeneira10 = <fs_val_tab>-atwtb * <fs_data>-Quantidade.

            WHEN OTHERS.
          ENDCASE.
        ENDLOOP.

        IF <fs_data>-options EQ 'O'  OR <fs_option>-low = 'T'.
          APPEND VALUE #( name = lc_param_doc
                          value = <fs_data>-documentno ) TO lt_parameters.

          <fs_data>-url_guia = cl_lsapi_manager=>create_flp_url( object     = lc_object_1
                                                                 action     = lc_action_1
                                                                 parameters = lt_parameters ).
          FREE: lt_parameters[].
        ENDIF.
        IF <fs_data>-options EQ 'L' OR <fs_option>-low = 'T'.
          APPEND VALUE #( name = lc_param_rom
                          value = <fs_data>-documentno ) TO lt_parameters.

          <fs_data>-url_guia = cl_lsapi_manager=>create_flp_url( object     = lc_object_2
                                                                 action     = lc_action_2
                                                                 parameters = lt_parameters ).
          FREE: lt_parameters[].
        ENDIF.


        REFRESH: lt_val_tab.
        CLEAR: lv_meins.

      ENDLOOP.

*    TRY.
*        IF gs_range-batchmanagement[ 1 ]-low EQ abap_true.
*          DELETE et_relat WHERE Quantidade EQ 0.
*        ENDIF.
*      CATCH cx_root.
*    ENDTRY.

      IF <fs_option>-low EQ 'O' OR <fs_option>-low = 'T'.

*        LOOP AT et_relat ASSIGNING FIELD-SYMBOL(<fs_dados>)
*        GROUP BY ( ordem = <fs_dados>-ordem batch = <fs_dados>-batch size = GROUP SIZE ) INTO DATA(lt_group).
*
*          LOOP AT GROUP lt_group ASSIGNING FIELD-SYMBOL(<fs_group>).
*
**        SELECT SINGLE StorageLocationName, \_Plant-PlantName
**          FROM I_StorageLocation
**         WHERE StorageLocation = @<fs_data>-StorageLocation
**           AND Plant = @<fs_data>-Plant
**          INTO ( @<fs_group>-StorageLocationName, @<fs_group>-PlantName ).
*
*            READ TABLE lt_data_add ASSIGNING <fs_data_add> WITH KEY material = <fs_dados>-material plant = <fs_dados>-plant BINARY SEARCH.
*            IF sy-subrc EQ 0.
*
**              <fs_group>-storagelocationname = <fs_data_add>-storagelocationname.
*              <fs_group>-storagelocationname1 = <fs_data_add>-storagelocationname.
**              <fs_group>-plantname = <fs_data_add>-plantname.
*              <fs_group>-plantname1 = <fs_data_add>-plantname.
**              <fs_group>-materialtext = <fs_data_add>-materialname.
*              <fs_group>-materialtext1 = <fs_data_add>-materialname.
*              <fs_group>-materialgroup = <fs_data_add>-materialgroup.
**              <fs_group>-materialgrouptext = <fs_data_add>-materialgrouptext.
*              <fs_group>-materialgrouptext1 = <fs_data_add>-materialgrouptext.
*
*            ENDIF.
*
*
**        SELECT SINGLE \_Text-MaterialName, \_MaterialGroup-MaterialGroup, \_MaterialGroup\_Text-MaterialGroupText
**          FROM I_Material
**         WHERE Material = @<fs_data>-material
**           AND \_MaterialGroup\_Text-Language = @sy-langu
**          INTO ( @<fs_group>-MaterialText, @<fs_group>-MaterialGroup, @<fs_group>-MaterialGroupText ).
*            TRY .
**                <fs_group>-peneira10 = REDUCE #( INIT lv_sum TYPE atwtb FOR ls_data IN et_relat WHERE ( ordem = <fs_group>-ordem ) NEXT lv_sum = lv_sum + ls_data-peneira10 ) / lt_group-size.
**                <fs_group>-peneira11 = REDUCE #( INIT lv_sum TYPE atwtb FOR ls_data IN et_relat WHERE ( ordem = <fs_group>-ordem ) NEXT lv_sum = lv_sum + ls_data-peneira11 ) / lt_group-size.
**                <fs_group>-peneira12 = REDUCE #( INIT lv_sum TYPE atwtb FOR ls_data IN et_relat WHERE ( ordem = <fs_group>-ordem ) NEXT lv_sum = lv_sum + ls_data-peneira12 ) / lt_group-size.
**                <fs_group>-peneira13 = REDUCE #( INIT lv_sum TYPE atwtb FOR ls_data IN et_relat WHERE ( ordem = <fs_group>-ordem ) NEXT lv_sum = lv_sum + ls_data-peneira13 ) / lt_group-size.
**                <fs_group>-peneira14 = REDUCE #( INIT lv_sum TYPE atwtb FOR ls_data IN et_relat WHERE ( ordem = <fs_group>-ordem ) NEXT lv_sum = lv_sum + ls_data-peneira14 ) / lt_group-size.
**                <fs_group>-peneira15 = REDUCE #( INIT lv_sum TYPE atwtb FOR ls_data IN et_relat WHERE ( ordem = <fs_group>-ordem ) NEXT lv_sum = lv_sum + ls_data-peneira15 ) / lt_group-size.
**                <fs_group>-peneira16 = REDUCE #( INIT lv_sum TYPE atwtb FOR ls_data IN et_relat WHERE ( ordem = <fs_group>-ordem ) NEXT lv_sum = lv_sum + ls_data-peneira16 ) / lt_group-size.
**                <fs_group>-peneira17 = REDUCE #( INIT lv_sum TYPE atwtb FOR ls_data IN et_relat WHERE ( ordem = <fs_group>-ordem ) NEXT lv_sum = lv_sum + ls_data-peneira17 ) / lt_group-size.
**                <fs_group>-peneira18 = REDUCE #( INIT lv_sum TYPE atwtb FOR ls_data IN et_relat WHERE ( ordem = <fs_group>-ordem ) NEXT lv_sum = lv_sum + ls_data-peneira18 ) / lt_group-size.
**                <fs_group>-peneira19 = REDUCE #( INIT lv_sum TYPE atwtb FOR ls_data IN et_relat WHERE ( ordem = <fs_group>-ordem ) NEXT lv_sum = lv_sum + ls_data-peneira19 ) / lt_group-size.
*
*              CATCH cx_sy_arithmetic_overflow.
*
*            ENDTRY.
*          ENDLOOP.
*
*        ENDLOOP.

        LOOP AT et_relat ASSIGNING FIELD-SYMBOL(<fs_dados>).

          READ TABLE lt_data_add ASSIGNING <fs_data_add> WITH KEY material = <fs_dados>-material plant = <fs_dados>-plant BINARY SEARCH.
          IF sy-subrc EQ 0.

*              <fs_group>-storagelocationname = <fs_data_add>-storagelocationname.
            <fs_dados>-storagelocationname1 = <fs_data_add>-storagelocationname.
*              <fs_group>-plantname = <fs_data_add>-plantname.
            <fs_dados>-plantname1 = <fs_data_add>-plantname.
*              <fs_group>-materialtext = <fs_data_add>-materialname.
            <fs_dados>-materialtext1 = <fs_data_add>-materialname.
            <fs_dados>-materialgroup = <fs_data_add>-materialgroup.
*              <fs_group>-materialgrouptext = <fs_data_add>-materialgrouptext.
            <fs_dados>-materialgrouptext1 = <fs_data_add>-materialgrouptext.

          ENDIF.

        ENDLOOP.

      ELSE.

*        LOOP AT et_relat ASSIGNING FIELD-SYMBOL(<fs_dados2>)
*        GROUP BY ( documentno = <fs_dados2>-documentno batch = <fs_dados2>-batch size = GROUP SIZE ) INTO DATA(lt_group2).
*
*          LOOP AT GROUP lt_group2 ASSIGNING FIELD-SYMBOL(<fs_group2>).
*
*            READ TABLE lt_data_add ASSIGNING <fs_data_add> WITH KEY material = <fs_data>-material
*                                                                    plant    = <fs_data>-plant
*                                                                    BINARY SEARCH.
*            IF sy-subrc EQ 0.
*
**              <fs_group2>-storagelocationname = <fs_data_add>-storagelocationname.
*              <fs_group2>-storagelocationname1 = <fs_data_add>-storagelocationname.
**              <fs_group2>-plantname           = <fs_data_add>-plantname.
*              <fs_group2>-plantname1           = <fs_data_add>-plantname.
**              <fs_group2>-materialtext        = <fs_data_add>-materialname.
*              <fs_group2>-materialtext1        = <fs_data_add>-materialname.
*              <fs_group2>-materialgroup       = <fs_data_add>-materialgroup.
**              <fs_group2>-materialgrouptext   = <fs_data_add>-materialgrouptext.
*              <fs_group2>-materialgrouptext1   = <fs_data_add>-materialgrouptext.
*
*            ENDIF.
*
*            TRY .
**                <fs_group2>-peneira10 = REDUCE #( INIT lv_sum2 TYPE atwtb FOR ls_data IN et_relat WHERE ( documentno = <fs_group2>-documentno ) NEXT lv_sum2 = lv_sum2 + ls_data-peneira10 ) / lt_group2-size.
**                <fs_group2>-peneira11 = REDUCE #( INIT lv_sum2 TYPE atwtb FOR ls_data IN et_relat WHERE ( documentno = <fs_group2>-documentno ) NEXT lv_sum2 = lv_sum2 + ls_data-peneira11 ) / lt_group2-size.
**                <fs_group2>-peneira12 = REDUCE #( INIT lv_sum2 TYPE atwtb FOR ls_data IN et_relat WHERE ( documentno = <fs_group2>-documentno ) NEXT lv_sum2 = lv_sum2 + ls_data-peneira12 ) / lt_group2-size.
**                <fs_group2>-peneira13 = REDUCE #( INIT lv_sum2 TYPE atwtb FOR ls_data IN et_relat WHERE ( documentno = <fs_group2>-documentno ) NEXT lv_sum2 = lv_sum2 + ls_data-peneira13 ) / lt_group2-size.
**                <fs_group2>-peneira14 = REDUCE #( INIT lv_sum2 TYPE atwtb FOR ls_data IN et_relat WHERE ( documentno = <fs_group2>-documentno ) NEXT lv_sum2 = lv_sum2 + ls_data-peneira14 ) / lt_group2-size.
**                <fs_group2>-peneira15 = REDUCE #( INIT lv_sum2 TYPE atwtb FOR ls_data IN et_relat WHERE ( documentno = <fs_group2>-documentno ) NEXT lv_sum2 = lv_sum2 + ls_data-peneira15 ) / lt_group2-size.
**                <fs_group2>-peneira16 = REDUCE #( INIT lv_sum2 TYPE atwtb FOR ls_data IN et_relat WHERE ( documentno = <fs_group2>-documentno ) NEXT lv_sum2 = lv_sum2 + ls_data-peneira16 ) / lt_group2-size.
**                <fs_group2>-peneira17 = REDUCE #( INIT lv_sum2 TYPE atwtb FOR ls_data IN et_relat WHERE ( documentno = <fs_group2>-documentno ) NEXT lv_sum2 = lv_sum2 + ls_data-peneira17 ) / lt_group2-size.
**                <fs_group2>-peneira18 = REDUCE #( INIT lv_sum2 TYPE atwtb FOR ls_data IN et_relat WHERE ( documentno = <fs_group2>-documentno ) NEXT lv_sum2 = lv_sum2 + ls_data-peneira18 ) / lt_group2-size.
**                <fs_group2>-peneira19 = REDUCE #( INIT lv_sum2 TYPE atwtb FOR ls_data IN et_relat WHERE ( documentno = <fs_group2>-documentno ) NEXT lv_sum2 = lv_sum2 + ls_data-peneira19 ) / lt_group2-size.
*
*              CATCH cx_sy_arithmetic_overflow.
*
*            ENDTRY.
*          ENDLOOP.
*        ENDLOOP.

        LOOP AT et_relat ASSIGNING FIELD-SYMBOL(<fs_dados2>)
        GROUP BY ( documentno = <fs_dados2>-documentno batch = <fs_dados2>-batch size = GROUP SIZE ) INTO DATA(lt_group2).

          LOOP AT GROUP lt_group2 ASSIGNING FIELD-SYMBOL(<fs_group2>).

            READ TABLE lt_data_add ASSIGNING <fs_data_add> WITH KEY material = <fs_group2>-material
                                                                    plant    = <fs_group2>-plant
                                                                    BINARY SEARCH.
            IF sy-subrc EQ 0.

              <fs_group2>-storagelocationname1 = <fs_data_add>-storagelocationname.
              <fs_group2>-plantname1           = <fs_data_add>-plantname.
              <fs_group2>-materialtext1        = <fs_data_add>-materialname.
              <fs_group2>-materialgroup        = <fs_data_add>-materialgroup.
              <fs_group2>-materialgrouptext1   = <fs_data_add>-materialgrouptext.

            ENDIF.

          ENDLOOP.
        ENDLOOP.

      ENDIF.

    ENDIF.

    DELETE et_relat WHERE ordem EQ '000000000000'.
    DELETE et_relat WHERE totalordem LE 0.
    SORT   et_relat BY documentno material plant storagelocation batch.

  ENDMETHOD.


  METHOD if_rap_query_filter~get_as_ranges.
    RETURN.
  ENDMETHOD.


  METHOD if_rap_query_filter~get_as_sql_string.
    RETURN.
  ENDMETHOD.


  METHOD if_rap_query_provider~select.

    DATA lv_exp_msg TYPE string.

* ---------------------------------------------------------------------------
* Verifica se informação foi solicitada
* ---------------------------------------------------------------------------
    TRY.
        CHECK io_request->is_data_requested( ).
      CATCH cx_rfc_dest_provider_error  INTO DATA(lo_ex_dest).
        lv_exp_msg = lo_ex_dest->get_longtext( ).
        RETURN.
    ENDTRY.

* ---------------------------------------------------------------------------
* Recupera informações de entidade, paginação, etc
* ---------------------------------------------------------------------------
    DATA(lv_top)       = io_request->get_paging( )->get_page_size( ).
    DATA(lv_skip)      = io_request->get_paging( )->get_offset( ).
    DATA(lv_max_rows)  = COND #( WHEN lv_top = if_rap_query_paging=>page_size_unlimited THEN 0 ELSE lv_top ).

* ---------------------------------------------------------------------------
* Recupera e seta filtros de seleção
* ---------------------------------------------------------------------------
    TRY.
        me->set_filters( EXPORTING it_filters = io_request->get_filter( )->get_as_ranges( ) ).
      CATCH cx_rap_query_filter_no_range INTO DATA(lo_ex_filter).
        lv_exp_msg = lo_ex_filter->get_longtext( ).
    ENDTRY.

* ---------------------------------------------------------------------------
* Monta relatório
* ---------------------------------------------------------------------------

    DATA lt_result TYPE STANDARD TABLE OF zc_mm_rep_estoque_classificado.
    me->build( IMPORTING et_relat = lt_result ).

* ---------------------------------------------------------------------------
* Realiza ordenação de acordo com parâmetros de entrada
* ---------------------------------------------------------------------------
    DATA(lt_requested_sort) = io_request->get_sort_elements( ).
    IF lines( lt_requested_sort ) > 0.
      DATA(lt_sort) = VALUE abap_sortorder_tab( FOR ls_sort IN lt_requested_sort ( name = ls_sort-element_name descending = ls_sort-descending ) ).
      SORT lt_result BY (lt_sort).
    ELSE.
      DATA(lt_sot2) = VALUE abap_sortorder_tab( ( name = `primary key` descending = abap_false ) ).
      SORT lt_result BY (lt_sort).
    ENDIF.

** ---------------------------------------------------------------------------
** Realiza as agregações de acordo com as annotatios na custom entity
** ---------------------------------------------------------------------------
*    DATA(lt_req_elements) = io_request->get_requested_elements( ).
*
*    DATA(lt_aggr_element) = io_request->get_aggregation( )->get_aggregated_elements( ).
*    IF lt_aggr_element IS NOT INITIAL.
*      LOOP AT lt_aggr_element ASSIGNING FIELD-SYMBOL(<fs_aggr_element>).
*        DELETE lt_req_elements WHERE table_line = <fs_aggr_element>-result_element.
*        DATA(lv_aggregation) = |{ <fs_aggr_element>-aggregation_method }( { <fs_aggr_element>-input_element } ) as { <fs_aggr_element>-result_element }|.
*        APPEND lv_aggregation TO lt_req_elements.
*      ENDLOOP.
*    ENDIF.
*
*    DATA(lv_req_elements)  = concat_lines_of( table = lt_req_elements sep = ',' ).
*
*    DATA(lt_grouped_element) = io_request->get_aggregation( )->get_grouped_elements( ).
*    DATA(lv_grouping) = concat_lines_of(  table = lt_grouped_element sep = ',' ).
*
*    SELECT (lv_req_elements)
*      FROM @lt_result AS dados
*     GROUP BY (lv_grouping)
*     ORDER BY ('primary key')
*      INTO CORRESPONDING FIELDS OF TABLE @lt_result
*      ##db_feature_mode[itabs_in_from_clause].

* ---------------------------------------------------------------------------
* Controla paginação (Adiciona registros de 20 em 20 )
* ---------------------------------------------------------------------------
    DATA(lt_result_page) = lt_result[].
    lt_result_page = VALUE #( FOR ls_result IN lt_result FROM ( lv_skip + 1 ) TO ( lv_skip + lv_max_rows ) ( ls_result ) ).
* ---------------------------------------------------------------------------
* Exibe registros
* ---------------------------------------------------------------------------
    io_response->set_total_number_of_records( CONV #( lines( lt_result[] ) ) ).
    io_response->set_data( lt_result_page[] ).

  ENDMETHOD.


  METHOD set_filters.

    DATA lo_root TYPE REF TO cx_root.
    DATA lv_exp_msg TYPE string.

    TRY.
        gs_range-material = it_filters[ name = 'MATERIAL' ]-range.
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        gs_range-plant = it_filters[ name = 'PLANT' ]-range.
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        gs_range-storagelocation = it_filters[ name = 'STORAGELOCATION' ]-range.
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        gs_range-batch = it_filters[ name = 'BATCH' ]-range.
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        gs_range-ordem = it_filters[ name = 'ORDEM' ]-range.
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

*    TRY.
*        gs_range-status = it_filters[ name = 'STATUS' ]-range.
*      CATCH cx_root INTO lo_root.
*        lv_exp_msg = lo_root->get_longtext( ).
*    ENDTRY.

    TRY.
        gs_range-options = it_filters[ name = 'OPTIONS' ]-range.
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

*    TRY.
*        gs_range-batchmanagement = it_filters[ name = 'BATCHMANAGEMENT' ]-range.
*      CATCH cx_root INTO lo_root.
*        lv_exp_msg = lo_root->get_longtext( ).
*    ENDTRY.

    TRY.
        gs_range-materialbaseunit = it_filters[ name = 'MATERIALBASEUNIT' ]-range.
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        gs_range-documentno = it_filters[ name = 'DOCUMENTNO' ]-range.
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
