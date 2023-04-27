class ZCLMM_AJST_SALD_REMESSA definition
  public
  final
  create public .

public section.

  methods ATRIBUIR_PEDIDO
    importing
      !IS_KEY type ZSMM_SUBC_SAVEATRIB
    exporting
      !ES_RETURN type BAPIRET2 .
  methods AJUSTAR_REMESSA
    importing
      !IS_KEY type ZSMM_SUBC_SAVEATRIB
    exporting
      !ET_RETURN type BAPIRET2_T .
  methods GET_SALDO
    importing
      !IT_KEY type ZCTGMM_SUBC_SAVEATRIB
    exporting
      !ET_SOMA type ZCTGMM_SUBC_SOMA
      !ET_SOMA_CHARG type ZCTGMM_SUBC_SOMA_CHARG .
  methods CALL_BAPIS
    importing
      !IS_KEY type ZSMM_SUBC_SAVEATRIB
    exporting
      !ET_RETURN type BAPIRET2_T .
  class-methods SETUP_MESSAGES
    importing
      !P_TASK type CLIKE .
protected section.
private section.

  constants GC_MSGID type SYST_MSGID value 'ZMM_SUBCONTRTC' ##NO_TEXT.
  constants GC_MSG_SUCES type SYST_MSGNO value '000' ##NO_TEXT.
  constants GC_MSG_PED_NF type SYST_MSGNO value '001' ##NO_TEXT.
  constants GC_SUCESS type SYST_MSGTY value 'S' ##NO_TEXT.
  constants GC_ERROR type SYST_MSGTY value 'E' ##NO_TEXT.
  constants GC_MSG_ERRO_PED type SYST_MSGNO value '002' ##NO_TEXT.
  constants GC_MSG_ERRO_CEN type SYST_MSGNO value '003' ##NO_TEXT.
  constants GC_MSG_ERRO_SLD type SYST_MSGNO value '004' ##NO_TEXT.
  class-data GV_WAIT_ASYNC type ABAP_BOOL .
  class-data GT_RETURN type BAPIRET2_T .
  constants GC_MSG_ATRIB type SYST_MSGNO value '005' ##NO_TEXT.
  constants GC_MSG_ERRO_PED_NV type SYST_MSGNO value '006' ##NO_TEXT.
  constants GC_MSG_ERRO_PED_ATRB type SYST_MSGNO value '007' ##NO_TEXT.
  constants GC_MSG_ERRO_EXPAN type SYST_MSGNO value '008' ##NO_TEXT.
  constants GC_MSG_ERRO_KUNNR type SYST_MSGNO value '009' ##NO_TEXT.

  methods GET_REF_PEDIDO
    importing
      !IS_KEY_RESB type ZSMM_SUBC_SAVEATRIB
    exporting
      !ES_ATRIB type ZSMM_CHV_NVPED .
  methods VALIDA_AJUST_REMESSA
    importing
      !IS_KEY_RESB type ZSMM_SUBC_SAVEATRIB
    exporting
      !ET_RETURN type BAPIRET2_T .
  methods CLEAR_PEDNV
    importing
      !IS_KEY type ZSMM_CHV_PEDNV optional .
ENDCLASS.



