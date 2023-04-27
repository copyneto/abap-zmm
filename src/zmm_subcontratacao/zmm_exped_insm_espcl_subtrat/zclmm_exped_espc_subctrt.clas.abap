class ZCLMM_EXPED_ESPC_SUBCTRT definition
  public
  final
  create public .

public section.

  methods EXPEDICAO
    importing
      !IS_XML_TRASNP type ZSMM_SUBC_XML_TRANSP
      !IT_KEYS type ZCTGMM_SUBC_KEY
    exporting
      !ET_RETURN type BAPIRET2_T .
  methods ADD_RETURN
    importing
      !IV_ID type SYMSGID optional
      !IV_NUMBER type SYMSGNO optional
      !IV_TYPE type BAPI_MTYPE optional
      !IV_MESSAGE_V1 type SYMSGV optional
      !IV_MESSAGE_V2 type SYMSGV optional
      !IV_MESSAGE_V3 type SYMSGV optional
      !IV_MESSAGE_V4 type SYMSGV optional
      !IT_RETURN type BAPIRET2_T optional
    changing
      !CT_RETURN type BAPIRET2_T .
  class-methods SETUP_MESSAGES
    importing
      !P_TASK type CLIKE .
protected section.
private section.

  types:
    BEGIN OF ty_lin_aux,
      belnr TYPE rseg-belnr,
      gjahr TYPE rseg-gjahr,
    END OF ty_lin_aux .
  types:
    BEGIN OF ty_sum_qtd,
      matnr TYPE matnr,
      lgort TYPE lgort_d,
      charg TYPE charg_d,
      qtd   TYPE zi_mm_expedinsum_espc_subcontr-quantidade,
      meins TYPE meins,
    END OF ty_sum_qtd .
  types:
    BEGIN OF ty_lin_ped,
      ebeln TYPE ekpo-ebeln,
      ebelp TYPE ekpo-ebelp,
    END OF ty_lin_ped .

  constants GC_MSG_ID type SYST_MSGID value 'ZMM_SUBCONTRTC' ##NO_TEXT.
  constants GC_SUCESS type SYST_MSGTY value 'S' ##NO_TEXT.
  constants GC_ERROR type SYST_MSGTY value 'E' ##NO_TEXT.
  constants GC_ERRO_NO_XML type SYST_MSGNO value '010' ##NO_TEXT.
  constants GC_ERRO_NFOD_XML type SYST_MSGNO value '011' ##NO_TEXT.
  constants GC_ERRO_XML_TRIANG type SYST_MSGNO value '012' ##NO_TEXT.
  constants GC_ERRO_CONCLUIDO type SYST_MSGNO value '013' ##NO_TEXT.
  constants GC_ERRO_MAT_DIF type SYST_MSGNO value '014' ##NO_TEXT.
  constants GC_ERRO_QTD_DIF type SYST_MSGNO value '015' ##NO_TEXT.
  constants GC_ERRO_FORNEC type SYST_MSGNO value '016' ##NO_TEXT.
  constants GC_ERRO_CFOP type SYST_MSGNO value '017' ##NO_TEXT.
  constants GC_ERRO_LFART type SYST_MSGNO value '018' ##NO_TEXT.
  constants GC_ERRO_TRANSP type SYST_MSGNO value '019' ##NO_TEXT.
  constants GC_ERRO_PROC type SYST_MSGNO value '020' ##NO_TEXT.
  class-data GV_WAIT_ASYNC type ABAP_BOOL .
  class-data GV_WAIT_ASYNC_1 type ABAP_BOOL .
  class-data GT_XVBFS type VBFS_T .
  class-data GT_XXLIPS type TT_LIPS .
  class-data GT_PROT type TAB_PROTT .
  constants GC_SUCESS_EXPED type SYST_MSGNO value '021' ##NO_TEXT.
  constants GC_ERRO_CONCL type SYST_MSGNO value '022' ##NO_TEXT.
  constants GC_ERRO_LINES type SYST_MSGNO value '023' ##NO_TEXT.

  methods VALIDA_EXPEDICAO
    importing
      !IS_XML_TRASNP type ZSMM_SUBC_XML_TRANSP
      !IT_KEYS type ZCTGMM_SUBC_KEY
    exporting
      !ET_RETURN type BAPIRET2_T .
  methods PREENCHE_BAPIS
    importing
      !IS_XML_TRASNP type ZSMM_SUBC_XML_TRANSP
      !IT_KEYS type ZCTGMM_SUBC_KEY
    exporting
      !ET_RETURN type BAPIRET2_T .
  methods CALL_GN_DELIVERY_CREATE
    importing
      !IS_VBSK_I type VBSK optional
      !IV_NO_COMMIT type RVSEL-XFELD default ' '
      !IV_VBLS_POS_RUECK type RVSEL-XFELD default ' '
      !IV_IF_NO_DEQUE type XFELD default SPACE
      !IV_IF_NO_PARTNER_DIALOG type XFELD default 'X'
      !IT_XKOMDLGN type SHP_KOMDLGN_T optional
      !IT_XVBLS type VBLS_T
      !IT_GN_PARTNER type PARTNER_GN_T optional
      iv_txsdc                 TYPE j_1btxsdc_
    exporting
      !ET_XVBFS type VBFS_T
      !ET_XXLIPS type TT_LIPS .
  methods CALL_PICKIN
    importing
      !IS_VBKOK_WA type ZSMM_EXPED_VBKOK optional
      !IV_IF_ERROR type XFELD default 'X'
      !IT_VBPOK_TAB type VBPOK_T optional
      !IV_DOCNUM type J_1BDOCNUM optional
      !IV_ITMNUM type J_1BITMNUM optional
    exporting
      !ET_PROT type TAB_PROTT .
  methods VALIDA_ESTORNO_EXPED
    importing
      !IT_KEYS type ZCTGMM_SUBC_KEY
    exporting
      !ET_RETURN type BAPIRET2_T .
