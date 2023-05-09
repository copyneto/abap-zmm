CLASS zclmm_exped_subct_param DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.


    METHODS atribuir_picking
      IMPORTING
        !it_keys   TYPE zctgmm_subct_key
      EXPORTING
        !et_return TYPE bapiret2_t .
    METHODS expedicao
      IMPORTING
        !it_keys   TYPE zctgmm_subct_key
      EXPORTING
        !et_return TYPE bapiret2_t .
    CLASS-METHODS setup_messages
      IMPORTING
        !p_task TYPE clike .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS gc_msg_id TYPE syst_msgid VALUE 'ZMM_SUBCONTRTC' ##NO_TEXT.
    CONSTANTS gc_delete_sb_picking TYPE char30 VALUE 'DELETE_SB_PICKING'.
    CONSTANTS gc_limpa_tabz_picking TYPE char30 VALUE 'LIMPA_TABZ_PICKING'.
    CONSTANTS gc_sucess TYPE syst_msgty VALUE 'S' ##NO_TEXT.
    CONSTANTS gc_warn TYPE syst_msgty VALUE 'W' ##NO_TEXT.
    CONSTANTS gc_error TYPE syst_msgty VALUE 'E' ##NO_TEXT.
    CONSTANTS gc_error_pend TYPE syst_msgno VALUE '013' ##NO_TEXT.
    CONSTANTS gc_error_pkg_zero TYPE syst_msgno VALUE '024' ##NO_TEXT.
    CONSTANTS gc_error_pkg_maior TYPE syst_msgno VALUE '025' ##NO_TEXT.
    CONSTANTS gc_error_grverd TYPE syst_msgno VALUE '026' ##NO_TEXT.
    CONSTANTS gc_error_transp TYPE syst_msgno VALUE '019' ##NO_TEXT.
    CLASS-DATA gt_xvbfs TYPE vbfs_t .
    CLASS-DATA gt_xxlips TYPE tt_lips .
    CLASS-DATA gt_prot TYPE tab_prott .
    CLASS-DATA gv_wait_async_1 TYPE abap_bool .
    CONSTANTS gc_sucess_exped TYPE syst_msgno VALUE '021' ##NO_TEXT.
    CONSTANTS gc_error_depos_peditm TYPE syst_msgno VALUE '027' ##NO_TEXT.
    CONSTANTS gc_error_pednfound TYPE syst_msgno VALUE '028' ##NO_TEXT.
    CONSTANTS gc_error_picking_vbeln TYPE syst_msgno VALUE '029' ##NO_TEXT.
    CONSTANTS gc_error_exped_exist TYPE syst_msgno VALUE '030' ##NO_TEXT.
    CONSTANTS gc_error_picking_return TYPE syst_msgno VALUE '031' ##NO_TEXT.
    CONSTANTS gc_error_picking_qtd_linha TYPE syst_msgno VALUE '032' ##NO_TEXT.
    CONSTANTS gc_error_picking_diver TYPE syst_msgno VALUE '033' ##NO_TEXT.
    CLASS-DATA gv_wait_async_2 TYPE abap_bool .

    METHODS valida_expedicao
      IMPORTING
        !it_keys   TYPE zctgmm_subct_key
      EXPORTING
        !et_return TYPE bapiret2_t .
    METHODS add_return
      IMPORTING
        !iv_id         TYPE symsgid OPTIONAL
        !iv_number     TYPE symsgno OPTIONAL
        !iv_type       TYPE bapi_mtype OPTIONAL
        !iv_message_v1 TYPE symsgv OPTIONAL
        !iv_message_v2 TYPE symsgv OPTIONAL
        !iv_message_v3 TYPE symsgv OPTIONAL
        !iv_message_v4 TYPE symsgv OPTIONAL
        !it_return     TYPE bapiret2_t OPTIONAL
      CHANGING
        !ct_return     TYPE bapiret2_t OPTIONAL .
    METHODS preenche_bapis
      IMPORTING
        !it_keys   TYPE zctgmm_subct_key
      EXPORTING
        !et_return TYPE bapiret2_t .
    METHODS call_gn_delivery_create
      IMPORTING
        !is_vbsk_i               TYPE vbsk
        !iv_no_commit            TYPE rvsel-xfeld DEFAULT ' '
        !iv_vbls_pos_rueck       TYPE rvsel-xfeld DEFAULT ' '
        !iv_if_no_deque          TYPE xfeld DEFAULT space
        !iv_if_no_partner_dialog TYPE xfeld DEFAULT 'X'
        !it_xkomdlgn             TYPE shp_komdlgn_t
        !it_xvbls                TYPE vbls_t
        !it_gn_partner           TYPE partner_gn_t
        iv_txsdc                 TYPE j_1btxsdc_
      EXPORTING
        !et_xvbfs                TYPE vbfs_t
        !et_xxlips               TYPE tt_lips .
    METHODS call_pickin
      IMPORTING
        !is_vbkok_wa  TYPE vbkok
        !iv_if_error  TYPE xfeld DEFAULT 'X'
        !it_vbpok_tab TYPE vbpok_t
      EXPORTING
        !et_prot      TYPE tab_prott .
    METHODS limpa_tabz_picking
      IMPORTING
        it_keys TYPE zctgmm_subct_key .
    METHODS delete_sb_picking
      IMPORTING
        it_keys TYPE zctgmm_subct_key.
