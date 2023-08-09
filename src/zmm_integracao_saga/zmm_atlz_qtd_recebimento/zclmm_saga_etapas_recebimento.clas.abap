CLASS zclmm_saga_etapas_recebimento DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: tt_nnf TYPE RANGE OF j_1bnfdoc-nfenum.

    METHODS main
      IMPORTING
        !ir_nnf TYPE tt_nnf.

  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS: BEGIN OF gc_values,
                 v04  TYPE gm_code  VALUE '04',
                 v344 TYPE bwart    VALUE '344',
                 v861 TYPE bwart    VALUE '861',
                 v3   TYPE mb_insmk VALUE '3',
               END OF gc_values.

    TYPES: tt_wms_receb TYPE STANDARD TABLE OF zi_mm_innfehd  WITH EMPTY KEY,
           tt_xnfe      TYPE STANDARD TABLE OF zsmm_saga_xnfe WITH EMPTY KEY.

    METHODS libera_entrad_mercadoria
      IMPORTING
        !ir_nnf   TYPE tt_nnf
      EXPORTING
        !et_receb TYPE zctgmm_wms_receb
        !et_xnfe  TYPE tt_xnfe.
    METHODS processo_contagem
      IMPORTING
        it_receb TYPE zctgmm_wms_receb
        it_xnfe  TYPE tt_xnfe.
    METHODS liberado
      IMPORTING
        it_receb         TYPE zctgmm_wms_receb
      RETURNING
        VALUE(rv_result) TYPE abap_bool.
ENDCLASS.



CLASS zclmm_saga_etapas_recebimento IMPLEMENTATION.


  METHOD libera_entrad_mercadoria.

    TYPES: BEGIN OF ty_receb,
             stcd1  TYPE /xnfe/innfehd-cnpj_emit,
             nfenum TYPE /xnfe/innfehd-nnf,
           END OF ty_receb.

    DATA: lt_receb_fae TYPE STANDARD TABLE OF ty_receb.

    SELECT *
      FROM ztmm_wms_receb
     WHERE nfenum   IN @ir_nnf
       AND zqtde_nf GT 0
       AND zconcl   EQ @space
      INTO TABLE @DATA(lt_receb).

    IF sy-subrc IS INITIAL.

      et_receb = lt_receb.

      LOOP AT lt_receb ASSIGNING FIELD-SYMBOL(<fs_receb>).

        SHIFT <fs_receb>-nfenum LEFT DELETING LEADING '0'.

        lt_receb_fae = VALUE #( BASE lt_receb_fae ( stcd1  = <fs_receb>-stcd1
                                                    nfenum = <fs_receb>-nfenum ) ).
      ENDLOOP.

      SORT lt_receb_fae BY stcd1
                           nfenum.
      DELETE ADJACENT DUPLICATES FROM lt_receb_fae COMPARING stcd1
                                                             nfenum.
      IF lt_receb_fae[] IS NOT INITIAL.

        SELECT guidheader,
               cnpjemit,
               nnf,
               proctyp,
               laststep
          FROM zi_mm_innfehd
           FOR ALL ENTRIES IN @lt_receb_fae
         WHERE cnpjemit  = @lt_receb_fae-stcd1
           AND nnf       = @lt_receb_fae-nfenum
          INTO TABLE @et_xnfe.

        IF sy-subrc IS INITIAL.

          LOOP AT et_xnfe ASSIGNING FIELD-SYMBOL(<fs_xnfe>).

            IF <fs_xnfe>-last_step EQ 'GRPOSTING' OR " Compra normal
               <fs_xnfe>-last_step EQ 'GRMMCHCK'.    " Transferência entre Plantas

              DO 2 TIMES.

                CALL FUNCTION '/XNFE/NFE_PROCFLOW_EXECUTION'
                  EXPORTING
                    iv_guid_header    = <fs_xnfe>-guid_header
                  EXCEPTIONS
                    no_proc_allowed   = 1
                    error_in_process  = 2
                    technical_error   = 3
                    error_reading_nfe = 4
                    no_logsys         = 5
                    OTHERS            = 6.

                IF sy-subrc NE 0.
                  CONTINUE.
                ENDIF.

              ENDDO.

              WAIT UP TO 5 SECONDS.

            ENDIF.
          ENDLOOP.

        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD main.

    me->libera_entrad_mercadoria(
        EXPORTING
            ir_nnf = ir_nnf
        IMPORTING
            et_receb = DATA(lt_receb)
            et_xnfe  = DATA(lt_xnfe) ).

    IF lt_receb[] IS NOT INITIAL.

      IF liberado( lt_receb  ) EQ abap_true.

        me->processo_contagem(
           EXPORTING it_receb = lt_receb
                     it_xnfe  = lt_xnfe ).
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD processo_contagem.

    DATA: lt_receb_sum     TYPE zctgmm_wms_receb,
          lt_updt_assign   TYPE /xnfe/nfeassign_t,
          lt_goodsmvt_item TYPE STANDARD TABLE OF bapi2017_gm_item_create,
          lt_return        TYPE STANDARD TABLE OF bapiret2,
          lt_receb_fae     TYPE tt_wms_receb.

    DATA: ls_receb_sum       TYPE ztmm_wms_receb,
          ls_goodsmvt_header TYPE bapi2017_gm_head_01,
          ls_goodsmvt_code   TYPE bapi2017_gm_code.

    DATA: lv_guid_header      TYPE /xnfe/guid_16,
          lv_dif              TYPE mseg-menge,
          lv_exec             TYPE char1,
          lv_mseg_2           TYPE char1,
          lv_materialdocument TYPE bapi2017_gm_head_ret-mat_doc,
          lv_nfenum           TYPE int8.

    IF it_receb IS NOT INITIAL.
      DATA(lt_receb) = it_receb.
    ENDIF.