CLASS ZCLMM_AJST_SALD_REMESSA IMPLEMENTATION.


  METHOD atribuir_pedido.

    DATA: lt_knvp TYPE STANDARD TABLE OF knvp.

    DATA: lv_erfmg TYPE resb-erfmg.

    CONSTANTS: lc_bwart TYPE lips-bwart  VALUE 'Z41',
               lc_vtweg TYPE tvkwz-vtweg VALUE '14'.

    CHECK is_key IS NOT INITIAL.

    me->get_ref_pedido( EXPORTING is_key_resb = is_key
                        IMPORTING es_atrib    = DATA(ls_atrib) ).

    IF ls_atrib IS NOT INITIAL.

      SELECT vbeln,
             matnr,
             vgbel,
             bwart
        FROM lips
       WHERE matnr = @ls_atrib-matnr
         AND vgbel = @is_key-ebeln_new
         AND bwart = @lc_bwart
        INTO @DATA(ls_lips)
         UP TO 1 ROWS.
      ENDSELECT.

      IF sy-subrc IS INITIAL.

        DATA(ls_clear_ped) = VALUE zsmm_chv_pednv( ebeln = ls_atrib-ebeln_ref
                                                   matnr = ls_atrib-matnr  ).

        me->clear_pednv( EXPORTING is_key = ls_clear_ped ).

        es_return-id         = gc_msgid.
        es_return-type       = gc_error.
        es_return-number     = gc_msg_erro_ped_atrb.
        es_return-message_v1 = ls_lips-vbeln.
        es_return-message_v2 = is_key-ebeln_new.
        RETURN.
      ENDIF.

      SELECT werks,
             vkorg,
             vtweg
        FROM tvkwz
       WHERE werks = @ls_atrib-werks
         AND vtweg = @lc_vtweg
        INTO @DATA(ls_tvkwz)
        UP TO 1 ROWS.
      ENDSELECT.

      SELECT SINGLE matnr,
                    spart
        FROM mara
       WHERE matnr = @ls_atrib-matnr
        INTO @DATA(ls_mara).

      IF ls_tvkwz IS NOT INITIAL
     AND ls_mara  IS NOT INITIAL.

        CALL FUNCTION 'SD_KNVP_READ'
          EXPORTING
            fif_vkorg            = ls_tvkwz-vkorg
            fif_vtweg            = ls_tvkwz-vtweg
            fif_spart            = ls_mara-spart
            fif_kunnr            = ls_atrib-lifnr
          TABLES
            fet_knvp             = lt_knvp
          EXCEPTIONS
            parameter_incomplete = 1
            no_record_found      = 2
            OTHERS               = 3.

        IF sy-subrc IS NOT INITIAL
       AND lt_knvp[] IS INITIAL.
          es_return-id         = gc_msgid.
          es_return-type       = gc_error.
          es_return-number     = gc_msg_erro_expan.
          es_return-message_v1 = ls_atrib-lifnr.
          es_return-message_v2 = ls_tvkwz-vkorg.
          es_return-message_v3 = ls_tvkwz-vtweg.
          es_return-message_v4 = ls_mara-spart.
          RETURN.
        ENDIF.
      ENDIF.

      SELECT SINGLE lifnr,
                    kunnr
        FROM lfa1
       WHERE lifnr = @ls_atrib-lifnr
        INTO @DATA(ls_lfa1).

      IF sy-subrc      IS NOT INITIAL
      OR ls_lfa1-kunnr IS INITIAL.
        es_return-id         = gc_msgid.
        es_return-type       = gc_error.
        es_return-number     = gc_msg_erro_kunnr.
        es_return-message_v1 = ls_atrib-lifnr.
        es_return-message_v2 = ls_atrib-lifnr.
        RETURN.
      ENDIF.

      SELECT SINGLE baugr, Saldo
        FROM zi_mm_relat_saldo_remessa
       WHERE rsnum = @is_key-rsnum
         AND rspos = @is_key-rspos
        INTO @DATA(ls_zi_mm_relat_saldo_remessa).

      IF sy-subrc IS INITIAL.