ENDCLASS.



CLASS ZCLMM_EXPED_SUBCT_PARAM IMPLEMENTATION.


  METHOD add_return.

    IF iv_number IS NOT INITIAL
   AND iv_id     IS NOT INITIAL.
      ct_return = VALUE #( BASE ct_return ( id         = iv_id
                                            number     = iv_number
                                            type       = iv_type
                                            message_v1 = iv_message_v1
                                            message_v2 = iv_message_v2
                                            message_v3 = iv_message_v3
                                            message_v4 = iv_message_v4 ) ).
    ENDIF.

    IF it_return[] IS NOT INITIAL.
      LOOP AT it_return ASSIGNING FIELD-SYMBOL(<fs_return>).

        ct_return = VALUE #( BASE ct_return ( id         = <fs_return>-id
                                              number     = <fs_return>-number
                                              type       = <fs_return>-type
                                              message_v1 = <fs_return>-message_v1
                                              message_v2 = <fs_return>-message_v2
                                              message_v3 = <fs_return>-message_v3
                                              message_v4 = <fs_return>-message_v4 ) ).

      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD atribuir_picking.

    DATA: lt_tab TYPE STANDARD TABLE OF ztmm_sbct_pickin.

    DATA: lv_error TYPE char1.

    CHECK it_keys IS NOT INITIAL.

    SELECT a~rsnum,
           a~rspos,
           a~ebeln,
           a~ebelp,
           a~lgort,
           a~quantidade
      FROM zi_mm_exped_subcontrat AS a
     INNER JOIN ekpo AS b ON b~ebeln = a~ebeln
                         AND b~ebelp = a~ebelp
       FOR ALL ENTRIES IN @it_keys
     WHERE a~rsnum = @it_keys-rsnum
       AND a~rspos = @it_keys-rspos
       AND a~vbeln IS INITIAL
      INTO TABLE @DATA(lt_relat).

    IF sy-subrc IS INITIAL.
      SORT lt_relat BY rsnum
                       rspos.
    ENDIF.

    LOOP AT it_keys ASSIGNING FIELD-SYMBOL(<fs_keys>).

      IF <fs_keys>-vbeln IS NOT INITIAL.
        et_return = VALUE #( BASE et_return ( id         = gc_msg_id
                                              type       = gc_error
                                              number     = gc_error_picking_vbeln ) ).
        lv_error = abap_true.
      ENDIF.

      READ TABLE lt_relat ASSIGNING FIELD-SYMBOL(<fs_relat>)
                                        WITH KEY rsnum = <fs_keys>-rsnum
                                                 rspos = <fs_keys>-rspos
                                                 BINARY SEARCH.

      IF sy-subrc IS INITIAL.
        IF <fs_relat>-lgort IS INITIAL.
          et_return = VALUE #( BASE et_return ( id         = gc_msg_id
                                                type       = gc_error
                                                number     = gc_error_depos_peditm
                                                message_v1 = <fs_relat>-ebeln
                                                message_v2 = <fs_relat>-ebelp ) ).
          lv_error = abap_true.
        ELSE.
          lt_tab = VALUE #( BASE lt_tab ( rsnum     = <fs_keys>-rsnum
                                          rspos     = <fs_keys>-rspos
                                          picking   = <fs_keys>-picking
                                          dats      = sy-datum ) ).
          IF <fs_relat>-quantidade <  <fs_keys>-picking.
            DATA(lv_qtd_div) = abap_true.
          ENDIF.

        ENDIF.
      ELSE.
        et_return = VALUE #( BASE et_return ( id         = gc_msg_id
                                              type       = gc_error
                                              number     = gc_error_pednfound ) ).
        lv_error = abap_true.
      ENDIF.

    ENDLOOP.

    IF lt_tab[] IS NOT INITIAL
   AND lv_error IS INITIAL.

      LOOP AT lt_tab ASSIGNING FIELD-SYMBOL(<fs_tab>).
        IF lv_qtd_div = abap_true.
          APPEND VALUE #(  id         = gc_msg_id
                             type       = gc_warn
                             number     = gc_error_picking_diver
                             message_v1 = <fs_tab>-rsnum
                             message_v2 = <fs_tab>-rspos
                             message_v3 = <fs_tab>-picking )  TO et_return.
        ELSE.
          APPEND VALUE #(  id         = gc_msg_id
                             type       = gc_sucess
                             number     = gc_error_picking_return
                             message_v1 = <fs_tab>-rsnum
                             message_v2 = <fs_tab>-rspos
                             message_v3 = <fs_tab>-picking )  TO et_return.
        ENDIF.
      ENDLOOP.

      MODIFY ztmm_sbct_pickin FROM TABLE lt_tab.
    ENDIF.

  ENDMETHOD.


  METHOD call_gn_delivery_create.

    CALL FUNCTION 'ZFMMM_GN_DELIVERY_CREATE'
      STARTING NEW TASK 'MM_SUBCON_DELIVERY'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        is_vbsk_i               = is_vbsk_i
        iv_no_commit            = iv_no_commit
        iv_vbls_pos_rueck       = iv_vbls_pos_rueck
        iv_if_no_deque          = iv_if_no_deque
        iv_if_no_partner_dialog = iv_if_no_partner_dialog
        it_xkomdlgn             = it_xkomdlgn
        it_xvbls                = it_xvbls
        it_gn_partner           = it_gn_partner
        iv_txsdc                = iv_txsdc.

    WAIT UNTIL gv_wait_async_1 = abap_true.
    et_xvbfs  = gt_xvbfs.
    et_xxlips = gt_xxlips.
    FREE gv_wait_async_1.

  ENDMETHOD.


  METHOD call_pickin.

    DATA(ls_vbkok) = VALUE zsmm_exped_vbkok(
    vbeln_vl = is_vbkok_wa-vbeln_vl
    wabuc  = is_vbkok_wa-wabuc
    ).

    CALL FUNCTION 'ZFMMM_PICKING'
      STARTING NEW TASK 'MM_SUBCON_PICKING'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        is_vbkok_wa  = ls_vbkok "is_vbkok_wa
        iv_if_error  = iv_if_error
        it_vbpok_tab = it_vbpok_tab
        iv_app_exp   = abap_true.

    WAIT UNTIL gv_wait_async_2 = abap_true.
    et_prot = gt_prot.
    FREE gv_wait_async_2.

  ENDMETHOD.


  METHOD expedicao.

    me->valida_expedicao( EXPORTING it_keys   = it_keys
                          IMPORTING et_return = et_return ).

    SORT et_return BY type.
    READ TABLE et_return TRANSPORTING NO FIELDS
                                       WITH KEY type = gc_error
                                       BINARY SEARCH.
    IF sy-subrc IS NOT INITIAL.

      me->preenche_bapis( EXPORTING it_keys   = it_keys
                          IMPORTING et_return = et_return ).

    ENDIF.

  ENDMETHOD.


  METHOD preenche_bapis.

    DATA: lt_gn_partner TYPE STANDARD TABLE OF partner_gn,
          lt_xkomdlgn   TYPE STANDARD TABLE OF komdlgn,
          lt_xvbls      TYPE vbls_t,
          lt_vbpok_tab  TYPE STANDARD TABLE OF vbpok.

    CONSTANTS: lc_lfart        TYPE lfart       VALUE 'LB',
