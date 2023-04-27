class ZCLMM_TRANSF_LPP definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF ty_cond,
             kschl  TYPE kschl,
             kwert  TYPE kwert,
             taxgrp TYPE j_1btaxgrp,
             lppid  TYPE j_1blppid,
           END OF ty_cond .
  types:
    tt_lpp  TYPE STANDARD TABLE OF j_1blpp .
  types:
    tt_cond TYPE STANDARD TABLE OF ty_cond WITH DEFAULT KEY .

  methods RECALC_LPP
    importing
      !IV_DOCNUM type J_1BNFDOC-DOCNUM
      !IV_UPDATE type BOOLEAN optional
    exporting
      !ET_LPP type ZCTGMM_J_1BLPP .
  methods CHECK_LPP
    importing
      !IV_DOCNUM type J_1BDOCNUM
    exporting
      !EV_NT_RELEVANT type BOOLEAN .
  methods RECALC_LPP_SAVE
    importing
      !IS_MSEG type MSEG optional
      !IS_KOMV type KOMV optional
      !IT_COND type TT_COND optional
    changing
      !CT_1BLPP type TT_LPP .
  methods RECALC_LPP_ITENS
    importing
      !IV_DOCNUM type J_1BNFDOC-DOCNUM
      !IV_UPDATE type BOOLEAN
    exporting
      !ET_LPP type ZCTGMM_J_1BLPP .
  PROTECTED SECTION.
private section.

  methods CALCULATE_AVERAGE
    importing
      !IV_ICMSAVR type J_1BICMSAVR
      !IV_LBKUM type RSEG-LBKUM
      !IV_MENGE type RSEG-MENGE
      !IV_UMREZ type UMREZ
      !IV_UMREN type UMREN
      !IV_SUBTVAL type J_1BSUBTVAL
    changing
      !CV_SUBTAVR type J_1BSUBTAVR .
  methods CHECK_COMPLEMENTARY_DOC
    importing
      !IV_NF_DOCNUM type J_1BDOCNUM
      !IV_NF_LPP_DOCNUM type J_1BDOCNUM
    changing
      !CV_HAS_COMPL_DOC type C .
ENDCLASS.



CLASS ZCLMM_TRANSF_LPP IMPLEMENTATION.


  METHOD calculate_average.

    CHECK iv_lbkum <> 0.

    cv_subtavr = ( iv_icmsavr * ( iv_lbkum - ( iv_menge * iv_umrez / iv_umren ) ) + iv_subtval ) / iv_lbkum .

  ENDMETHOD.


  METHOD check_complementary_doc.

    IF iv_nf_docnum <> 0 AND iv_nf_docnum = iv_nf_lpp_docnum.
      cv_has_compl_doc = 'X'.
    ELSE.
      cv_has_compl_doc = ' '.
    ENDIF.

  ENDMETHOD.


  METHOD check_lpp.

    DATA: lv_lppid TYPE flag.

    CHECK iv_docnum IS NOT INITIAL.

*    SELECT matnr,
*           bwkey,
*           bwtar,
*           lppid
*      FROM j_1blpp
*     WHERE docref = @iv_docnum
*      INTO @DATA(ls_j_1blpp)
*      UP TO 1 ROWS.
*    ENDSELECT.
*
*    IF sy-subrc IS INITIAL.
*      ev_nt_relevant = abap_true.
*      RETURN.
*    ENDIF.

    SELECT SINGLE docnum,
                  direct
      FROM j_1bnfdoc AS a
     WHERE docnum = @iv_docnum
      INTO @DATA(ls_doc).

    IF sy-subrc IS INITIAL.

      " Only reverse the LPP if this nf has set it. for it this
      " Nota Fiscal needs to be an incoming NF (direct = 1 or 4).
      IF ls_doc-direct = 1
      OR ls_doc-direct = 4.

        SELECT docnum,
               itmnum,
               matnr,
               bwkey,
               bwtar,
               menge,
               kalsm,
               mwskz
          FROM j_1bnflin
         WHERE docnum = @iv_docnum
          INTO TABLE @DATA(lt_lin).

        IF sy-subrc IS INITIAL.

          SORT lt_lin BY docnum ASCENDING
                         itmnum DESCENDING.

          READ TABLE lt_lin ASSIGNING FIELD-SYMBOL(<fs_lin>) INDEX 1.
          IF sy-subrc IS INITIAL.

            CALL FUNCTION 'J_1B_LPP_CHECK'
              EXPORTING
                matnr = <fs_lin>-matnr
                bwkey = <fs_lin>-bwkey
                bwtar = <fs_lin>-bwtar
                menge = <fs_lin>-menge
                kalsm = <fs_lin>-kalsm
                mwskz = <fs_lin>-mwskz
              CHANGING
                lppid = lv_lppid.

            " Item not relevant
            IF lv_lppid IS INITIAL.
              ev_nt_relevant = abap_true.
              RETURN.
            ENDIF.
          ENDIF.
        ENDIF.

      ELSE.
        ev_nt_relevant = abap_true.
      ENDIF.

    ELSE.
      ev_nt_relevant = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD recalc_lpp.

    DATA: lt_nf_tax   TYPE STANDARD TABLE OF j_1btxdata,
          lt_lpp_updt TYPE STANDARD TABLE OF j_1blpp.

    DATA: lv_ipi            TYPE c,
          lv_lpp            TYPE c,
          lv_lppid          TYPE flag,
          lv_taxval         TYPE j_1btaxval,
          lv_icmsval        TYPE j_1blpp-icmsval,
          lv_subtval        TYPE j_1blpp-subtval,
          lv_has_compl_docs TYPE c VALUE ' '.

    CHECK iv_docnum IS NOT INITIAL.

    check_lpp( EXPORTING iv_docnum      = iv_docnum
               IMPORTING ev_nt_relevant = DATA(lv_ntrelev) ).

    IF lv_ntrelev IS INITIAL.

      SELECT matnr,
             bwkey,
             bwtar
        FROM j_1bnflin
       WHERE docnum = @iv_docnum
        INTO @DATA(ls_key)
          UP TO 1 ROWS.
      ENDSELECT.

      IF sy-subrc IS NOT INITIAL.
        RETURN.
      ENDIF.

      SELECT br_notafiscal     AS docnum,
             br_notafiscalitem AS itmnum,
             matnr,
             bwkey,
             bwtar,
             menge,
             meins,
             netpr,
             kalsm,
             mwskz,
             refkey,
             refitm
        FROM zi_mm_lpp_docitem_proc
       WHERE matnr = @ls_key-matnr
         AND bwkey = @ls_key-bwkey
         AND bwtar = @ls_key-bwtar
        INTO TABLE @DATA(lt_lin).

      IF sy-subrc IS INITIAL.
        SORT lt_lin BY docnum DESCENDING.

