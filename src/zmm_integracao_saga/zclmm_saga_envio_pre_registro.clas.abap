CLASS zclmm_saga_envio_pre_registro DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS envio_registro
      IMPORTING
        !iv_ordemfrete       TYPE ze_ordemfrete OPTIONAL
        !iv_remessa          TYPE vbeln
        !iv_ebeln            TYPE ebeln OPTIONAL
        !is_innfehd          TYPE /xnfe/innfehd OPTIONAL
        VALUE(iv_xblnr)      TYPE xblnr OPTIONAL
        !iv_item_btd_entrega TYPE /scmtms/base_btd_tco
      EXPORTING
        !et_return           TYPE bapiret2_t .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS: BEGIN OF gc_values,
                 btd_73     TYPE /scmtms/base_btd_tco VALUE '73',
                 btd_58     TYPE /scmtms/base_btd_tco VALUE '58',
                 temp000002 TYPE vbelv VALUE 'TEMP000002',
                 j          TYPE vbtypl_n VALUE 'J',
               END OF gc_values.

    TYPES:
      BEGIN OF ty_likp,
        vbeln TYPE likp-vbeln,
        erdat TYPE likp-erdat,
        vstel TYPE likp-vstel,
        vkorg TYPE likp-vkorg,
        lfart TYPE likp-lfart,
        wadat TYPE likp-wadat,
        lifsk TYPE likp-lifsk,
        lprio TYPE likp-lprio,
        kunnr TYPE likp-kunnr,
        kunag TYPE likp-kunag,
        anzpk TYPE likp-anzpk,
        vtwiv TYPE likp-vtwiv,
        werks TYPE likp-werks,
      END OF ty_likp .
    TYPES:
      BEGIN OF ty_knvv,
        kunnr TYPE knvv-kunnr,
        vkorg TYPE knvv-vkorg,
        vtweg TYPE knvv-vtweg,
        kvgr5 TYPE knvv-kvgr5,
      END OF ty_knvv .
    TYPES:
      BEGIN OF ty_vbpa,
        vbeln TYPE vbpa-vbeln,
        parvw TYPE vbpa-parvw,
        adrnr TYPE vbpa-adrnr,
      END OF ty_vbpa .
    TYPES:
      BEGIN OF ty_vbak,
        vbeln TYPE vbak-vbeln,
        xblnr TYPE vbak-xblnr,
      END OF ty_vbak .
    TYPES:
      BEGIN OF ty_adrc,
        addrnumber TYPE adrc-addrnumber,
        date_from  TYPE adrc-date_from,
        city1      TYPE adrc-city1,
        city2      TYPE adrc-city2,
        post_code1 TYPE adrc-post_code1,
        street     TYPE adrc-street,
        region     TYPE adrc-region,
        tel_number TYPE adrc-tel_number,
      END OF ty_adrc .
    TYPES:
      BEGIN OF ty_lips,
        vbeln TYPE lips-vbeln,
        posnr TYPE lips-posnr,
        matnr TYPE lips-matnr,
        lgort TYPE lips-lgort,
        lfimg TYPE lips-lfimg,
        vrkme TYPE lips-vrkme,
      END OF ty_lips .
    TYPES:
      BEGIN OF ty_marm,
        matnr TYPE matnr,
        meinh TYPE meinh,
        umrez TYPE umrez,
      END OF ty_marm .
    TYPES:
      ty_ty_knvv TYPE TABLE OF ty_knvv .
    TYPES:
      ty_ty_vbpa TYPE TABLE OF ty_vbpa .
    TYPES:
      ty_ty_adrc TYPE TABLE OF ty_adrc .
    TYPES:
      ty_ty_lips TYPE TABLE OF ty_lips .
    TYPES:
      ty_ty_marm   TYPE TABLE OF ty_marm,
      ty_wms_receb TYPE TABLE OF ztmm_wms_receb.

    DATA go_srv_tor TYPE REF TO /bobf/if_tra_service_manager .

    METHODS busca_dados
      IMPORTING
        !iv_remessa TYPE vbeln
        !iv_ebeln   TYPE ebeln OPTIONAL
      EXPORTING
        !es_likp    TYPE ty_likp
        !et_knvv    TYPE ty_ty_knvv
        !et_vbpa    TYPE ty_ty_vbpa
        !es_vbak    TYPE ty_vbak
        !et_adrc    TYPE ty_ty_adrc
        !et_lips    TYPE ty_ty_lips
        !et_marm    TYPE ty_ty_marm .
    METHODS valida_parametros
      IMPORTING
        !is_likp      TYPE ty_likp
        !iv_kvgr5     TYPE kvgr5
      EXPORTING
        !ev_dataagend TYPE wadat
        !ev_ztipo     TYPE ze_ztipo
        !ev_ztipog    TYPE ze_ztipog .
    METHODS envio_saga
      IMPORTING
        !is_output    TYPE zclsd_mt_remessa_ordem
        !it_wms_receb TYPE ty_wms_receb.
    METHODS envia_transporte
      IMPORTING
        iv_ordemfrete   TYPE ze_ordemfrete
      EXPORTING
        es_transp       TYPE zclsd_dt_remessa_ordem_transpo
        ev_agente_frete TYPE /scmtms/pty_carrier .
    METHODS get_lifnr
      IMPORTING
        iv_cnpj_emit     TYPE /xnfe/innfehd-cnpj_emit
      RETURNING
        VALUE(rv_result) TYPE lifnr.
    METHODS get_ordemfrete
      IMPORTING
        iv_xblnr         TYPE xblnr
        iv_ebeln         TYPE ebeln
      RETURNING
        VALUE(rv_result) TYPE ze_ordemfrete.
    METHODS validate_xblnr
      IMPORTING
        iv_xblnr  TYPE xblnr1
      EXPORTING
        ev_nfenum TYPE j_1bnfnum9
        ev_series TYPE j_1bseries.