*               lc_bwart_gv     TYPE bwart       VALUE 'Y41', "chamado 8000004978
               lc_bwart_nm     TYPE bwart       VALUE '541',
               lc_spart_gv     TYPE mara-spart  VALUE '05',
               lc_lifsk        TYPE lifsk       VALUE '05',
               lc_parvw        TYPE parvw       VALUE 'SP',
               lc_sammg        TYPE sammg       VALUE 'SUBCONTRAT',
               lc_smart        TYPE smart       VALUE 'L',
               lc_wabuc        TYPE wabuc       VALUE 'Y',
               lc_intercompany TYPE tvkwz-vtweg VALUE '10',
               lc_vgtyp        TYPE vbtypl      VALUE 'V'.

    DATA: lv_bwart TYPE bwart,
          lv_lifnr TYPE t001w-lifnr.

    IF it_keys[] IS NOT INITIAL.

      SELECT a~rsnum,
             a~rspos,
             a~ebeln,
             a~ebelp,
             a~matnr,
             a~werks,
             a~quantidade,
             a~meins,
             a~charg,
             a~vbeln,
             a~lifnr,
             a~picking,
             b~spart,
             a~lgort
        FROM zi_mm_exped_subcontrat AS a
       INNER JOIN mara AS b ON b~matnr = a~matnr
       INNER JOIN ekpo AS c ON c~ebeln = a~ebeln
                           AND c~ebelp = a~ebelp
         FOR ALL ENTRIES IN @it_keys
       WHERE a~rsnum = @it_keys-rsnum
         AND a~rspos = @it_keys-rspos
         AND ( a~item  = @it_keys-item OR a~item IS NULL )
         AND a~vbeln IS INITIAL
        INTO TABLE @DATA(lt_relat).

      IF sy-subrc IS INITIAL.

        DATA(lt_relat_fae) = lt_relat[].
        SORT lt_relat_fae BY werks.
        DELETE ADJACENT DUPLICATES FROM lt_relat_fae COMPARING werks.

        SELECT tvkwz~werks,
               tvkwz~vkorg,
               tvkwz~vtweg
          FROM tvkwz
          INNER JOIN mvke
             ON mvke~vkorg = tvkwz~vkorg
            AND mvke~vtweg = tvkwz~vtweg
          FOR ALL ENTRIES IN @lt_relat_fae
          WHERE tvkwz~werks = @lt_relat_fae-werks
            AND tvkwz~vtweg = @lc_intercompany
            AND mvke~matnr  = @lt_relat_fae-matnr
          INTO TABLE @DATA(lt_tvkwz)
          BYPASSING BUFFER.

          delete lt_tvkwz where vkorg = '1410'.

        IF sy-subrc IS INITIAL.
          SORT lt_tvkwz BY werks.
        ENDIF.

        SELECT werks,
               lifnr
          FROM t001w
           FOR ALL ENTRIES IN @lt_relat_fae
         WHERE werks = @lt_relat_fae-werks
          INTO TABLE @DATA(lt_t001w).
        IF sy-subrc IS INITIAL.
          SORT lt_t001w BY werks.
        ENDIF.

        READ TABLE lt_relat INTO DATA(ls_relat) INDEX 1.
        SELECT SINGLE kunnr
        FROM lfa1
        INTO @DATA(ls_kunnr)
        WHERE lifnr = @ls_relat-lifnr.

        DATA(ls_transp) = it_keys[ 1 ].

        LOOP AT lt_relat ASSIGNING FIELD-SYMBOL(<fs_relat>).

          READ TABLE lt_tvkwz INTO DATA(ls_tvkwz) WITH KEY werks = <fs_relat>-werks
                                                  BINARY SEARCH.
          IF sy-subrc IS NOT INITIAL.
            CLEAR ls_tvkwz.
          ENDIF.
