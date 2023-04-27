CLASS zclmm_exped_espc_armazgm DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS expedicao
      IMPORTING
        !is_xml_trasnp TYPE zsmm_subc_xml_transp
        !it_keys       TYPE zctgmm_armaz_key
      EXPORTING
        !et_return     TYPE bapiret2_t .
    CLASS-METHODS setup_messages
      IMPORTING
        !p_task TYPE clike .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS gc_msg_id TYPE syst_msgid VALUE 'ZMM_SUBCONTRTC' ##NO_TEXT.
    CONSTANTS gc_sucess TYPE syst_msgty VALUE 'S' ##NO_TEXT.
    CONSTANTS gc_error TYPE syst_msgty VALUE 'E' ##NO_TEXT.
    CONSTANTS gc_erro_transp TYPE syst_msgno VALUE '019' ##NO_TEXT.
    CONSTANTS gc_erro_xml TYPE syst_msgno VALUE '039' ##NO_TEXT.
    CONSTANTS gc_erro_taxe TYPE syst_msgno VALUE '040' ##NO_TEXT.
    CLASS-DATA gt_xvbfs TYPE vbfs_t .
    CLASS-DATA gt_xxlips TYPE tt_lips .
    CLASS-DATA gt_prot TYPE tab_prott .
    CLASS-DATA gv_wait_async TYPE abap_bool .
    CONSTANTS gc_sucess_exped TYPE syst_msgno VALUE '021' ##NO_TEXT.

    METHODS valida_expedicao
      IMPORTING
        !is_xml_trasnp TYPE zsmm_subc_xml_transp
      EXPORTING
        !et_return     TYPE bapiret2_t .
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
        !is_xml_trasnp TYPE zsmm_subc_xml_transp
        !it_keys       TYPE zctgmm_armaz_key
      EXPORTING
        !et_return     TYPE bapiret2_t .
    METHODS call_pickin
      IMPORTING
        !is_vbkok_wa  TYPE zsmm_exped_vbkok
        !iv_if_error  TYPE xfeld DEFAULT 'X'
        !it_vbpok_tab TYPE vbpok_t
        !iv_docnum    TYPE j_1bdocnum
        !iv_itmnum    TYPE j_1bitmnum
      EXPORTING
        !et_prot      TYPE tab_prott .
    METHODS call_gn_delivery_create
      IMPORTING
        is_vbsk_i               TYPE vbsk
        iv_no_commit            TYPE rvsel-xfeld DEFAULT ' '
        iv_vbls_pos_rueck       TYPE rvsel-xfeld DEFAULT ' '
        iv_if_no_deque          TYPE xfeld DEFAULT space
        iv_if_no_partner_dialog TYPE xfeld DEFAULT 'X'
        it_xkomdlgn             TYPE shp_komdlgn_t
        it_xvbls                TYPE vbls_t
        it_gn_partner           TYPE partner_gn_t
        iv_TXSDC                type j_1btxsdc_
      EXPORTING
        et_xvbfs                TYPE vbfs_t
        et_xxlips               TYPE tt_lips .
    METHODS export_memory
      IMPORTING
        !iv_docnum TYPE j_1bdocnum
        !iv_itmnum TYPE j_1bitmnum.
ENDCLASS.