ENDCLASS.



CLASS ZCLMM_EXPED_ESPC_SUBCTRT IMPLEMENTATION.


  METHOD expedicao.

    me->valida_expedicao( EXPORTING is_xml_trasnp = is_xml_trasnp
                                    it_keys       = it_keys
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


  METHOD valida_expedicao.

    DATA: lt_lin_aux  TYPE STANDARD TABLE OF ty_lin_aux,
          lt_sum_qtd  TYPE STANDARD TABLE OF ty_sum_qtd,
          lt_sum_rseg TYPE STANDARD TABLE OF ty_sum_qtd,
          lt_lin_ped  TYPE STANDARD TABLE OF ty_lin_ped.

    DATA: ls_sum_qtd TYPE ty_sum_qtd,
          ls_lin_ped TYPE ty_lin_ped.

    CONSTANTS: lc_cfop_1 TYPE j_1bnflin-cfop VALUE '1122AA',
               lc_cfop_2 TYPE j_1bnflin-cfop VALUE '2122AA',
               lc_kfart  TYPE likp-lfart     VALUE 'LB'.

*    SELECT guid_header,
*           nfeid,
*           uf_emit,
*           demi,
*           cnpj_emit,
*           mod,
*           nnf
*      FROM /xnfe/innfehd
*     WHERE nfeid = @is_xml_trasnp-xml_transp
*      INTO @DATA(ls_xnfe)
*        UP TO 1 ROWS.
*    ENDSELECT.
*
*    IF sy-subrc IS INITIAL.

    IF is_xml_trasnp-xml_transp IS NOT INITIAL.

      SELECT docnum
        FROM j_1bnfe_active
       INTO TABLE @DATA(lt_active)
       WHERE regio       EQ @is_xml_trasnp-xml_transp(2)
         AND nfyear      EQ @is_xml_trasnp-xml_transp+2(2)
         AND nfmonth     EQ @is_xml_trasnp-xml_transp+4(2)
         AND stcd1       EQ @is_xml_trasnp-xml_transp+6(14)
         AND model       EQ @is_xml_trasnp-xml_transp+20(2)
         AND nfnum9      EQ @is_xml_trasnp-xml_transp+25(9)
         AND action_requ EQ 'C'
         AND cancel      NE @abap_true.

      IF sy-subrc IS NOT INITIAL.
        me->add_return(
          EXPORTING
            iv_id         = gc_msg_id
            iv_number     = gc_erro_nfod_xml
            iv_type       = gc_error
          CHANGING
            ct_return     = et_return ).
        RETURN.
      ELSE.

        DATA(lt_active_fae) = lt_active[].
        SORT lt_active_fae BY docnum.
        DELETE ADJACENT DUPLICATES FROM lt_active_fae COMPARING docnum.

        IF lt_active_fae[] IS NOT INITIAL.
          SELECT docnum,
                 itmnum,
                 refkey,
                 xped,
                 nitemped,
                 cfop
            FROM j_1bnflin
             FOR ALL ENTRIES IN @lt_active_fae
           WHERE docnum = @lt_active_fae-docnum
            INTO TABLE @DATA(lt_lin).

          IF sy-subrc IS INITIAL.
            SORT lt_lin BY docnum.

            LOOP AT lt_lin ASSIGNING FIELD-SYMBOL(<fs_lin>).

              IF <fs_lin>-cfop EQ lc_cfop_1
              OR <fs_lin>-cfop EQ lc_cfop_2.
                lt_lin_ped = VALUE #( BASE lt_lin_ped ( ebeln = <fs_lin>-xped(10)
                                                        ebelp = <fs_lin>-nitemped(5) ) ).
                lt_lin_ped = VALUE #( BASE lt_lin_ped ( ebeln = <fs_lin>-xped(10)
                                                        ebelp = <fs_lin>-nitemped+1(5) ) ).
              ELSE.
                me->add_return( EXPORTING iv_id     = gc_msg_id
                                          iv_number = gc_erro_cfop
                                          iv_type   = gc_error
                                 CHANGING ct_return = et_return ).
                RETURN.
              ENDIF.
            ENDLOOP.

            IF lt_lin_ped[] IS NOT INITIAL.

              SELECT ebeln,
                     ebelp,
                     emlif
                FROM ekpo
                 FOR ALL ENTRIES IN @lt_lin_ped
               WHERE ebeln = @lt_lin_ped-ebeln
                 AND ebelp = @lt_lin_ped-ebelp
                 AND serru = @abap_true
                INTO TABLE @DATA(lt_ekpo).

              IF sy-subrc IS INITIAL.
                SORT lt_ekpo BY ebeln
                                ebelp.

                DATA(lt_ekpo_fae) = lt_ekpo[].

                SORT lt_ekpo_fae BY ebeln.
                DELETE ADJACENT DUPLICATES FROM lt_ekpo_fae COMPARING ebeln.

                SELECT ebeln,
                       lifnr
                  FROM ekko
                   FOR ALL ENTRIES IN @lt_ekpo_fae
                 WHERE ebeln = @lt_ekpo_fae-ebeln
                  INTO TABLE @DATA(lt_ekko).

                IF sy-subrc IS INITIAL.
                  SORT lt_ekko BY lifnr.
                ENDIF.

              ENDIF.
            ENDIF.

            LOOP AT lt_lin ASSIGNING <fs_lin>.
              IF <fs_lin>-refkey IS NOT INITIAL.
                lt_lin_aux = VALUE #( BASE lt_lin_aux ( belnr = <fs_lin>-refkey(10)
                                                        gjahr = <fs_lin>-refkey+10(4) ) ).
              ENDIF.
            ENDLOOP.

            SORT lt_lin_aux BY belnr
                               gjahr.

            IF lt_lin_aux[] IS NOT INITIAL.
              SELECT belnr,
                     gjahr,
                     buzei,
                     matnr,
                     menge
                FROM rseg
                 FOR ALL ENTRIES IN @lt_lin_aux
               WHERE belnr = @lt_lin_aux-belnr
                 AND gjahr = @lt_lin_aux-gjahr
                INTO TABLE @DATA(lt_rseg).

              IF sy-subrc IS INITIAL.
                SORT lt_rseg BY matnr.

                LOOP AT lt_rseg ASSIGNING FIELD-SYMBOL(<fs_rseg>).
                  ls_sum_qtd-matnr = <fs_rseg>-matnr.
                  ls_sum_qtd-qtd   = <fs_rseg>-menge.
                  COLLECT ls_sum_qtd INTO lt_sum_rseg.
                ENDLOOP.

                SORT lt_sum_rseg BY matnr.

              ENDIF.
            ENDIF.

            IF it_keys[] IS NOT INITIAL.

              SELECT rsnum,
                     rspos,
                     matnr,
                     werks,
                     quantidade,
                     status,
                     lifnr
                FROM zi_mm_expedinsum_espc_subcontr
                 FOR ALL ENTRIES IN @it_keys
               WHERE rsnum = @it_keys-rsnum
                 AND rspos = @it_keys-rspos
                 AND vbeln IS INITIAL
                INTO TABLE @DATA(lt_relat).

              IF sy-subrc IS INITIAL.

                DATA(lt_relat_valid) = lt_relat[].
                SORT lt_relat_valid BY werks
                                       lifnr.
                DELETE ADJACENT DUPLICATES FROM lt_relat_valid COMPARING werks
                                                                         lifnr.
                DATA(lv_lines) = lines( lt_relat_valid ).
                IF lv_lines GT 1.
                  me->add_return( EXPORTING iv_id     = gc_msg_id
                                            iv_number = gc_erro_proc
                                            iv_type   = gc_error
                                   CHANGING ct_return = et_return ).
                  RETURN.
                ENDIF.

                LOOP AT lt_relat ASSIGNING FIELD-SYMBOL(<fs_relat>).

                  IF <fs_relat>-status EQ TEXT-001. " Concluído
                    me->add_return( EXPORTING iv_id     = gc_msg_id
                                              iv_number = gc_erro_concluido
                                              iv_type   = gc_error
                                     CHANGING ct_return = et_return ).
                    RETURN.
                  ENDIF.

                  READ TABLE lt_rseg TRANSPORTING NO FIELDS
                                                   WITH KEY matnr = <fs_relat>-matnr
                                                   BINARY SEARCH.
                  IF sy-subrc IS NOT INITIAL.
                    me->add_return( EXPORTING iv_id     = gc_msg_id
                                              iv_number = gc_erro_mat_dif
                                              iv_type   = gc_error
                                     CHANGING ct_return = et_return ).
                    RETURN.
                  ENDIF.

                  READ TABLE lt_ekpo TRANSPORTING NO FIELDS
                                                   WITH KEY emlif = <fs_relat>-lifnr
                                                   BINARY SEARCH.
                  IF sy-subrc IS NOT INITIAL.
                    me->add_return( EXPORTING iv_id     = gc_msg_id
                                              iv_number = gc_erro_fornec
                                              iv_type   = gc_error
                                     CHANGING ct_return = et_return ).
                    RETURN.
                  ENDIF.

                  ls_sum_qtd-matnr = <fs_relat>-matnr.
                  ls_sum_qtd-qtd   = <fs_relat>-quantidade.
                  COLLECT ls_sum_qtd INTO lt_sum_qtd.
                ENDLOOP.

                LOOP AT lt_sum_qtd ASSIGNING FIELD-SYMBOL(<fs_sum_qtd>).

                  READ TABLE lt_sum_rseg ASSIGNING FIELD-SYMBOL(<fs_sum_rseg>)
                                                       WITH KEY matnr = <fs_sum_qtd>-matnr
                                                       BINARY SEARCH.

                  IF <fs_sum_qtd>-qtd < <fs_sum_rseg>-qtd.
                    me->add_return( EXPORTING iv_id     = gc_msg_id
                                              iv_number = gc_erro_qtd_dif
                                              iv_type   = gc_error
                                     CHANGING ct_return = et_return ).
                    RETURN.
                  ENDIF.
                ENDLOOP.

                DATA(lt_relat_fae) = lt_relat[].

                SORT lt_relat_fae BY matnr.
                DELETE ADJACENT DUPLICATES FROM lt_relat_fae COMPARING matnr.

                SELECT matnr
                  FROM mara
                   FOR ALL ENTRIES IN @lt_relat_fae
                 WHERE matnr = @lt_relat_fae-matnr
                  INTO TABLE @DATA(lt_mara).

                IF sy-subrc IS INITIAL.
                  SORT lt_mara BY matnr.
                ENDIF.

                SELECT vbeln,
                       inco3_l
                  FROM likp
                 WHERE lfart   = @lc_kfart
                   AND inco3_l = @is_xml_trasnp-xml_transp
                  INTO TABLE @DATA(lt_likp).

                IF sy-subrc IS INITIAL.
                  me->add_return( EXPORTING iv_id     = gc_msg_id
                                            iv_number = gc_erro_lfart
                                            iv_type   = gc_error
                                   CHANGING ct_return = et_return ).
                  RETURN.
                ENDIF.

                SELECT werks,
                       vtweg
                  FROM tvkwz
                   FOR ALL ENTRIES IN @lt_relat
                 WHERE werks = @lt_relat-werks
                   AND vtweg = '14'
                  INTO TABLE @DATA(lt_tvkwz).

                IF sy-subrc IS INITIAL.
                  SORT lt_tvkwz BY werks.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.

        LOOP AT lt_active ASSIGNING FIELD-SYMBOL(<fs_active>).

          READ TABLE lt_lin TRANSPORTING NO FIELDS
                                          WITH KEY docnum = <fs_active>-docnum
                                          BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            LOOP AT lt_lin ASSIGNING FIELD-SYMBOL(<fs_lin_aux>) FROM sy-tabix.
              IF <fs_lin_aux>-docnum NE <fs_active>-docnum.
                EXIT.
              ENDIF.

              ls_lin_ped-ebeln = <fs_lin_aux>-xped.
              ls_lin_ped-ebelp = <fs_lin_aux>-nitemped.

              READ TABLE lt_ekpo TRANSPORTING NO FIELDS
                                               WITH KEY ebeln = ls_lin_ped-ebeln
                                                        ebelp = ls_lin_ped-ebelp
                                                        BINARY SEARCH.
              IF sy-subrc IS INITIAL.
                LOOP AT lt_ekpo ASSIGNING FIELD-SYMBOL(<fs_ekpo>) FROM sy-tabix.
                  IF <fs_ekpo>-ebeln NE ls_lin_ped-ebeln
                  OR <fs_ekpo>-ebelp NE ls_lin_ped-ebelp.
                    EXIT.
                  ENDIF.

                  READ TABLE lt_ekko TRANSPORTING NO FIELDS
                                                   WITH KEY ebeln = <fs_ekpo>-ebeln
                                                   BINARY SEARCH.
                  IF sy-subrc IS NOT INITIAL.
                    me->add_return( EXPORTING iv_id     = gc_msg_id
                                              iv_number = gc_erro_xml_triang
                                              iv_type   = gc_error
                                     CHANGING ct_return = et_return ).
                    RETURN.
                  ENDIF.
                ENDLOOP.
              ELSE.
                me->add_return( EXPORTING iv_id     = gc_msg_id
                                          iv_number = gc_erro_xml_triang
                                          iv_type   = gc_error
                                 CHANGING ct_return = et_return ).
                RETURN.
              ENDIF.
            ENDLOOP.
          ENDIF.
        ENDLOOP.

        IF is_xml_trasnp-transptdr  IS INITIAL
        OR is_xml_trasnp-incoterms1 IS INITIAL
        OR is_xml_trasnp-incoterms2 IS INITIAL
        OR is_xml_trasnp-traid      IS INITIAL.

          SELECT werks,
                 regio
            FROM t001w
             FOR ALL ENTRIES IN @lt_relat
           WHERE werks = @lt_relat-werks
            INTO TABLE @DATA(lt_t001w).

          IF sy-subrc IS INITIAL.
            SORT lt_t001w BY regio.

            DATA(lt_t001w_fae) = lt_t001w[].
            SORT lt_t001w_fae BY regio.
            DELETE ADJACENT DUPLICATES FROM lt_t001w_fae COMPARING regio.

            SELECT shipfrom,
                   shipto
              FROM ztmm_emissa_nf
               FOR ALL ENTRIES IN @lt_t001w_fae
             WHERE shipfrom = @lt_t001w_fae-regio
              INTO TABLE @DATA(lt_regio_nf).

            IF sy-subrc IS INITIAL.
              SORT lt_regio_nf BY shipfrom
                                  shipto.
            ENDIF.
          ENDIF.

          SELECT lifnr,
                 regio
            FROM lfa1
             FOR ALL ENTRIES IN @lt_relat
           WHERE lifnr = @lt_relat-lifnr
            INTO TABLE @DATA(lt_lfa1).

          IF sy-subrc IS INITIAL.
            SORT lt_lfa1 BY regio.
          ENDIF.

          LOOP AT lt_relat ASSIGNING <fs_relat>.

            READ TABLE lt_t001w ASSIGNING FIELD-SYMBOL(<fs_t001w>)
                                              WITH KEY werks = <fs_relat>-werks
                                              BINARY SEARCH.
            IF sy-subrc IS INITIAL.

              READ TABLE lt_lfa1 ASSIGNING FIELD-SYMBOL(<fs_lfa1>)
                                               WITH KEY lifnr = <fs_relat>-lifnr
                                               BINARY SEARCH.
              IF sy-subrc IS INITIAL.

                READ TABLE lt_regio_nf TRANSPORTING NO FIELDS
                                                     WITH KEY shipfrom = <fs_t001w>-regio
                                                              shipto   = <fs_lfa1>-regio
                                                              BINARY SEARCH.
                IF sy-subrc IS NOT INITIAL.