*        IF lines( lt_lin ) >= 2.
*          READ TABLE lt_lin INTO DATA(ls_lin) INDEX 2.
*        ELSE.
        READ TABLE lt_lin INTO DATA(ls_lin) INDEX 1.
*        ENDIF.
      ELSE.

        SELECT matnr,
               bwkey,
               bwtar,
               lppid,
               lppnet,
               lppbrt,
               icmsval,
               subtval,
               icmsavr,
               subtavr,
               docref,
               zipival
          FROM j_1blpp
         WHERE matnr = @ls_key-matnr
           AND bwkey = @ls_key-bwkey
           AND bwtar = @ls_key-bwtar
          INTO TABLE @DATA(lt_lpp_firts).

        IF lt_lpp_firts IS NOT INITIAL.

          CLEAR: lt_lpp_firts[ 1 ]-lppnet,
                 lt_lpp_firts[ 1 ]-lppbrt,
                 lt_lpp_firts[ 1 ]-icmsval,
                 lt_lpp_firts[ 1 ]-subtval,
                 lt_lpp_firts[ 1 ]-icmsavr,
                 lt_lpp_firts[ 1 ]-subtavr,
                 lt_lpp_firts[ 1 ]-docref,
                 lt_lpp_firts[ 1 ]-zipival.

*          lt_lpp_firts[ 1 ]-lppid = 'S'.

          CALL FUNCTION 'ZFMMM_UPDATE_LPP'
            STARTING NEW TASK 'ZMM_UPDT_LPP'
            EXPORTING
              it_lpp = lt_lpp_firts.

        ENDIF.

        RETURN.

      ENDIF.

      SELECT SINGLE docnum,
                    docref,
                    doctyp
        FROM j_1bnfdoc
       WHERE docnum = @ls_lin-docnum
        INTO @DATA(ls_j1bnfdoc).

      SELECT SINGLE belnr,
                    gjahr,
                    buzei,
                    lbkum,
                    menge,
                    ebeln,
                    ebelp,
                    orderitemqtytobaseqtynmrtr  AS umrez,
                    orderitemqtytobaseqtydnmntr AS umren
        FROM rseg AS a
       INNER JOIN i_purchaseorderitem AS b ON b~purchaseorder     = a~ebeln
                                          AND b~purchaseorderitem = a~ebelp
       WHERE belnr = @ls_lin-refkey(10)
         AND gjahr = @ls_lin-refkey+10(4)
         AND buzei = @ls_lin-refitm
        INTO @DATA(ls_rseg).

      IF sy-subrc IS INITIAL.
        DATA(lv_menge) = ls_rseg-menge.
        DATA(lv_umrez) = ls_rseg-umrez.
        DATA(lv_umren) = ls_rseg-umren.
        DATA(lv_lbkum) = ls_rseg-lbkum.
      ENDIF.

      SELECT mandt,
             matnr,
             bwkey,
             bwtar,
             lppid,
             lppnet,
             lppbrt,
             icmsval,
             subtval,
             icmsavr,
             subtavr,
             docref,
             zipival
        FROM j_1blpp
       WHERE matnr = @ls_lin-matnr
         AND bwkey = @ls_lin-bwkey
         AND bwtar = @ls_lin-bwtar
        INTO TABLE @DATA(lt_lpp).

      IF sy-subrc IS INITIAL.
        SORT lt_lpp BY matnr
                       bwkey
                       bwtar
                       lppid.
      ENDIF.

      SELECT 'I'    AS sign,
             'EQ'   AS option,
             taxtyp AS low,
             taxtyp AS high
        FROM j_1baj
       WHERE taxgrp EQ 'IPI'
         AND lppact EQ @abap_true
        INTO TABLE @DATA(lt_ipi).

      SELECT 'I'    AS sign,
             'EQ'   AS option,
             taxtyp AS low,
             taxtyp AS high
        FROM j_1baj
       WHERE taxgrp EQ 'ICMS'
         AND lppact EQ @abap_true
        INTO TABLE @DATA(lt_icms).

      SELECT 'I'    AS sign,
             'EQ'   AS option,
             taxtyp AS low,
             taxtyp AS high
        FROM j_1baj
       WHERE taxgrp EQ 'ICST'
         AND lppact EQ @abap_true
        INTO TABLE @DATA(lt_icst).

      SELECT SINGLE matnr,
                    bwkey,
                    bwtar,
                    mtuse
        FROM mbew
       WHERE matnr = @ls_lin-matnr
         AND bwkey = @ls_lin-bwkey
         AND bwtar = @ls_lin-bwtar
        INTO @DATA(ls_mbew).

      SELECT br_notafiscal      AS docnum,
             br_notafiscalitem  AS itmnum,
             br_taxtype         AS taxtyp,
             taxgroup           AS taxgrp,
             br_nfitemtaxamount AS taxval
        FROM i_br_nftax
       WHERE br_notafiscal     = @ls_lin-docnum
         AND br_notafiscalitem = @ls_lin-itmnum
        INTO TABLE @DATA(lt_nftax).

      READ TABLE lt_lpp ASSIGNING FIELD-SYMBOL(<fs_lpp>)
                                      WITH KEY matnr = ls_lin-matnr
                                               bwkey = ls_lin-bwkey
                                               bwtar = ls_lin-bwtar
                                               BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        <fs_lpp>-lppnet = ls_lin-netpr.
        <fs_lpp>-lppbrt = ls_lin-netpr.
      ENDIF.

      LOOP AT lt_nftax ASSIGNING FIELD-SYMBOL(<fs_nf_tax>).