*        SELECT matnr,
*               erfmg
*          FROM resb
*         WHERE ebeln = @is_key-ebeln_new
*           AND matnr = @ls_atrib-matnr
*          INTO TABLE @DATA(lt_resb).
*
*        IF sy-subrc IS INITIAL.
*          LOOP AT lt_resb ASSIGNING FIELD-SYMBOL(<fs_resb>).
*            lv_erfmg = lv_erfmg + <fs_resb>-erfmg.
*          ENDLOOP.
*        ENDIF.
*      ENDIF.
*
*      IF sy-subrc IS INITIAL.
        DATA(ls_docdata) = VALUE ztmm_remes_pednv( ebeln     = ls_atrib-ebeln_ref
                                                   matnr     = ls_atrib-matnr
                                                   user_proc = sy-uname
                                                   ebeln_nv  = is_key-ebeln_new
                                                   qtd_nova  = ls_zi_mm_relat_saldo_remessa-Saldo
                                                   dats      = sy-datum ).
        MODIFY ztmm_remes_pednv FROM ls_docdata.

        IF sy-subrc IS INITIAL.
          es_return-id     = gc_msgid.
          es_return-number = gc_msg_suces.
          es_return-type   = gc_sucess.
        ENDIF.

      ELSE.

        es_return-id         = gc_msgid.
        es_return-type       = gc_error.
        es_return-number     = gc_msg_ped_nf.
        es_return-message_v1 = is_key-ebeln_new.
        es_return-message_v2 = ls_atrib-matnr.

      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_ref_pedido.

    SELECT SINGLE ebeln,
                  matnr,
                  lifnr,
                  werks
      FROM zi_mm_relat_saldo_remessa
     WHERE rsnum = @is_key_resb-rsnum
       AND rspos = @is_key_resb-rspos
      INTO @DATA(ls_atrib).

    IF sy-subrc IS INITIAL.
      es_atrib = ls_atrib.
    ENDIF.

  ENDMETHOD.


  METHOD ajustar_remessa.

    DATA: lt_goodsmvt_item TYPE STANDARD TABLE OF bapi2017_gm_item_create.

    CHECK is_key IS NOT INITIAL.

    FREE: et_return[],
          gt_return[].

    me->valida_ajust_remessa( EXPORTING is_key_resb = is_key
                              IMPORTING et_return   = et_return ).

    SORT et_return BY type.

    READ TABLE et_return TRANSPORTING NO FIELDS
                                       WITH KEY type = gc_error
                                       BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      RETURN.
    ENDIF.

    CALL FUNCTION 'ZFMMM_SUBC_ATRIBUI_PEDIDO'
      STARTING NEW TASK 'AJUSTAR_REMESSA'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        is_key = is_key.

    WAIT UNTIL gv_wait_async = abap_true.
    DATA(lt_return) = gt_return.
    APPEND LINES OF lt_return TO et_return.

  ENDMETHOD.


  METHOD call_bapis.

    TYPES: BEGIN OF ty_lotes,
             charg TYPE charg_d,
             menge TYPE menge_d,
           END OF ty_lotes.

    DATA: lt_goodsmvt_item TYPE STANDARD TABLE OF bapi2017_gm_item_create,
          lt_return        TYPE STANDARD TABLE OF bapiret2,
          lt_xkomdlgn      TYPE STANDARD TABLE OF komdlgn,
          lt_xvbfs         TYPE STANDARD TABLE OF vbfs,
          lt_xvbls         TYPE STANDARD TABLE OF vbls,
          lt_xxlips        TYPE STANDARD TABLE OF lips,
          lt_vbpok         TYPE STANDARD TABLE OF vbpok,
          lt_prot          TYPE STANDARD TABLE OF prott,
          lt_keys          TYPE STANDARD TABLE OF zsmm_subc_saveatrib,
          lt_lotes         TYPE STANDARD TABLE OF ty_lotes.

    CONSTANTS: lc_bwart  TYPE bwart         VALUE 'Z42',
               lc_code   TYPE gm_code       VALUE '04',
               lc_error  TYPE sy-msgty      VALUE 'E',
               lc_sammg  TYPE vbsk-sammg    VALUE 'SUBCONTRAT',
               lc_smart  TYPE vbsk-smart    VALUE 'L',
               lc_vtweg  TYPE tvkwz-vtweg   VALUE '14',
               lc_wabuc  TYPE vbkok-wabuc   VALUE 'Y',
               lc_lfart  TYPE komdlgn-lfart VALUE 'LB',
               lc_bwart1 TYPE komdlgn-bwart VALUE 'Z41',
               lc_lifsk  TYPE komdlgn-lifsk VALUE '05',
               lc_vbtypl TYPE vbtypl        VALUE 'V'.

    DATA: lv_goodsmvt_headret TYPE bapi2017_gm_head_ret,
          lv_materialdocument TYPE bapi2017_gm_head_ret-mat_doc,
          lv_matdocumentyear  TYPE bapi2017_gm_head_ret-doc_year,
          lv_menge            TYPE mseg-menge,
          lv_qtdnova          TYPE menge_d,
          lv_sair             TYPE char1.

    SELECT SINGLE ebeln,
                  matnr,
                  werks,
                  lifnr,
                  meins,
                  vbeln,
                  pednv,
                  qtdnova,
                  baugr
          FROM zi_mm_relat_saldo_remessa
         WHERE rsnum = @is_key-rsnum
           AND rspos = @is_key-rspos
          INTO @DATA(ls_relat).

    IF sy-subrc IS INITIAL.

      SELECT ebeln,
             ebelp,
             lgort
        FROM ekpo
       WHERE ebeln = @ls_relat-pednv
         AND matnr = @ls_relat-baugr
        INTO @DATA(ls_ekpo)
         UP TO 1 ROWS.
      ENDSELECT.

      DATA(ls_header) = VALUE bapi2017_gm_head_01( pstng_date = sy-datum
                                                   doc_date   = sy-datum ).

      DATA(ls_code) = VALUE bapi2017_gm_code( gm_code = lc_code ).

      SELECT mblnr,
             mjahr,
             zeile,
             matnr,
             charg,
             menge,
             vbeln_im,
             vbelp_im
        FROM nsdm_e_mseg
       WHERE xauto    = @abap_true
         AND vbeln_im = @ls_relat-vbeln
         AND matnr    = @ls_relat-matnr
        INTO TABLE @DATA(lt_mseg_comp).
      IF sy-subrc IS INITIAL.

        lt_keys = VALUE #( BASE lt_keys ( rsnum = is_key-rsnum
                                          rspos = is_key-rspos ) ).

        me->get_saldo( EXPORTING it_key        = lt_keys
                       IMPORTING et_soma_charg = DATA(lt_soma_charg) ).

        SORT lt_soma_charg BY charg.

        DATA(lt_mseg_aux) = lt_mseg_comp[].
        FREE: lt_mseg_aux[].

        LOOP AT lt_mseg_comp ASSIGNING FIELD-SYMBOL(<fs_mseg_comp>).

          lv_menge = <fs_mseg_comp>-menge.

          READ TABLE lt_soma_charg TRANSPORTING NO FIELDS
                                                 WITH KEY charg = <fs_mseg_comp>-charg
                                                 BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            LOOP AT lt_soma_charg ASSIGNING FIELD-SYMBOL(<fs_soma_charg>) FROM sy-tabix.
              IF <fs_soma_charg>-charg NE <fs_mseg_comp>-charg.
                EXIT.
              ENDIF.

              lv_menge             = <fs_mseg_comp>-menge - <fs_soma_charg>-menge.
              <fs_mseg_comp>-menge = lv_menge.

            ENDLOOP.

            IF lv_menge >= 0.
              APPEND <fs_mseg_comp> TO lt_mseg_aux.
            ENDIF.

          ELSE.
            APPEND <fs_mseg_comp> TO lt_mseg_aux.
          ENDIF.
        ENDLOOP.

        SORT lt_mseg_aux BY mblnr
                            mjahr
                            zeile.

        lv_qtdnova = ls_relat-qtdnova.

        LOOP AT lt_mseg_aux ASSIGNING FIELD-SYMBOL(<fs_mseg_aux>).

          lv_menge = <fs_mseg_aux>-menge - lv_qtdnova.

          IF lv_menge < 0.
            lv_menge = ls_relat-qtdnova.
            lv_sair = abap_true.
          ELSE.
            lv_menge = <fs_mseg_aux>-menge.
            lv_qtdnova = lv_qtdnova - <fs_mseg_aux>-menge.
          ENDIF.

          lt_goodsmvt_item = VALUE #( BASE lt_goodsmvt_item ( material   = ls_relat-matnr
                                                              plant      = ls_relat-werks
                                                              batch      = <fs_mseg_aux>-charg
                                                              po_number  = ls_ekpo-ebeln
                                                              po_item    = ls_ekpo-ebelp
                                                              stge_loc   = ls_ekpo-lgort
                                                              move_type  = lc_bwart
                                                              vendor     = ls_relat-lifnr
                                                              entry_qnt  = lv_menge
                                                              entry_uom  = ls_relat-meins
                                                              move_mat   = ls_relat-matnr
                                                              move_plant = ls_relat-werks
                                                              gr_rcpt    = ls_relat-vbeln ) ).

          lt_lotes = VALUE #( BASE lt_lotes ( charg = <fs_mseg_aux>-charg
                                              menge = lv_menge ) ).

          IF lv_sair IS NOT INITIAL.
            EXIT.
          ENDIF.

        ENDLOOP.
      ENDIF.

      CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
        EXPORTING
          goodsmvt_header  = ls_header
          goodsmvt_code    = ls_code
        IMPORTING
          goodsmvt_headret = lv_goodsmvt_headret
          materialdocument = lv_materialdocument
          matdocumentyear  = lv_matdocumentyear
        TABLES
          goodsmvt_item    = lt_goodsmvt_item
          return           = lt_return.

      SORT lt_return BY type.

      READ TABLE lt_return TRANSPORTING NO FIELDS
                                         WITH KEY type = lc_error
                                         BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        et_return = lt_return.
      ELSE.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.

        DO 5 TIMES.

          SELECT mblnr,
                 mjahr
            FROM mseg
           WHERE mblnr = @lv_materialdocument
             AND mjahr = @lv_matdocumentyear
            INTO TABLE @DATA(lt_mseg).

          IF sy-subrc IS INITIAL.
            EXIT.
          ELSE.
            WAIT UP TO 1 SECONDS.
          ENDIF.

        ENDDO.

        IF lt_mseg[] IS NOT INITIAL.

          SELECT werks,
                 vkorg,
                 vtweg
            FROM tvkwz
           WHERE werks = @ls_relat-werks
             AND vtweg = @lc_vtweg
            INTO @DATA(ls_tvkwz)
            UP TO 1 ROWS.
          ENDSELECT.

          SELECT SINGLE matnr,
                        spart
            FROM mara
           WHERE matnr = @ls_relat-matnr
            INTO @DATA(ls_mara).

          DATA(ls_vbsk) = VALUE vbsk( sammg = lc_sammg
                                      smart = lc_smart ).
          LOOP AT lt_lotes ASSIGNING FIELD-SYMBOL(<fs_lotes>).

            lt_xkomdlgn = VALUE #( BASE lt_xkomdlgn ( vstel = ls_relat-werks
                                                      vkorg = ls_tvkwz-vkorg
                                                      vtweg = ls_tvkwz-vtweg
                                                      charg = <fs_lotes>-charg
                                                      lgort = ls_ekpo-lgort
                                                      vgbel = ls_ekpo-ebeln
                                                      vgpos = ls_ekpo-ebelp
                                                      vgtyp = lc_vbtypl
                                                      vrkme = ls_relat-meins
                                                      spart = ls_mara-spart
                                                      lfart = lc_lfart
                                                      kunwe = ls_relat-lifnr
                                                      lifnr = ls_relat-lifnr
                                                      matnr = ls_relat-matnr
                                                      werks = ls_relat-werks
                                                      wadat = sy-datum
                                                      lfdat = sy-datum
                                                      lfimg = ls_relat-qtdnova
                                                      bwart = lc_bwart1
                                                      lifsk = lc_lifsk
                                                      lifex = ls_relat-vbeln ) ).

          ENDLOOP.

          CALL FUNCTION 'GN_DELIVERY_CREATE'
            EXPORTING
              vbsk_i               = ls_vbsk
              no_commit            = abap_true
              vbls_pos_rueck       = abap_true
              if_no_deque          = abap_true
              if_no_partner_dialog = abap_true
            TABLES
              xkomdlgn             = lt_xkomdlgn
              xvbfs                = lt_xvbfs
              xvbls                = lt_xvbls
              xxlips               = lt_xxlips.

          SORT lt_xvbfs BY msgty.

          READ TABLE lt_xvbfs TRANSPORTING NO FIELDS
                                            WITH KEY msgty = gc_error
                                            BINARY SEARCH.
          IF sy-subrc IS INITIAL.

            DATA(ls_xvbfs) = lt_xvbfs[ 1 ].

            et_return = VALUE #( BASE et_return ( id         = ls_xvbfs-msgid
                                                  number     = ls_xvbfs-msgno
                                                  type       = ls_xvbfs-msgty
                                                  message_v1 = ls_xvbfs-msgv1
                                                  message_v2 = ls_xvbfs-msgv2
                                                  message_v3 = ls_xvbfs-msgv3
                                                  message_v4 = ls_xvbfs-msgv4 ) ).
          ELSE.

            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
              EXPORTING
                wait = abap_true.

            IF lt_xxlips[] IS NOT INITIAL.
              DO 5 TIMES.
                SELECT vbeln,
                       posnr
                  FROM lips
                   FOR ALL ENTRIES IN @lt_xxlips
                 WHERE vbeln = @lt_xxlips-vbeln
                  INTO TABLE @DATA(lt_lips).
                IF sy-subrc IS INITIAL.
                  EXIT.
                ELSE.
                  WAIT UP TO 1 SECONDS.
                ENDIF.
              ENDDO.
            ENDIF.

            IF lt_lips[] IS NOT INITIAL.

              DATA(ls_xxlips) = lt_xxlips[ 1 ].

              DATA(ls_vbkok) = VALUE vbkok( vbeln_vl = ls_xxlips-vbeln
                                            wabuc    = lc_wabuc ).

              LOOP AT lt_xxlips ASSIGNING FIELD-SYMBOL(<fs_xxlips>).

                lt_vbpok = VALUE #( BASE lt_vbpok ( vbeln_vl = <fs_xxlips>-vbeln
                                                    posnr_vl = <fs_xxlips>-posnr
                                                    vbeln    = <fs_xxlips>-vgbel
                                                    posnn    = <fs_xxlips>-vgpos
                                                    pikmg    = <fs_xxlips>-lfimg ) ).
              ENDLOOP.

              IF lt_vbpok[] IS NOT INITIAL.
                CALL FUNCTION 'SD_DELIVERY_UPDATE_PICKING_1'
                  EXPORTING
                    vbkok_wa                 = ls_vbkok
                    if_error_messages_send_1 = abap_true
                  TABLES
                    vbpok_tab                = lt_vbpok
                    prot                     = lt_prot.

                IF lt_prot[] IS INITIAL.

                  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
                    EXPORTING
                      wait = abap_true.

                  DATA(ls_vbpok) = lt_vbpok[ 1 ].

                  et_return = VALUE #( BASE et_return ( id         = gc_msgid
                                                        number     = gc_msg_atrib
                                                        type       = gc_sucess
                                                        message_v1 = ls_vbpok-vbeln ) ).

                  DATA(ls_chv_ped) = VALUE zsmm_chv_pednv( ebeln = ls_relat-ebeln
                                                           matnr = ls_relat-matnr ).

                  me->clear_pednv( EXPORTING is_key = ls_chv_ped ).

                ELSE.

                  DATA(ls_prot) = lt_prot[ 1 ].

                  et_return = VALUE #( BASE et_return ( id         = ls_prot-msgid
                                                        number     = ls_prot-msgno
                                                        type       = ls_prot-msgty
                                                        message_v1 = ls_prot-msgv1
                                                        message_v2 = ls_prot-msgv2
                                                        message_v3 = ls_prot-msgv3
                                                        message_v4 = ls_prot-msgv4 ) ).

                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_saldo.

    TYPES: BEGIN OF ty_comp,
             lifex TYPE  vbeln,
           END OF ty_comp,
           BEGIN OF ty_likp_aux,
             matnr TYPE mseg-matnr,
             vbeln TYPE vbeln,
           END OF ty_likp_aux.

    DATA: lt_soma     TYPE STANDARD TABLE OF zsmm_subc_soma,
          lt_comp     TYPE STANDARD TABLE OF ty_comp,
          lt_likp_aux TYPE STANDARD TABLE OF ty_likp_aux.

    DATA: ls_soma       TYPE zsmm_subc_soma,
          ls_soma_charg TYPE zsmm_subc_soma_charg,
          ls_comp       TYPE ty_comp.

    DATA: lv_tabix TYPE sy-tabix,
          lv_lifex TYPE lifex,
          lv_vbeln TYPE lips-vbeln.

    CONSTANTS: lc_shkzg TYPE shkzg VALUE 'S'.

    CHECK it_key[] IS NOT INITIAL.

    SELECT rsnum,
           rspos,
           ebeln,
           matnr,
           vbeln,
           erfmg,
           lfimg
      FROM zi_mm_relat_saldo_remessa
      FOR ALL ENTRIES IN @it_key
     WHERE rsnum = @it_key-rsnum
       AND rspos = @it_key-rspos
      INTO TABLE @DATA(lt_relat).

    IF sy-subrc IS INITIAL.

      LOOP AT lt_relat ASSIGNING FIELD-SYMBOL(<fs_relat>).
        IF <fs_relat>-vbeln IS NOT INITIAL.
          lt_comp = VALUE #( BASE lt_comp ( lifex = <fs_relat>-vbeln ) ).
        ENDIF.
      ENDLOOP.

      IF lt_comp[] IS NOT INITIAL.

        SORT lt_comp BY lifex.
        DELETE ADJACENT DUPLICATES FROM lt_comp COMPARING lifex.

        SELECT vbeln,
               lifex
          FROM likp
           FOR ALL ENTRIES IN @lt_comp
         WHERE vbeln = @lt_comp-lifex
          INTO TABLE @DATA(lt_likp).

        IF sy-subrc IS INITIAL.

          SORT lt_likp BY lifex.

          SORT lt_relat BY vbeln.

          LOOP AT lt_likp ASSIGNING FIELD-SYMBOL(<fs_likp>).

            lv_vbeln = <fs_likp>-vbeln.

            READ TABLE lt_relat ASSIGNING <fs_relat>
                                 WITH KEY vbeln = lv_vbeln
                                 BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              lt_likp_aux = VALUE #( BASE lt_likp_aux ( matnr = <fs_relat>-matnr
                                                        vbeln = <fs_likp>-vbeln ) ).
            ENDIF.
          ENDLOOP.

          IF lt_likp_aux[] IS NOT INITIAL.

            SELECT vbeln,
                   posnr,
                   matnr,
                   charg,
                   lfimg
              FROM lips
               FOR ALL ENTRIES IN @lt_likp_aux
             WHERE vbeln = @lt_likp_aux-vbeln
               AND matnr = @lt_likp_aux-matnr
              INTO TABLE @DATA(lt_lips).

            IF sy-subrc IS INITIAL.

              SORT lt_lips BY vbeln
                              matnr.

              LOOP AT lt_likp ASSIGNING <fs_likp>.

                lv_vbeln = <fs_likp>-vbeln.

                READ TABLE lt_relat ASSIGNING <fs_relat>
                                     WITH KEY vbeln = lv_vbeln
                                     BINARY SEARCH.
                IF sy-subrc IS INITIAL.

                  READ TABLE lt_lips TRANSPORTING NO FIELDS
                                                   WITH KEY vbeln = <fs_likp>-vbeln
                                                            matnr = <fs_relat>-matnr
                                                            BINARY SEARCH.
                  IF sy-subrc IS INITIAL.
                    LOOP AT lt_lips ASSIGNING FIELD-SYMBOL(<fs_lips>) FROM sy-tabix.
                      IF <fs_lips>-vbeln NE <fs_likp>-vbeln
                      OR <fs_lips>-matnr NE <fs_relat>-matnr.
                        EXIT.
                      ENDIF.

                      ls_soma-matnr = <fs_relat>-matnr.
                      ls_soma-ebeln = <fs_relat>-ebeln.
                      ls_soma-menge = <fs_lips>-lfimg.
                      COLLECT ls_soma INTO lt_soma.

                      ls_soma_charg-matnr = <fs_relat>-matnr.
                      ls_soma_charg-ebeln = <fs_relat>-ebeln.
                      ls_soma_charg-charg = <fs_lips>-charg.
                      ls_soma_charg-menge = <fs_lips>-lfimg.
                      COLLECT ls_soma_charg INTO et_soma_charg.

                    ENDLOOP.
                  ENDIF.
                ENDIF.
              ENDLOOP.

              IF lt_soma[] IS NOT INITIAL.
                et_soma[] = lt_soma[].
              ENDIF.

            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD setup_messages.
    CASE p_task.

      WHEN 'AJUSTAR_REMESSA'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_SUBC_ATRIBUI_PEDIDO'
            IMPORTING
                et_return = gt_return.

    ENDCASE.

    gv_wait_async = abap_true.

  ENDMETHOD.


  METHOD valida_ajust_remessa.

    DATA: lt_key_resb TYPE zctgmm_subc_saveatrib.

    DATA: lv_menge TYPE menge_d.

    SELECT SINGLE a~werks,
                  a~matnr,
                  a~lifnr,
                  a~ebeln,
                  a~ebelp,
                  a~lfimg,
                  a~pednv,
                  a~qtdnova,
                  a~baugr,
                  a~saldo,
                  b~werks AS werks_po,
                  b~matnr AS matnr_po,
                  c~lifnr AS lifnr_ko
      FROM zi_mm_relat_saldo_remessa AS a
      INNER JOIN ekpo AS b ON b~ebeln = a~ebeln
                          AND b~ebelp = b~ebelp
      INNER JOIN ekko AS c ON c~ebeln = a~ebeln
     WHERE rsnum = @is_key_resb-rsnum
       AND rspos = @is_key_resb-rspos
      INTO @DATA(ls_atrib).

    IF sy-subrc IS INITIAL.

      IF ls_atrib-pednv IS INITIAL.
        et_return = VALUE #( BASE et_return ( id     = gc_msgid
                                              number = gc_msg_erro_ped_nv
                                              type   = gc_error ) ).
      ENDIF.

      IF ls_atrib-werks NE ls_atrib-werks_po
      OR ls_atrib-baugr NE ls_atrib-matnr_po
      OR ls_atrib-lifnr NE ls_atrib-lifnr_ko.
        et_return = VALUE #( BASE et_return ( id     = gc_msgid
                                              number = gc_msg_erro_ped
                                              type   = gc_error ) ).
      ENDIF.
    ELSE.
      et_return = VALUE #( BASE et_return ( id     = gc_msgid
                                            number = gc_msg_erro_ped_nv
                                            type   = gc_error ) ).
    ENDIF.

    SELECT werks,
           vtweg
      FROM tvkwz
     WHERE werks = @ls_atrib-werks
       AND vtweg = '14'
      INTO @DATA(ls_tvkwz)
        UP TO 1 ROWS.
    ENDSELECT.
    IF sy-subrc IS NOT INITIAL.
      et_return = VALUE #( BASE et_return ( id     = gc_msgid
                                            number = gc_msg_erro_cen
                                            type   = gc_error ) ).
    ENDIF.

    lt_key_resb = VALUE #( BASE lt_key_resb ( rsnum     = is_key_resb-rsnum
                                              rspos     = is_key_resb-rspos
                                              ebeln_new = is_key_resb-ebeln_new ) ).

    me->get_saldo( EXPORTING it_key  = lt_key_resb
                   IMPORTING et_soma = DATA(lt_soma) ).

    DATA(ls_soma) = VALUE #( lt_soma[ 1 ] OPTIONAL ).

    lv_menge = ls_soma-menge + ls_atrib-qtdnova.

*    IF ls_atrib-lfimg < lv_menge.
*      et_return = VALUE #( BASE et_return ( id     = gc_msgid
*                                            number = gc_msg_erro_sld
*                                            type   = gc_error ) ).
*    ENDIF.

  ENDMETHOD.


  METHOD clear_pednv.

    CALL FUNCTION 'ZFMMM_SUBC_CLEAR_ATRIB'
      STARTING NEW TASK 'ZMMCLEAR_ATRIBUICAO'
      EXPORTING
        is_key = is_key.

  ENDMETHOD.
ENDCLASS.