ENDCLASS.



CLASS zclmm_saga_envio_pre_registro IMPLEMENTATION.


  METHOD busca_dados.

    DATA: lt_docflow TYPE tdt_docflow,
          lv_parvw   TYPE c LENGTH 2,
          lv_remessa TYPE vbeln.

    UNPACK iv_remessa TO lv_remessa.

    DO 5 TIMES.
      SELECT SINGLE vbeln,
                    erdat,
                    vstel,
                    vkorg,
                    lfart,
                    wadat,
                    lifsk,
                    lprio,
                    kunnr,
                    kunag,
                    anzpk,
                    vtwiv,
                    werks
        FROM likp
         INTO @DATA(ls_likp)
        WHERE vbeln = @lv_remessa.
      IF sy-subrc IS INITIAL.

        SELECT SINGLE xblnr
                 FROM ekes
                 INTO @DATA(lv_ekes_xblnr)
                WHERE vbeln EQ @lv_remessa.

        IF sy-subrc EQ 0.

          IF lv_ekes_xblnr CA '-'.
            SPLIT lv_ekes_xblnr AT '-' INTO: lv_ekes_xblnr DATA(lv_verificador).
          ENDIF.

          SELECT SINGLE xblnr
         FROM mkpf
         INTO @DATA(lv_mkpf_xblnr)
        WHERE le_vbeln EQ @lv_ekes_xblnr.

          IF sy-subrc EQ 0.

            validate_xblnr(
            EXPORTING
                iv_xblnr = lv_mkpf_xblnr
            IMPORTING
                ev_nfenum = DATA(lv_nfenum)
                ev_series = DATA(lv_series)  ).

            SELECT SINGLE cnpj_bupla
                     FROM j_1bnfdoc
                     INTO @DATA(lv_cgc)
                    WHERE nftype EQ 'YC'
                        AND nfenum EQ @lv_nfenum
                        AND series EQ @lv_series.

            IF sy-subrc EQ 0.

              SELECT SINGLE supplier
                       FROM i_supplier
                       INTO @DATA(lv_supplier)
                      WHERE taxnumber1 EQ @lv_cgc.

              IF sy-subrc EQ 0.
                ls_likp-kunag = lv_supplier.
              ENDIF.

            ENDIF.

          ENDIF.

        ENDIF.

        EXIT.
      ELSE.
        WAIT UP TO 1 SECONDS.
      ENDIF.
    ENDDO.
    IF ls_likp IS NOT INITIAL.
      SELECT kunnr, vkorg, vtweg, kvgr5
        FROM knvv
        INTO TABLE @DATA(lt_knvv)
        WHERE kunnr = @ls_likp-kunnr AND
              vkorg = @ls_likp-vkorg AND
              vtweg = @ls_likp-vtwiv.

      CALL FUNCTION 'CONVERSION_EXIT_PARVW_INPUT'
        EXPORTING
          input  = 'RM'
        IMPORTING
          output = lv_parvw.

      SELECT vbeln, parvw, adrnr
        FROM vbpa
        INTO TABLE @DATA(lt_vbpa)
        WHERE vbeln = @lv_remessa AND
              parvw = @lv_parvw.

      IF sy-subrc IS INITIAL.


        CALL FUNCTION 'SD_DOCUMENT_FLOW_GET' "#EC CI_SEL_NESTED
          EXPORTING
            iv_docnum  = lv_remessa
          IMPORTING
            et_docflow = lt_docflow.

        IF lt_docflow IS NOT INITIAL.
          READ TABLE lt_docflow INTO DATA(ls_flow) WITH KEY vbtyp_n = 'H'. "#EC CI_STDSEQ
          IF sy-subrc IS INITIAL.

            SELECT SINGLE vbeln, xblnr
              FROM vbak
              INTO @DATA(ls_vbak)
              WHERE vbeln = @ls_flow-docnum.
          ENDIF.

          DATA(lt_vbpa_aux) = lt_vbpa[].
          SORT lt_vbpa_aux BY adrnr.
          DELETE ADJACENT DUPLICATES FROM lt_vbpa_aux COMPARING adrnr.

          IF lt_vbpa_aux[] IS NOT INITIAL.

            SELECT addrnumber, date_from, city1, city2, post_code1, region, tel_number
              FROM adrc
              INTO TABLE @DATA(lt_adrc)
              FOR ALL ENTRIES IN @lt_vbpa_aux
              WHERE addrnumber = @lt_vbpa_aux-adrnr.

            IF sy-subrc IS INITIAL.

              SORT lt_adrc BY date_from DESCENDING.

            ENDIF.
          ENDIF.
        ENDIF.