*** chamado 8000004978
*          IF <fs_relat>-spart EQ lc_spart_gv.
*            lv_bwart = lc_bwart_gv.
*          ELSE.
            lv_bwart = lc_bwart_nm.
*          ENDIF.

          READ TABLE lt_t001w ASSIGNING FIELD-SYMBOL(<fs_t001w>)
                                            WITH KEY werks = <fs_relat>-werks
                                            BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            lv_lifnr = <fs_t001w>-lifnr.
          ELSE.
            CLEAR lv_lifnr.
          ENDIF.

          lt_xkomdlgn = VALUE #( BASE lt_xkomdlgn ( vstel   = <fs_relat>-werks
                                                    vkorg   = ls_tvkwz-vkorg
                                                    vtweg   = ls_tvkwz-vtweg
                                                    spart   = <fs_relat>-spart
                                                    lfart   = lc_lfart
*                                                    kunwe   = <fs_relat>-lifnr
*                                                    lifnr   = lv_lifnr
                                                    kunwe   = ls_kunnr
                                                    lifnr   = <fs_relat>-lifnr
                                                    matnr   = <fs_relat>-matnr
                                                    werks   = <fs_relat>-werks
                                                    wadat   = sy-datum
                                                    lfdat   = sy-datum
                                                    lfimg   = <fs_relat>-picking
                                                    bwart   = lv_bwart
                                                    charg   = <fs_relat>-charg