*                  me->add_return( EXPORTING iv_id     = gc_msg_id
*                                            iv_number = gc_erro_transp
*                                            iv_type   = gc_error
*                                   CHANGING ct_return = et_return ).

                ENDIF.
              ENDIF.
            ENDIF.
          ENDLOOP.

        ENDIF.
      ENDIF.

    ELSE.

      me->add_return(
        EXPORTING
          iv_id         = gc_msg_id
          iv_number     = gc_erro_nfod_xml
          iv_type       = gc_error
        CHANGING
          ct_return     = et_return ).
      RETURN.
    ENDIF.

  ENDMETHOD.


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
      STARTING NEW TASK 'MM_BAPI_DELIVERY'
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
    FREE gv_wait_async.

  ENDMETHOD.


  METHOD call_pickin.

    CALL FUNCTION 'ZFMMM_PICKING'
      STARTING NEW TASK 'MM_BAPI_PICKING'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        is_vbkok_wa  = is_vbkok_wa
        iv_if_error  = iv_if_error
        it_vbpok_tab = it_vbpok_tab
        iv_docnum    = iv_docnum
        iv_itmnum    = iv_itmnum
        iv_especial  = abap_true.

    WAIT UNTIL gv_wait_async_1 = abap_true.
    et_prot = gt_prot.
    FREE gv_wait_async_1.

  ENDMETHOD.


  METHOD preenche_bapis.

    DATA: lt_xkomdlgn   TYPE STANDARD TABLE OF komdlgn,
          lt_gn_partner TYPE STANDARD TABLE OF partner_gn,
          lt_sum_qtd    TYPE STANDARD TABLE OF ty_sum_qtd,
          lt_sum_mseg   TYPE STANDARD TABLE OF ty_sum_qtd,
          lt_xvbls      TYPE vbls_t,
          lt_vbpok_tab  TYPE STANDARD TABLE OF vbpok.

    DATA: ls_lin_ped TYPE ty_lin_ped,
          ls_lin_ref TYPE ty_lin_aux,
          ls_sum_qtd TYPE ty_sum_qtd,
          ls_vbkok   TYPE zsmm_exped_vbkok.

    DATA: lv_matnr      TYPE matnr,
          lv_dif        TYPE rseg-menge,
          lv_lfimg      TYPE lfimg,
          lv_lfimg_saldo TYPE lfimg,
          lv_bapi_lfimg TYPE lfimg,
          lv_bwart      TYPE bwart.

    CONSTANTS: lc_outros    TYPE tvkwz-vtweg             VALUE '14',
               lc_sammg     TYPE sammg                   VALUE 'SUBCONTRAT',
               lc_smart     TYPE smart                   VALUE 'L',
               lc_vgtyp     TYPE vbtypl                  VALUE 'V',
               lc_lfart     TYPE lfart                   VALUE 'LB',
               lc_lifsk     TYPE lifsk                   VALUE '05',
               lc_parvw     TYPE parvw                   VALUE 'SP',
               lc_bwart_rg1 TYPE bwart                   VALUE 'Z41',
               lc_bwart_rg2 TYPE bwart                   VALUE '941',
               lc_bwart_rg3 TYPE bwart                   VALUE 'Y41',   " chamado 8000004978
               lc_action_rq TYPE j_1bnfe_action_required VALUE 'C',
               lc_wabuc     TYPE wabuc                   VALUE 'Y'.

    IF it_keys[] IS NOT INITIAL.
      SELECT a~rsnum,
             a~rspos,
             a~werks,
             a~matnr,
             a~ebeln,
             a~ebelp,
             a~quantidade,
             a~meins,
             a~lifnr,
             a~pstdat,
             b~spart
        FROM zi_mm_expedinsum_espc_subcontr AS a
        INNER JOIN mara AS b ON b~matnr = a~matnr
         FOR ALL ENTRIES IN @it_keys
       WHERE rsnum = @it_keys-rsnum
         AND rspos = @it_keys-rspos
         AND vbeln IS INITIAL
        INTO TABLE @DATA(lt_relat).

      IF sy-subrc IS INITIAL.
        SORT lt_relat BY rsnum
                         rspos.

        LOOP AT lt_relat ASSIGNING FIELD-SYMBOL(<fs_relat>).
          ls_sum_qtd-matnr = <fs_relat>-matnr.
          ls_sum_qtd-qtd   = <fs_relat>-quantidade.
          COLLECT ls_sum_qtd INTO lt_sum_qtd.
        ENDLOOP.

        DATA(lt_relat_fae) = lt_relat[].
        SORT lt_relat_fae BY werks.
        DELETE ADJACENT DUPLICATES FROM lt_relat_fae COMPARING werks.

        SELECT werks,
               vkorg,
               vtweg
          FROM tvkwz
           FOR ALL ENTRIES IN @lt_relat_fae
         WHERE werks = @lt_relat_fae-werks
           AND vtweg = @lc_outros
          INTO TABLE @DATA(lt_tvkwz).

        IF sy-subrc IS INITIAL.
          SORT lt_tvkwz BY werks.
        ENDIF.

        SELECT werks,
               regio,
               lifnr
          FROM t001w
           FOR ALL ENTRIES IN @lt_relat_fae
         WHERE werks = @lt_relat_fae-werks
          INTO TABLE @DATA(lt_t001w).

        IF sy-subrc IS INITIAL.
          SORT lt_t001w BY werks.

          SELECT shipfrom,
                 shipto
            FROM ztmm_emissa_nf
             FOR ALL ENTRIES IN @lt_t001w
           WHERE shipfrom = @lt_t001w-regio
            INTO TABLE @DATA(lt_regios).

          IF sy-subrc IS INITIAL.
            SORT lt_regios BY shipfrom
                              shipto.
          ENDIF.
        ENDIF.

        lt_relat_fae[] = lt_relat[].
        SORT lt_relat_fae BY lifnr.
        DELETE ADJACENT DUPLICATES FROM lt_relat_fae COMPARING lifnr.

        SELECT lifnr,
               regio
          FROM lfa1
           FOR ALL ENTRIES IN @lt_relat_fae
         WHERE lifnr = @lt_relat_fae-lifnr
          INTO TABLE @DATA(lt_lfa1).

        IF sy-subrc IS INITIAL.
          SORT lt_lfa1 BY lifnr.
        ENDIF.
      ENDIF.
    ENDIF.

    IF it_keys[] IS NOT INITIAL.
      SELECT rsnum,
             rspos,
             lgort
        FROM resb
         FOR ALL ENTRIES IN @it_keys
       WHERE rsnum = @it_keys-rsnum
         AND rspos = @it_keys-rspos
        INTO TABLE @DATA(lt_resb).

      IF sy-subrc IS INITIAL.
        SORT lt_resb BY rsnum
                        rspos.
      ENDIF.
    ENDIF.

