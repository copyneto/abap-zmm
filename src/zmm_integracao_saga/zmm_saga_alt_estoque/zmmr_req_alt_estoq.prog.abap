***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: JOB Altera Estoque SAGA WMS                            *
*** AUTOR    : Flavia Nunes – META                                    *
*** FUNCIONAL: Fábio Delgado – META                                   *
*** DATA     : 25/02/2022                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR        | DESCRIÇÃO                              *
***-------------------------------------------------------------------*
***           |              |                                        *
***********************************************************************
*&---------------------------------------------------------------------*
*& Report ZMMR_REQ_ALT_ESTOQ
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmmr_req_alt_estoq.

TYPES: BEGIN OF ty_receb,
         nfenum     TYPE  /xnfe/nnf,
         lifnr      TYPE  lifnr,
         stcd1      TYPE stcd1,
         itmnum     TYPE j_1bitmnum,
         charg      TYPE charg_d,
         vbeln      TYPE j_1brefkey,
         lfart      TYPE lfart,
         werks      TYPE werks_d,
         matnr      TYPE  /xnfe/po_matnr,
         zqtde_nf   TYPE  ze_qtd_nf,
         zqtde_cont TYPE ze_qtd_cont,
         zconcl     TYPE ze_rec_concl,
         zarmaz     TYPE ze_lib_arm,
         idnfenum   TYPE  /xnfe/id,
       END OF ty_receb.

CONSTANTS: BEGIN OF gc_values,
             v100       TYPE /xnfe/statuscode VALUE '100',
             v1         TYPE j_1bdirect  VALUE '1',
             v6         TYPE j_1bdoctyp  VALUE '6',
             ik         TYPE j_1bnftype  VALUE 'IK',
             il         TYPE j_1bnftype  VALUE 'IL',
           END OF gc_values.

TYPES: ty_receb_change TYPE STANDARD TABLE OF ty_receb WITH DEFAULT KEY,
       ty_receb_save   TYPE STANDARD TABLE OF ztmm_wms_receb WITH DEFAULT KEY.

DATA: lr_lfart        TYPE RANGE OF lfart.

START-OF-SELECTION.
  PERFORM f_main.