CLASS ZCLMM_EXPED_ESPC_ARMAZGM IMPLEMENTATION.


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


  METHOD call_gn_delivery_create.

    CALL FUNCTION 'ZFMMM_GN_DELIVERY_CREATE'
      STARTING NEW TASK 'MM_ARMZ_DELIVERY'
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

    WAIT UNTIL gv_wait_async = abap_true.
    et_xvbfs  = gt_xvbfs.
    et_xxlips = gt_xxlips.
    CLEAR gv_wait_async.

  ENDMETHOD.


  METHOD call_pickin.

    export_memory( EXPORTING iv_docnum = iv_docnum iv_itmnum = iv_itmnum ).

    CALL FUNCTION 'ZFMMM_PICKING'
      STARTING NEW TASK 'MM_ARMZ_PICKING'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        is_vbkok_wa  = is_vbkok_wa
        iv_if_error  = iv_if_error
        it_vbpok_tab = it_vbpok_tab
        iv_docnum = iv_docnum
        iv_itmnum = iv_itmnum
      IV_ESPECIAL = abap_true.

    WAIT UNTIL gv_wait_async = abap_true.
    et_prot = gt_prot.
    CLEAR gv_wait_async.

  ENDMETHOD.


  METHOD expedicao.

    CHECK it_keys[] IS NOT INITIAL. "t


      SELECT xml_entins
        FROM zi_mm_exped_armazenagem
         FOR ALL ENTRIES IN @it_keys
       WHERE docnum = @it_keys-docnum
         AND itmnum = @it_keys-itmnum
        INTO TABLE @DATA(lt_relat).

     sort lt_relat by XML_EntIns.
     delete ADJACENT DUPLICATES FROM lt_relat COMPARING XML_EntIns.

     if  lines( lt_relat ) > 1.

      me->add_return( EXPORTING iv_id     = gc_msg_id
                                iv_number = gc_erro_xml
                                iv_type   = gc_error
                       CHANGING ct_return = et_return ).
      exit.

     endif.

    me->valida_expedicao( EXPORTING is_xml_trasnp = is_xml_trasnp
                          IMPORTING et_return     = et_return ).

    SORT et_return BY type.
    READ TABLE et_return TRANSPORTING NO FIELDS
                                       WITH KEY type = gc_error
                                       BINARY SEARCH.
    IF sy-subrc IS NOT INITIAL.
      me->preenche_bapis( EXPORTING is_xml_trasnp = is_xml_trasnp
                                    it_keys       = it_keys
                          IMPORTING et_return     = et_return ).
    ENDIF.

  ENDMETHOD.


  METHOD preenche_bapis.

    DATA: lt_xkomdlgn    TYPE STANDARD TABLE OF komdlgn,
          lt_gn_partner  TYPE STANDARD TABLE OF partner_gn,
          lt_xvbls       TYPE vbls_t,
          lt_vbpok_tab   TYPE STANDARD TABLE OF vbpok,
          lt_prot_return TYPE STANDARD TABLE OF prott,
          lt_vbfs_return TYPE STANDARD TABLE OF vbfs.

    DATA: ls_vbkok TYPE zsmm_exped_vbkok.

    DATA: lv_grverd TYPE char1,
          lv_bwart  TYPE bwart,
          lv_lifnr  TYPE t001w-lifnr.

    CONSTANTS:
               lc_bwart_gv TYPE bwart       VALUE 'Y41',
*               lc_bwart_gv TYPE bwart       VALUE 'Y51',
               lc_bwart_nm TYPE bwart       VALUE 'Y41',
               lc_spart_gv TYPE mara-spart  VALUE '05',
               lc_lfart    TYPE lfart       VALUE 'LB',
               lc_lifsk    TYPE lifsk       VALUE '05',
               lc_parvw    TYPE parvw       VALUE 'SP',
               lc_sammg    TYPE sammg       VALUE 'SUBCONTRAT',
               lc_smart    TYPE smart       VALUE 'L',
               lc_wabuc    TYPE wabuc       VALUE 'Y',
               lc_outros   TYPE tvkwz-vtweg VALUE '10'.