*    SELECT guid_header,
*           nfeid,
*           uf_emit,
*           demi,
*           cnpj_emit,
*           mod,
*           nnf
*      FROM /xnfe/innfehd
*     WHERE nfeid = @is_xml_trasnp-xml_transp
*      INTO @DATA(ls_xnfe)
*        UP TO 1 ROWS.
*    ENDSELECT.
**
*    IF sy-subrc IS INITIAL.
    IF is_xml_trasnp-xml_transp IS NOT INITIAL.

      SELECT SINGLE docnum
        FROM j_1bnfe_active
       WHERE regio       EQ @is_xml_trasnp-xml_transp(2)
         AND nfyear      EQ @is_xml_trasnp-xml_transp+2(2)
         AND nfmonth     EQ @is_xml_trasnp-xml_transp+4(2)
         AND stcd1       EQ @is_xml_trasnp-xml_transp+6(14)
         AND model       EQ @is_xml_trasnp-xml_transp+20(2)
         AND nfnum9      EQ @is_xml_trasnp-xml_transp+25(9)
         AND action_requ EQ @lc_action_rq
         AND cancel      NE @abap_true
        INTO @DATA(lv_active).

      IF sy-subrc IS INITIAL.
        SELECT docnum,
               itmnum,
               xped,
               nitemped,
               refkey
          FROM j_1bnflin
         WHERE docnum = @lv_active
          INTO @DATA(ls_lin)
            UP TO 1 ROWS.
        ENDSELECT.

        IF sy-subrc IS INITIAL.

          ls_lin_ped-ebeln = ls_lin-xped(10).

          SELECT SINGLE ebeln,
                        lifnr
            FROM ekko
           WHERE ebeln = @ls_lin_ped-ebeln
            INTO @DATA(ls_ekko).

          IF sy-subrc IS NOT INITIAL.
            CLEAR ls_ekko.
          ENDIF.

          ls_lin_ref-belnr = ls_lin-refkey(10).
          ls_lin_ref-gjahr = ls_lin-refkey+10(4).

          IF ls_lin_ref IS NOT INITIAL.
            SELECT belnr,
                   gjahr,
                   buzei,
                   matnr,
                   menge,
                   lfbnr,
                   lfgja
             FROM rseg
             WHERE belnr = @ls_lin_ref-belnr
               AND gjahr = @ls_lin_ref-gjahr
              INTO TABLE @DATA(lt_rseg).

            IF sy-subrc IS INITIAL.

              DATA(lt_rseg_fae) = lt_rseg[].

              SORT lt_rseg_fae BY lfbnr
                                  lfgja.
              DELETE ADJACENT DUPLICATES FROM lt_rseg_fae COMPARING lfbnr
                                                                    lfgja.

              SELECT mblnr,
                     mjahr,
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

