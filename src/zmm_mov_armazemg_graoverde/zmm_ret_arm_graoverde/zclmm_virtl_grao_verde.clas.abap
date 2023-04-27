CLASS zclmm_virtl_grao_verde DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLMM_VIRTL_GRAO_VERDE IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    TYPES: BEGIN OF ty_nfe,
             guid_header TYPE /xnfe/guid_16,
             access_key  TYPE /xnfe/id,
             regio       TYPE j_1bregio,
             nfyear      TYPE j_1byear,
             nfmonth     TYPE j_1bmonth,
             stcd1       TYPE j_1bstcd1,
             model       TYPE j_1bmodel,
             serie       TYPE j_1bseries,
             nfnum9      TYPE j_1bnfnum9,
             docnum9     TYPE j_1bdocnum9,
             cdv         TYPE j_1bcheckdigit,
             nitem       TYPE numc3,
           END OF ty_nfe.

    TYPES: BEGIN OF ty_hd,
             nfyear  TYPE j_1bnfe_active-nfyear,
             nfmonth TYPE j_1bnfe_active-nfmonth,
             stcd1   TYPE j_1bnfe_active-stcd1,
             model   TYPE j_1bnfe_active-model,
             nfnum9  TYPE j_1bnfe_active-nfnum9,
           END OF ty_hd.

    DATA: lt_hd_filtro TYPE STANDARD TABLE OF ty_hd.

    DATA: lt_key        TYPE zctgmm_subc_saveatrib,
          lt_nfe_remess TYPE STANDARD TABLE OF ty_nfe.

    CHECK NOT it_original_data IS INITIAL.

    DATA lt_calculated_data TYPE STANDARD TABLE OF zc_mm_ret_arm_graoverde WITH DEFAULT KEY.

    MOVE-CORRESPONDING it_original_data TO lt_calculated_data.

    IF lt_calculated_data[] IS NOT INITIAL.



      SELECT a~guid_header,
             a~nfeid,
             a~cnpj_emit,
             a~mod,
             a~nnf,
             b~nfyear,
             b~nfmonth
        FROM /xnfe/innfehd AS a
        LEFT OUTER JOIN zi_mm_filtro_demi_gv AS b ON b~guidheader = a~guid_header
         FOR ALL ENTRIES IN @lt_calculated_data
       WHERE nfeid = @lt_calculated_data-xml
        INTO TABLE @DATA(lt_hd).

      IF sy-subrc IS INITIAL.

        lt_hd_filtro = VALUE #( FOR ls_hd_aux IN lt_hd
                              ( nfyear  = ls_hd_aux-nfyear
                                nfmonth = ls_hd_aux-nfmonth
                                stcd1   = ls_hd_aux-cnpj_emit(14)
                                model   = ls_hd_aux-mod
                                nfnum9  = ls_hd_aux-nnf ) ).

        IF lt_hd_filtro IS NOT INITIAL.

          SELECT a~docnum,
                 a~nfyear,
                 a~nfmonth,
                 a~stcd1,
                 a~model,
                 a~nfnum9,
                 a~action_requ,
                 a~cancel,
                 a~credat,
                 b~mblnr,
                 b~mjahr
            FROM j_1bnfe_active AS a
            LEFT JOIN zi_mm_filtro_refkey_gv AS b ON b~docnum = a~docnum
             FOR ALL ENTRIES IN @lt_hd_filtro
           WHERE nfyear  = @lt_hd_filtro-nfyear
             AND nfmonth = @lt_hd_filtro-nfmonth
             AND stcd1   = @lt_hd_filtro-stcd1
             AND model   = @lt_hd_filtro-model
             AND nfnum9  = @lt_hd_filtro-nfnum9
             AND cancel  = @space
          INTO TABLE @DATA(lt_bn_active).

          IF sy-subrc IS INITIAL.
            SORT lt_bn_active BY nfyear
                                 nfmonth
                                 stcd1
                                 model
                                 nfnum9.

            SELECT mblnr,
                   mjahr,
                   ummab_cid,
                   umwrk_cid,
                   charg_cid,
                   lifnr_cid,
                   charg,
                   matnr
              FROM matdoc
               FOR ALL ENTRIES IN @lt_bn_active
             WHERE mblnr = @lt_bn_active-mblnr
               AND mjahr = @lt_bn_active-mjahr
               AND sobkz = @space
              INTO TABLE @DATA(lt_matdoc).

            IF sy-subrc IS INITIAL.
              SORT lt_matdoc BY mblnr
                                mjahr.
            ENDIF.
          ENDIF.
        ENDIF.

        SORT lt_hd BY nfeid.

        SELECT guid_header,
               access_key,
               counter
         FROM /xnfe/innfenfe
          FOR ALL ENTRIES IN @lt_hd
        WHERE guid_header = @lt_hd-guid_header
         INTO TABLE @DATA(lt_nfe).

        IF sy-subrc IS INITIAL.

          LOOP AT lt_nfe ASSIGNING FIELD-SYMBOL(<fs_nfe>).

            lt_nfe_remess = VALUE #( BASE lt_nfe_remess ( guid_header = <fs_nfe>-guid_header
                                                          access_key  = <fs_nfe>-access_key
                                                          regio       = <fs_nfe>-access_key(2)
                                                          nfyear      = <fs_nfe>-access_key+2(2)
                                                          nfmonth     = <fs_nfe>-access_key+4(2)
                                                          stcd1       = <fs_nfe>-access_key+6(14)
                                                          model       = <fs_nfe>-access_key+20(2)
                                                          serie       = <fs_nfe>-access_key+22(3)
                                                          nfnum9      = <fs_nfe>-access_key+25(9)
                                                          docnum9     = <fs_nfe>-access_key+34(9)
                                                          cdv         = <fs_nfe>-access_key+43(1)
                                                          nitem       = <fs_nfe>-counter ) ).

          ENDLOOP.

          IF lt_nfe_remess[] IS NOT INITIAL.

            SORT lt_nfe_remess BY guid_header
                                  nitem.

            SELECT docnum,
                   regio,
                   nfyear,
                   nfmonth,
                   stcd1,
                   model,
                   serie,
                   nfnum9,
                   docnum9,
                   cdv,
                   parid
              FROM j_1bnfe_active
               FOR ALL ENTRIES IN @lt_nfe_remess
             WHERE regio    = @lt_nfe_remess-regio
               AND nfyear   = @lt_nfe_remess-nfyear
               AND nfmonth  = @lt_nfe_remess-nfmonth
               AND stcd1    = @lt_nfe_remess-stcd1
               AND model    = @lt_nfe_remess-model
               AND serie    = @lt_nfe_remess-serie
               AND nfnum9   = @lt_nfe_remess-nfnum9
               AND docnum9  = @lt_nfe_remess-docnum9
               AND cdv      = @lt_nfe_remess-cdv
              INTO TABLE @DATA(lt_active).

            IF sy-subrc IS INITIAL.
              SORT lt_active BY regio
                                nfyear
                                nfmonth
                                stcd1
                                model
                                serie
                                nfnum9
                                docnum9
                                cdv.

              SELECT docnum,
                     refkey,
                     matnr,
                     werks,
                     charg,
                     meins
                FROM j_1bnflin
                 FOR ALL ENTRIES IN @lt_active
               WHERE docnum = @lt_active-docnum
               INTO TABLE @DATA(lt_lin).

              IF sy-subrc IS INITIAL.
                DATA(lt_data) = lt_calculated_data[].