*        CLEAR lv_lppid.
*        CALL FUNCTION 'J_1B_LPP_CHECK'
*          EXPORTING
*            matnr = ls_lin-matnr
*            bwkey = ls_lin-bwkey
*            bwtar = ls_lin-bwtar
*            menge = ls_lin-menge
*            kalsm = ls_lin-kalsm
*            mwskz = ls_lin-mwskz
*          CHANGING
*            lppid = lv_lppid.
        lv_lppid = 'S'.

        READ TABLE lt_lpp ASSIGNING <fs_lpp>
                           WITH KEY matnr = ls_lin-matnr
                                    bwkey = ls_lin-bwkey
                                    bwtar = ls_lin-bwtar
                                    lppid = lv_lppid
                                    BINARY SEARCH.
        IF sy-subrc IS INITIAL.

          check_complementary_doc( EXPORTING iv_nf_docnum     = ls_j1bnfdoc-docref
                                             iv_nf_lpp_docnum = <fs_lpp>-docref
                                    CHANGING cv_has_compl_doc = lv_has_compl_docs ).

          CALL FUNCTION 'J_1B_READ_J1BAJ'
            EXPORTING
              i_kschl    = <fs_nf_tax>-taxtyp
            IMPORTING
              e_flag_lpp = lv_lpp
              e_flag_ipi = lv_ipi
            EXCEPTIONS
              not_found  = 1
              OTHERS     = 2.

          IF sy-subrc IS INITIAL.

            lv_taxval = <fs_nf_tax>-taxval / ( lv_menge * lv_umrez / lv_umren ).

            IF lv_ipi = abap_true.
              <fs_lpp>-lppbrt = <fs_lpp>-lppbrt + lv_taxval.
            ELSE.
              CASE lv_lpp.
                WHEN 'I'.
                  <fs_lpp>-lppbrt = <fs_lpp>-lppbrt + lv_taxval.

                  " Check the existence of compl. documents
                  IF lv_has_compl_docs IS NOT INITIAL.
                    lv_icmsval = lv_icmsval + lv_taxval.
                  ELSEIF ls_j1bnfdoc-doctyp <> '2'.
                    lv_icmsval = lv_taxval.
                  ENDIF.

                  <fs_lpp>-icmsval = lv_icmsval.

                  "--- GR-Quantity alread included in LBKUM !!------------
                  calculate_average( EXPORTING iv_icmsavr = <fs_lpp>-icmsavr
                                               iv_lbkum   = lv_lbkum
                                               iv_menge   = lv_menge
                                               iv_umrez   = lv_umrez
                                               iv_umren   = lv_umren
                                               iv_subtval = <fs_nf_tax>-taxval
                                      CHANGING cv_subtavr = <fs_lpp>-icmsavr ).

                WHEN 'S'.
                  <fs_lpp>-lppbrt = <fs_lpp>-lppbrt + lv_taxval.

                  " Check the existence of compl. documents
                  IF lv_has_compl_docs IS NOT INITIAL.
                    lv_subtval = lv_subtval + lv_taxval.
                  ELSE.
                    lv_subtval = lv_taxval.
                  ENDIF.

                  <fs_lpp>-subtval = lv_subtval.

                  calculate_average( EXPORTING iv_icmsavr = <fs_lpp>-subtavr
                                               iv_lbkum   = lv_lbkum
                                               iv_menge   = lv_menge
                                               iv_umrez   = lv_umrez
                                               iv_umren   = lv_umren
                                               iv_subtval = <fs_nf_tax>-taxval
                                      CHANGING cv_subtavr = <fs_lpp>-subtavr ).
              ENDCASE.
            ENDIF.
          ENDIF.

          IF <fs_nf_tax>-taxtyp IN lt_ipi.

            <fs_lpp>-docref = ls_lin-docnum.

            TRY.
                <fs_lpp>-zipival = <fs_nf_tax>-taxval / ( lv_menge * lv_umrez / lv_umren ).

              CATCH cx_sy_zerodivide.
            ENDTRY.

            IF lv_lpp EQ 'I'
            OR lv_ipi EQ abap_true.
              SUBTRACT <fs_lpp>-zipival FROM <fs_lpp>-lppbrt.
            ENDIF.

          ENDIF.

          IF <fs_nf_tax>-taxtyp IN lt_icms
         AND lv_lpp             EQ 'S'.

            <fs_lpp>-docref = ls_lin-docnum.

            TRY.

                <fs_lpp>-icmsval = <fs_nf_tax>-taxval / ( lv_menge * lv_umrez / lv_umren ).
                ADD <fs_lpp>-icmsval TO <fs_lpp>-lppbrt.

                calculate_average( EXPORTING iv_icmsavr = <fs_lpp>-icmsavr
                                             iv_lbkum   = lv_lbkum
                                             iv_menge   = lv_menge
                                             iv_umrez   = lv_umrez
                                             iv_umren   = lv_umren
                                             iv_subtval = <fs_lpp>-icmsval
                                    CHANGING cv_subtavr = <fs_lpp>-icmsavr ).

              CATCH cx_sy_zerodivide.
            ENDTRY.
          ENDIF.

          IF <fs_nf_tax>-taxtyp IN lt_icst
         AND lv_lpp             EQ 'S'.

            <fs_lpp>-docref = ls_lin-docnum.

            TRY.