*              LOOP AT lt_rseg ASSIGNING FIELD-SYMBOL(<fs_rseg>).
*                ls_sum_qtd-matnr = <fs_rseg>-matnr.
*                ls_sum_qtd-qtd   = <fs_rseg>-menge.
*                COLLECT ls_sum_qtd INTO lt_sum_rseg.
*              ENDLOOP.

              LOOP AT lt_mseg ASSIGNING FIELD-SYMBOL(<fs_mseg>).
                ls_sum_qtd-matnr = <fs_mseg>-matnr.
                ls_sum_qtd-lgort = <fs_mseg>-lgort.
                ls_sum_qtd-charg = <fs_mseg>-charg.
                ls_sum_qtd-meins = <fs_mseg>-meins.
                ls_sum_qtd-qtd   = <fs_mseg>-menge.
                COLLECT ls_sum_qtd INTO lt_sum_mseg.
              ENDLOOP.

            ENDIF.

          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    SORT lt_sum_mseg BY matnr lgort charg.
    SORT lt_sum_qtd BY matnr.

    SORT lt_relat BY matnr
                     quantidade DESCENDING
                     pstdat     ASCENDING.

    READ TABLE lt_relat INTO DATA(ls_relat) INDEX 1.

    SELECT SINGLE kunnr
      FROM lfa1
      INTO @DATA(ls_kunnr)
     WHERE lifnr = @ls_relat-lifnr.

    SORT lt_relat BY ebeln ebelp.
    LOOP AT lt_relat ASSIGNING <fs_relat>.

      READ TABLE lt_resb ASSIGNING FIELD-SYMBOL(<fs_resb>)
                                       WITH KEY rsnum = <fs_relat>-rsnum
                                                rspos = <fs_relat>-rspos
                                                BINARY SEARCH.

      READ TABLE lt_tvkwz INTO DATA(ls_tvkwz)
                           WITH KEY werks = <fs_relat>-werks
                           BINARY SEARCH.
      IF sy-subrc IS NOT INITIAL.
        CLEAR ls_tvkwz.
      ENDIF.

      READ TABLE lt_t001w ASSIGNING FIELD-SYMBOL(<fs_t001w>)
                                        WITH KEY werks = <fs_relat>-werks
                                        BINARY SEARCH.
      IF sy-subrc IS INITIAL.

        READ TABLE lt_lfa1 ASSIGNING FIELD-SYMBOL(<fs_lfa1>)
                                         WITH KEY lifnr = <fs_relat>-lifnr
                                         BINARY SEARCH.

        IF sy-subrc IS INITIAL.

          READ TABLE lt_regios INTO DATA(ls_regios)
                                WITH KEY shipfrom = <fs_t001w>-regio
                                         shipto   = <fs_lfa1>-regio
                                         BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            lv_bwart = lc_bwart_rg1.
          ELSE.
            lv_bwart = lc_bwart_rg2.