*        SELECT vbeln, posnr, matnr, lgort, lfimg, vrkme
*          FROM lips
*          INTO TABLE @DATA(lt_lips)
*          WHERE vbeln = @lv_remessa.
*
*        IF sy-subrc IS INITIAL.
*          DATA(lt_lips_aux) = lt_lips[].
*          SORT lt_lips_aux BY  matnr vrkme.
*          DELETE ADJACENT DUPLICATES FROM  lt_lips_aux COMPARING matnr vrkme.
*
*          IF lt_lips_aux[] IS NOT INITIAL.
*
*            SELECT matnr, meinh, umrez
*              FROM marm
*              INTO TABLE @DATA(lt_marm)
*              FOR ALL ENTRIES IN @lt_lips_aux
*              WHERE matnr = @lt_lips_aux-matnr AND
*                    meinh = @lt_lips_aux-vrkme.
*            IF sy-subrc IS INITIAL.
*              SORT lt_marm BY matnr meinh. "Binary Search
*            ENDIF.
*          ENDIF.
*
*        ENDIF.

      ENDIF.

      SELECT vbeln, posnr, matnr, lgort, lfimg, vrkme
          FROM lips
          INTO TABLE @DATA(lt_lips)
          WHERE vbeln = @lv_remessa.

      IF sy-subrc IS INITIAL.
        DATA(lt_lips_aux) = lt_lips[].
        SORT lt_lips_aux BY  matnr vrkme.
        DELETE ADJACENT DUPLICATES FROM  lt_lips_aux COMPARING matnr vrkme.

        IF lt_lips_aux[] IS NOT INITIAL.

          SELECT matnr, meinh, umrez
            FROM marm
            INTO TABLE @DATA(lt_marm)
            FOR ALL ENTRIES IN @lt_lips_aux
            WHERE matnr = @lt_lips_aux-matnr AND
                  meinh = @lt_lips_aux-vrkme.
          IF sy-subrc IS INITIAL.
            SORT lt_marm BY matnr meinh. "Binary Search
          ENDIF.
        ENDIF.

      ENDIF.

      IF ls_likp-kunag IS INITIAL AND
         ls_likp-kunnr IS INITIAL.

        SELECT SINGLE lifnr FROM ekko
        WHERE ebeln = @iv_ebeln
        INTO @ls_likp-kunag.

      ENDIF.

    ENDIF.

    es_likp = ls_likp.
    et_knvv = lt_knvv[].
    et_vbpa = lt_vbpa[].
    es_vbak = ls_vbak.
    et_adrc = lt_adrc[].
    et_lips = lt_lips[].
    et_marm = lt_marm[].

  ENDMETHOD.


  METHOD envia_transporte.

    DATA: lt_tor          TYPE /scmtms/t_tor_root_k,
          lt_tor_root_key TYPE /bobf/t_frw_key,
          lt_tor_party    TYPE /scmtms/t_tor_party_k,
          lt_parameters   TYPE /bobf/t_frw_query_selparam,
          lt_itemtr       TYPE /scmtms/t_tor_item_tr_k.

    go_srv_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    APPEND INITIAL LINE TO lt_parameters ASSIGNING FIELD-SYMBOL(<fs_parameters>).
    <fs_parameters>-attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-root_elements-tor_id.
    <fs_parameters>-sign   = 'I'.
    <fs_parameters>-option = 'EQ'.
    <fs_parameters>-low    = iv_ordemfrete.

    go_srv_tor->query(
                        EXPORTING
                          iv_query_key            = /scmtms/if_tor_c=>sc_query-root-root_elements
                          it_selection_parameters = lt_parameters
                          iv_fill_data            = abap_true
                        IMPORTING
                          et_key                  = lt_tor_root_key
                          et_data                 = lt_tor
                     ).

    LOOP AT lt_tor ASSIGNING FIELD-SYMBOL(<fs_tor>).

      /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = <fs_tor>-key CHANGING ct_key = lt_tor_root_key ).

      go_srv_tor->retrieve_by_association(
        EXPORTING
          iv_node_key             = /scmtms/if_tor_c=>sc_node-root
          it_key                  = lt_tor_root_key
          iv_association          = /scmtms/if_tor_c=>sc_association-root-item_tr
          iv_fill_data            = abap_true
        IMPORTING
          et_data                 = lt_itemtr
      ).
      go_srv_tor->retrieve_by_association(
       EXPORTING
           iv_node_key             = /scmtms/if_tor_c=>sc_node-root
           it_key                  = lt_tor_root_key
           iv_association = /scmtms/if_tor_c=>sc_association-root-party
           iv_fill_data   = abap_true
       IMPORTING
            et_data       = lt_tor_party ).

      ev_agente_frete = <fs_tor>-tspid.

    ENDLOOP.
    LOOP AT lt_itemtr ASSIGNING FIELD-SYMBOL(<fs_itemtr>).
      CHECK <fs_itemtr>-item_cat = 'AVR'.
      es_transp-ztpveic = <fs_itemtr>-tures_tco.
      es_transp-platnumber = <fs_itemtr>-platenumber.
    ENDLOOP.
    LOOP AT lt_tor_party ASSIGNING FIELD-SYMBOL(<fs_party>).
      es_transp-zcodmot = <fs_party>-party_id.
    ENDLOOP.
    IF es_transp-zcodmot IS NOT INITIAL.
      SELECT SINGLE lifnr, mcod1, stcd2
        FROM lfa1
        INTO @DATA(ls_lfa1)
        WHERE lifnr = @es_transp-zcodmot.

      IF sy-subrc IS INITIAL.
        es_transp-znomemot = ls_lfa1-mcod1.
        es_transp-zcpfmot  = ls_lfa1-stcd2.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD envio_registro.

    CONSTANTS: lc_zp(10)    TYPE c               VALUE 'ZP',
               lc_parm_mod  TYPE ze_param_modulo VALUE 'MM',
               lc_cnpj_dest TYPE ze_param_chave  VALUE 'CNPJ_CENTRO'.

    DATA: lt_wms_receb TYPE ty_wms_receb.

    DATA: ls_output    TYPE zclsd_mt_remessa_ordem,
          ls_wms_receb TYPE ztmm_wms_receb.

    DATA: lr_cnpj_dest TYPE RANGE OF /xnfe/cnpj_dest.

    DATA: lv_lines TYPE i.

    me->busca_dados( EXPORTING
                           iv_remessa = iv_remessa
                           iv_ebeln   = iv_ebeln
                     IMPORTING
                            es_likp = DATA(ls_likp)
                            et_knvv = DATA(lt_knvv)
                            et_vbpa = DATA(lt_vbps)
                            es_vbak = DATA(ls_vbak)
                            et_adrc = DATA(lt_adrc)
                            et_lips = DATA(lt_lips)
                            et_marm = DATA(lt_marm) ).

    IF lt_knvv[] IS NOT INITIAL.
      DATA(lv_kvgr5) = lt_knvv[ 1 ]-kvgr5.
    ENDIF.

    me->valida_parametros( EXPORTING
                                is_likp      = ls_likp
                                iv_kvgr5     = lv_kvgr5
                           IMPORTING
                                ev_dataagend = DATA(lv_dataagend)
                                ev_ztipo     = DATA(lv_ztipo)
                                ev_ztipog    = DATA(lv_ztipog) ).


    IF lt_lips[] IS NOT INITIAL.
      DATA(lv_lgort) = lt_lips[ 1 ]-lgort.
