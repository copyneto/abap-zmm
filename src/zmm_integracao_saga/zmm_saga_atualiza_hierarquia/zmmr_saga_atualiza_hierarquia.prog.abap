*&---------------------------------------------------------------------*
*& Report ZMMR_SAGA_ATUALIZA_HIERARQUIA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmmr_saga_atualiza_hierarquia.

TABLES: t179.
*********************************************************************
* TELA DE SELEÇÃO                                                   *
*********************************************************************
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS:
   s_prodh FOR t179-prodh.

SELECTION-SCREEN END OF BLOCK b1.

**********************************************************************
* EVENTOS                                                            *
**********************************************************************
START-OF-SELECTION.
  PERFORM f_main.

*&--------------------------------*
*& F_MAIN
*&--------------------------------*
FORM f_main.

  DATA: lt_hier_1 TYPE STANDARD TABLE OF zi_mm_hierarquia_material,
        lt_hier_2 TYPE STANDARD TABLE OF zi_mm_hierarquia_material,
        lt_hier_3 TYPE STANDARD TABLE OF zi_mm_hierarquia_material.

  DATA: ls_output TYPE zclmm_mt_envia_grupo_mercadori.

  DATA lv_char40 TYPE char40.

  SELECT hierarquia,
         nivel1,
         nivel2,
         nivel3,
         nivel,
         descricao
    FROM zi_mm_hierarquia_material
   WHERE hierarquia IN @s_prodh[]
    INTO TABLE @DATA(lt_hierarquias).

  IF sy-subrc IS INITIAL.

    LOOP AT lt_hierarquias ASSIGNING FIELD-SYMBOL(<fs_hierarquia>).

      CASE <fs_hierarquia>-nivel.
        WHEN '1'.
          APPEND <fs_hierarquia> TO lt_hier_1.
        WHEN '2'.
          APPEND <fs_hierarquia> TO lt_hier_2.
        WHEN '3'.
          APPEND <fs_hierarquia> TO lt_hier_3.
        WHEN OTHERS.
      ENDCASE.

    ENDLOOP.

    SORT lt_hier_1 BY nivel1.
    SORT lt_hier_2 BY nivel1
                      nivel2.
    SORT lt_hier_3 BY nivel1
                      nivel2
                      nivel3.

    TRY.

        DATA(lo_object) = NEW zclmm_co_si_grupo_mercadoria_o( ).

        LOOP AT lt_hier_1 ASSIGNING FIELD-SYMBOL(<fs_nivel_1>).

          " Envio do nível 1
          ls_output-mt_envia_grupo_mercadoria-z_prdha = <fs_nivel_1>-hierarquia.
          ls_output-mt_envia_grupo_mercadoria-vtext_1 = <fs_nivel_1>-descricao.
          ls_output-mt_envia_grupo_mercadoria-vtext_2 = <fs_nivel_1>-descricao(40).

          lo_object->si_grupo_mercadoria_out( output = ls_output ).
          CLEAR ls_output.

          COMMIT WORK AND WAIT.
          WAIT UP TO 3 SECONDS. " Tempo para chegar corretamente no SAGA

          READ TABLE lt_hier_2 TRANSPORTING NO FIELDS
                                             WITH KEY nivel1 = <fs_nivel_1>-nivel1
                                             BINARY SEARCH.

          LOOP AT lt_hier_2 ASSIGNING FIELD-SYMBOL(<fs_nivel_2>) FROM sy-tabix.
            IF <fs_nivel_2>-nivel1 NE <fs_nivel_1>-nivel1.
              EXIT.
            ENDIF.

            " Envio do nível 1 e 2
            ls_output-mt_envia_grupo_mercadoria-z_prdha = <fs_nivel_2>-hierarquia.
            ls_output-mt_envia_grupo_mercadoria-vtext_1 = |{ <fs_nivel_1>-descricao } { <fs_nivel_2>-descricao }|.

            " Descrição com limite de 40
            lv_char40 = |{ <fs_nivel_1>-descricao } { <fs_nivel_2>-descricao }|.
            ls_output-mt_envia_grupo_mercadoria-vtext_2 = lv_char40.
            ls_output-mt_envia_grupo_mercadoria-prodh   = <fs_nivel_1>-hierarquia.

            lo_object->si_grupo_mercadoria_out( output = ls_output ).
            CLEAR ls_output.

            COMMIT WORK AND WAIT.
            WAIT UP TO 3 SECONDS. " Tempo para chegar corretamente no SAGA

            READ TABLE lt_hier_3 TRANSPORTING NO FIELDS
                                               WITH KEY nivel1 = <fs_nivel_2>-nivel1
                                                        nivel2 = <fs_nivel_2>-nivel2
                                                        BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              LOOP AT lt_hier_3 ASSIGNING FIELD-SYMBOL(<fs_nivel_3>) FROM sy-tabix.
                IF <fs_nivel_3>-nivel1 NE <fs_nivel_2>-nivel1
                OR <fs_nivel_3>-nivel2 NE <fs_nivel_2>-nivel2.
                  EXIT.
                ENDIF.

                " Envio do nível 2 e 3
                ls_output-mt_envia_grupo_mercadoria-z_prdha = <fs_nivel_3>-hierarquia.
                ls_output-mt_envia_grupo_mercadoria-vtext_1 = |{ <fs_nivel_1>-descricao } { <fs_nivel_2>-descricao } { <fs_nivel_3>-descricao }|.

                " Descrição com limite de 40
                lv_char40 = |{ <fs_nivel_1>-descricao } { <fs_nivel_2>-descricao } { <fs_nivel_3>-descricao }|.
                ls_output-mt_envia_grupo_mercadoria-vtext_2 = lv_char40.
                ls_output-mt_envia_grupo_mercadoria-prodh   = <fs_nivel_2>-hierarquia.

                lo_object->si_grupo_mercadoria_out( output = ls_output ).
                CLEAR ls_output.

                COMMIT WORK AND WAIT.
                WAIT UP TO 3 SECONDS.

              ENDLOOP.
            ENDIF.
          ENDLOOP.
        ENDLOOP.

      CATCH cx_ai_system_fault. " Application Integration: Technical Error.
    ENDTRY.
  ENDIF.

ENDFORM.