*                LOOP AT lt_lin INTO DATA(ls_lin).
*
*                  READ TABLE lt_data INTO DATA(ls_data) WITH KEY materialatribuido = ls_lin-matnr.
*                  IF  sy-subrc IS NOT INITIAL.
*
*                    DELETE lt_lin WHERE docnum =  ls_lin-docnum.
*                    DELETE lt_active WHERE docnum =  ls_lin-docnum.
*
*                  ENDIF.
*                ENDLOOP.

                IF lt_lin[] IS NOT INITIAL.

                  SORT lt_lin BY docnum.

                  SELECT matnr,
                         werks,
                         charg,
                         lifnr,
                         lblab
                    FROM mslb
                     FOR ALL ENTRIES IN @lt_lin
                   WHERE matnr = @lt_lin-matnr
                     AND werks = @lt_lin-werks
                     AND charg = @lt_lin-charg
                     AND sobkz = 'O'
                    INTO TABLE @DATA(lt_mslb).

                  IF sy-subrc IS INITIAL.
                    SORT lt_mslb BY matnr
                                    werks
                                    charg
                                    lifnr.
                  ENDIF.

                  DATA(lt_lin_fae) = lt_lin[].
                  SORT lt_lin_fae BY matnr.
                  DELETE ADJACENT DUPLICATES FROM lt_lin_fae COMPARING matnr.

                  SELECT matnr,
                         maktx
                    FROM makt
                     FOR ALL ENTRIES IN @lt_lin_fae
                   WHERE matnr = @lt_lin_fae-matnr
                    INTO TABLE @DATA(lt_makt).

                  IF sy-subrc IS INITIAL.
                    SORT lt_makt BY matnr.
                  ENDIF.

                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.

        DATA(lt_data_aux) = lt_calculated_data[].

        LOOP AT lt_calculated_data ASSIGNING FIELD-SYMBOL(<fs_calculated>).

          DATA(lv_tabix) = sy-tabix.