*                IF ls_mbew-mtuse EQ '1'
*                OR ls_mbew-mtuse EQ '0'.
*                  <fs_lpp>-lppid = 'I'.
*
*                ELSEIF ls_mbew-mtuse EQ '2'
*                    OR ls_mbew-mtuse EQ '3'.
*                  <fs_lpp>-lppid = 'S'.
*                ENDIF.

                <fs_lpp>-lppid = 'S'.

                <fs_lpp>-subtval = <fs_nf_tax>-taxval / ( lv_menge * lv_umrez / lv_umren ).

                SUBTRACT <fs_lpp>-subtval FROM <fs_lpp>-lppbrt.

                calculate_average( EXPORTING iv_icmsavr = <fs_lpp>-subtavr
                                             iv_lbkum   = lv_lbkum
                                             iv_menge   = lv_menge
                                             iv_umrez   = lv_umrez
                                             iv_umren   = lv_umren
                                             iv_subtval = <fs_lpp>-subtval
                                    CHANGING cv_subtavr = <fs_lpp>-subtavr ).

              CATCH cx_sy_zerodivide.
            ENDTRY.
          ENDIF.

          <fs_lpp>-docref = ls_lin-docnum.

        ENDIF.
      ENDLOOP.

      et_lpp[] = lt_lpp[].

      IF lt_lpp[]  IS NOT INITIAL
     AND iv_update EQ abap_true.

        CALL FUNCTION 'ZFMMM_UPDATE_LPP'
          STARTING NEW TASK 'ZMM_UPDT_LPP'
          EXPORTING
            it_lpp = lt_lpp.

      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD recalc_lpp_save.

    DATA: lt_komv TYPE komv_t.

    DATA: lv_lppid          TYPE flag,
          lv_lpp            TYPE c,
          lv_ipi            TYPE c,
          lv_has_compl_docs TYPE c VALUE ' ',
          lv_icmsval        TYPE j_1blpp-icmsval,
          lv_subtval        TYPE j_1blpp-subtval,
          lv_taxval         TYPE j_1btaxval,
          lv_lppnet         TYPE j_1blppnet,
          lv_lppbrt         TYPE j_1blppbrt,
          lv_refkey         TYPE j_1bnflin-refkey,
          lv_limpar         TYPE char1.

    FIELD-SYMBOLS: <fs_t_komv> TYPE komv_t.

    DATA(lt_1blpp) = ct_1blpp[].

    SORT lt_1blpp BY matnr
                     bwkey
                     bwtar
                     lppid DESCENDING.

    DELETE ADJACENT DUPLICATES FROM lt_1blpp COMPARING matnr
                                                       bwkey
                                                       bwtar.

    READ TABLE lt_1blpp TRANSPORTING NO FIELDS
                                      WITH KEY matnr = is_mseg-matnr
                                               bwkey = is_mseg-werks
                                               bwtar = is_mseg-bwtar
                                               BINARY SEARCH.
    IF sy-subrc IS INITIAL.

      " Movimentação de estorno
      IF is_mseg-bwart = '863'.
        SELECT br_notafiscal     AS docnum,
               br_notafiscalitem AS itmnum,
               matnr,
               bwkey,
               bwtar,
               refkey,
               menge
          FROM zi_mm_lpp_docitem_proc
         WHERE matnr = @is_mseg-matnr
           AND bwkey = @is_mseg-werks
           AND bwtar = @is_mseg-bwtar
          INTO TABLE @DATA(lt_lin_all).

        IF sy-subrc IS INITIAL.
          SORT lt_lin_all BY matnr  ASCENDING
                             bwkey  ASCENDING
                             bwtar  ASCENDING
                             docnum DESCENDING.

          DATA(ls_lin_all) = VALUE #( lt_lin_all[ 1 ] OPTIONAL ).

          lv_refkey = is_mseg-mblnr && is_mseg-gjahr.

          " Verifica se o DOCNUM estornado é o atual na LPP
          " Se não for o atual, não precisa atualizar
          IF ls_lin_all-refkey NE lv_refkey.
            FREE: ct_1blpp[].
            RETURN.
          ELSE.

            IF lines( lt_lin_all ) > 2.

              ls_lin_all = VALUE #( lt_lin_all[ 2 ] OPTIONAL ).

              SELECT br_notafiscal      AS docnum,
                     br_notafiscalitem  AS itmnum,
                     br_taxtype         AS taxtyp,
                     taxgroup           AS taxgrp,
                     br_nfitemtaxamount AS taxval
                FROM i_br_nftax
               WHERE br_notafiscal     = @ls_lin_all-docnum
                 AND br_notafiscalitem = @ls_lin_all-itmnum
                INTO TABLE @DATA(lt_nftax).

              IF sy-subrc IS INITIAL.
                SORT lt_nftax BY taxtyp.
              ENDIF.

            ELSE.
              lv_limpar = abap_true.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.

      SELECT 'I'    AS sign,
             'EQ'   AS option,
             taxtyp AS low,
             taxtyp AS high
        FROM j_1baj
        INTO TABLE @DATA(lt_ipi)
       WHERE taxgrp EQ 'IPI'
         AND lppact EQ @abap_true.

      IF sy-subrc IS INITIAL.
        ASSIGN ('(SAPLJ1BN)XKOMV[]') TO <fs_t_komv>.
        IF <fs_t_komv> IS ASSIGNED.
          lt_komv = <fs_t_komv>[].

          SORT lt_komv BY kposn
                          kschl.
        ENDIF.
      ENDIF.

      SELECT 'I'    AS sign,
             'EQ'   AS option,
             taxtyp AS low,
             taxtyp AS high
        FROM j_1baj
        INTO TABLE @DATA(lt_icms)
       WHERE taxgrp EQ 'ICMS'
         AND lppact EQ @abap_true.

      SELECT 'I'    AS sign,
             'EQ'   AS option,
             taxtyp AS low,
             taxtyp AS high
        FROM j_1baj
        INTO TABLE @DATA(lt_icst)
       WHERE taxgrp EQ 'ICST'
         AND lppact EQ @abap_true.

      SELECT SINGLE umrez,
                    umren
        FROM ekpo
       WHERE ebeln = @is_mseg-ebeln
         AND ebelp = @is_mseg-ebelp
        INTO @DATA(ls_ekpo).

      LOOP AT lt_1blpp ASSIGNING FIELD-SYMBOL(<fs_1blpp>).
        IF <fs_1blpp>-matnr NE is_mseg-matnr
        OR <fs_1blpp>-bwkey NE is_mseg-werks
        OR <fs_1blpp>-bwtar NE is_mseg-bwtar.
          CONTINUE.
        ENDIF.

        LOOP AT it_cond ASSIGNING FIELD-SYMBOL(<fs_nf_tax>).

          IF <fs_nf_tax>-kschl EQ is_komv-kschl.

            CALL FUNCTION 'J_1B_READ_J1BAJ'
              EXPORTING
                i_kschl    = <fs_nf_tax>-kschl
              IMPORTING
                e_flag_lpp = lv_lpp
                e_flag_ipi = lv_ipi
              EXCEPTIONS
                not_found  = 1
                OTHERS     = 2.

            IF sy-subrc EQ 0.

              " Movimentação de estorno
              IF is_mseg-bwart = '863'.

                IF lv_limpar IS NOT INITIAL.
                  CLEAR: <fs_1blpp>-lppnet,
                         <fs_1blpp>-lppbrt,
                         <fs_1blpp>-icmsval,
                         <fs_1blpp>-subtval,
                         <fs_1blpp>-icmsavr,
                         <fs_1blpp>-subtavr,
                         <fs_1blpp>-docref,
                         <fs_1blpp>-zipival.

                  CONTINUE.
                ELSE.

                  <fs_1blpp>-docref = ls_lin_all-docnum.

                ENDIF.
              ENDIF.

              IF <fs_nf_tax>-kschl IN lt_ipi.
                TRY.
                    <fs_1blpp>-zipival = is_komv-kwert / ( is_mseg-menge * ls_ekpo-umrez / ls_ekpo-umren ).
                  CATCH cx_sy_zerodivide.
                ENDTRY.
              ENDIF.

              IF <fs_nf_tax>-kschl IN lt_icms.
                TRY.

                    <fs_1blpp>-icmsval = is_komv-kwert / ( is_mseg-menge * ls_ekpo-umrez / ls_ekpo-umren ).

                  CATCH cx_sy_zerodivide.
                ENDTRY.
              ENDIF.

              IF <fs_nf_tax>-kschl IN lt_icst
             AND lv_lpp            EQ 'S'.
                TRY.

                    <fs_1blpp>-subtval = is_komv-kwert / ( is_mseg-menge * ls_ekpo-umrez / ls_ekpo-umren ).

                  CATCH cx_sy_zerodivide.
                ENDTRY.
              ENDIF.
            ENDIF.
          ENDIF.

          <fs_1blpp>-lppid = 'S'.

        ENDLOOP.

        LOOP AT lt_ipi ASSIGNING FIELD-SYMBOL(<fs_ipi>).

          " Movimentação de estorno
          IF is_mseg-bwart = '863'.

            READ TABLE lt_nftax ASSIGNING FIELD-SYMBOL(<fs_nftax>)
                                              WITH KEY taxtyp = <fs_ipi>-low
                                              BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              <fs_1blpp>-zipival = <fs_nftax>-taxval / ( ls_lin_all-menge * ls_ekpo-umrez / ls_ekpo-umren ).
            ENDIF.

          ELSE.
            READ TABLE lt_komv ASSIGNING FIELD-SYMBOL(<fs_komv>)
                                             WITH KEY kposn = is_komv-kposn
                                                      kschl = <fs_ipi>-low
                                             BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              <fs_1blpp>-zipival = <fs_komv>-kwert / ( is_mseg-bstmg * ls_ekpo-umrez / ls_ekpo-umren ).
            ENDIF.
          ENDIF.
        ENDLOOP.

      ENDLOOP.

      ct_1blpp[] = lt_1blpp.

    ENDIF.

  ENDMETHOD.


  METHOD recalc_lpp_itens.

    TYPES: BEGIN OF ty_rseg_key,
             belnr TYPE rseg-belnr,
             gjahr TYPE rseg-gjahr,
             buzei TYPE rseg-buzei,
           END OF ty_rseg_key.

    DATA: lt_nf_tax   TYPE STANDARD TABLE OF j_1btxdata,
          lt_lpp_updt TYPE STANDARD TABLE OF j_1blpp,
          lt_rseg_key TYPE STANDARD TABLE OF ty_rseg_key.

    DATA: lv_ipi            TYPE c,
          lv_lpp            TYPE c,
          lv_lppid          TYPE flag,
          lv_taxval         TYPE j_1btaxval,
          lv_icmsval        TYPE j_1blpp-icmsval,
          lv_subtval        TYPE j_1blpp-subtval,
          lv_has_compl_docs TYPE c VALUE ' '.

    CHECK iv_docnum IS NOT INITIAL.