*                                                    lifsk   = lc_lifsk
                                                    inco1   = ls_transp-incoterms1
                                                    inco2_l = ls_transp-incoterms2
                                                    traid   = ls_transp-traid
                                                    vrkme   = <fs_relat>-meins
                                                    vgbel   = <fs_relat>-ebeln
                                                    vgpos   = <fs_relat>-ebelp
                                                    vgtyp   = lc_vgtyp
                                                    lgort   = <fs_relat>-lgort
                                                    berot   = 'SUBCONTR.' ) ).

        ENDLOOP.

        lt_gn_partner = VALUE #( BASE lt_gn_partner ( parvw = lc_parvw
                                                      lifnr = ls_transp-transptdr ) ).

        DATA(ls_vbsk_i) = VALUE vbsk( sammg = lc_sammg
                                      smart = lc_smart ).

        me->call_gn_delivery_create( EXPORTING is_vbsk_i               = ls_vbsk_i
                                               iv_no_commit            = abap_true
                                               iv_vbls_pos_rueck       = abap_true
                                               iv_if_no_deque          = abap_true
                                               iv_if_no_partner_dialog = abap_true
                                               it_xkomdlgn             = lt_xkomdlgn
                                               it_xvbls                = lt_xvbls
                                               it_gn_partner           = lt_gn_partner
                                               iv_txsdc                = ls_transp-txsdc
                                     IMPORTING et_xvbfs                = DATA(lt_xvbfs)
                                               et_xxlips               = DATA(lt_xxlips) ).

        SORT lt_xvbfs BY msgty.
        READ TABLE lt_xvbfs TRANSPORTING NO FIELDS
                                          WITH KEY msgty = gc_error
                                          BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          LOOP AT lt_xvbfs ASSIGNING FIELD-SYMBOL(<fs_xvbfs>).
            et_return = VALUE #( BASE et_return ( id         = <fs_xvbfs>-msgid
                                                  number     = <fs_xvbfs>-msgno
                                                  type       = <fs_xvbfs>-msgty
                                                  message_v1 = <fs_xvbfs>-msgv1
                                                  message_v2 = <fs_xvbfs>-msgv2
                                                  message_v3 = <fs_xvbfs>-msgv3
                                                  message_v4 = <fs_xvbfs>-msgv4 ) ).
          ENDLOOP.
        ELSE.

          WAIT UP TO 1 SECONDS.

          IF lt_xxlips[] IS NOT INITIAL.
            SELECT DISTINCT vbeln
              FROM lips
              FOR ALL ENTRIES IN @lt_xxlips
              WHERE vbeln = @lt_xxlips-vbeln
                INTO TABLE @DATA(lt_lips_aux).

            IF sy-subrc IS INITIAL.

*              DATA(ls_xxlips) = VALUE #( lt_xxlips[ 1 ] OPTIONAL ).

*              IF sy-subrc IS INITIAL.
*                LOOP AT it_keys ASSIGNING FIELD-SYMBOL(<fs_keys>).
*                  UPDATE ztmm_sbct_pickin SET vbeln = ls_xxlips-vbeln
*                  WHERE rsnum = <fs_keys>-rsnum
*                    AND rspos = <fs_keys>-rspos.
*                ENDLOOP.
*              ENDIF.

              SORT lt_lips_aux BY vbeln.