*               lc_outros   TYPE tvkwz-vtweg VALUE '14'.

    IF it_keys[] IS NOT INITIAL.
      SELECT a~docnum,
             a~itmnum,
             a~matnr,
             a~werks,
             a~emlif,
             a~menge,
             a~meins,
             a~charg,
             a~vbeln,
             a~xml_entins,
             b~spart,
             c~parid
        FROM zi_mm_exped_armazenagem AS a
       INNER JOIN mara AS b ON b~matnr = a~matnr
       INNER JOIN j_1bnfe_active AS c ON c~docnum = a~docnum
         FOR ALL ENTRIES IN @it_keys
       WHERE a~docnum = @it_keys-docnum
         AND a~itmnum = @it_keys-itmnum
        INTO TABLE @DATA(lt_relat).

      IF sy-subrc IS INITIAL.

        DATA(lt_relat_fae) = lt_relat[].

        READ TABLE lt_relat INTO DATA(ls_relat) INDEX 1.

        SELECT docnum,
               itmnum,
               xped,
               nitemped,
               refkey
          FROM j_1bnflin
         WHERE docnum = @ls_relat-docnum
          INTO @DATA(ls_lin)
            UP TO 1 ROWS.
        ENDSELECT.

        DATA(ls_lin_belnr) = ls_lin-refkey(10).
        DATA(ls_lin_gjahr) = ls_lin-refkey+10(4).

        IF ls_lin_belnr IS NOT INITIAL.
          SELECT belnr,
                 gjahr,
                 buzei,
                 matnr,
                 menge,
                 lfbnr,
                 lfgja
           FROM rseg
           WHERE belnr = @ls_lin_belnr
             AND gjahr = @ls_lin_gjahr
            INTO TABLE @DATA(lt_rseg).

          IF sy-subrc IS INITIAL.

            DATA(lt_rseg_fae) = lt_rseg[].

            SORT lt_rseg_fae BY lfbnr
                                lfgja.

            DELETE ADJACENT DUPLICATES FROM lt_rseg_fae COMPARING lfbnr
                                                                  lfgja.

            SELECT mblnr,
                   mjahr,
                   werks,
                   matnr,
                   charg,
                   lgort,
                   menge,
                   meins
              FROM mseg
              FOR ALL ENTRIES IN @lt_rseg_fae
             WHERE mblnr = @lt_rseg_fae-lfbnr
               AND mjahr = @lt_rseg_fae-lfgja
              INTO TABLE @DATA(lt_mseg).

            IF sy-subrc IS INITIAL.
              SORT lt_mseg BY matnr.
            ENDIF.
          ENDIF.
        ENDIF.

        lt_relat_fae = lt_relat[].
        SORT lt_relat_fae BY werks.
        DELETE ADJACENT DUPLICATES FROM lt_relat_fae COMPARING werks.

        SELECT werks,
               vkorg,
               vtweg
          FROM tvkwz
           FOR ALL ENTRIES IN @lt_relat_fae
         WHERE werks = @lt_relat_fae-werks
           AND vtweg = @lc_outros
           AND vkorg <> '1410'
          INTO TABLE @DATA(lt_tvkwz).
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

        SORT lt_relat BY spart.

        READ TABLE lt_relat TRANSPORTING NO FIELDS
                                          WITH KEY spart = lc_spart_gv
                                          BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          lv_bwart = lc_bwart_gv. "Grão Verde
        ELSE.
          lv_bwart = lc_bwart_nm.
        ENDIF.

        SORT lt_relat BY matnr.

        DATA(lt_relat_aux) = lt_relat[].
        DELETE ADJACENT DUPLICATES FROM lt_relat_aux COMPARING matnr.

        SELECT SINGLE kunnr
        FROM lfa1
        INTO @DATA(ls_kunnr)
        WHERE lifnr = @ls_relat-emlif.

        LOOP AT lt_relat_aux ASSIGNING FIELD-SYMBOL(<fs_relat_aux>).

          FREE: lt_xkomdlgn[],
                lt_gn_partner[],
                gt_xvbfs[],
                gt_xxlips[].

          READ TABLE lt_mseg TRANSPORTING NO FIELDS
                                           WITH KEY matnr = <fs_relat_aux>-matnr
                                           BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            LOOP AT lt_mseg ASSIGNING FIELD-SYMBOL(<fs_relat>) FROM sy-tabix. "#EC CI_NESTED
              IF <fs_relat>-matnr NE <fs_relat_aux>-matnr.
                EXIT.
              ENDIF.

              READ TABLE lt_tvkwz INTO DATA(ls_tvkwz) WITH KEY werks = <fs_relat>-werks
                                                      BINARY SEARCH.
              IF sy-subrc IS NOT INITIAL.
                CLEAR ls_tvkwz.
              ENDIF.

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
                                                        spart   = <fs_relat_aux>-spart
                                                        lfart   = lc_lfart
