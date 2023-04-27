*&---------------------------------------------------------------------*
*& Include zmmi_paletizacao
*&---------------------------------------------------------------------*

    IF segment_name = lc_marm.

      DATA(lt_docdata) = idoc_data[].
      SORT lt_docdata BY segnam.

      READ TABLE lt_docdata ASSIGNING FIELD-SYMBOL(<fs_maram>)
                                          WITH KEY segnam = lc_maram
                                          BINARY SEARCH.
      IF sy-subrc = 0.
        ls_maram = <fs_maram>-sdata.
      ENDIF.

      SELECT a~centro,
             a~z_lastro,
             a~z_altura
        FROM ztmm_paletizacao AS a
       INNER JOIN marc AS b ON a~material = b~matnr
                           AND a~centro = b~werks
       WHERE a~material = @f_marm-matnr
         AND a~z_unit   = @f_marm-meinh
        INTO TABLE @DATA(lt_paletizacao).

      IF sy-subrc IS INITIAL.

        lv_memory_id = |{ f_marm-matnr }{ sy-uname(4) }|.
        IMPORT lv_werks TO lv_werks FROM DATABASE indx(zp) ID lv_memory_id.

        IF sy-subrc IS INITIAL.

          SORT lt_paletizacao BY centro.

          READ TABLE lt_docdata ASSIGNING FIELD-SYMBOL(<fs_marcm>) "idoc_data
                                              WITH KEY segnam = lc_marc
                                              BINARY SEARCH.
          IF sy-subrc EQ 0.

            IMPORT iv_tcode TO lv_tcode FROM MEMORY ID 'TCODE_PALETIZACAO'. " ZFMMM_TRIGGER_MATMAS

            IF lv_tcode NE lc_mm01 AND
               lv_tcode NE lc_mm02.

              READ TABLE lt_paletizacao ASSIGNING FIELD-SYMBOL(<fs_palet>)
                                                      WITH KEY centro = lv_werks
                                                      BINARY SEARCH.
              IF sy-subrc IS INITIAL.

                APPEND INITIAL LINE TO idoc_data ASSIGNING FIELD-SYMBOL(<fs_data>).
                <fs_data>-segnam = 'ZMM_MARM_PALET'.
                ls_palet-werks   = <fs_palet>-centro.
                ls_palet-meinh   = f_marm-meinh.

                ls_palet-zlastro = <fs_palet>-z_lastro.
                ls_palet-zaltura = <fs_palet>-z_altura.

                CONDENSE ls_palet-werks NO-GAPS.
                lv_nvezes = 4 - strlen( ls_palet-werks ).

                DO lv_nvezes TIMES.
                  CONCATENATE ls_palet-werks ' ' INTO ls_palet-werks SEPARATED BY space.
                ENDDO.

                CONDENSE ls_palet-meinh NO-GAPS.
                lv_nvezes = 3 - strlen( ls_palet-meinh ).

                DO lv_nvezes TIMES.
                  CONCATENATE ls_palet-meinh ' ' INTO ls_palet-meinh SEPARATED BY space.
                ENDDO.

                CONDENSE ls_palet-zlastro NO-GAPS.
                lv_nvezes = 15 - strlen( ls_palet-zlastro ).
                DO lv_nvezes TIMES.
                  CONCATENATE ls_palet-zlastro ' ' INTO ls_palet-zlastro SEPARATED BY space.
                ENDDO.

                CONDENSE ls_palet-zaltura NO-GAPS.
                lv_nvezes = 15 - strlen( ls_palet-zaltura ).
                DO lv_nvezes TIMES.
                  CONCATENATE ls_palet-zaltura ' ' INTO ls_palet-zaltura SEPARATED BY space.
                ENDDO.
                <fs_data>-sdata = ls_palet-werks && ls_palet-meinh && ls_palet-zlastro && ls_palet-zaltura.

              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.

