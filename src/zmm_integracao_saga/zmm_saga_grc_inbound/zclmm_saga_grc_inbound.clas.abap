CLASS zclmm_saga_grc_inbound DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS dados_trans
      IMPORTING
        !is_header TYPE /xnfe/innfehd.

    METHODS dados_pross
      IMPORTING
        !is_header TYPE /xnfe/innfehd
        !it_assign TYPE /xnfe/nfeassign_t.

  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS gc_f TYPE c VALUE 'F'.
    CONSTANTS gc_1 TYPE c VALUE '1'.
    CONSTANTS gc_0 TYPE c VALUE '0'.
    CONSTANTS gc_b TYPE c VALUE '/'.
    CONSTANTS gc_p TYPE c LENGTH 13 VALUE 'DEPOSITOS_WMS'.

    METHODS rmvzeros
      IMPORTING
                !iv_pomatnr      TYPE string
      RETURNING VALUE(rv_result) TYPE string.

ENDCLASS.



CLASS zclmm_saga_grc_inbound IMPLEMENTATION.


  METHOD dados_pross.

    DATA: lv_matnr TYPE  matnr,
          lv_menge TYPE  bstmg,
          lv_meins TYPE  meins.

    SELECT lifnr, stcd1
      FROM lfa1
      INTO TABLE @DATA(lt_lfa1)
      WHERE stcd1 = @is_header-cnpj_emit.

    IF sy-subrc IS INITIAL.

      DATA(ls_lfa1)   = lt_lfa1[ 1 ].