*            DESCRIBE TABLE lt_lips LINES DATA(lv_lines).

      LOOP AT lt_lips ASSIGNING FIELD-SYMBOL(<fs_lips>).
        IF <fs_lips>-lfimg GT 0.
          ADD 1 TO lv_lines.
        ENDIF.
      ENDLOOP.
    ENDIF.

    IF lt_adrc[] IS NOT INITIAL.
      DATA(ls_adrc) = lt_adrc[ 1 ].
      DATA(lv_zobspostal) = ls_adrc-street && ' ' && ls_adrc-city1 && ' ' && ls_adrc-city2
                            && ' ' && ls_adrc-post_code1  && ' ' && ls_adrc-region
                            && ' ' && ls_adrc-tel_number.
    ENDIF.

    IF iv_ordemfrete IS INITIAL.
      DATA(lv_ordemfrete) = get_ordemfrete( EXPORTING iv_xblnr = iv_xblnr
                                                      iv_ebeln = iv_ebeln ).
    ELSE.
      lv_ordemfrete = iv_ordemfrete.
    ENDIF.

    me->envia_transporte( EXPORTING
                           iv_ordemfrete = lv_ordemfrete
                           IMPORTING
                            es_transp       = DATA(ls_transp)
                            ev_agente_frete = DATA(lv_agente_frete)  ).

    " HEADER
    ls_output-mt_remessa_ordem-vbeln        = |{ ls_likp-vbeln ALPHA = OUT }|.
    ls_output-mt_remessa_ordem-werks        = ls_likp-vstel.
    ls_output-mt_remessa_ordem-ztipo        = lv_ztipo+10(2).
    ls_output-mt_remessa_ordem-ztipogeracao = lv_ztipog.

    IF ls_output-mt_remessa_ordem-ztipo EQ 05.
      TRY.
          DATA(lo_param) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 21.07.2023

          lo_param->m_get_range( EXPORTING iv_modulo = lc_parm_mod
                                           iv_chave1 = lc_cnpj_dest
                                 IMPORTING et_range  = lr_cnpj_dest ).
        CATCH zcxca_tabela_parametros.
      ENDTRY.

      IF is_innfehd-cnpj_dest IN lr_cnpj_dest.
        ls_output-mt_remessa_ordem-ztipo = '01'.
        ls_output-mt_remessa_ordem-werks = ls_likp-werks.
      ENDIF.
    ENDIF.

    IF ls_output-mt_remessa_ordem-ztipo EQ 14 " Devolução
    OR ls_output-mt_remessa_ordem-ztipo EQ 01. " Recebimento

      ls_output-mt_remessa_ordem-xbelnr = ls_output-mt_remessa_ordem-vbeln.

      IF ls_output-mt_remessa_ordem-ztipo EQ 01.
        ls_output-mt_remessa_ordem-vbeln = COND #( WHEN is_innfehd-nnf IS NOT INITIAL THEN is_innfehd-nnf && '/' && is_innfehd-nprot ELSE |{ ls_likp-vbeln ALPHA = OUT }| ).
      ENDIF.
    ENDIF.

    ls_output-mt_remessa_ordem-kunag = COND #( WHEN ls_likp-kunag IS INITIAL THEN ls_likp-kunnr ELSE ls_likp-kunag ).

    IF ls_output-mt_remessa_ordem-ztipo EQ 01.

      ls_output-mt_remessa_ordem-kunag = COND #( WHEN iv_item_btd_entrega EQ gc_values-btd_58
                                                    THEN get_lifnr( is_innfehd-cnpj_emit )
                                                 WHEN iv_item_btd_entrega EQ gc_values-btd_73
                                                    THEN COND #( WHEN ls_likp-kunag IS INITIAL
                                                                  THEN ls_likp-kunnr
                                                                  ELSE ls_likp-kunag ) ).

    ENDIF.

