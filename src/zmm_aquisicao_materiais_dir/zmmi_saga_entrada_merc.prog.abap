*&---------------------------------------------------------------------*
*& Include zmmi_saga_entrada_merc
*&---------------------------------------------------------------------*


  CONSTANTS: lc_param     TYPE ztmm_saga_param-parametro VALUE 'DEPOSITOS_WMS',
             lc_bwart_101 TYPE lips-bwart                VALUE '101',
             lc_bwart_861 TYPE lips-bwart                VALUE '861',
             lc_error     TYPE sy-msgty                  VALUE 'E',
             lc_msg_id    TYPE sy-msgid                  VALUE 'ZMM_SAGA',
             lc_msg_wms   TYPE sy-msgno                  VALUE '001'.

  IF ( is_mseg-bwart = lc_bwart_101 OR  "Entrada compra
       is_mseg-bwart = lc_bwart_861 )   "Entrada transferência entre plantas
 AND is_mseg-vbeln_im IS NOT INITIAL.

    IF is_mseg IS NOT INITIAL.

      SELECT vbeln,
             verur,
             lifnr
        FROM likp
       WHERE vbeln = @is_mseg-vbeln_im
        INTO TABLE @DATA(lt_likp).

      IF sy-subrc IS INITIAL.
        SORT lt_likp BY vbeln.

        IF is_mseg-bwart = lc_bwart_101.

          DATA(lt_likp_fae) = lt_likp[].
          SORT lt_likp_fae BY verur
                              lifnr.
          DELETE ADJACENT DUPLICATES FROM lt_likp_fae COMPARING verur
                                                                lifnr.

          SELECT nfenum,
                 lifnr
            FROM ztmm_wms_receb
             FOR ALL ENTRIES IN @lt_likp_fae
           WHERE nfenum = @lt_likp_fae-verur(9)
             AND lifnr  = @lt_likp_fae-lifnr
            INTO TABLE @DATA(lt_receb_101).

          IF sy-subrc IS INITIAL.
            SORT lt_receb_101 BY nfenum
                                 lifnr.
          ENDIF.

        ELSEIF is_mseg-bwart = lc_bwart_861.

          lt_likp_fae = lt_likp[].
          SORT lt_likp_fae BY verur.
          DELETE ADJACENT DUPLICATES FROM lt_likp_fae COMPARING verur.

          SELECT vbeln_im,
                 xblnr_mkpf
            FROM mseg
             FOR ALL ENTRIES IN @lt_likp_fae
           WHERE vbeln_im = @lt_likp_fae-verur(10)
            INTO TABLE @DATA(lt_mseg).

          IF sy-subrc IS INITIAL.
            SORT lt_mseg BY vbeln_im.

            SELECT nfenum,
                   lifnr
              FROM ztmm_wms_receb
               FOR ALL ENTRIES IN @lt_mseg
             WHERE nfenum = @lt_mseg-xblnr_mkpf(9)
              INTO TABLE @DATA(lt_receb_861).

            IF sy-subrc IS INITIAL.
              SORT lt_receb_861 BY nfenum
                                   lifnr.
            ENDIF.

          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    IF is_mseg IS NOT INITIAL.

      SELECT vbeln,
             werks,
             lgort,
             bwart
        FROM lips
       WHERE vbeln = @is_mseg-vbeln_im
        INTO TABLE @DATA(lt_lips).

      IF sy-subrc IS INITIAL.
        SORT lt_lips BY vbeln.

        SELECT werks,
               valor
          FROM ztmm_saga_param
           FOR ALL ENTRIES IN @lt_lips
         WHERE werks     = @lt_lips-werks
           AND parametro = @lc_param
          INTO TABLE @DATA(lt_param).

        IF sy-subrc IS INITIAL.
          SORT lt_param BY werks.
        ENDIF.

      ENDIF.
    ENDIF.
  ENDIF.

  LOOP AT lt_lips ASSIGNING FIELD-SYMBOL(<fs_lips>).

    READ TABLE lt_param ASSIGNING FIELD-SYMBOL(<fs_param>)
                                      WITH KEY werks = <fs_lips>-werks
                                      BINARY SEARCH.
    IF sy-subrc IS INITIAL.

      IF <fs_param>-valor CS <fs_lips>-lgort.
        READ TABLE lt_likp ASSIGNING FIELD-SYMBOL(<fs_likp>)
                                         WITH KEY vbeln = <fs_lips>-vbeln
                                         BINARY SEARCH.
        IF sy-subrc IS INITIAL.

          CASE <fs_lips>-bwart.
            WHEN lc_bwart_101.

              READ TABLE lt_receb_101 ASSIGNING FIELD-SYMBOL(<fs_receb_101>)
                                                    WITH KEY nfenum = <fs_likp>-verur(9)
                                                             lifnr  = <fs_likp>-lifnr
                                                             BINARY SEARCH.
              IF sy-subrc IS NOT INITIAL.
                MESSAGE ID lc_msg_id TYPE lc_error NUMBER lc_msg_wms.
              ENDIF.

            WHEN lc_bwart_861.

              READ TABLE lt_mseg ASSIGNING FIELD-SYMBOL(<fs_mseg>)
                                               WITH KEY vbeln_im = <fs_likp>-verur(10)
                                               BINARY SEARCH.
              IF sy-subrc IS INITIAL.
                READ TABLE lt_receb_861 ASSIGNING FIELD-SYMBOL(<fs_receb_861>)
                                                      WITH KEY nfenum = <fs_mseg>-xblnr_mkpf(9)
                                                               lifnr  = <fs_likp>-lifnr
                                                      BINARY SEARCH.
                IF sy-subrc IS NOT INITIAL.
                  MESSAGE ID lc_msg_id TYPE lc_error NUMBER lc_msg_wms.
                ENDIF.
              ENDIF.

            WHEN OTHERS.
          ENDCASE.

        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.