*            lt_gn_partner = VALUE #( BASE lt_gn_partner ( parvw = lc_parvw
*                                                          lifnr = is_xml_trasnp-transptdr ) ).

          ENDIF.
        ENDIF.
      ENDIF.

      READ TABLE lt_sum_qtd INTO DATA(ls_sum_relat)
                             WITH KEY matnr = <fs_relat>-matnr
                             BINARY SEARCH.
      IF sy-subrc IS NOT INITIAL.
        CLEAR ls_sum_relat.
      ENDIF.

      READ TABLE lt_sum_mseg TRANSPORTING NO FIELDS
                                           WITH KEY matnr = <fs_relat>-matnr
                                           BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        LOOP AT lt_sum_mseg ASSIGNING FIELD-SYMBOL(<fs_sum_mseg>) FROM sy-tabix.
          IF <fs_sum_mseg>-matnr NE <fs_relat>-matnr.
            EXIT.
          ENDIF.

*      READ TABLE lt_sum_rseg INTO DATA(ls_sum_rseg)
*                              WITH KEY matnr = <fs_relat>-matnr
*                              BINARY SEARCH.
*      IF sy-subrc IS NOT INITIAL.
*        CLEAR ls_sum_rseg.
*      ENDIF.

          IF lv_matnr IS INITIAL.
            lv_matnr = <fs_relat>-matnr.
            lv_lfimg_saldo = <fs_sum_mseg>-qtd.
          ENDIF.

          IF lv_matnr NE <fs_relat>-matnr.
            CLEAR: lv_dif,
                   lv_lfimg.
            lv_matnr = <fs_relat>-matnr.
            lv_lfimg_saldo = <fs_sum_mseg>-qtd.
          ENDIF.