*    ls_output-mt_remessa_ordem-lifnr            = ls_transp-zcodmot.
    ls_output-mt_remessa_ordem-lifnr            = lv_agente_frete.
    ls_output-mt_remessa_ordem-lprio            = ls_likp-lprio.
    ls_output-mt_remessa_ordem-zordemfrete      = |{ lv_ordemfrete ALPHA = OUT }|.
    ls_output-mt_remessa_ordem-lgort            = lv_lgort.
    ls_output-mt_remessa_ordem-erdat            = ls_likp-erdat.
    ls_output-mt_remessa_ordem-zdataagendamento = ls_likp-erdat.
    ls_output-mt_remessa_ordem-znritens         = lv_lines.
    ls_output-mt_remessa_ordem-anzpk            = ls_likp-anzpk.
    ls_output-mt_remessa_ordem-zobspostal       = lv_zobspostal.

    " TRANSPORTE
    ls_output-mt_remessa_ordem-transporte-platnumber = ls_transp-platnumber.
    ls_output-mt_remessa_ordem-transporte-zcodmot    = ls_transp-zcodmot.
    ls_output-mt_remessa_ordem-transporte-zcpfmot    = ls_transp-zcpfmot.
    ls_output-mt_remessa_ordem-transporte-ztpveic    = ls_transp-ztpveic.
    ls_output-mt_remessa_ordem-transporte-znomemot   = ls_transp-znomemot.

    ls_wms_receb-nfenum   = is_innfehd-nnf.
    ls_wms_receb-lifnr    = ls_output-mt_remessa_ordem-kunag.
    ls_wms_receb-stcd1    = is_innfehd-cnpj_emit.
    ls_wms_receb-werks    = ls_likp-vstel.
    ls_wms_receb-idnfenum = is_innfehd-guid_header.

    IF ls_likp-lifsk EQ lc_zp.
      DATA(lv_lifsk) = ls_likp-lifsk.
    ENDIF.

    LOOP AT lt_lips ASSIGNING <fs_lips>.

      READ TABLE lt_marm ASSIGNING FIELD-SYMBOL(<fs_marm>) WITH KEY matnr = <fs_lips>-matnr
                                                                    meinh = <fs_lips>-vrkme
                                                                    BINARY SEARCH.
      IF sy-subrc IS INITIAL.

        CHECK <fs_lips>-lfimg > 0.

        " ITENS
        APPEND VALUE #( posnr = <fs_lips>-posnr
                        matnr = <fs_lips>-matnr
                        umrez = <fs_marm>-umrez
                        lfimg = <fs_lips>-lfimg
                        lifsk = lv_lifsk
        ) TO ls_output-mt_remessa_ordem-itens.

        ls_wms_receb-matnr    = <fs_lips>-matnr.
        ls_wms_receb-itmnum   = <fs_lips>-posnr.