*                                                      kunwe   = <fs_relat_aux>-emlif
                                                        kunwe   = ls_kunnr
                                                        matnr   = <fs_relat>-matnr
                                                        werks   = <fs_relat>-werks
                                                        wadat   = sy-datum
                                                        lfdat   = sy-datum
                                                        lfimg   = <fs_relat>-menge
                                                        vrkme   = <fs_relat>-meins
*                                                        MEINS   = <fs_relat>-meins
                                                        charg   = <fs_relat>-charg
                                                        kzazu   = abap_true
                                                        inco1   = is_xml_trasnp-incoterms1
                                                        lgort = <fs_relat>-lgort
                                                        lifnr   = <fs_relat_aux>-emlif
                                                        traid   = is_xml_trasnp-traid
                                                        bwart   = lv_bwart
                                                        inco3_l = <fs_relat_aux>-xml_entins
*                                                        lifsk   = lc_lifsk
                                                        inco2_l = is_xml_trasnp-incoterms2
                                                        berot   = 'SUBCONTR.' ) ).
            ENDLOOP.
          ENDIF.
          IF is_xml_trasnp-transptdr IS NOT INITIAL.
            lt_gn_partner = VALUE #( BASE lt_gn_partner ( parvw = lc_parvw
                                                          lifnr = is_xml_trasnp-transptdr ) ).
          ENDIF.
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
                                                 iv_txsdc                = is_xml_trasnp-txsdc
                                       IMPORTING et_xvbfs                = DATA(lt_xvbfs)
                                                 et_xxlips               = DATA(lt_xxlips) ).

*          READ TABLE lt_xvbfs TRANSPORTING NO FIELDS
*                                            WITH KEY msgty = gc_error.
          IF line_exists( lt_xvbfs[ msgty = gc_error ] ). "#EC CI_STDSEQ
*          IF sy-subrc IS INITIAL.

            APPEND LINES OF lt_xvbfs TO lt_vbfs_return.
            FREE: lt_xvbfs[].

          ELSE.

            WAIT UP TO 1 SECONDS.

            IF lt_xxlips[] IS NOT INITIAL.
              SELECT vbeln
                FROM lips
                 FOR ALL ENTRIES IN @lt_xxlips
               WHERE vbeln = @lt_xxlips-vbeln
                INTO TABLE @DATA(lt_lips_ret).

              IF sy-subrc IS INITIAL.

                DATA(ls_xxlips) = VALUE #( lt_lips_ret[ 1 ] OPTIONAL ).

