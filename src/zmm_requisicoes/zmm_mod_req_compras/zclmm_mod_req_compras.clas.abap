"! <p class="shorttext synchronized">Classe badi ME_PROCESS_REQ_CUST</p>
"! Autor: Jefferson Fujii
"! <br>Data: 11/01/2022
"!
CLASS zclmm_mod_req_compras DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_ex_me_process_req_cust .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclmm_mod_req_compras IMPLEMENTATION.


  METHOD if_ex_me_process_req_cust~check.
  ENDMETHOD.


  METHOD if_ex_me_process_req_cust~close.
  ENDMETHOD.


  METHOD if_ex_me_process_req_cust~fieldselection_header.
  ENDMETHOD.


  METHOD if_ex_me_process_req_cust~fieldselection_header_refkeys.
  ENDMETHOD.


  METHOD if_ex_me_process_req_cust~fieldselection_item.

  ENDMETHOD.


  METHOD if_ex_me_process_req_cust~fieldselection_item_refkeys.
  ENDMETHOD.


  METHOD if_ex_me_process_req_cust~initialize.
  ENDMETHOD.


  METHOD if_ex_me_process_req_cust~open.

    " Validar modificação ME
    INCLUDE zmmi_validate_me IF FOUND.

  ENDMETHOD.


  METHOD if_ex_me_process_req_cust~post.
    DATA: lt_mereq_item TYPE mmpur_t_mereqitem.

    DATA(lt_items) = im_header->get_items( ).

    LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<fs_item>).
      DATA(ls_mereq_item) = <fs_item>-item->get_data( ).
      APPEND ls_mereq_item TO lt_mereq_item.
    ENDLOOP.

    IF lt_mereq_item IS NOT INITIAL.
      SELECT matnr,
             mtart
        FROM mara
        INTO TABLE @DATA(lt_mara)
        FOR ALL ENTRIES IN @lt_mereq_item
        WHERE matnr EQ @lt_mereq_item-matnr
          AND mtart IN ('HALB','ZHAL')
        ORDER BY PRIMARY KEY.

      SELECT idnrk,
             datuv,
             valid_to
        FROM stpo
        INTO TABLE @DATA(lt_stpo)
        FOR ALL ENTRIES IN @lt_mereq_item
        WHERE stlty    EQ 'M'
          AND idnrk    EQ @lt_mereq_item-matnr
          AND datuv    LE @lt_mereq_item-lfdat
          AND valid_to GE @lt_mereq_item-lfdat.
      SORT lt_stpo BY idnrk.
    ENDIF.

* Se for semi-acabado e tiver em lista técnica, avisar da necessidade de informar ordem de produção (Nº acompanhamento)
    LOOP AT lt_mereq_item ASSIGNING FIELD-SYMBOL(<fs_mereq_item>).
      CHECK <fs_mereq_item>-bednr IS INITIAL.

      READ TABLE lt_mara TRANSPORTING NO FIELDS
        WITH KEY matnr = <fs_mereq_item>-matnr BINARY SEARCH.
      CHECK sy-subrc EQ 0.

* Buscar lista ténica vigente para este material
      READ TABLE lt_stpo TRANSPORTING NO FIELDS
        WITH KEY idnrk = <fs_mereq_item>-matnr BINARY SEARCH.
      CHECK sy-subrc EQ 0.

      MESSAGE w004(zmm).
      EXIT.
    ENDLOOP.

**********************************************************************
** INTEGRAÇÃO REQUISIÇÃO - Mercado Eletronico
**********************************************************************
    TRY .
        NEW zclmm_send_req( )->execute( is_header = im_header ).
      CATCH cx_ai_system_fault.
    ENDTRY.
**********************************************************************

  ENDMETHOD.


  METHOD if_ex_me_process_req_cust~process_account.
  ENDMETHOD.


  METHOD if_ex_me_process_req_cust~process_header.

  ENDMETHOD.


  METHOD if_ex_me_process_req_cust~process_item.

    CONSTANTS: BEGIN OF lc_parametros,
                 modulo    TYPE ztca_param_mod-modulo VALUE 'MM',
                 chave1    TYPE ztca_param_par-chave1 VALUE 'ME',
                 chave2    TYPE ztca_param_par-chave2 VALUE 'PROCESSITEMPREQ',
                 chave3    TYPE ztca_param_par-chave3 VALUE 'ACTIVE',
                 chave2_me TYPE ztca_param_par-chave2 VALUE 'MODIFYITEMPREQ',
                 chave3_me TYPE ztca_param_par-chave3 VALUE 'RELEASE',
                 ucomm     TYPE syst_ucomm  VALUE 'MEREQFLUSH',
               END OF lc_parametros.

    DATA: lr_ativo TYPE RANGE OF xfeld,
          lr_me    TYPE RANGE OF xfeld.

    DATA: lr_bom         TYPE REF TO if_bom_mm,
          lt_bom_g       TYPE mmpur_t_mdpm,
          ls_mereq_item  TYPE mereq_item,
          lv_aufnr       TYPE afko-aufnr,
          ls_mereqheader TYPE REF TO if_purchase_requisition,
          ls_header      TYPE mereq_header.

    ls_mereq_item  = im_item->get_data( ).

    ls_mereqheader = im_item->get_requisition( ).

    ls_header = ls_mereqheader->get_data( ).

    "    Validar exclusão e status ME
    INCLUDE zmmi_validate_delete_me IF FOUND.

    TRY.
        NEW zclca_tabela_parametros( )->m_get_range( EXPORTING iv_modulo = lc_parametros-modulo
                                                               iv_chave1 = lc_parametros-chave1
                                                               iv_chave2 = lc_parametros-chave2
                                                               iv_chave3 = lc_parametros-chave3
                                                     IMPORTING et_range  = lr_ativo ).
      CATCH zcxca_tabela_parametros.
    ENDTRY.

    IF     lr_ativo  IS INITIAL
    OR NOT abap_true IN lr_ativo.
      RETURN.
    ENDIF.

    IF ls_mereq_item-pstyp EQ '3' AND "Subcontratação
       ls_mereq_item-werks IS NOT INITIAL AND
       ls_mereq_item-menge IS NOT INITIAL.