*              DELETE ADJACENT DUPLICATES FROM lt_lips_aux COMPARING vbeln.
*              LOOP AT lt_lips_aux ASSIGNING FIELD-SYMBOL(<fs_lips>).

*                DATA(ls_vbkok) = VALUE vbkok( vbeln_vl = <fs_lips>-vbeln
*                                              wabuc    = lc_wabuc ).
*                CLEAR lt_vbpok_tab.
**                LOOP AT lt_xxlips ASSIGNING FIELD-SYMBOL(<fs_xxlips>).
**                  IF <fs_xxlips>-vbeln = <fs_lips>-vbeln.
**                    lt_vbpok_tab = VALUE #( BASE lt_vbpok_tab ( vbeln_vl = <fs_xxlips>-vbeln
**                                                                posnr_vl = <fs_xxlips>-posnr
**                                                                vbeln    = <fs_xxlips>-vgbel
**                                                                posnn    = <fs_xxlips>-vgpos
**                                                                pikmg    = <fs_xxlips>-lfimg ) ).
**                  ENDIF.
**                ENDLOOP.
*
*                lt_vbpok_tab = VALUE #( BASE lt_vbpok_tab FOR <fs_xxlips> IN lt_xxlips
*                WHERE ( vbeln = <fs_lips>-vbeln )
*                ( vbeln_vl = <fs_xxlips>-vbeln
*                  posnr_vl = <fs_xxlips>-posnr
*                  vbeln    = <fs_xxlips>-vgbel
*                  posnn    = <fs_xxlips>-vgpos
*                  pikmg    = <fs_xxlips>-lfimg ) ).
*
*                me->call_pickin( EXPORTING is_vbkok_wa  = ls_vbkok
*                                           iv_if_error  = abap_true
*                                           it_vbpok_tab = lt_vbpok_tab
*                                 IMPORTING et_prot      = DATA(lt_prot) ).
*
*                IF lt_prot[] IS NOT INITIAL.
**                  LOOP AT lt_prot ASSIGNING FIELD-SYMBOL(<fs_prot>).
**                    et_return = VALUE #( BASE et_return ( id         = <fs_prot>-msgid
**                                                          number     = <fs_prot>-msgno
**                                                          type       = <fs_prot>-msgty
**                                                          message_v1 = <fs_prot>-msgv1
**                                                          message_v2 = <fs_prot>-msgv2
**                                                          message_v3 = <fs_prot>-msgv3
**                                                          message_v4 = <fs_prot>-msgv4 ) ).
**                  ENDLOOP.
*                  et_return = VALUE #( BASE et_return FOR <fs_prot> IN lt_prot
*                   ( id         = <fs_prot>-msgid
*                     number     = <fs_prot>-msgno
*                     type       = <fs_prot>-msgty
*                     message_v1 = <fs_prot>-msgv1
*                     message_v2 = <fs_prot>-msgv2
*                     message_v3 = <fs_prot>-msgv3
*                     message_v4 = <fs_prot>-msgv4 ) ).
*
*                  CALL METHOD (gc_delete_sb_picking) EXPORTING it_keys = it_keys.
*
*                ELSE.
*
*                  me->limpa_tabz_picking( it_keys = it_keys ).
*
*                  et_return = VALUE #( BASE et_return ( id         = gc_msg_id
*                                                        number     = gc_sucess_exped
*                                                        type       = gc_sucess ) ).
*                ENDIF.
*
*
*              ENDLOOP.


              LOOP AT lt_xxlips ASSIGNING FIELD-SYMBOL(<fs_xlips_key>)
                GROUP BY ( vbeln = <fs_xlips_key>-vbeln )
                ASSIGNING FIELD-SYMBOL(<fs_xlips_group>).

                READ TABLE lt_lips_aux TRANSPORTING NO FIELDS
                  WITH KEY vbeln = <fs_xlips_group>-vbeln BINARY SEARCH.
                CHECK sy-subrc EQ 0.

                DATA(ls_vbkok) = VALUE vbkok( vbeln_vl = <fs_xlips_group>-vbeln
                                              wabuc    = lc_wabuc ).

                FREE lt_vbpok_tab.
                LOOP AT GROUP <fs_xlips_group> ASSIGNING FIELD-SYMBOL(<fs_xxlips>).
                  APPEND VALUE #( vbeln_vl = <fs_xxlips>-vbeln
                                  posnr_vl = <fs_xxlips>-posnr
                                  vbeln    = <fs_xxlips>-vbeln
                                  posnn    = <fs_xxlips>-posnr
                                  meins    = <fs_xxlips>-meins