*        SELECT SINGLE mseht
*          FROM t006a
*         WHERE spras = @sy-langu
*           AND msehi = @f_marm-meinh
*          INTO @DATA(lv_aux_mseht).
*
*        IF sy-subrc = 0.
*
*          APPEND INITIAL LINE TO idoc_data ASSIGNING <fs_data>.
*          <fs_data>-segnam = 'ZMM_T006A'.
*
*          lv_meinh = f_marm-meinh.
*          CONDENSE lv_meinh NO-GAPS.
*
*          lv_nvezes = 3 - strlen( lv_meinh ).
*          DO lv_nvezes TIMES.
*            CONCATENATE lv_meinh ' ' INTO lv_meinh SEPARATED BY space.
*          ENDDO.
*
*          lv_mseht = lv_aux_mseht.
*          CONDENSE lv_mseht NO-GAPS.
*
*          lv_nvezes = 10 - strlen( lv_mseht ).
*          DO lv_nvezes TIMES.
*            CONCATENATE lv_mseht ' ' INTO lv_mseht SEPARATED BY space.
*          ENDDO.
*
*          <fs_data>-sdata = lv_meinh && lv_mseht.
*
*        ENDIF.
*
*        CALL FUNCTION 'ZWMS_FM_MENOR_QTDE_WMS'
*          EXPORTING
*            i_matnr = f_marm-matnr
*            i_menge = 1
*            i_meins = ls_maram-meins
*          IMPORTING
*            e_meins = lv_menor_um.
*
*        CASE f_marm-numtp.
*          WHEN 'HE'.
*            CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
*              EXPORTING
*                i_matnr              = f_marm-matnr
*                i_in_me              = ls_maram-meins
*                i_out_me             = lv_menor_um
*                i_menge              = 1
*              IMPORTING
*                e_menge              = lv_qtd
*              EXCEPTIONS
*                error_in_application = 1
*                error                = 2
*                OTHERS               = 3.
*
*            IF sy-subrc = 0.
*
*              lv_numtp = f_marm-numtp.
*
*              CONDENSE lv_numtp NO-GAPS.
*
*              lv_nvezes = 2 - strlen( lv_numtp ).
*              DO lv_nvezes TIMES.
*                CONCATENATE lv_numtp ' ' INTO lv_numtp SEPARATED BY space.
*              ENDDO.
*
*              lv_menge = lv_qtd.
*              CONDENSE lv_menge NO-GAPS.
*              lv_nvezes = 15 - strlen( lv_menge ).
*              DO lv_nvezes TIMES.
*                CONCATENATE lv_menge ' ' INTO lv_menge SEPARATED BY space.
*              ENDDO.
*
*              APPEND INITIAL LINE TO idoc_data ASSIGNING <fs_data>.
*              <fs_data>-segnam = 'ZMM_MARM_QTD'.
**            <fs_data>-sdata = f_marm-numtp && lv_qtd.
*              <fs_data>-sdata = lv_numtp && lv_menge.
*
*            ENDIF.
*
*          WHEN 'IC'.
*            IF f_marm-meinh IS NOT INITIAL.
*              CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
*                EXPORTING
*                  i_matnr              = f_marm-matnr
*                  i_in_me              = f_marm-meinh
*                  i_out_me             = lv_menor_um
*                  i_menge              = 1
*                IMPORTING
*                  e_menge              = lv_qtd
*                EXCEPTIONS
*                  error_in_application = 1
*                  error                = 2
*                  OTHERS               = 3.
*
*              IF sy-subrc = 0.
*
*                lv_numtp = f_marm-numtp.
*
*                CONDENSE lv_numtp NO-GAPS.
*
*                lv_nvezes = 2 - strlen( lv_numtp ).
*                DO lv_nvezes TIMES.
*                  CONCATENATE lv_numtp ' ' INTO lv_numtp SEPARATED BY space.
*                ENDDO.
*
*                lv_menge = lv_qtd.
*                CONDENSE lv_menge NO-GAPS.
*                lv_nvezes = 15 - strlen( lv_menge ).
*                DO lv_nvezes TIMES.
*                  CONCATENATE lv_menge ' ' INTO lv_menge SEPARATED BY space.
*                ENDDO.
*
*                APPEND INITIAL LINE TO idoc_data ASSIGNING <fs_data>.
*                <fs_data>-segnam = 'ZMM_MARM_QTD'.
*                <fs_data>-sdata = lv_numtp && lv_menge.
*              ENDIF.
*            ENDIF.
*        ENDCASE.
      ENDIF.

      SELECT SINGLE mseht
          FROM t006a
         WHERE spras = @sy-langu
           AND msehi = @f_marm-meinh
          INTO @DATA(lv_aux_mseht).

      IF sy-subrc = 0.

        APPEND INITIAL LINE TO idoc_data ASSIGNING <fs_data>.
        <fs_data>-segnam = 'ZMM_T006A'.

        lv_meinh = f_marm-meinh.
        CONDENSE lv_meinh NO-GAPS.

        lv_nvezes = 3 - strlen( lv_meinh ).
        DO lv_nvezes TIMES.
          CONCATENATE lv_meinh ' ' INTO lv_meinh SEPARATED BY space.
        ENDDO.

        lv_mseht = lv_aux_mseht.
        CONDENSE lv_mseht NO-GAPS.

        lv_nvezes = 10 - strlen( lv_mseht ).
        DO lv_nvezes TIMES.
          CONCATENATE lv_mseht ' ' INTO lv_mseht SEPARATED BY space.
        ENDDO.

        <fs_data>-sdata = lv_meinh && lv_mseht.

      ENDIF.


      CALL FUNCTION 'ZWMS_FM_MENOR_QTDE_WMS'
        EXPORTING
          i_matnr = f_marm-matnr
          i_menge = 1
          i_meins = ls_maram-meins
        IMPORTING
          e_meins = lv_menor_um.

      CASE f_marm-numtp.
        WHEN 'HE'.
          CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
            EXPORTING
              i_matnr              = f_marm-matnr
              i_in_me              = ls_maram-meins
              i_out_me             = lv_menor_um
              i_menge              = 1
            IMPORTING
              e_menge              = lv_qtd
            EXCEPTIONS
              error_in_application = 1
              error                = 2
              OTHERS               = 3.

          IF sy-subrc = 0.

            lv_numtp = f_marm-numtp.

            CONDENSE lv_numtp NO-GAPS.

            lv_nvezes = 2 - strlen( lv_numtp ).
            DO lv_nvezes TIMES.
              CONCATENATE lv_numtp ' ' INTO lv_numtp SEPARATED BY space.
            ENDDO.

            lv_menge = lv_qtd.
            CONDENSE lv_menge NO-GAPS.
            lv_nvezes = 15 - strlen( lv_menge ).
            DO lv_nvezes TIMES.
              CONCATENATE lv_menge ' ' INTO lv_menge SEPARATED BY space.
            ENDDO.

            APPEND INITIAL LINE TO idoc_data ASSIGNING <fs_data>.
            <fs_data>-segnam = 'ZMM_MARM_QTD'.