*          IF <fs_calculated>-materialatribuido IS INITIAL.
*            CONTINUE.
*          ENDIF.

          READ TABLE lt_hd ASSIGNING FIELD-SYMBOL(<fs_hd>)
                                         WITH KEY nfeid = <fs_calculated>-xml
                                         BINARY SEARCH.
          IF sy-subrc IS INITIAL.

            READ TABLE lt_nfe_remess TRANSPORTING NO FIELDS
                                                   WITH KEY guid_header = <fs_hd>-guid_header
                                                            nitem       = <fs_calculated>-nitem
                                                            BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              LOOP AT lt_nfe_remess ASSIGNING FIELD-SYMBOL(<fs_nfs>) FROM sy-tabix.
                IF <fs_nfs>-guid_header NE <fs_hd>-guid_header
                OR <fs_nfs>-nitem       NE <fs_calculated>-nitem.
                  EXIT.
                ENDIF.

                READ TABLE lt_active ASSIGNING FIELD-SYMBOL(<fs_active>)
                                                   WITH KEY regio   = <fs_nfs>-regio
                                                            nfyear  = <fs_nfs>-nfyear
                                                            nfmonth = <fs_nfs>-nfmonth
                                                            stcd1   = <fs_nfs>-stcd1
                                                            model   = <fs_nfs>-model
                                                            serie   = <fs_nfs>-serie
                                                            nfnum9  = <fs_nfs>-nfnum9
                                                            docnum9 = <fs_nfs>-docnum9
                                                            cdv     =  <fs_nfs>-cdv
                                                            BINARY SEARCH.
                IF sy-subrc IS INITIAL.

                  READ TABLE lt_lin ASSIGNING FIELD-SYMBOL(<fs_lin>)
                                                  WITH KEY docnum = <fs_active>-docnum
                                                  BINARY SEARCH.
                  IF sy-subrc IS INITIAL.

*                    READ TABLE lt_data_aux ASSIGNING FIELD-SYMBOL(<fs_calcul>) WITH KEY xml = <fs_calculated>-xml
*                                                                                        materialatribuido = <fs_lin>-matnr.
                    READ TABLE lt_data_aux ASSIGNING FIELD-SYMBOL(<fs_calcul>) INDEX lv_tabix.

                    IF <fs_calcul> IS ASSIGNED.

                      READ TABLE lt_mslb ASSIGNING FIELD-SYMBOL(<fs_mslb>)
                                                       WITH KEY matnr = <fs_lin>-matnr
                                                                werks = <fs_lin>-werks
                                                                charg = <fs_lin>-charg
                                                                lifnr = <fs_active>-parid
                                                                BINARY SEARCH.
                      IF sy-subrc IS INITIAL.

                        READ TABLE lt_bn_active ASSIGNING FIELD-SYMBOL(<fs_actv_aux>)
                                                              WITH KEY nfyear  = <fs_hd>-nfyear
                                                                       nfmonth = <fs_hd>-nfmonth
                                                                       stcd1   = <fs_hd>-cnpj_emit(14)
                                                                       model   = <fs_hd>-mod
                                                                       nfnum9  = <fs_hd>-nnf
                                                                       BINARY SEARCH.

                        IF sy-subrc IS INITIAL.
                          READ TABLE lt_matdoc TRANSPORTING NO FIELDS
                                                             WITH KEY mblnr = <fs_actv_aux>-mblnr
                                                                      mjahr = <fs_actv_aux>-mjahr
                                                                      BINARY SEARCH.
                          IF sy-subrc IS INITIAL.

                            LOOP AT lt_matdoc ASSIGNING FIELD-SYMBOL(<fs_matdoc>) FROM sy-tabix.
                              IF <fs_matdoc>-mblnr NE <fs_actv_aux>-mblnr
                              OR <fs_matdoc>-mjahr NE <fs_actv_aux>-mjahr.
                                EXIT.
                              ENDIF.

                              IF ( <fs_matdoc>-matnr <> <fs_mslb>-matnr ) OR
                                 ( <fs_matdoc>-ummab_cid = <fs_mslb>-matnr AND
                                   <fs_matdoc>-umwrk_cid = <fs_mslb>-werks AND
                                   <fs_matdoc>-charg_cid = <fs_mslb>-charg AND
                                   <fs_matdoc>-lifnr_cid = <fs_mslb>-lifnr ).

                                <fs_calcul>-docmaterial = <fs_matdoc>-mblnr.
                                <fs_calcul>-lote        = <fs_matdoc>-charg.

                                IF <fs_actv_aux>-action_requ EQ 'C'.
                                  <fs_calcul>-docnum2           = <fs_actv_aux>-docnum.
                                  <fs_calcul>-credat            = <fs_actv_aux>-credat.
                                  <fs_calcul>-status            = TEXT-001.
                                  <fs_calcul>-statuscriticality = 3.

                                ELSEIF <fs_actv_aux>-action_requ NE space.
                                  <fs_calcul>-status            = TEXT-003.
                                  <fs_calcul>-statuscriticality = 2.
                                ELSE.
                                  <fs_calcul>-status            = TEXT-004.
                                  <fs_calcul>-statuscriticality = 1.

                                ENDIF.

                                EXIT.

                              ELSE.
                                <fs_calcul>-status            = TEXT-004.
                                <fs_calcul>-statuscriticality = 1.
                              ENDIF.
                            ENDLOOP.
                          ELSE.
                            <fs_calcul>-status            = TEXT-004.
                            <fs_calcul>-statuscriticality = 1.
                          ENDIF.
                        ELSE.
                          <fs_calcul>-status            = TEXT-004.
                          <fs_calcul>-statuscriticality = 1.
                        ENDIF.