*        ls_wms_receb-zqtde_nf = <fs_lips>-lfimg.

        APPEND ls_wms_receb TO lt_wms_receb.

      ENDIF.
    ENDLOOP.

    me->envio_saga( EXPORTING is_output    = ls_output
                              it_wms_receb = lt_wms_receb ).

  ENDMETHOD.


  METHOD envio_saga.

    TRY.

        NEW zclsd_co_si_envia_remessa_orde( )->si_envia_remessa_ordem_out(
            EXPORTING
                output = is_output ).

        IF sy-subrc EQ 0.

          IF is_output-mt_remessa_ordem-ztipo EQ 12
          OR is_output-mt_remessa_ordem-ztipo EQ 01
          OR is_output-mt_remessa_ordem-ztipo EQ 05.
            MODIFY ztmm_wms_receb FROM TABLE it_wms_receb.
          ENDIF.

          COMMIT WORK.

        ENDIF.

      CATCH cx_root INTO DATA(lo_cx_root).
        DATA(lv_msg)  = lo_cx_root->get_text( ).
    ENDTRY.
  ENDMETHOD.


  METHOD get_lifnr.

    SELECT SINGLE supplier FROM I_Supplier
    WHERE TaxNumber1 = @iv_cnpj_emit
    INTO @rv_result.

  ENDMETHOD.


  METHOD get_ordemfrete.

    DATA: lt_docflow TYPE tdt_docflow.

    CALL FUNCTION 'SD_DOCUMENT_FLOW_GET'
      EXPORTING
        iv_docnum        = CONV vbeln( iv_xblnr )
        iv_all_items     = space
        iv_self_if_empty = space
      IMPORTING
        et_docflow       = lt_docflow.

    IF lt_docflow IS NOT INITIAL.

      rv_result = VALUE #( lt_docflow[ docnuv = gc_values-temp000002 ]-docnum OPTIONAL ).

    ELSE.

      SELECT SINGLE ihrez FROM ekko
      WHERE ebeln = @iv_ebeln
      INTO @DATA(lv_ihrez).

      IF sy-subrc EQ 0.

        DATA(lv_ihrez_ok) = CONV vbeln_von( lv_ihrez ).

        UNPACK lv_ihrez_ok TO lv_ihrez_ok.

        SELECT SINGLE vbeln FROM vbfa
        WHERE vbelv   = @lv_ihrez_ok
          AND vbtyp_n = @gc_values-j
        INTO @DATA(lv_vbeln).

        IF sy-subrc EQ 0.

          CALL FUNCTION 'SD_DOCUMENT_FLOW_GET'
            EXPORTING
              iv_docnum        = lv_vbeln
              iv_all_items     = space
              iv_self_if_empty = space
            IMPORTING
              et_docflow       = lt_docflow.

          IF lt_docflow IS NOT INITIAL.

            rv_result = VALUE #( lt_docflow[ docnuv = gc_values-temp000002 ]-docnum OPTIONAL ).

          ENDIF.

        ENDIF.


      ENDIF.

    ENDIF.


  ENDMETHOD.


  METHOD valida_parametros.

    CONSTANTS: lc_modulo_3 TYPE ztca_param_mod-modulo VALUE 'SD',
               lc_chave1_3 TYPE ztca_param_par-chave1 VALUE 'SAGA',
               lc_chave2_3 TYPE ztca_param_par-chave2 VALUE 'ZTIPO'.

    CONSTANTS: lc_modulo_4 TYPE ztca_param_mod-modulo VALUE 'SD',
               lc_chave1_4 TYPE ztca_param_par-chave1 VALUE 'SAGA',
               lc_chave2_4 TYPE ztca_param_par-chave2 VALUE 'ZTIPOGERACAO'.

    CONSTANTS: lc_modulo_5 TYPE ztca_param_mod-modulo VALUE 'SD',
               lc_chave1_5 TYPE ztca_param_par-chave1 VALUE 'ADM_AGENDAMENTO',
               lc_chave2_5 TYPE ztca_param_par-chave2 VALUE 'GRP_AGENDA'.

    DATA: lv_chave2_2 TYPE ztca_param_par-chave2,
          lv_chave3_3 TYPE ztca_param_par-chave3,
          lv_chave3_4 TYPE ztca_param_par-chave3.

    DATA: lr_ztipo  TYPE RANGE OF ze_ztipo,
          lr_ztipog TYPE RANGE OF ze_ztipog,
          lr_agenda TYPE RANGE OF kvgr5.

    CLEAR: lr_ztipo, lr_ztipog, lr_agenda .


    lv_chave3_3 = is_likp-lfart.
    lv_chave3_4 = is_likp-lfart.