*      DATA(lv_fornec) = gc_f && ls_lfa1-lifnr.
      DATA(lv_numero) = is_header-nnf && gc_b && ls_lfa1-lifnr.


      IF  is_header-t1_cnpj IS INITIAL.

        DATA(lv_codigo) = gc_1.

      ELSE.

        SELECT lifnr, stcd1
          FROM lfa1
            INTO TABLE @DATA(lt_lfa1_aux)
         WHERE stcd1 = @is_header-t1_cnpj.

        IF sy-subrc IS INITIAL.

          DATA(ls_lfa1_aux) = lt_lfa1_aux[ 1 ].
          lv_codigo = gc_f && ls_lfa1_aux-lifnr.

        ENDIF.

      ENDIF.
    ENDIF.

    DATA(lt_assign) = it_assign[].
    SORT lt_assign BY ponumber poitem.
    DELETE ADJACENT DUPLICATES FROM lt_assign COMPARING ponumber poitem.

    IF lt_assign[] IS NOT INITIAL.

      SELECT ebeln, ebelp, werks, lgort
        FROM ekpo
        INTO TABLE @DATA(lt_ekpo)
        FOR ALL ENTRIES IN @lt_assign
        WHERE ebeln = @lt_assign-ponumber AND
              ebelp = @lt_assign-poitem.

      IF sy-subrc IS INITIAL.

        DATA(ls_ekpo) = lt_ekpo[ 1 ].

        DATA(lt_ekpo_aux) = lt_ekpo[].
        SORT lt_ekpo_aux BY werks.
        DELETE ADJACENT DUPLICATES FROM lt_ekpo_aux COMPARING werks.


        IF lt_ekpo_aux IS NOT INITIAL.

          SELECT werks, parametro, valor
            FROM  ztmm_saga_param
            INTO TABLE @DATA(lt_param)
            FOR ALL ENTRIES IN @lt_ekpo_aux
            WHERE werks     = @lt_ekpo_aux-werks AND
                  parametro = @gc_p.

          IF sy-subrc IS INITIAL.
            SORT lt_param BY werks.
          ENDIF.

          READ TABLE lt_param ASSIGNING FIELD-SYMBOL(<fs_param>) WITH KEY werks = ls_ekpo-werks
                                                                BINARY SEARCH.
          IF sy-subrc IS INITIAL.

            IF <fs_param>-valor CS ls_ekpo-lgort.

              DATA(ls_output) = VALUE zclmm_mt_processo_compra(
                          mt_processo_compra-cabecalho-centro              = ls_ekpo-werks
                          mt_processo_compra-cabecalho-fornec              = ls_lfa1-lifnr"lv_fornec
                          mt_processo_compra-cabecalho-numero              = lv_numero
                          mt_processo_compra-cabecalho-transportador       = lv_codigo
                          mt_processo_compra-cabecalho-numeroexterno       = is_header-nnf
                          mt_processo_compra-cabecalho-proprietario        = gc_1
                          mt_processo_compra-cabecalho-tipo                = gc_1
                          mt_processo_compra-cabecalho-atendimentoparcial  = gc_0
                          mt_processo_compra-cabecalho-recebimentosurpresa = gc_1
                          mt_processo_compra-cabecalho-deposito            = gc_1 ).

              LOOP AT it_assign ASSIGNING FIELD-SYMBOL(<fs_assing>).

                lv_matnr = <fs_assing>-pomatnr.
                lv_menge = <fs_assing>-poitquan.
                lv_meins = <fs_assing>-poituom.

                CALL FUNCTION 'ZWMS_FM_MENOR_QTDE_WMS'
                  EXPORTING
                    i_matnr = lv_matnr
                    i_menge = lv_menge
                    i_meins = lv_meins
                  IMPORTING
                    e_menge = lv_menge
                    e_meins = lv_meins.

                APPEND VALUE #( centro                  = ls_ekpo-werks
                                material                = rmvzeros( conv #( <fs_assing>-pomatnr ) )
                                descr_mat               = <fs_assing>-pomaktx
                                itmnum                  = <fs_assing>-nitem
                                numero                  = lv_numero
                                numeroexternosec        = is_header-nnf
                                proprietario            = gc_1
                                tipo                    = gc_1
                                valorembalagem          = gc_1
                                quantidade              = lv_menge )
                                TO ls_output-mt_processo_compra-itens.

                CLEAR:  lv_matnr,
                        lv_menge,
                        lv_meins.

              ENDLOOP.

              TRY.

                  NEW zclmm_co_si_enviar_processo_co( )->si_enviar_processo_compra_out( EXPORTING output = ls_output ).

                  IF sy-subrc EQ 0.
                    COMMIT WORK.
                  ENDIF.

                CATCH cx_root.
              ENDTRY.


            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD dados_trans.

    TYPES: BEGIN OF ty_ekpo,
             ebeln TYPE ekpo-ebeln,
             ebelp TYPE ekpo-ebelp,
           END OF ty_ekpo.

    DATA lv_matnr TYPE  matnr.
    DATA lv_menge TYPE  bstmg.
    DATA lv_meins TYPE  meins.
    DATA lt_ekpo_aux TYPE TABLE OF ty_ekpo.


    IF is_header-cnpj_emit(8) EQ is_header-cnpj_dest(8).

      SELECT lifnr, stcd1
        FROM lfa1
        INTO TABLE @DATA(lt_lfa1)
        WHERE stcd1 = @is_header-cnpj_emit.

      IF sy-subrc IS INITIAL.

        DATA(ls_lfa1) = lt_lfa1[ 1 ].
        DATA(lv_fornec) = gc_f && ls_lfa1-lifnr.
        DATA(lv_numero) = is_header-nnf && gc_b && ls_lfa1-lifnr.


        IF  is_header-t1_cnpj IS INITIAL.

          DATA(lv_codigo) = gc_1.

        ELSE.
          SELECT lifnr, stcd1
            FROM lfa1
      INTO TABLE @DATA(lt_lfa1_tl)
           WHERE stcd1 = @is_header-t1_cnpj.
          IF sy-subrc IS INITIAL.
            DATA(ls_lfa1_tl) = lt_lfa1_tl[ 1 ].
            lv_codigo = gc_f && ls_lfa1_tl-lifnr.
          ENDIF.
        ENDIF.


        DATA(lt_lfa1_aux) = lt_lfa1[].
        SORT lt_lfa1_aux BY lifnr.
        DELETE ADJACENT DUPLICATES FROM lt_lfa1_aux COMPARING lifnr.

        IF lt_lfa1_aux[] IS NOT INITIAL.

          SELECT docnum, nfnum9, parid
            FROM j_1bnfe_active
            INTO TABLE @DATA(lt_act)
            WHERE stcd1  = @is_header-cnpj_emit AND
                  nfnum9 = @is_header-nnf.
          IF sy-subrc IS INITIAL.

            DATA(lt_act_aux) = lt_act[].
            SORT lt_act_aux BY docnum.
            DELETE ADJACENT DUPLICATES FROM lt_act_aux COMPARING docnum.

            IF lt_act_aux[] IS NOT INITIAL.

              SELECT docnum, itmnum, matnr, menge, meins, maktx, xped, nitemped
                FROM j_1bnflin
                INTO TABLE @DATA(lt_lin)
                FOR ALL ENTRIES IN @lt_act_aux
                WHERE  docnum = @lt_act_aux-docnum.

              IF sy-subrc IS INITIAL.

                DATA(lt_lin_aux) = lt_lin[].
                SORT lt_lin_aux BY xped nitemped.
                DELETE ADJACENT DUPLICATES FROM lt_lin_aux COMPARING xped nitemped.

                LOOP AT lt_lin ASSIGNING FIELD-SYMBOL(<fs_lin_aux>).
                  APPEND INITIAL LINE TO lt_ekpo_aux ASSIGNING FIELD-SYMBOL(<fs_ekpo_aux>).
                  <fs_ekpo_aux>-ebeln  =  <fs_lin_aux>-xped.
                  <fs_ekpo_aux>-ebelp  =  <fs_lin_aux>-nitemped.
                ENDLOOP.

                IF lt_lin_aux[] IS NOT INITIAL.

                  SELECT ebeln, ebelp, werks, lgort
                    FROM  ekpo
                    INTO TABLE @DATA(lt_ekpo)
                    FOR ALL ENTRIES IN @lt_ekpo_aux
                    WHERE ebeln = @lt_ekpo_aux-ebeln  AND
                          ebelp = @lt_ekpo_aux-ebelp .

                  IF sy-subrc IS INITIAL.

                    DATA(ls_ekpo) = lt_ekpo[ 1 ].

                    DATA(lt_ekpo_aux2) = lt_ekpo[].
                    SORT lt_ekpo_aux2 BY lgort.
                    DELETE ADJACENT DUPLICATES FROM lt_ekpo_aux2 COMPARING lgort.

                    IF lt_ekpo_aux2[] IS NOT INITIAL.

                      SELECT werks, sglmtv, lgort
                        FROM ztmm_saga_depara
                        INTO TABLE @DATA(lt_depara)
                        FOR ALL ENTRIES IN @lt_ekpo_aux2
                        WHERE werks = @lt_ekpo_aux2-werks AND
                              lgort = @lt_ekpo_aux2-lgort.
                      IF sy-subrc IS INITIAL.
                        SORT lt_depara BY lgort.
                      ENDIF.

                    ENDIF.
                    DATA(lt_ekpo_aux3) = lt_ekpo[].
                    SORT lt_ekpo_aux3 BY werks.
                    DELETE ADJACENT DUPLICATES FROM lt_ekpo_aux3 COMPARING werks.

                    IF lt_ekpo_aux3[] IS NOT INITIAL.

                      SELECT werks, parametro, valor
                        FROM ztmm_saga_param
                        INTO TABLE @DATA(lt_param)
                        FOR ALL ENTRIES IN @lt_ekpo_aux3
                        WHERE werks     = @lt_ekpo_aux3-werks AND
                              parametro = @gc_p.
                      IF sy-subrc IS INITIAL.
                        SORT lt_param BY werks.
                      ENDIF.
                    ENDIF.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    READ TABLE lt_param ASSIGNING FIELD-SYMBOL(<fs_param>) WITH KEY werks = ls_ekpo-werks
                                                           BINARY SEARCH.
    IF sy-subrc IS INITIAL.

      IF <fs_param>-valor CS ls_ekpo-lgort.

        DATA(ls_output) = VALUE zclmm_mt_processo_compra(
                mt_processo_compra-cabecalho-centro              = ls_ekpo-werks
                mt_processo_compra-cabecalho-fornec              = lv_fornec
                mt_processo_compra-cabecalho-numero              = lv_numero
                mt_processo_compra-cabecalho-transportador       = lv_codigo
                mt_processo_compra-cabecalho-numeroexterno       = is_header-nnf
                mt_processo_compra-cabecalho-proprietario        = gc_1
                mt_processo_compra-cabecalho-tipo                = gc_1
                mt_processo_compra-cabecalho-atendimentoparcial  = gc_0
                mt_processo_compra-cabecalho-recebimentosurpresa = gc_1
                mt_processo_compra-cabecalho-deposito            = gc_1 ).

        LOOP AT lt_lin ASSIGNING FIELD-SYMBOL(<fs_lin>).

          READ TABLE lt_depara ASSIGNING FIELD-SYMBOL(<fs_depara>) WITH KEY lgort = ls_ekpo-lgort
                                                                  BINARY SEARCH.

          IF sy-subrc IS INITIAL.

            lv_matnr = <fs_lin>-matnr.
            lv_menge = <fs_lin>-menge.
            lv_meins = <fs_lin>-meins.

            CALL FUNCTION 'ZWMS_FM_MENOR_QTDE_WMS'
              EXPORTING
                i_matnr = lv_matnr
                i_menge = lv_menge
                i_meins = lv_meins
              IMPORTING
                e_menge = lv_menge
                e_meins = lv_meins.

            APPEND VALUE #( centro                  = ls_ekpo-werks
                            material                = rmvzeros( conv #( <fs_lin>-matnr ) )
                            descr_mat               = <fs_lin>-maktx
                            itmnum                  = <fs_lin>-itmnum
                            numero                  = lv_numero
                            numeroexternosec        = is_header-nnf
                            proprietario            = gc_1
                            tipo                    = gc_1
                            valorembalagem          = gc_1
                            cod_bloq                = <fs_depara>-sglmtv
                            quantidade = lv_menge ) TO ls_output-mt_processo_compra-itens.

            CLEAR:  lv_matnr,
                    lv_menge,
                    lv_meins.

          ENDIF.

        ENDLOOP.

        TRY.

            NEW zclmm_co_si_enviar_processo_co( )->si_enviar_processo_compra_out( output = ls_output ).

            IF sy-subrc EQ 0.
              COMMIT WORK.
            ENDIF.

          CATCH cx_root.
        ENDTRY.

      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD rmvzeros.

    DATA(lv_pomatnr) = iv_pomatnr.

    SHIFT lv_pomatnr LEFT DELETING LEADING '0'.

    rv_result = lv_pomatnr.

  ENDMETHOD.

ENDCLASS.