*                      <fs_calculated>-charg          = <fs_mslb>-charg.
*                      <fs_calculated>-erfme          = <fs_lin>-meins.
*                      <fs_calculated>-qtde           = <fs_mslb>-lblab.
*                      <fs_calculated>-materialremess = <fs_lin>-matnr.
                        <fs_calcul>-charg          = <fs_mslb>-charg.
                        <fs_calcul>-erfme          = <fs_lin>-meins.
                        <fs_calcul>-qtde           = <fs_mslb>-lblab.
                        <fs_calcul>-materialremess = <fs_lin>-matnr.

                        READ TABLE lt_makt ASSIGNING FIELD-SYMBOL(<fs_makt>)
                                                         WITH KEY matnr = <fs_lin>-matnr
                                                         BINARY SEARCH.
                        IF sy-subrc IS INITIAL.
                          <fs_calculated>-matremtext = <fs_makt>-maktx.
                        ENDIF.

                      ELSE.
                        <fs_calcul>-status            = TEXT-005.
                        <fs_calcul>-statuscriticality = 1.
                      ENDIF.
                    ELSE.
                      <fs_calcul>-status            = TEXT-004.
                      <fs_calcul>-statuscriticality = 1.
                    ENDIF.
                  ELSE.
                    READ TABLE lt_data_aux ASSIGNING <fs_calcul> INDEX lv_tabix.
                    IF sy-subrc IS INITIAL.
                      <fs_calcul>-status            = TEXT-004.
                      <fs_calcul>-statuscriticality = 1.
                      UNASSIGN <fs_calcul>.
                    ENDIF.
                  ENDIF.
                ELSE.
                  READ TABLE lt_data_aux ASSIGNING <fs_calcul> INDEX lv_tabix.
                  IF sy-subrc IS INITIAL.
                    <fs_calcul>-status            = TEXT-004.
                    <fs_calcul>-statuscriticality = 1.
                    UNASSIGN <fs_calcul>.
                  ENDIF.
                ENDIF.

                IF <fs_calcul> IS ASSIGNED.
                  UNASSIGN <fs_calcul>.
                ENDIF.

              ENDLOOP.

            ELSE.

              READ TABLE lt_data_aux ASSIGNING <fs_calcul> INDEX lv_tabix.
              IF sy-subrc IS INITIAL.
                <fs_calcul>-status            = TEXT-004.
                <fs_calcul>-statuscriticality = 1.
                UNASSIGN <fs_calcul>.
              ENDIF.
            ENDIF.

*            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.

*    MOVE-CORRESPONDING lt_calculated_data TO ct_calculated_data.
    MOVE-CORRESPONDING lt_data_aux TO ct_calculated_data.

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    IF et_requested_orig_elements IS INITIAL.
*    APPEND 'REQNUMBER' TO et_requested_orig_elements.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