*                                  vbeln    = <fs_xxlips>-vgbel
*                                  posnn    = <fs_xxlips>-vgpos
                                  pikmg    = <fs_xxlips>-lfimg ) TO lt_vbpok_tab.
                ENDLOOP.

                me->call_pickin( EXPORTING is_vbkok_wa  = ls_vbkok
                                           iv_if_error  = abap_true
                                           it_vbpok_tab = lt_vbpok_tab
                                 IMPORTING et_prot      = DATA(lt_prot) ).

                IF lt_prot[] IS NOT INITIAL.
                  et_return = VALUE #( BASE et_return FOR <fs_prot> IN lt_prot
                   ( id         = <fs_prot>-msgid
                     number     = <fs_prot>-msgno
                     type       = <fs_prot>-msgty
                     message_v1 = <fs_prot>-msgv1
                     message_v2 = <fs_prot>-msgv2
                     message_v3 = <fs_prot>-msgv3
                     message_v4 = <fs_prot>-msgv4 ) ).

                  CALL METHOD (gc_delete_sb_picking) EXPORTING it_keys = it_keys.

                ELSE.

                  CALL METHOD (gc_limpa_tabz_picking) EXPORTING it_keys = it_keys.

                  et_return = VALUE #( BASE et_return ( id         = gc_msg_id
                                                        number     = gc_sucess_exped
                                                        type       = gc_sucess ) ).
                ENDIF.

              ENDLOOP.

            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD setup_messages.

    CASE p_task.

      WHEN 'MM_SUBCON_DELIVERY'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_GN_DELIVERY_CREATE'
         IMPORTING
           et_xvbfs = gt_xvbfs
           et_lips  = gt_xxlips.

        gv_wait_async_1 = abap_true.

      WHEN 'MM_SUBCON_PICKING'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_PICKING'
          IMPORTING
            et_prot = gt_prot.

        gv_wait_async_2 = abap_true.

    ENDCASE.

  ENDMETHOD.


  METHOD valida_expedicao.

    CHECK it_keys[] IS NOT INITIAL.

    CONSTANTS: lc_spart_gv   TYPE mara-spart VALUE '05'.

    DATA: lv_grv TYPE char1.