*                LOOP AT lt_xxlips ASSIGNING FIELD-SYMBOL(<fs_xxlips>).
*                  lt_vbpok_tab = VALUE #( BASE lt_vbpok_tab ( vbeln_vl = <fs_xxlips>-vbeln
*                                                              posnr_vl = <fs_xxlips>-posnr
*                                                              vbeln    = <fs_xxlips>-vgbel
*                                                              posnn    = <fs_xxlips>-vgpos
*                                                              pikmg    = <fs_xxlips>-lfimg ) ).
*                ENDLOOP.

                  lt_vbpok_tab = VALUE #( BASE lt_vbpok_tab
                    FOR ls_xxlips1 IN lt_xxlips (
                      vbeln_vl = ls_xxlips1-vbeln
                      posnr_vl = ls_xxlips1-posnr
                      vbeln    = ls_xxlips1-vbeln
                      posnn    = ls_xxlips1-posnr
*                      vbeln    = ls_xxlips1-vgbel
*                      posnn    = ls_xxlips1-vgpos
                      pikmg    = ls_xxlips1-lfimg
                      meins    = ls_xxlips1-meins
                  ) ).

                ls_vbkok-vbeln_vl = ls_xxlips-vbeln.
                ls_vbkok-wabuc    = lc_wabuc.

                me->call_pickin( EXPORTING is_vbkok_wa  = ls_vbkok
                                           iv_if_error  = abap_true
                                           it_vbpok_tab = lt_vbpok_tab
                                           iv_docnum    = <fs_relat_aux>-Docnum
                                           iv_itmnum    = <fs_relat_aux>-Itmnum
                                 IMPORTING et_prot      = DATA(lt_prot) ).

                IF lt_prot[] IS NOT INITIAL.

                  APPEND LINES OF lt_prot TO lt_prot_return.

                ELSE.
                  et_return = VALUE #( BASE et_return ( id         = gc_msg_id
                                                        number     = gc_sucess_exped
                                                        type       = gc_sucess ) ).
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.

    IF lt_vbfs_return[] IS NOT INITIAL.
      LOOP AT lt_vbfs_return ASSIGNING FIELD-SYMBOL(<fs_xvbfs>).
        et_return = VALUE #( BASE et_return ( id         = <fs_xvbfs>-msgid
                                              number     = <fs_xvbfs>-msgno
                                              type       = <fs_xvbfs>-msgty
                                              message_v1 = <fs_xvbfs>-msgv1
                                              message_v2 = <fs_xvbfs>-msgv2
                                              message_v3 = <fs_xvbfs>-msgv3
                                              message_v4 = <fs_xvbfs>-msgv4 ) ).
      ENDLOOP.
    ENDIF.

    IF lt_prot_return[] IS NOT INITIAL.
      LOOP AT lt_prot_return ASSIGNING FIELD-SYMBOL(<fs_prot>).
        et_return = VALUE #( BASE et_return ( id         = <fs_prot>-msgid
                                              number     = <fs_prot>-msgno
                                              type       = <fs_prot>-msgty
                                              message_v1 = <fs_prot>-msgv1
                                              message_v2 = <fs_prot>-msgv2
                                              message_v3 = <fs_prot>-msgv3
                                              message_v4 = <fs_prot>-msgv4 ) ).
      ENDLOOP.
      FREE: lt_prot_return[].
    ENDIF.

  ENDMETHOD.


  METHOD setup_messages.

    CASE p_task.

      WHEN 'MM_ARMZ_DELIVERY'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_GN_DELIVERY_CREATE'
         IMPORTING
           et_xvbfs = gt_xvbfs
           et_lips  = gt_xxlips.

      WHEN 'MM_ARMZ_PICKING'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_PICKING'
          IMPORTING
            et_prot = gt_prot.

    ENDCASE.

    gv_wait_async = abap_true.

  ENDMETHOD.


  METHOD valida_expedicao.

*    IF is_xml_trasnp-transptdr  IS INITIAL
*    OR is_xml_trasnp-traid      IS INITIAL
*    OR is_xml_trasnp-incoterms1 IS INITIAL
*    OR is_xml_trasnp-incoterms2 IS INITIAL.
*
*      me->add_return( EXPORTING iv_id     = gc_msg_id
*                                iv_number = gc_erro_transp
*                                iv_type   = gc_error
*                       CHANGING ct_return = et_return ).
*
*    ENDIF.

    if is_xml_trasnp-txsdc is not initial.
       select SINGLE taxcode
        from J_1BTXSDC
        where taxcode = @is_xml_trasnp-txsdc
        into @data(lv_J_1BTXSDC).


       if sy-subrc <> 0.

      me->add_return( EXPORTING iv_id     = gc_msg_id
                                iv_number = gc_erro_taxe
                                iv_type   = gc_error
                       CHANGING ct_return = et_return ).
       endif.

    endif.

  ENDMETHOD.


  METHOD export_memory.

    FREE MEMORY ID 'ARMAZ'.

    DATA(ls_armaz_key) = VALUE zsmm_armaz_key( docnum = iv_docnum itmnum = iv_docnum ).

    EXPORT ls_armaz_key FROM ls_armaz_key TO MEMORY ID 'ARMAZ'.

  ENDMETHOD.
ENDCLASS.