*    check_lpp( EXPORTING iv_docnum      = iv_docnum
*               IMPORTING ev_nt_relevant = DATA(lv_ntrelev) ).
*
*    IF lv_ntrelev IS INITIAL.

    SELECT matnr,
           bwkey,
           bwtar
      FROM j_1bnflin
     WHERE docnum = @iv_docnum
      INTO TABLE @DATA(lt_key).

    IF sy-subrc IS NOT INITIAL.
      RETURN.
    ENDIF.

    DATA(lt_key_fae) = lt_key[].
    SORT lt_key_fae BY matnr
                       bwkey
                       bwtar.
    DELETE ADJACENT DUPLICATES FROM lt_key_fae COMPARING matnr
                                                         bwkey
                                                         bwtar.

    IF lt_key_fae[] IS NOT INITIAL.

      SELECT br_notafiscal     AS docnum,
             br_notafiscalitem AS itmnum,
             matnr,
             bwkey,
             bwtar,
             menge,
             meins,
             netpr,
             kalsm,
             mwskz,
             refkey,
             refitm
        FROM zi_mm_lpp_docitem_proc
         FOR ALL ENTRIES IN @lt_key_fae
       WHERE matnr = @lt_key_fae-matnr
         AND bwkey = @lt_key_fae-bwkey
         AND bwtar = @lt_key_fae-bwtar
        INTO TABLE @DATA(lt_lin_all).

      IF sy-subrc IS INITIAL.
        SORT lt_lin_all BY matnr  ASCENDING
                           bwkey  ASCENDING
                           bwtar  ASCENDING
                           docnum DESCENDING.

        DATA(ls_lin_all) = VALUE #( lt_lin_all[ 1 ] OPTIONAL ).

        " Verifica se o DOCNUM estornado é o atual na LPP
        SELECT SINGLE COUNT(*)
          FROM j_1blpp
         WHERE matnr = @ls_lin_all-matnr
           AND bwkey = @ls_lin_all-bwkey
           AND bwtar = @ls_lin_all-bwtar
           AND lppid = 'S'
           AND docref = @ls_lin_all-docnum.

        " Se não for o atual, não precisa atualizar
        IF sy-subrc IS INITIAL.
          RETURN.
        ENDIF.

        DATA(lt_lin) = lt_lin_all[].

        DELETE ADJACENT DUPLICATES FROM lt_lin COMPARING matnr
                                                         bwkey
                                                         bwtar.
      ELSE.

        SELECT matnr,
               bwkey,
               bwtar,
               lppid,
               lppnet,
               lppbrt,
               icmsval,
               subtval,
               icmsavr,
               subtavr,
               docref,
               zipival
          FROM j_1blpp
           FOR ALL ENTRIES IN @lt_key_fae
         WHERE matnr = @lt_key_fae-matnr
           AND bwkey = @lt_key_fae-bwkey
           AND bwtar = @lt_key_fae-bwtar
           AND lppid = 'S'
          INTO TABLE @DATA(lt_lpp_firts).

        IF sy-subrc IS INITIAL.

          LOOP AT lt_lpp_firts ASSIGNING FIELD-SYMBOL(<fs_lpp_firts>).

            CLEAR: <fs_lpp_firts>-lppnet,
                   <fs_lpp_firts>-lppbrt,
                   <fs_lpp_firts>-icmsval,
                   <fs_lpp_firts>-subtval,
                   <fs_lpp_firts>-icmsavr,
                   <fs_lpp_firts>-subtavr,
                   <fs_lpp_firts>-docref,
                   <fs_lpp_firts>-zipival.

          ENDLOOP.

          CALL FUNCTION 'ZFMMM_UPDATE_LPP'
            STARTING NEW TASK 'ZMM_UPDT_LPP'
            EXPORTING
              it_lpp = lt_lpp_firts.
        ENDIF.

        RETURN.

      ENDIF.
    ENDIF.

    DATA(lt_lin_fae) = lt_lin[].
    SORT lt_lin_fae BY docnum.
    DELETE ADJACENT DUPLICATES FROM lt_lin_fae COMPARING docnum.

    IF lt_lin_fae[] IS NOT INITIAL.
      SELECT docnum,
             docref,
             doctyp
        FROM j_1bnfdoc
         FOR ALL ENTRIES IN @lt_lin_fae
       WHERE docnum = @lt_lin_fae-docnum
        INTO TABLE @DATA(lt_j1bnfdoc).

      IF sy-subrc IS INITIAL.
        SORT lt_j1bnfdoc BY docnum.
      ENDIF.
    ENDIF.

    lt_lin_fae = lt_lin[].
    SORT lt_lin_fae BY refkey
                       refitm.
    DELETE ADJACENT DUPLICATES FROM lt_lin_fae COMPARING refkey
                                                         refitm.

    lt_rseg_key = VALUE #( FOR ls_lin_fae IN lt_lin_fae (  belnr = ls_lin_fae-refkey(10)
                                                           gjahr = ls_lin_fae-refkey+10(4)
                                                           buzei = ls_lin_fae-refitm ) ).

    IF lt_rseg_key[] IS NOT INITIAL.
      SELECT belnr,
             gjahr,
             buzei,
             lbkum,
             menge,
             ebeln,
             ebelp,
             orderitemqtytobaseqtynmrtr  AS umrez,
             orderitemqtytobaseqtydnmntr AS umren
        FROM rseg AS a
       INNER JOIN i_purchaseorderitem AS b ON b~purchaseorder     = a~ebeln
                                          AND b~purchaseorderitem = a~ebelp
         FOR ALL ENTRIES IN @lt_rseg_key
       WHERE belnr = @lt_rseg_key-belnr
         AND gjahr = @lt_rseg_key-gjahr
         AND buzei = @lt_rseg_key-buzei
        INTO TABLE @DATA(lt_rseg).

      IF sy-subrc IS INITIAL.
        SORT lt_rseg BY belnr
                        gjahr
                        buzei.
      ENDIF.
    ENDIF.

    lt_lin_fae = lt_lin[].
    SORT lt_lin_fae BY matnr
                       bwkey
                       bwtar.
    DELETE ADJACENT DUPLICATES FROM lt_lin_fae COMPARING matnr
                                                         bwkey
                                                         bwtar.

    SELECT mandt,
           matnr,
           bwkey,
           bwtar,
           lppid,
           lppnet,
           lppbrt,
           icmsval,
           subtval,
           icmsavr,
           subtavr,
           docref,
           zipival
      FROM j_1blpp
       FOR ALL ENTRIES IN @lt_key_fae
     WHERE matnr = @lt_key_fae-matnr
       AND bwkey = @lt_key_fae-bwkey
       AND bwtar = @lt_key_fae-bwtar
       AND lppid = 'S'
      INTO TABLE @DATA(lt_lpp).

    IF sy-subrc IS INITIAL.
      SORT lt_lpp BY matnr
                     bwkey
                     bwtar.
    ENDIF.

    SELECT 'I'    AS sign,
           'EQ'   AS option,
           taxtyp AS low,
           taxtyp AS high
      FROM j_1baj
     WHERE taxgrp EQ 'IPI'
       AND lppact EQ @abap_true
      INTO TABLE @DATA(lt_ipi).

    SELECT 'I'    AS sign,
           'EQ'   AS option,
           taxtyp AS low,
           taxtyp AS high
      FROM j_1baj
     WHERE taxgrp EQ 'ICMS'
       AND lppact EQ @abap_true
      INTO TABLE @DATA(lt_icms).

    SELECT 'I'    AS sign,
           'EQ'   AS option,
           taxtyp AS low,
           taxtyp AS high
      FROM j_1baj
     WHERE taxgrp EQ 'ICST'
       AND lppact EQ @abap_true
      INTO TABLE @DATA(lt_icst).

    lt_lin_fae = lt_lin[].
    SORT lt_lin_fae BY docnum
                       itmnum.
    DELETE ADJACENT DUPLICATES FROM lt_lin_fae COMPARING docnum
                                                         itmnum.
    IF lt_lin_fae[] IS NOT INITIAL.
      SELECT br_notafiscal      AS docnum,
             br_notafiscalitem  AS itmnum,
             br_taxtype         AS taxtyp,
             taxgroup           AS taxgrp,
             br_nfitemtaxamount AS taxval
        FROM i_br_nftax
         FOR ALL ENTRIES IN @lt_lin_fae
       WHERE br_notafiscal     = @lt_lin_fae-docnum
         AND br_notafiscalitem = @lt_lin_fae-itmnum
        INTO TABLE @DATA(lt_nftax).

      IF sy-subrc IS INITIAL.
        SORT lt_nftax BY docnum
                         itmnum.
      ENDIF.
    ENDIF.

    SORT lt_lin BY matnr
                   bwkey
                   bwtar.

    " Resetar os valores
    LOOP AT lt_lpp ASSIGNING FIELD-SYMBOL(<fs_lpp>).

      READ TABLE lt_lin ASSIGNING FIELD-SYMBOL(<fs_lin>)
                                      WITH KEY matnr = <fs_lpp>-matnr
                                               bwkey = <fs_lpp>-bwkey
                                               bwtar = <fs_lpp>-bwtar
                                               BINARY SEARCH.
      IF sy-subrc IS INITIAL.

        READ TABLE lt_rseg ASSIGNING FIELD-SYMBOL(<fs_rseg>)
                                         WITH KEY belnr = <fs_lin>-refkey(10)
                                                  gjahr = <fs_lin>-refkey+10(4)
                                                  buzei = <fs_lin>-refitm
                                                  BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          DATA(lv_menge) = <fs_rseg>-menge.
          DATA(lv_umrez) = <fs_rseg>-umrez.
          DATA(lv_umren) = <fs_rseg>-umren.

          IF lv_umrez IS INITIAL.
            lv_umrez = 1.
          ENDIF.

          <fs_lpp>-lppnet = <fs_lin>-netpr / lv_umrez.
          <fs_lpp>-lppbrt = <fs_lin>-netpr / lv_umrez.

        ELSE.
          <fs_lpp>-lppnet = <fs_lin>-netpr.
          <fs_lpp>-lppbrt = <fs_lin>-netpr.
        ENDIF.
      ENDIF.

    ENDLOOP.

    LOOP AT lt_lpp ASSIGNING <fs_lpp>.

      READ TABLE lt_lin ASSIGNING <fs_lin>
                         WITH KEY matnr = <fs_lpp>-matnr
                                  bwkey = <fs_lpp>-bwkey
                                  bwtar = <fs_lpp>-bwtar
                                  BINARY SEARCH.
      IF sy-subrc IS INITIAL.

        READ TABLE lt_j1bnfdoc ASSIGNING FIELD-SYMBOL(<fs_j1bnfdoc>)
                                             WITH KEY docnum = <fs_lin>-docnum
                                             BINARY SEARCH.
        IF sy-subrc IS NOT INITIAL.
          CONTINUE.
        ENDIF.

        READ TABLE lt_rseg ASSIGNING <fs_rseg>
                            WITH KEY belnr = <fs_lin>-refkey(10)
                                     gjahr = <fs_lin>-refkey+10(4)
                                     buzei = <fs_lin>-refitm
                                     BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          lv_menge = <fs_rseg>-menge.
          lv_umrez = <fs_rseg>-umrez.
          lv_umren = <fs_rseg>-umren.
          DATA(lv_lbkum) = <fs_rseg>-lbkum.
        ELSE.
          CLEAR: lv_menge,
                 lv_umrez,
                 lv_umren,
                 lv_lbkum.
        ENDIF.

        READ TABLE lt_nftax TRANSPORTING NO FIELDS
                                          WITH KEY docnum = <fs_lin>-docnum
                                                   itmnum = <fs_lin>-itmnum
                                                   BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          LOOP AT lt_nftax ASSIGNING FIELD-SYMBOL(<fs_nf_tax>) FROM sy-tabix.
            IF <fs_nf_tax>-docnum NE <fs_lin>-docnum
            OR <fs_nf_tax>-itmnum NE <fs_lin>-itmnum.
              EXIT.
            ENDIF.

            check_complementary_doc( EXPORTING iv_nf_docnum     = <fs_j1bnfdoc>-docref
                                               iv_nf_lpp_docnum = <fs_lpp>-docref
                                      CHANGING cv_has_compl_doc = lv_has_compl_docs ).

            CALL FUNCTION 'J_1B_READ_J1BAJ'
              EXPORTING
                i_kschl    = <fs_nf_tax>-taxtyp
              IMPORTING
                e_flag_lpp = lv_lpp
                e_flag_ipi = lv_ipi
              EXCEPTIONS
                not_found  = 1
                OTHERS     = 2.

            IF sy-subrc IS INITIAL.

              lv_taxval = <fs_nf_tax>-taxval / ( lv_menge * lv_umrez / lv_umren ).

              IF lv_ipi = abap_true.
                <fs_lpp>-lppbrt = <fs_lpp>-lppbrt + lv_taxval.
              ELSE.
                CASE lv_lpp.
                  WHEN 'I'.
                    <fs_lpp>-lppbrt = <fs_lpp>-lppbrt + lv_taxval.

                    " Check the existence of compl. documents
                    IF lv_has_compl_docs IS NOT INITIAL.
                      lv_icmsval = lv_icmsval + lv_taxval.
                    ELSEIF <fs_j1bnfdoc>-doctyp <> '2'.
                      lv_icmsval = lv_taxval.
                    ENDIF.

                    <fs_lpp>-icmsval = lv_icmsval.

                    "--- GR-Quantity alread included in LBKUM !!------------
                    calculate_average( EXPORTING iv_icmsavr = <fs_lpp>-icmsavr
                                                 iv_lbkum   = lv_lbkum
                                                 iv_menge   = lv_menge
                                                 iv_umrez   = lv_umrez
                                                 iv_umren   = lv_umren
                                                 iv_subtval = <fs_nf_tax>-taxval
                                        CHANGING cv_subtavr = <fs_lpp>-icmsavr ).

                  WHEN 'S'.
                    <fs_lpp>-lppbrt = <fs_lpp>-lppbrt + lv_taxval.

                    " Check the existence of compl. documents
                    IF lv_has_compl_docs IS NOT INITIAL.
                      lv_subtval = lv_subtval + lv_taxval.
                    ELSE.
                      lv_subtval = lv_taxval.
                    ENDIF.

                    <fs_lpp>-subtval = lv_subtval.

                    calculate_average( EXPORTING iv_icmsavr = <fs_lpp>-subtavr
                                                 iv_lbkum   = lv_lbkum
                                                 iv_menge   = lv_menge
                                                 iv_umrez   = lv_umrez
                                                 iv_umren   = lv_umren
                                                 iv_subtval = <fs_nf_tax>-taxval
                                        CHANGING cv_subtavr = <fs_lpp>-subtavr ).
                ENDCASE.
              ENDIF.
            ENDIF.

            IF <fs_nf_tax>-taxtyp IN lt_ipi.

              <fs_lpp>-docref = <fs_lin>-docnum.

              TRY.
                  <fs_lpp>-zipival = <fs_nf_tax>-taxval / ( lv_menge * lv_umrez / lv_umren ).

                CATCH cx_sy_zerodivide.
              ENDTRY.

              IF lv_lpp EQ 'I'
              OR lv_ipi EQ abap_true.
                SUBTRACT <fs_lpp>-zipival FROM <fs_lpp>-lppbrt.
              ENDIF.

            ENDIF.

            IF <fs_nf_tax>-taxtyp IN lt_icms
           AND lv_lpp             EQ 'S'.

              <fs_lpp>-docref = <fs_lin>-docnum.

              TRY.

                  <fs_lpp>-icmsval = <fs_nf_tax>-taxval / ( lv_menge * lv_umrez / lv_umren ).
                  ADD <fs_lpp>-icmsval TO <fs_lpp>-lppbrt.

                  calculate_average( EXPORTING iv_icmsavr = <fs_lpp>-icmsavr
                                               iv_lbkum   = lv_lbkum
                                               iv_menge   = lv_menge
                                               iv_umrez   = lv_umrez
                                               iv_umren   = lv_umren
                                               iv_subtval = <fs_lpp>-icmsval
                                      CHANGING cv_subtavr = <fs_lpp>-icmsavr ).

                CATCH cx_sy_zerodivide.
              ENDTRY.
            ENDIF.

            IF <fs_nf_tax>-taxtyp IN lt_icst
           AND lv_lpp             EQ 'S'.

              <fs_lpp>-docref = <fs_lin>-docnum.

              TRY.

                  <fs_lpp>-lppid = 'S'.

                  <fs_lpp>-subtval = <fs_nf_tax>-taxval / ( lv_menge * lv_umrez / lv_umren ).

                  SUBTRACT <fs_lpp>-subtval FROM <fs_lpp>-lppbrt.

                  calculate_average( EXPORTING iv_icmsavr = <fs_lpp>-subtavr
                                               iv_lbkum   = lv_lbkum
                                               iv_menge   = lv_menge
                                               iv_umrez   = lv_umrez
                                               iv_umren   = lv_umren
                                               iv_subtval = <fs_lpp>-subtval
                                      CHANGING cv_subtavr = <fs_lpp>-subtavr ).

                CATCH cx_sy_zerodivide.
              ENDTRY.
            ENDIF.

            <fs_lpp>-docref = <fs_lin>-docnum.

          ENDLOOP.
        ENDIF.

      ELSE.

        CLEAR: <fs_lpp>-lppnet,
               <fs_lpp>-lppbrt,
               <fs_lpp>-icmsval,
               <fs_lpp>-subtval,
               <fs_lpp>-icmsavr,
               <fs_lpp>-subtavr,
               <fs_lpp>-docref,
               <fs_lpp>-zipival.
      ENDIF.

    ENDLOOP.

    et_lpp[] = lt_lpp[].

    IF lt_lpp[]  IS NOT INITIAL
   AND iv_update EQ abap_true.

      CALL FUNCTION 'ZFMMM_UPDATE_LPP'
        STARTING NEW TASK 'ZMM_UPDT_LPP'
        EXPORTING
          it_lpp = lt_lpp.

    ENDIF.
*    ENDIF.

  ENDMETHOD.
ENDCLASS.