***      lv_dif = ls_sum_relat-qtd - ls_sum_rseg-qtd.
**          lv_dif = ls_sum_relat-qtd - <fs_sum_mseg>-qtd.
**
**          IF lv_dif GT 0.
**
**            IF <fs_relat>-quantidade LT lv_dif.
**              lv_lfimg      = <fs_relat>-quantidade + lv_lfimg.
**              lv_bapi_lfimg = <fs_relat>-quantidade.
**              lv_dif        = lv_dif - <fs_relat>-quantidade.
**            ELSE.
**              lv_lfimg      = <fs_relat>-quantidade - lv_dif + lv_lfimg.
**              lv_bapi_lfimg = <fs_relat>-quantidade - lv_dif.
**              lv_dif        = lv_dif - <fs_relat>-quantidade.
**
**              IF lv_dif LE 0.
**                lv_dif = 0.
**              ENDIF.
**            ENDIF.
**
**          ELSE.
**
**            IF lv_lfimg LT ls_sum_relat-qtd.
**              lv_lfimg      = <fs_relat>-quantidade + lv_lfimg.
**              lv_bapi_lfimg = <fs_relat>-quantidade.
**            ELSE.
**              CONTINUE.
**            ENDIF.
**          ENDIF.

          IF lv_lfimg_saldo <= 0.
            CONTINUE.
          ENDIF.

          IF <fs_relat>-quantidade <= lv_lfimg_saldo.
            lv_bapi_lfimg = <fs_relat>-quantidade.
          ELSE.
            lv_bapi_lfimg = lv_lfimg_saldo.
          ENDIF.
          lv_lfimg_saldo = lv_lfimg_saldo - <fs_relat>-quantidade.

          lt_xkomdlgn = VALUE #( BASE lt_xkomdlgn ( vstel   = <fs_relat>-werks
                                                    vkorg   = ls_tvkwz-vkorg
                                                    vtweg   = ls_tvkwz-vtweg
                                                    spart   = <fs_relat>-spart
                                                    lfart   = lc_lfart