*&---------------------------------------------------------------------*
*& FORM F_MAIN
*&---------------------------------------------------------------------*
FORM f_main.

  DATA: lt_receb_dev    TYPE STANDARD TABLE OF ztmm_wms_receb,
        lt_receb_change TYPE ty_receb_change.

  DATA: ls_output TYPE zclmm_dt_envia_altera_requisic.

  DATA: lv_matnr TYPE matnr,
        lv_qtd   TYPE string.

  SELECT *
    FROM ztmm_wms_receb
   WHERE zarmaz EQ @space
     AND zconcl EQ @abap_true
    INTO TABLE @DATA(lt_receb).

  IF sy-subrc IS INITIAL.

    lt_receb_change = VALUE ty_receb_change( FOR ls_receb IN lt_receb (
                                             nfenum     = CONV /xnfe/nnf( ls_receb-nfenum )
                                             lifnr      = ls_receb-lifnr
                                             stcd1      = ls_receb-stcd1
                                             itmnum     = ls_receb-itmnum
                                             charg      = ls_receb-charg
                                             vbeln      = ls_receb-vbeln
                                             lfart      = ls_receb-lfart
                                             werks      = ls_receb-werks
                                             matnr      = ls_receb-matnr
                                             zqtde_nf   = ls_receb-zqtde_nf
                                             zqtde_cont = ls_receb-zqtde_cont
                                             zconcl     = ls_receb-zconcl
                                             zarmaz     = ls_receb-zarmaz
                                             idnfenum   = ls_receb-idnfenum ) ).

    IF lt_receb_change IS NOT INITIAL.

      " Entrada
      SELECT nnf,
             nprot
        FROM zi_mm_altestoq_innfehd
         FOR ALL ENTRIES IN @lt_receb_change
       WHERE nnf     = @lt_receb_change-nfenum
         AND statcod = @gc_values-v100
        INTO TABLE @DATA(lt_innfehd).

      IF sy-subrc EQ 0.

        SORT lt_innfehd BY nnf.

        LOOP AT lt_receb_change ASSIGNING FIELD-SYMBOL(<fs_receb>).

          READ TABLE lt_innfehd ASSIGNING FIELD-SYMBOL(<fs_innfehd>)
                                              WITH KEY nnf = <fs_receb>-nfenum
                                              BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            DATA(lv_nprot) = <fs_innfehd>-nprot.
          ELSE.
            CLEAR lv_nprot.
          ENDIF.

          IF lv_nprot IS NOT INITIAL.

            PACK <fs_receb>-matnr TO <fs_receb>-matnr.

            CONDENSE <fs_receb>-matnr NO-GAPS.

            TRY.

                NEW zclmm_co_si_envia_altera_requi( )->si_envia_altera_requisicao_out(
                          EXPORTING
                             output = VALUE #( mt_envia_altera_requisicao = VALUE #(  centro     = <fs_receb>-werks
                                                                                      numero     = COND #( WHEN <fs_receb>-vbeln IS NOT INITIAL THEN <fs_receb>-vbeln ELSE <fs_receb>-nfenum  && '/' && lv_nprot )
                                                                                      numeroitem = <fs_receb>-itmnum
                                                                                      quantidade = <fs_receb>-zqtde_cont
                                                                                      material   = |{ <fs_receb>-matnr ALPHA = OUT }| )
                                                                                      ) ).
                UNPACK <fs_receb>-matnr TO <fs_receb>-matnr.
                <fs_receb>-zarmaz = abap_true.

              CATCH cx_root.
            ENDTRY.

          ENDIF.

          CLEAR: ls_output.

        ENDLOOP.

      ENDIF.
    ENDIF.


    IF lt_receb_change IS NOT INITIAL.

      DATA(lt_receb_save) = VALUE ty_receb_save( FOR ls_receb_save IN lt_receb_change (
                                                 nfenum     = CONV j_1bnfnum9( ls_receb_save-nfenum )
                                                 lifnr      = ls_receb_save-lifnr
                                                 stcd1      = ls_receb_save-stcd1
                                                 itmnum     = ls_receb_save-itmnum
                                                 charg      = ls_receb_save-charg
                                                 vbeln      = ls_receb_save-vbeln
                                                 lfart      = ls_receb_save-lfart
                                                 werks      = ls_receb_save-werks
                                                 matnr      = ls_receb_save-matnr
                                                 zqtde_nf   = ls_receb_save-zqtde_nf
                                                 zqtde_cont = ls_receb_save-zqtde_cont
                                                 zconcl     = ls_receb_save-zconcl
                                                 zarmaz     = ls_receb_save-zarmaz
                                                 idnfenum   = ls_receb_save-idnfenum
                                                 ) ).

      MODIFY ztmm_wms_receb FROM TABLE lt_receb_save.

      IF sy-subrc EQ 0.
        COMMIT WORK.
      ENDIF.

      WRITE: TEXT-002.

    ENDIF.

    DATA(lt_receb_fae) = lt_receb[].
    SORT lt_receb_fae BY nfenum.
    DELETE ADJACENT DUPLICATES FROM lt_receb_fae COMPARING nfenum.

    IF lt_receb_fae[] IS NOT INITIAL.

      " Devolução
      SELECT br_notafiscal AS docnum,
             br_nfenumber  AS nfenum
        FROM i_br_nfdocument
         FOR ALL ENTRIES IN @lt_receb_fae
       WHERE br_nfenumber      = @lt_receb_fae-nfenum
         AND br_nfdirection    = @gc_values-v1
         AND br_nfdocumenttype = @gc_values-v6
         AND br_nftype         IN ( @gc_values-ik, @gc_values-il )
        INTO TABLE @DATA(lt_1bnfdoc).

      IF sy-subrc EQ 0.

        SORT lt_1bnfdoc BY nfenum.

        DATA(lt_doc_fae) = lt_1bnfdoc[].
        SORT lt_doc_fae BY docnum.
        DELETE ADJACENT DUPLICATES FROM lt_doc_fae COMPARING docnum.

        SELECT br_notafiscal             AS docnum,
               br_notafiscalitem         AS itmnum,
               br_nfsourcedocumentnumber AS refkey
          FROM i_br_nfitem
           FOR ALL ENTRIES IN @lt_doc_fae
         WHERE br_notafiscal = @lt_doc_fae-docnum
          INTO TABLE @DATA(lt_lin).

        IF sy-subrc IS INITIAL.
          SORT lt_lin BY docnum.

          DATA(lt_lin_fae) = lt_lin[].
          SORT lt_lin_fae BY refkey.
          DELETE ADJACENT DUPLICATES FROM lt_lin_fae COMPARING refkey.

          SELECT vbeln,
                 vgbel
            FROM vbrp
             FOR ALL ENTRIES IN @lt_lin_fae
           WHERE vbeln = @lt_lin_fae-refkey(10)
            INTO TABLE @DATA(lt_vbrp).

          IF sy-subrc IS INITIAL.
            SORT lt_vbrp BY vbeln.
          ENDIF.
        ENDIF.

        LOOP AT lt_receb ASSIGNING FIELD-SYMBOL(<fs_rec>).

          READ TABLE lt_1bnfdoc ASSIGNING FIELD-SYMBOL(<fs_1bnfdoc>)
                                              WITH KEY nfenum = <fs_rec>-nfenum
                                              BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            DATA(lv_docnum) = <fs_1bnfdoc>-docnum.
          ELSE.
            CLEAR lv_docnum.
          ENDIF.

          IF lv_docnum IS NOT INITIAL.

            READ TABLE lt_lin ASSIGNING FIELD-SYMBOL(<fs_lin>)
                                            WITH KEY docnum = lv_docnum
                                            BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              DATA(lv_refkey) = <fs_lin>-refkey.
            ELSE.
              CLEAR lv_refkey.
            ENDIF.

            IF lv_refkey IS NOT INITIAL.

              READ TABLE lt_vbrp ASSIGNING FIELD-SYMBOL(<fs_vbrp>)
                                               WITH KEY vbeln = lv_refkey
                                               BINARY SEARCH.
              IF sy-subrc IS INITIAL.
                DATA(lv_vgbel) = <fs_vbrp>-vgbel.
              ELSE.
                CLEAR lv_vgbel.
              ENDIF.

              IF lv_vgbel IS NOT INITIAL.

                PACK <fs_rec>-matnr TO <fs_rec>-matnr.

                CONDENSE <fs_rec>-matnr NO-GAPS.

                CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
                  EXPORTING
                    input  = <fs_rec>-matnr
                  IMPORTING
                    output = lv_matnr.

                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                  EXPORTING
                    input  = lv_vgbel
                  IMPORTING
                    output = lv_vgbel.

                TRY.

                    lv_qtd = <fs_rec>-zqtde_cont.
                    CONDENSE lv_qtd NO-GAPS.

                    NEW zclmm_co_si_envia_altera_requi( )->si_envia_altera_requisicao_out(
                              EXPORTING
                                 output = VALUE #( mt_envia_altera_requisicao = VALUE #( centro     = <fs_rec>-werks
                                                                                         numero     = lv_vgbel
                                                                                         numeroitem = <fs_rec>-itmnum
                                                                                         quantidade = lv_qtd
                                                                                         material   = lv_matnr ) ) ).

                    UNPACK <fs_rec>-matnr TO <fs_rec>-matnr.
                    <fs_rec>-zarmaz = abap_true.

                    APPEND <fs_rec> TO lt_receb_dev.

                  CATCH cx_root.
                ENDTRY.
              ENDIF.
            ENDIF.
          ENDIF.

          CLEAR: ls_output.

        ENDLOOP.

        IF lt_receb_dev IS NOT INITIAL.

          MODIFY ztmm_wms_receb FROM TABLE lt_receb_dev.

          IF sy-subrc EQ 0.
            COMMIT WORK.
          ENDIF.
        ENDIF.

      ENDIF.
    ENDIF.

  ELSE.

    IF sy-batch EQ abap_true.
      WRITE: TEXT-003.
    ENDIF.

  ENDIF.
ENDFORM.