** Seleçao dos parametros
    DATA(lo_parametros) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 21.07.2023

*Buscar
    TRY.
        lo_parametros->m_get_range(
          EXPORTING
            iv_modulo = lc_modulo_3
            iv_chave1 = lc_chave1_3
            iv_chave2 = lc_chave2_3
            iv_chave3 = lv_chave3_3
          IMPORTING
            et_range  = lr_ztipo ).
      CATCH zcxca_tabela_parametros.
        "handle exception
    ENDTRY.

* Saída
    READ TABLE lr_ztipo ASSIGNING FIELD-SYMBOL(<fs_tipo>) INDEX 1.
    IF sy-subrc EQ 0.
      ev_ztipo = <fs_tipo>-low.
    ENDIF.

*Buscar
    TRY.
        lo_parametros->m_get_range(
          EXPORTING
            iv_modulo = lc_modulo_4
            iv_chave1 = lc_chave1_4
            iv_chave2 = lc_chave2_4
            iv_chave3 = lv_chave3_4
          IMPORTING
            et_range  = lr_ztipog ).
      CATCH zcxca_tabela_parametros.
        "handle exception
    ENDTRY.

* Saída
    READ TABLE lr_ztipog ASSIGNING FIELD-SYMBOL(<fs_tipog>) INDEX 1.
    IF sy-subrc EQ 0.
      ev_ztipog = <fs_tipog>-low.
    ELSE.
      ev_ztipog = 0.
    ENDIF.

*Buscar
    TRY.
        lo_parametros->m_get_range(
          EXPORTING
            iv_modulo = lc_modulo_5
            iv_chave1 = lc_chave1_5
            iv_chave2 = lc_chave2_5
          IMPORTING
            et_range  = lr_agenda ).
      CATCH zcxca_tabela_parametros.
        "handle exception
    ENDTRY.

    IF NOT iv_kvgr5 IN lr_agenda .
      ev_dataagend = is_likp-wadat.
    ENDIF.

  ENDMETHOD.

  METHOD validate_xblnr.

    IF iv_xblnr CA '-'.

      DATA(lv_xblnr) = iv_xblnr.

      SPLIT lv_xblnr AT '-' INTO ev_nfenum ev_series.

    ELSE.
      ev_nfenum = iv_xblnr.
    ENDIF.

    UNPACK ev_nfenum TO ev_nfenum.

  ENDMETHOD.

ENDCLASS.