*    SORT lt_receb BY nfenum
*                     lifnr
*                     matnr.

    LOOP AT lt_receb ASSIGNING FIELD-SYMBOL(<fs_rec>).

      SHIFT <fs_rec>-nfenum LEFT DELETING LEADING '0'.

      lt_receb_fae = VALUE #( BASE lt_receb_fae ( cnpjemit  = <fs_rec>-stcd1
                                                  nnf       = <fs_rec>-nfenum ) ).
    ENDLOOP.

    LOOP AT  lt_receb ASSIGNING FIELD-SYMBOL(<fs_receb>).

      ls_receb_sum-nfenum     = <fs_receb>-nfenum.
      ls_receb_sum-matnr      = <fs_receb>-matnr.
      ls_receb_sum-lifnr      = <fs_receb>-lifnr.
      ls_receb_sum-stcd1      = <fs_receb>-stcd1.
      ls_receb_sum-charg      = <fs_receb>-charg.
      ls_receb_sum-itmnum     = <fs_receb>-itmnum.
      ls_receb_sum-werks      = <fs_receb>-werks.
      ls_receb_sum-zqtde_nf   = <fs_receb>-zqtde_nf.
      ls_receb_sum-zqtde_cont = <fs_receb>-zqtde_cont.
      ls_receb_sum-idnfenum   = <fs_receb>-idnfenum.
      ls_receb_sum-zconcl     = <fs_receb>-zconcl.
      ls_receb_sum-zarmaz     = <fs_receb>-zarmaz.

      UNPACK ls_receb_sum-nfenum TO ls_receb_sum-nfenum.
      UNPACK ls_receb_sum-matnr  TO ls_receb_sum-matnr.

      COLLECT ls_receb_sum INTO lt_receb_sum.

    ENDLOOP.

    IF lt_receb_sum[] IS NOT INITIAL.

      SORT lt_receb_sum BY nfenum
                           lifnr.

      DATA(lt_receb_cop) = lt_receb_sum[].

      IF lt_receb_cop IS NOT INITIAL.

        IF it_xnfe[] IS NOT INITIAL.

          SELECT guid_header,
                 nitem,
                 matdoc,
                 pomatnr,
                 cprod
            FROM /xnfe/nfeassign
             FOR ALL ENTRIES IN @it_xnfe
           WHERE guid_header = @it_xnfe-guid_header
            INTO TABLE @DATA(lt_assign).

          IF sy-subrc IS INITIAL.

            SELECT guid_header, ponumber, poitem
              FROM /xnfe/innfeit
              INTO TABLE @DATA(lt_innfeit)
              FOR ALL ENTRIES IN @it_xnfe
            WHERE guid_header = @it_xnfe-guid_header.

            IF sy-subrc EQ 0.

              SELECT ebeln, ebelp, belnr
                FROM ekbe
                INTO TABLE @DATA(lt_ekbe)
                FOR ALL ENTRIES IN @lt_innfeit
               WHERE ebeln EQ @lt_innfeit-ponumber
                 AND ebelp EQ @lt_innfeit-poitem
                 AND bwart EQ @gc_values-v861.

              IF sy-subrc EQ 0.

                LOOP AT lt_assign ASSIGNING FIELD-SYMBOL(<fs_assign>).
                  READ TABLE lt_innfeit ASSIGNING FIELD-SYMBOL(<fs_innfeit>) WITH KEY guid_header = <fs_assign>-guid_header.
                  IF sy-subrc EQ 0.
                    READ TABLE lt_ekbe ASSIGNING FIELD-SYMBOL(<fs_ekbe>) WITH KEY ebeln = <fs_innfeit>-ponumber
                                                                                  ebelp = <fs_innfeit>-poitem.
                    IF sy-subrc EQ 0.
                      <fs_assign>-matdoc = <fs_ekbe>-belnr.
                    ENDIF.
                  ENDIF.
                ENDLOOP.

              ENDIF.

            ENDIF.

            SORT lt_assign BY guid_header
                              cprod.

            DATA(lt_assign_2) = lt_assign[].
            SORT lt_assign_2 BY guid_header
                                pomatnr.

            DATA(lt_assign_fae) = lt_assign[].

            SORT lt_assign_fae BY matdoc.
            DELETE ADJACENT DUPLICATES FROM lt_assign_fae COMPARING matdoc.

            SELECT mblnr,
                   matnr,
                   charg,
                   menge,
                   werks,
                   lgort,
                   meins,
                   ebeln,
                   ebelp,
                   xblnr_mkpf
              FROM mseg
               FOR ALL ENTRIES IN @lt_assign_fae
             WHERE mblnr = @lt_assign_fae-matdoc
              INTO TABLE @DATA(lt_mseg).

            IF sy-subrc IS INITIAL.

              DATA(lt_mseg_aux) = lt_mseg[].
              FREE: lt_mseg_aux[].

              SORT lt_mseg BY mblnr
                              matnr
                              charg
                              menge DESCENDING.

              DATA(lt_xnfe_aux) = it_xnfe[].

              SORT lt_xnfe_aux BY cnpj_emit
                                  nnf.

              LOOP AT lt_receb_sum ASSIGNING FIELD-SYMBOL(<fs_doc>).

                READ TABLE lt_xnfe_aux ASSIGNING FIELD-SYMBOL(<fs_xnfe>)
                                       WITH KEY cnpj_emit = <fs_doc>-stcd1
                                                nnf       = <fs_doc>-nfenum
                                                BINARY SEARCH.

                READ TABLE lt_xnfe_aux ASSIGNING <fs_xnfe>
                                                     WITH KEY cnpj_emit = <fs_doc>-stcd1
                                                              nnf       = <fs_doc>-nfenum
                                                              BINARY SEARCH.
                IF sy-subrc IS INITIAL.

                  IF <fs_xnfe>-proctyp = 'STOCKTRF'.
                    READ TABLE lt_assign ASSIGNING <fs_assign>
                                                       WITH KEY guid_header = <fs_xnfe>-guid_header
                                                                cprod       = <fs_doc>-matnr
                                                                BINARY SEARCH.
                    IF sy-subrc IS NOT INITIAL.
                      CONTINUE.
                    ENDIF.
                  ELSE.
                    READ TABLE lt_assign_2 ASSIGNING <fs_assign>
                                            WITH KEY guid_header = <fs_xnfe>-guid_header
                                                     pomatnr     = <fs_doc>-matnr
                                                     BINARY SEARCH.
                    IF sy-subrc IS NOT INITIAL.
                      CONTINUE.
                    ENDIF.
                  ENDIF.

                  IF <fs_assign> IS ASSIGNED.

                    IF lv_guid_header NE <fs_xnfe>-guid_header.
                      lv_guid_header = <fs_xnfe>-guid_header.

                      FREE: lt_updt_assign[].
                      CALL FUNCTION '/XNFE/B2BNFE_READ'
                        EXPORTING
                          iv_guid_header     = <fs_xnfe>-guid_header
                          with_enqueue       = abap_true
                        IMPORTING
                          et_assign          = lt_updt_assign
                        EXCEPTIONS
                          nfe_does_not_exist = 1
                          nfe_locked         = 2
                          technical_error    = 3
                          OTHERS             = 4.

                      IF sy-subrc IS NOT INITIAL.
                        EXIT.
                      ENDIF.
                    ENDIF.

                    IF <fs_doc>-zqtde_nf = <fs_doc>-zqtde_cont.

                      IF lt_updt_assign[] IS NOT INITIAL.

                        READ TABLE lt_updt_assign ASSIGNING FIELD-SYMBOL(<fs_updt_assign>)
                                                                WITH KEY guid_header = <fs_assign>-guid_header
                                                                         nitem       = <fs_assign>-nitem
                                                                         BINARY SEARCH.
                        IF sy-subrc IS INITIAL.

                          <fs_updt_assign>-recquan = <fs_doc>-zqtde_cont.

                          CALL FUNCTION '/XNFE/B2BNFE_MODIFY_ASSIGNMENT'
                            EXPORTING
                              iv_guid_header  = <fs_assign>-guid_header
                              it_nfeassign    = lt_updt_assign
                            EXCEPTIONS
                              technical_error = 1
                              OTHERS          = 2.

                          IF sy-subrc IS INITIAL.
                            <fs_doc>-zconcl = abap_true.
                          ENDIF.

                        ENDIF.
                      ENDIF.

                    ELSE.

                      IF lt_updt_assign[] IS NOT INITIAL.

                        READ TABLE lt_updt_assign ASSIGNING <fs_updt_assign>
                                                   WITH KEY guid_header = <fs_assign>-guid_header
                                                            nitem       = <fs_assign>-nitem
                                                            BINARY SEARCH.
                        IF sy-subrc IS INITIAL.

                          <fs_updt_assign>-recquan = <fs_doc>-zqtde_cont.

                          CALL FUNCTION '/XNFE/B2BNFE_MODIFY_ASSIGNMENT'
                            EXPORTING
                              iv_guid_header  = <fs_assign>-guid_header
                              it_nfeassign    = lt_updt_assign
                            EXCEPTIONS
                              technical_error = 1
                              OTHERS          = 2.

                          IF sy-subrc IS INITIAL.

                            <fs_doc>-zconcl = abap_true.

                            FREE: lt_mseg_aux[].

                            SHIFT <fs_doc>-nfenum LEFT DELETING LEADING '0'.

                            SORT lt_receb BY nfenum
                                             lifnr
                                             matnr.

                            READ TABLE  lt_receb TRANSPORTING NO FIELDS
                                                                   WITH KEY nfenum = |{ <fs_doc>-nfenum ALPHA = OUT }|
                                                                            lifnr  = <fs_doc>-lifnr
                                                                            matnr  = <fs_doc>-matnr
                                                                            BINARY SEARCH.
                            IF sy-subrc IS INITIAL.

                              LOOP AT  lt_receb ASSIGNING FIELD-SYMBOL(<fs_receb_updt>) FROM sy-tabix.
                                IF <fs_receb_updt>-nfenum NE <fs_doc>-nfenum
                                OR <fs_receb_updt>-lifnr  NE <fs_doc>-lifnr
                                OR <fs_receb_updt>-matnr  NE <fs_doc>-matnr
                                OR <fs_receb_updt>-zconcl EQ abap_true.
                                  EXIT.
                                ENDIF.

                                IF <fs_receb_updt>-zqtde_nf NE <fs_receb_updt>-zqtde_cont.

                                  lv_dif = <fs_receb_updt>-zqtde_nf - <fs_receb_updt>-zqtde_cont.

                                  CLEAR lv_mseg_2.
                                  READ TABLE lt_mseg TRANSPORTING NO FIELDS
                                                                  WITH KEY mblnr = <fs_assign>-matdoc
                                                                           matnr = <fs_receb_updt>-matnr
                                                                           charg  = <fs_receb_updt>-charg
                                                                           BINARY SEARCH.
                                  IF sy-subrc IS NOT INITIAL.
                                    lv_mseg_2 = abap_true.

                                    READ TABLE lt_mseg TRANSPORTING NO FIELDS
                                                                    WITH KEY mblnr = <fs_assign>-matdoc
                                                                             matnr = <fs_receb_updt>-matnr
                                                                             BINARY SEARCH.
                                  ENDIF.

                                  IF sy-subrc IS INITIAL.
                                    LOOP AT lt_mseg ASSIGNING FIELD-SYMBOL(<fs_mseg>) FROM sy-tabix.

                                      IF lv_mseg_2 IS INITIAL.
                                        IF <fs_mseg>-mblnr NE <fs_assign>-matdoc
                                        OR <fs_mseg>-matnr NE <fs_receb_updt>-matnr
                                        OR <fs_mseg>-charg NE <fs_receb_updt>-charg.
                                          EXIT.
                                        ENDIF.
                                      ELSE.
                                        IF <fs_mseg>-mblnr NE <fs_assign>-matdoc
                                        OR <fs_mseg>-matnr NE <fs_receb_updt>-matnr.
                                          EXIT.
                                        ENDIF.
                                      ENDIF.

                                      IF <fs_mseg>-menge GE lv_dif.

                                        <fs_receb_updt>-zconcl = abap_true.
                                        lv_exec = abap_true.

                                        <fs_mseg>-menge = <fs_mseg>-menge - lv_dif.
                                        APPEND <fs_mseg> TO lt_mseg_aux.

                                      ENDIF.

                                    ENDLOOP.
                                  ENDIF.
                                ENDIF.
                              ENDLOOP.

                              IF lv_exec IS NOT INITIAL.

                                CLEAR lv_exec.

                                LOOP AT lt_mseg_aux ASSIGNING <fs_mseg>. " Bloqueio

                                  CLEAR lv_materialdocument.

                                  FREE: lt_goodsmvt_item[].

                                  ls_goodsmvt_header-pstng_date = sy-datum.
                                  ls_goodsmvt_header-doc_date   = sy-datum.
                                  ls_goodsmvt_header-ref_doc_no = <fs_mseg>-xblnr_mkpf.

                                  ls_goodsmvt_code-gm_code = gc_values-v04.

                                  lt_goodsmvt_item = VALUE #( BASE lt_goodsmvt_item (
                                         material  = <fs_mseg>-matnr
                                         plant     = <fs_mseg>-werks
                                         stge_loc  = <fs_mseg>-lgort
                                         batch     = <fs_mseg>-charg
                                         move_type = gc_values-v344
                                         entry_qnt = lv_dif
                                         stck_type = gc_values-v3
                                         entry_uom = <fs_mseg>-meins ) ).

                                  CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
                                    EXPORTING
                                      goodsmvt_header  = ls_goodsmvt_header
                                      goodsmvt_code    = ls_goodsmvt_code
                                    IMPORTING
                                      materialdocument = lv_materialdocument
                                    TABLES
                                      goodsmvt_item    = lt_goodsmvt_item
                                      return           = lt_return.

                                  IF lv_materialdocument IS NOT INITIAL.
                                    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
                                  ELSE.
                                    <fs_doc>-zconcl = abap_false.
                                  ENDIF.

                                ENDLOOP.

                              ENDIF.

                            ELSE.
                              <fs_doc>-zconcl = abap_false.
                            ENDIF.
                          ENDIF.
                        ENDIF.
                      ENDIF.
                    ENDIF.
                  ENDIF.
                ENDIF.

                UNPACK <fs_doc>-nfenum TO <fs_doc>-nfenum.

              ENDLOOP.

              CALL FUNCTION '/XNFE/B2BNFE_DB_UPDATE'
                EXPORTING
                  wo_dequeue = abap_false
                EXCEPTIONS
                  db_error   = 1
                  OTHERS     = 2.

              IF sy-subrc NE 0.
                MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1
                                                                       sy-msgv2
                                                                       sy-msgv3
                                                                       sy-msgv4.
              ENDIF.

            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.

      IF lt_receb_sum IS NOT INITIAL.

        MODIFY ztmm_wms_receb FROM TABLE lt_receb_sum.

        IF sy-subrc IS INITIAL.
          COMMIT WORK.
        ENDIF.

      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD liberado.

    DATA(lv_idnfe) = VALUE /xnfe/guid_16( it_receb[ 1 ]-idnfenum OPTIONAL ).

    CHECK lv_idnfe IS NOT INITIAL.

    SELECT SINGLE 'X' FROM /xnfe/innfehd
    WHERE guid_header = @lv_idnfe
    AND ( actstat EQ '11'
       OR  actstat EQ '99' )
    INTO @rv_result.

  ENDMETHOD.

ENDCLASS.