*            <fs_data>-sdata = f_marm-numtp && lv_qtd.
            <fs_data>-sdata = lv_numtp && lv_menge.

          ENDIF.

        WHEN 'IC'.
          IF f_marm-meinh IS NOT INITIAL.
            CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
              EXPORTING
                i_matnr              = f_marm-matnr
                i_in_me              = f_marm-meinh
                i_out_me             = lv_menor_um
                i_menge              = 1
              IMPORTING
                e_menge              = lv_qtd
              EXCEPTIONS
                error_in_application = 1
                error                = 2
                OTHERS               = 3.

            IF sy-subrc = 0.

              lv_numtp = f_marm-numtp.

              CONDENSE lv_numtp NO-GAPS.

              lv_nvezes = 2 - strlen( lv_numtp ).
              DO lv_nvezes TIMES.
                CONCATENATE lv_numtp ' ' INTO lv_numtp SEPARATED BY space.
              ENDDO.

              lv_menge = lv_qtd.
              CONDENSE lv_menge NO-GAPS.
              lv_nvezes = 15 - strlen( lv_menge ).
              DO lv_nvezes TIMES.
                CONCATENATE lv_menge ' ' INTO lv_menge SEPARATED BY space.
              ENDDO.

              APPEND INITIAL LINE TO idoc_data ASSIGNING <fs_data>.
              <fs_data>-segnam = 'ZMM_MARM_QTD'.
              <fs_data>-sdata = lv_numtp && lv_menge.
            ENDIF.
          ENDIF.
      ENDCASE.

    ENDIF.