*" Get BOM data
      lr_bom = im_item->get_bom( ).

      IF lr_bom IS NOT INITIAL.
        DATA(lt_bom_tmp) = lr_bom->get_data( ).

        LOOP AT lt_bom_tmp ASSIGNING FIELD-SYMBOL(<fs_bom_tmp>).
          CHECK <fs_bom_tmp>-stlnr IS NOT INITIAL.
          APPEND <fs_bom_tmp> TO lt_bom_g.
        ENDLOOP.

        IF lt_bom_g IS NOT INITIAL.
          SELECT stpo~idnrk
            FROM stko
            INNER JOIN stpo
              ON  stpo~stlty    = stko~stlty
              AND stpo~stlnr    = stko~stlnr
              AND stpo~datuv    = stko~datuv
              AND stpo~valid_to = stko~valid_to
            FOR ALL ENTRIES IN @lt_bom_g
            WHERE stko~stlty    = @lt_bom_g-stlty
              AND stko~stlnr    = @lt_bom_g-stlnr
              AND stko~stlal    = @lt_bom_g-stalt
              AND stko~wrkan    = @lt_bom_g-werks
            INTO TABLE @DATA(lt_stpo).
          SORT lt_stpo BY idnrk.
        ENDIF.

        IF ls_header-banfn IS NOT INITIAL.
          SELECT SINGLE @abap_true
            FROM ekpo
            INTO @DATA(lv_doc_subseq)
            WHERE loekz = @space
              AND banfn = @ls_header-banfn
              AND bnfpo = @ls_mereq_item-bnfpo.
        ENDIF.

*Se inserir componente manualmente, dar erro
        LOOP AT lt_bom_g ASSIGNING FIELD-SYMBOL(<fs_bom>).
          IF <fs_bom>-matnr NE ls_mereq_item-matnr.
            READ TABLE lt_stpo TRANSPORTING NO FIELDS
              WITH KEY idnrk = <fs_bom>-matnr BINARY SEARCH.
            IF sy-subrc NE 0.
              MESSAGE e001(zmm). "Item novo
            ELSE.
              MESSAGE e008(zmm). "Item de lista técnica
            ENDIF.
          ENDIF.
        ENDLOOP.

        lt_bom_tmp = lt_bom_g.
        FREE lt_bom_g.

        LOOP AT lt_bom_tmp ASSIGNING <fs_bom_tmp>.
          CHECK <fs_bom_tmp>-selkz IS NOT INITIAL.
          APPEND <fs_bom_tmp> TO lt_bom_g.
        ENDLOOP.

*Se alterar um componente manualmente, dar erro
        LOOP AT lt_bom_g ASSIGNING <fs_bom>.
          IF lv_doc_subseq EQ abap_true.
            MESSAGE e007(zmm) WITH '(analisar doc.subsequentes).'.
          ELSE.
            READ TABLE lt_stpo TRANSPORTING NO FIELDS
              WITH KEY idnrk = <fs_bom>-matnr BINARY SEARCH.
            IF sy-subrc NE 0.
              MESSAGE e002(zmm).
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.

*Tratativa para insumos aplicados
*Se tiver ordem de produção (Nº acompanhamento), for semi-acabado ou outro insumo, e estiver em lista técnica
    IF ls_mereq_item-bednr IS NOT INITIAL.
      SELECT SINGLE mtart
        FROM mara
        INTO @DATA(ls_mtart)
        WHERE matnr = @ls_mereq_item-matnr.
      IF  sy-subrc EQ 0
      AND ( ls_mtart EQ 'HALB'
         OR ls_mtart EQ 'VERP'
         OR ls_mtart EQ 'ROH' ).
*Buscar lista técnica vigente para este material
        SELECT SINGLE COUNT( * )
          FROM stpo
          WHERE stlty    EQ 'M'
            AND idnrk    EQ @ls_mereq_item-matnr
            AND datuv    LE @ls_mereq_item-lfdat
            AND valid_to GE @ls_mereq_item-lfdat.
        IF sy-subrc EQ 0.
*Buscar ordem de produção vigente
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = ls_mereq_item-bednr
            IMPORTING
              output = lv_aufnr.

          SELECT SINGLE gstrp,
                        gltrp
            FROM afko
            INTO (@DATA(lv_gstrp),@DATA(lv_gltrp))
            WHERE aufnr = @lv_aufnr.
          IF sy-subrc NE 0.
            MESSAGE e005(zmm) WITH lv_aufnr.
          ELSEIF lv_gstrp <= ls_mereq_item-lfdat AND
                 lv_gltrp >= ls_mereq_item-lfdat.
            MESSAGE e006(zmm) WITH lv_aufnr.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.


  ENDMETHOD.
ENDCLASS.