*                                                  kunwe   = <fs_relat>-lifnr
*                                                  lifnr   = <fs_t001w>-lifnr
                                                    kunwe   = ls_kunnr
                                                    lifnr   = <fs_relat>-lifnr
                                                    matnr   = <fs_relat>-matnr
                                                    werks   = <fs_relat>-werks
                                                    charg = <fs_sum_mseg>-charg
                                                    wadat   = sy-datum
                                                    lfdat   = sy-datum
                                                    lfimg   = lv_bapi_lfimg
*                                                vrkme   = <fs_relat>-meins
                                                    vrkme   = <fs_sum_mseg>-meins
                                                    vgbel   = <fs_relat>-ebeln
                                                    vgpos   = <fs_relat>-ebelp
                                                    vgtyp   = lc_vgtyp
                                                    kzazu   = abap_true
                                                    inco1   = is_xml_trasnp-incoterms1
                                                    lgort   = <fs_sum_mseg>-lgort
                                                    traid   = is_xml_trasnp-traid
                                                    bwart   = lv_bwart
                                                    inco3_l = is_xml_trasnp-xml_transp
*                                                    lifsk   = lc_lifsk
                                                    inco2_l = is_xml_trasnp-incoterms2
                                                    berot   = 'SUBCONTR.') ).

        ENDLOOP.
      ENDIF.
    ENDLOOP.

    DELETE ADJACENT DUPLICATES FROM lt_gn_partner.

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
        SELECT vbeln
          FROM lips
           FOR ALL ENTRIES IN @lt_xxlips
         WHERE vbeln = @lt_xxlips-vbeln
          INTO TABLE @DATA(lt_lips).

        IF sy-subrc IS INITIAL.

          DATA(ls_xxlips) = VALUE #( lt_xxlips[ 1 ] OPTIONAL ).

          ls_vbkok-vbeln_vl = ls_xxlips-vbeln.
          ls_vbkok-wabuc    = lc_wabuc.

          LOOP AT lt_xxlips ASSIGNING FIELD-SYMBOL(<fs_xxlips>).
            lt_vbpok_tab = VALUE #( BASE lt_vbpok_tab ( vbeln_vl = <fs_xxlips>-vbeln
                                                        posnr_vl = <fs_xxlips>-posnr
                                                        vbeln    = <fs_xxlips>-vbeln
                                                        posnn = <fs_xxlips>-posnr
                                                        meins = <fs_xxlips>-meins
*                                                        vbeln    = <fs_xxlips>-vgbel
*                                                        posnn    = <fs_xxlips>-vgpos
                                                        pikmg    = <fs_xxlips>-lfimg ) ).
          ENDLOOP.

          me->call_pickin( EXPORTING is_vbkok_wa  = ls_vbkok
                                     iv_if_error  = abap_true
                                     it_vbpok_tab = lt_vbpok_tab
                                     iv_docnum = ls_lin-docnum
                                     iv_itmnum = ls_lin-itmnum
                           IMPORTING et_prot      = DATA(lt_prot) ).

          IF lt_prot[] IS NOT INITIAL.
            LOOP AT lt_prot ASSIGNING FIELD-SYMBOL(<fs_prot>).
              et_return = VALUE #( BASE et_return ( id         = <fs_prot>-msgid
                                                    number     = <fs_prot>-msgno
                                                    type       = <fs_prot>-msgty
                                                    message_v1 = <fs_prot>-msgv1
                                                    message_v2 = <fs_prot>-msgv2
                                                    message_v3 = <fs_prot>-msgv3
                                                    message_v4 = <fs_prot>-msgv4 ) ).
            ENDLOOP.
          ELSE.
            et_return = VALUE #( BASE et_return ( id         = gc_msg_id
                                                  number     = gc_sucess_exped
                                                  type       = gc_sucess ) ).
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD setup_messages.

    CASE p_task.

      WHEN 'MM_BAPI_DELIVERY'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_GN_DELIVERY_CREATE'
         IMPORTING
           et_xvbfs = gt_xvbfs
           et_lips  = gt_xxlips.

        gv_wait_async = abap_true.

      WHEN 'MM_BAPI_PICKING'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_PICKING'
          IMPORTING
            et_prot = gt_prot.

        gv_wait_async_1 = abap_true.

    ENDCASE.



  ENDMETHOD.


  METHOD valida_estorno_exped.

    DATA(lv_lines) = lines( it_keys ).

    IF lv_lines GT 1.
      me->add_return( EXPORTING iv_id     = gc_msg_id
                                iv_number = gc_erro_lines
                                iv_type   = gc_error
                       CHANGING ct_return = et_return ).
      RETURN.
    ENDIF.

    SELECT rsnum,
           rspos,
           status
      FROM zi_mm_expedinsum_espc_subcontr
       FOR ALL ENTRIES IN @it_keys
     WHERE rsnum = @it_keys-rsnum
       AND rspos = @it_keys-rspos
       AND vbeln = @it_keys-vbeln
      INTO TABLE @DATA(lt_relat).

    IF sy-subrc IS INITIAL.
      LOOP AT lt_relat ASSIGNING FIELD-SYMBOL(<fs_relat>).

        IF <fs_relat>-status NE TEXT-001.
          me->add_return( EXPORTING iv_id     = gc_msg_id
                                    iv_number = gc_erro_concl
                                    iv_type   = gc_error
                           CHANGING ct_return = et_return ).
          RETURN.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