*    SELECT a~rsnum,
*           a~rspos,
*           a~vbeln,
*           a~status,
*           a~picking,
*           a~quantidade,
*           b~spart
*      FROM zi_mm_resb_reserva_item AS a
*     INNER JOIN mara AS b ON b~matnr = a~matnr
*       FOR ALL ENTRIES IN @it_keys
*     WHERE rsnum = @it_keys-rsnum
*       AND rspos = @it_keys-rspos
*       AND vbeln = @it_keys-vbeln
*      INTO TABLE @DATA(lt_relat).


    SELECT a~rsnum,
           a~rspos,
           a~vbeln,
           a~status,
           a~picking,
           a~quantidade,
           b~spart
      FROM zi_mm_exped_subcontrat AS a
     INNER JOIN mara AS b ON b~matnr = a~matnr
       FOR ALL ENTRIES IN @it_keys
     WHERE rsnum = @it_keys-rsnum
       AND rspos = @it_keys-rspos
       AND ( item  = @it_keys-item OR item IS NULL )
       AND vbeln = @it_keys-vbeln
      INTO TABLE @DATA(lt_relat).

    IF sy-subrc IS INITIAL.

      CLEAR lv_grv.
      LOOP AT lt_relat ASSIGNING FIELD-SYMBOL(<fs_relat>).

        IF <fs_relat>-vbeln IS NOT INITIAL.
          et_return = VALUE #( BASE et_return ( id     = gc_msg_id
                                                type   = gc_error
                                                number = gc_error_exped_exist
                                                row    = sy-tabix ) ).
        ENDIF.

        IF <fs_relat>-status NE TEXT-001.
          et_return = VALUE #( BASE et_return ( id     = gc_msg_id
                                                type   = gc_error
                                                number = gc_error_pend
                                                row    = sy-tabix ) ).
        ENDIF.

        IF <fs_relat>-picking IS INITIAL.
          et_return = VALUE #( BASE et_return ( id     = gc_msg_id
                                                type   = gc_error
                                                number = gc_error_pkg_zero
                                                row    = sy-tabix ) ).
        ENDIF.

        IF <fs_relat>-picking GT <fs_relat>-quantidade.
          et_return = VALUE #( BASE et_return ( id     = gc_msg_id
                                                type   = gc_error
                                                number = gc_error_pkg_maior
                                                row    = sy-tabix ) ).
        ENDIF.

        IF lv_grv IS INITIAL AND <fs_relat>-spart = lc_spart_gv.
          lv_grv = abap_true.
        ELSEIF lv_grv IS NOT INITIAL AND <fs_relat>-spart = lc_spart_gv.
          et_return = VALUE #( BASE et_return ( id     = gc_msg_id
                                                type   = gc_error
                                                number = gc_error_grverd
                                                row    = sy-tabix ) ).
          EXIT.
        ELSE.
          CONTINUE.
        ENDIF.

      ENDLOOP.

      READ TABLE it_keys ASSIGNING FIELD-SYMBOL(<fs_keys>) INDEX 1.
      IF sy-subrc IS INITIAL.
        IF <fs_keys>-transptdr  IS INITIAL
        OR <fs_keys>-incoterms1 IS INITIAL
        OR <fs_keys>-incoterms2 IS INITIAL
        OR <fs_keys>-traid      IS INITIAL.

          et_return = VALUE #( BASE et_return ( id     = gc_msg_id
                                                type   = gc_error
                                                number = gc_error_transp
                                                row    = sy-tabix ) ).

        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD limpa_tabz_picking.

    IF it_keys[] IS NOT INITIAL.
*      SELECT mandt,
*             rsnum,
*             rspos,
*             vbeln,
*             picking,
*             dats,
*             user_proc
*        FROM ztmm_sbct_pickin
*         FOR ALL ENTRIES IN @it_keys
*       WHERE rsnum = @it_keys-rsnum
*         AND rspos = @it_keys-rspos
*        INTO TABLE @DATA(lt_delete).
*
*      IF sy-subrc IS INITIAL.
*        DELETE ztmm_sbct_pickin FROM TABLE lt_delete.
*      ENDIF.



      SELECT mandt,
             rsnum,
             rspos,
             item,
             vbeln
*             picking,
*             dats,
*             user_proc
        FROM ztmm_sb_picking
         FOR ALL ENTRIES IN @it_keys
       WHERE rsnum = @it_keys-rsnum
         AND rspos = @it_keys-rspos
         AND ( item = @it_keys-item OR item IS NULL )
        INTO TABLE @DATA(lt_delete).

      IF sy-subrc IS INITIAL.
        DELETE ztmm_sb_picking FROM TABLE lt_delete.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD delete_sb_picking.

    IF it_keys IS INITIAL.
      RETURN.
    ENDIF.

    SELECT * FROM ztmm_sb_picking
      FOR ALL ENTRIES IN @it_keys
      WHERE rsnum EQ @it_keys-rsnum
        AND rspos EQ @it_keys-rspos
        AND ( item EQ @it_keys-item
           OR item IS NULL )
      INTO TABLE @DATA(lt_picking).
    IF sy-subrc = 0.
      DATA lt_picking_del TYPE TABLE OF ztmm_sb_picking.

      LOOP AT lt_picking ASSIGNING FIELD-SYMBOL(<fs_picking>).
        IF <fs_picking>-fornecida = <fs_picking>-picking.
          APPEND <fs_picking> TO lt_picking_del.
*                        DELETE FROM ztmm_sb_picking
*                        WHERE rsnum = <fs_picking>-rsnum
*                          AND rspos = <fs_picking>-rspos
*                          AND item  = <fs_picking>-item.
        ENDIF.
      ENDLOOP.

      IF lt_picking_del IS NOT INITIAL.
        DELETE ztmm_sb_picking FROM TABLE lt_picking_del.
      ENDIF.

    ENDIF.


  ENDMETHOD.
ENDCLASS.
