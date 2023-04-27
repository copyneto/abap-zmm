CLASS zclmm_inventario_fisico DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_param,
        iblnr TYPE RANGE OF ztmm_alivium-iblnr,
        gjahr TYPE RANGE OF ztmm_alivium-gjahr,
        werks TYPE RANGE OF ikpf-werks,
        budat TYPE RANGE OF ikpf-budat,
        bldat TYPE RANGE OF ikpf-bldat,
        mblnr TYPE RANGE OF ztmm_alivium-mblnr,
      END OF ty_param,

      ty_out TYPE STANDARD TABLE OF zsmm_alivium WITH EMPTY KEY.

    DATA: gt_out TYPE ty_out.

    DATA: gs_param TYPE ty_param.

    DATA: gr_iblnr TYPE REF TO data,
          gr_gjahr TYPE REF TO data,
          gr_werks TYPE REF TO data,
          gr_budat TYPE REF TO data,
          gr_bldat TYPE REF TO data,
          gr_mblnr TYPE REF TO data.

    DATA: gv_nf_en_sa  TYPE c LENGTH 1.

    CLASS-METHODS:
      "! Cria instancia
      get_instance
        RETURNING
          VALUE(ro_instance) TYPE REF TO zclmm_inventario_fisico .

    METHODS:
      "! Preenche parametros de entrada para filtrar os selects
      set_ref_data.

    METHODS:
      process_data.

    METHODS on_user_command
      FOR EVENT user_command OF cl_gui_alv_grid
      IMPORTING
        !e_ucomm .

    METHODS:
      hotspot_click
        FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING e_column_id es_row_no.

    METHODS:
      handle_finished FOR EVENT finished OF cl_gui_timer.

    METHODS:
      get_data.

    METHODS has_data
      RETURNING
        VALUE(rv_is_ok) TYPE boole_d .

    METHODS gerar_mi07
      RETURNING
        VALUE(rt_return) TYPE bapiret2_t.


  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_doc_entrada,
        docnum  TYPE j_1bnfdoc-docnum,
        nfenum  TYPE j_1bnfdoc-nfenum,
        docstat TYPE j_1bnfdoc-docstat,
      END OF ty_doc_entrada,

      BEGIN OF ty_active,
        docnum      TYPE j_1bnfe_active-docnum,
        code        TYPE j_1bnfe_active-code,
        cancel      TYPE j_1bnfe_active-cancel,
        action_requ TYPE j_1bnfe_active-action_requ,
      END OF ty_active,

      ty_t_doc_entrada TYPE TABLE OF ty_doc_entrada,
      ty_t_active      TYPE TABLE OF ty_active.

    DATA: gv_interval     TYPE i VALUE 10.

    DATA: go_grid      TYPE REF TO cl_gui_alv_grid,
          go_container TYPE REF TO cl_gui_container,
          go_timer     TYPE REF TO cl_gui_timer.

    CLASS-DATA go_instance TYPE REF TO zclmm_inventario_fisico .

    METHODS:
      nf_ent_sai
        IMPORTING
          is_main        TYPE ztmm_alivium
          it_doc_entrada TYPE ty_t_doc_entrada
          it_active      TYPE ty_t_active
        CHANGING
          cs_out         TYPE zsmm_alivium.

    METHODS
      show_grid
        CHANGING
          ct_alv_tab TYPE ANY TABLE .

    METHODS
      fill_fcat
        RETURNING
          VALUE(rt_fcat) TYPE lvc_t_fcat .

    METHODS
      show_log
        IMPORTING it_return TYPE bapiret2_t.

ENDCLASS.



CLASS zclmm_inventario_fisico IMPLEMENTATION.
  METHOD get_instance.
    IF ( go_instance IS INITIAL ).
      go_instance = NEW zclmm_inventario_fisico( ).
    ENDIF.

    ro_instance = go_instance.
  ENDMETHOD.

  METHOD set_ref_data.
    ASSIGN gr_iblnr->* TO FIELD-SYMBOL(<fs_iblnr>).
    ASSIGN gr_gjahr->* TO FIELD-SYMBOL(<fs_gjahr>).
    ASSIGN gr_werks->* TO FIELD-SYMBOL(<fs_werks>).
    ASSIGN gr_budat->* TO FIELD-SYMBOL(<fs_budat>).
    ASSIGN gr_bldat->* TO FIELD-SYMBOL(<fs_bldat>).
    ASSIGN gr_mblnr->* TO FIELD-SYMBOL(<fs_mblnr>).

    gs_param-iblnr[]  = <fs_iblnr>.
    gs_param-gjahr[]  = <fs_gjahr>.
    gs_param-werks[]  = <fs_werks>.
    gs_param-budat[]  = <fs_budat>.
    gs_param-bldat[]  = <fs_bldat>.
    gs_param-mblnr[]  = <fs_mblnr>.


    UNASSIGN <fs_iblnr>.
    UNASSIGN <fs_gjahr>.
    UNASSIGN <fs_werks>.
    UNASSIGN <fs_budat>.
    UNASSIGN <fs_bldat>.
    UNASSIGN <fs_mblnr>.
  ENDMETHOD.

  METHOD process_data.
    me->show_grid( CHANGING ct_alv_tab = gt_out ).
  ENDMETHOD.

  METHOD get_data.
    DATA: ls_active TYPE j_1bnfe_active,
*          ls_main   TYPE ztmm_alivium,
          ls_bkpf   TYPE bkpf,
          ls_out    TYPE zsmm_alivium,

          lt_ikpf   TYPE TABLE OF zsmm_alivium,

          lr_bukrs  TYPE RANGE OF bukrs,
          ls_bukrs  LIKE LINE OF lr_bukrs,
          lr_gjahr  TYPE RANGE OF gjahr,
          ls_gjahr  LIKE LINE OF lr_gjahr,
          lr_belnr  TYPE RANGE OF belnr_d,
          ls_belnr  LIKE LINE OF lr_belnr.

    SELECT SINGLE value
      FROM ztmm_alivium_par
      INTO @DATA(lv_interval_aux)
      WHERE function = @gc_function.

    gv_interval = lv_interval_aux.

*    SELECT SINGLE *            THIAGO, VERIFICAR
*      FROM zinv_user_ucomm
*      INTO gs_inv_user_ucomm
*     WHERE name = sy-uname.

*** SÓ ME INTERESSAM OS REGISTROS QUE AINDA NÃO TIVERAM DOCUMENTO DE MATERIAL GERADO
*** OU AINDA NÃO GEROU NOTA, OU AINDA NÃO CONTABILIZOU

    SELECT * FROM ztmm_alivium
      INTO TABLE @DATA(lt_main)
      WHERE iblnr IN @gs_param-iblnr
      AND   gjahr IN @gs_param-gjahr
      AND   mblnr IN @gs_param-mblnr
      AND   ( mblnr EQ '' OR docnum_entrada EQ '' OR docnum_saida EQ '' OR belnr EQ '' OR ( docnum_entrada <> '' AND docnum_saida <> ''  ) ). "#EC CI_CMPLX_WHERE

    LOOP AT lt_main REFERENCE INTO DATA(ls_main) WHERE belnr IS NOT INITIAL. "#EC CI_STDSEQ
      ls_belnr-low = ls_main->belnr.
      ls_belnr-sign = 'I'.
      ls_belnr-option = 'EQ'.
      APPEND ls_belnr TO lr_belnr.

      ls_bukrs-low = ls_main->bukrs.
      ls_bukrs-sign = 'I'.
      ls_bukrs-option = 'EQ'.
      APPEND ls_bukrs TO lr_bukrs.

      ls_gjahr-low = ls_main->gjahr.
      ls_gjahr-sign = 'I'.
      ls_gjahr-option = 'EQ'.
      APPEND ls_gjahr TO lr_gjahr.
    ENDLOOP.

**********************************************************************
    IF lr_belnr IS NOT INITIAL.
      SELECT bukrs, belnr, gjahr, stblg
        FROM bkpf
        INTO TABLE @DATA(lt_bkpf)
        WHERE bukrs IN @lr_bukrs AND
              belnr IN @lr_belnr AND
              gjahr IN @lr_gjahr.

      IF lt_bkpf[] IS NOT INITIAL.
        SORT lt_bkpf BY bukrs belnr gjahr.
      ENDIF.
    ENDIF.

    CHECK NOT lt_main[] IS INITIAL.

    SORT lt_main BY iblnr gjahr.

    " Seleciona os documentos de entrada
    SELECT docnum, nfenum, docstat
      FROM j_1bnfdoc
      INTO TABLE @DATA(lt_doc_entradas)
       FOR ALL ENTRIES IN @lt_main
     WHERE docnum = @lt_main-docnum_entrada.

    IF lt_doc_entradas[] IS NOT INITIAL.
      SORT lt_doc_entradas BY docnum.
    ENDIF.

    "Seleciona os documentos de saida
    SELECT docnum, nfenum, docstat
      FROM j_1bnfdoc
      INTO TABLE @DATA(lt_doc_saidas)
       FOR ALL ENTRIES IN @lt_main
     WHERE docnum = @lt_main-docnum_saida.

    IF lt_doc_saidas[] IS NOT INITIAL.
      SORT lt_doc_saidas BY docnum.
    ENDIF.
*    FREE: it_active.

    IF lt_doc_entradas IS NOT INITIAL.
      SELECT docnum, code, cancel, action_requ
        FROM j_1bnfe_active
        INTO TABLE @DATA(lt_active)
        FOR ALL ENTRIES IN @lt_doc_entradas
        WHERE docnum = @lt_doc_entradas-docnum.
    ENDIF.

    IF lt_doc_saidas IS NOT INITIAL.
      SELECT docnum, code, cancel, action_requ
        FROM j_1bnfe_active
        APPENDING CORRESPONDING FIELDS OF TABLE @lt_active
        FOR ALL ENTRIES IN @lt_doc_saidas
        WHERE docnum = @lt_doc_saidas-docnum.
    ENDIF.

*** BUSCO OS DADOS DA IKPF, POIS, SERÁ A PARTIR DESTA TABELA
*** QUE SERÃO GERADOS OS PRÓXIMOS DOCUMENTOS

    SELECT iblnr, gjahr, werks, lgort, bldat, budat, usnam
      FROM ikpf
      INTO TABLE @DATA(lt_ikpf_table)
      FOR ALL ENTRIES IN @lt_main
      WHERE iblnr EQ @lt_main-iblnr
      AND   gjahr EQ @lt_main-gjahr
      AND   werks IN @gs_param-werks
      AND   budat IN @gs_param-budat
      AND   bldat IN @gs_param-bldat.

    CHECK lt_ikpf_table IS NOT INITIAL.

    SELECT iblnr, gjahr, zeili, matnr, werks, lgort, usnam, budat, buchm, menge, mblnr
      FROM iseg
      INTO TABLE @DATA(lt_iseg)
       FOR ALL ENTRIES IN @lt_ikpf_table
     WHERE iblnr = @lt_ikpf_table-iblnr
       AND gjahr = @lt_ikpf_table-gjahr.           "#EC CI_NO_TRANSFORM

    CHECK lt_iseg IS NOT INITIAL.

    SELECT matnr, maktx
      FROM makt
      INTO TABLE @DATA(lt_makt)
       FOR ALL ENTRIES IN @lt_iseg
       WHERE matnr = @lt_iseg-matnr
       AND spras   = @sy-langu.                    "#EC CI_NO_TRANSFORM

    IF lt_makt[] IS NOT INITIAL.
      SORT lt_makt BY matnr.
    ENDIF.

    MOVE-CORRESPONDING lt_ikpf_table TO lt_ikpf.

    SORT: lt_ikpf.", it_iseg.
    FREE: gt_out.
    CLEAR: gv_nf_en_sa.

    LOOP AT lt_ikpf ASSIGNING FIELD-SYMBOL(<fs_ikpf>).

      CLEAR ls_main.

      READ TABLE lt_main REFERENCE INTO ls_main WITH KEY iblnr = <fs_ikpf>-iblnr
                                                         gjahr = <fs_ikpf>-gjahr
                                                         BINARY SEARCH.

      MOVE-CORRESPONDING ls_main->* TO <fs_ikpf>.

      READ TABLE lt_doc_saidas INTO DATA(ls_doc) WITH KEY docnum = ls_main->docnum_saida BINARY SEARCH.
      IF sy-subrc = 0.
        <fs_ikpf>-nfenum = ls_doc-nfenum.
      ELSE.
        READ TABLE lt_doc_entradas INTO ls_doc WITH KEY docnum = ls_main->docnum_entrada BINARY SEARCH.
        IF sy-subrc = 0.
          <fs_ikpf>-nfenum = ls_doc-nfenum.
        ENDIF.
      ENDIF.

      IF ls_main->docnum_entrada IS INITIAL AND ls_main->docnum_saida IS INITIAL.
        CLEAR <fs_ikpf>-docstat_icon.
      ELSEIF ls_doc-nfenum IS NOT INITIAL AND ls_doc-docstat = ''.
        <fs_ikpf>-docstat_icon = '@9Y@'. "ICON_ACTIVITY
      ELSEIF ls_doc-nfenum IS INITIAL.
        <fs_ikpf>-docstat_icon = '@AH@'. "ICON_WARNING
      ELSEIF ls_doc-docstat = '1'.
        <fs_ikpf>-docstat_icon = '@DF@'. "ICON_COMPLETE
      ELSEIF ls_doc-docstat = '2'.
        <fs_ikpf>-docstat_icon = '@AG@'. "ICON_ALERT
      ELSEIF ls_doc-docstat = '3'.
        <fs_ikpf>-docstat_icon = '@F1@'. "ICON_DEFECT
      ENDIF.

      IF ls_main->docnum_entrada IS NOT INITIAL AND ls_main->docnum_saida IS INITIAL.
        READ TABLE lt_active INTO ls_active WITH KEY docnum = ls_main->docnum_entrada. "#EC CI_STDSEQ
        IF ( sy-subrc = 0 AND ls_active-code NE '100' AND
             ls_doc-docstat = '1' ) OR
           ( ls_active-cancel = 'X' ).
*        <fs_out>-status_nf_en = 'X'.
          <fs_ikpf>-status_nf = 'X'.
          <fs_ikpf>-docstat_icon = '@DF@'.
        ENDIF.
      ENDIF.

      " Tratativa quando o doc. de inventário possuir NF de entrada e saída
      IF NOT ls_main->docnum_entrada IS INITIAL AND NOT ls_main->docnum_saida IS INITIAL.
        me->nf_ent_sai( EXPORTING is_main        = ls_main->*
                                  it_doc_entrada = lt_doc_entradas
                                  it_active      = lt_active
                        CHANGING  cs_out         = <fs_ikpf> ).
        gv_nf_en_sa = abap_true.
      ENDIF.

      IF ls_main->docnum_saida IS NOT INITIAL.
        READ TABLE lt_active INTO ls_active WITH KEY docnum = ls_main->docnum_saida. "#EC CI_STDSEQ
        IF ( sy-subrc = 0 AND ls_active-code NE '100' AND
             ls_doc-docstat = '1' ) OR
           ( ls_active-cancel = 'X' ).
          <fs_ikpf>-status_nf = 'X'.
          <fs_ikpf>-docstat_icon = '@DF@'.
        ENDIF.
      ENDIF.

*    " Tratativa quando o doc. de inventário possuir NF de entrada e saída
*    IF NOT ls_main-docnum_entrada IS INITIAL AND NOT ls_main-docnum_saida IS INITIAL.
*      PERFORM f_nf_ent_sai USING ls_main
*                           CHANGING <fs_out>.
*      gv_nf_en_sa = abap_true.
*    ENDIF.

      IF <fs_ikpf>-belnr IS NOT INITIAL.
        READ TABLE lt_bkpf INTO ls_bkpf WITH KEY belnr = <fs_ikpf>-belnr
                                                 bukrs = <fs_ikpf>-bukrs
                                                 gjahr = <fs_ikpf>-gjahr
                                                 BINARY SEARCH.

        IF sy-subrc = 0 AND ls_bkpf-stblg IS NOT INITIAL.
          <fs_ikpf>-belnr_estorn = ls_bkpf-stblg.
          <fs_ikpf>-status_belnr = 'X'.
        ENDIF.
      ENDIF.

      IF ls_active-action_requ = 'C'.
        <fs_ikpf>-docstat_icon = '@DF@'. "ICON_COMPLETE
      ENDIF.

      <fs_ikpf>-color = 'C100'.
      APPEND <fs_ikpf> TO gt_out.

*     LOOP AT it_iseg INTO gs_iseg WHERE iblnr = <fs_out>-iblnr AND gjahr = <fs_out>-gjahr.
*       MOVE-CORRESPONDING gs_iseg TO gs_out.
*       gs_out-difmg = gs_out-buchm - gs_out-menge.
*       CLEAR: gs_out-iblnr, gs_out-budat, gs_out-mblnr, gs_out-gjahr, gs_out-werks, gs_out-lgort.
*       READ TABLE it_makt INTO gs_makt WITH KEY matnr = gs_out-matnr.
*       gs_out-maktx = gs_makt-maktx.
*
*       gs_out-color = 'C200'.
*       APPEND gs_out TO it_out.
*     ENDLOOP.

      CLEAR: ls_doc.", gs_iseg, gs_out.
    ENDLOOP.

    CLEAR ls_out.
    LOOP AT lt_iseg REFERENCE INTO DATA(ls_iseg).
      MOVE-CORRESPONDING ls_iseg->* TO ls_out.
      ls_out-difmg = ls_out-menge - ls_out-buchm.
*    CLEAR: gs_out-iblnr, gs_out-budat, gs_out-mblnr, gs_out-gjahr, gs_out-werks, gs_out-lgort.
      READ TABLE lt_makt INTO DATA(ls_makt) WITH KEY matnr = ls_out-matnr BINARY SEARCH.
      ls_out-maktx = ls_makt-maktx.

      ls_out-color = 'C200'.
      APPEND ls_out TO gt_out.
    ENDLOOP.

    SORT gt_out BY iblnr gjahr zeili.

  ENDMETHOD.

  METHOD nf_ent_sai.
    READ TABLE it_doc_entrada INTO  DATA(ls_doc) WITH KEY docnum = is_main-docnum_entrada BINARY SEARCH.
    IF sy-subrc = 0.
      cs_out-nfenum_en = ls_doc-nfenum.
    ENDIF.

    IF is_main-docnum_entrada IS INITIAL.
      CLEAR cs_out-docstat_icon_en.
    ELSEIF ls_doc-nfenum IS NOT INITIAL AND ls_doc-docstat = ''.
      cs_out-docstat_icon_en = '@9Y@'. "ICON_ACTIVITY
    ELSEIF ls_doc-nfenum IS INITIAL.
      cs_out-docstat_icon_en = '@AH@'. "ICON_WARNING
    ELSEIF ls_doc-docstat = '1'.
      cs_out-docstat_icon_en = '@DF@'. "ICON_COMPLETE
    ELSEIF ls_doc-docstat = '2'.
      cs_out-docstat_icon_en = '@AG@'. "ICON_ALERT
    ELSEIF ls_doc-docstat = '3'.
      cs_out-docstat_icon_en = '@F1@'. "ICON_DEFECT
    ENDIF.

    IF is_main-docnum_entrada IS NOT INITIAL.
      READ TABLE it_active INTO DATA(ls_active) WITH KEY docnum = is_main-docnum_entrada. "#EC CI_STDSEQ
      IF ( sy-subrc = 0 AND ls_active-code NE '100' AND
           ls_doc-docstat = '1' ) OR
         ( ls_active-cancel = 'X' ).
        cs_out-status_nf_en = 'X'.
        cs_out-status_nf = ' '.
        cs_out-docstat_icon_en = '@DF@'.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD on_user_command.

    DATA lt_return TYPE bapiret2_t.

    FREE lt_return.

    CASE e_ucomm.
      WHEN gc_GERAR_MI07.
        lt_return = me->gerar_mi07(  ).

        me->show_log( lt_return ).

      WHEN gc_GERAR_NOTA.
      WHEN gc_GERAR_ACCT.
      WHEN gc_ATUALIZAR.
      WHEN gc_ESTORNAR.
    ENDCASE. "e_ucomm

  ENDMETHOD.

  METHOD has_data.
    IF ( gt_out[] IS NOT INITIAL ).
      rv_is_ok = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD show_grid.
    DATA: ls_layout  TYPE lvc_s_layo,
          ls_variant TYPE disvariant.

    IF ( go_grid IS NOT BOUND ).

      ls_layout-sel_mode   = 'A'.
      ls_layout-cwidth_opt = abap_true.
      ls_layout-zebra      = abap_true.
      ls_layout-info_fname = 'COLOR'.

      ls_variant-handle   = 'A001'.
      ls_variant-report   = sy-repid.
      ls_variant-username = sy-uname.

      DATA(lt_fcat) = fill_fcat( ).

      go_container = NEW cl_gui_custom_container( container_name = 'CONTAINER' ).
      CREATE OBJECT go_grid EXPORTING i_parent = go_container .

      "Registra eventos
      SET HANDLER on_user_command FOR go_grid.

      IF gv_interval IS NOT INITIAL.
        IF ( go_timer IS NOT BOUND ).
          CREATE OBJECT go_timer.
        ENDIF.

        SET HANDLER handle_finished FOR go_timer.
        go_timer->interval = gv_interval.
        go_timer->run(  ).
      ENDIF.

      SET HANDLER hotspot_click FOR go_grid.

      go_grid->set_table_for_first_display(
        EXPORTING
        is_variant                      = ls_variant
        i_save                          = 'A'
        i_default                       = abap_true
          is_layout                     = ls_layout
        CHANGING
          it_fieldcatalog               = lt_fcat
          it_outtab                     = ct_alv_tab
        EXCEPTIONS
          invalid_parameter_combination = 1
          program_error                 = 2
          too_many_lines                = 3
          OTHERS                        = 4 ).

    ELSE.
      go_grid->refresh_table_display( ).

      IF gv_interval IS NOT INITIAL.
        IF ( go_timer IS NOT BOUND ).
          CREATE OBJECT go_timer.
        ENDIF.

        SET HANDLER handle_finished FOR go_timer.
        go_timer->interval = gv_interval.
        go_timer->run(  ).
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD fill_fcat.
    DATA: lv_structure TYPE dd02l-tabname.

    lv_structure = gc_structure.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = lv_structure
      CHANGING
        ct_fieldcat      = rt_fcat.

    SORT rt_fcat BY scrtext_l.

    LOOP AT rt_fcat ASSIGNING FIELD-SYMBOL(<fs_cat>).

      CASE <fs_cat>-fieldname.
        WHEN 'MBLNR' OR 'IBLNR'.
          <fs_cat>-hotspot = 'X'.
        WHEN 'GJAHR'.
          DELETE rt_fcat INDEX sy-tabix.
        WHEN 'BELNR'.
          <fs_cat>-hotspot    = 'X'.
          <fs_cat>-scrtext_l  = TEXT-t13.
          <fs_cat>-scrtext_m  = <fs_cat>-scrtext_l.
          <fs_cat>-scrtext_s  = <fs_cat>-scrtext_l.
          <fs_cat>-selddictxt = <fs_cat>-scrtext_l.
          <fs_cat>-coltext    = <fs_cat>-scrtext_l.
        WHEN 'BELNR_ESTORN'.
          <fs_cat>-scrtext_l  = TEXT-t12.
          <fs_cat>-scrtext_m  = TEXT-t12.
          <fs_cat>-scrtext_s  = TEXT-t12.
          <fs_cat>-selddictxt = TEXT-t12.
          <fs_cat>-coltext    = TEXT-t12.
        WHEN 'STATUS_BELNR'.
          <fs_cat>-scrtext_l  = TEXT-t11.
          <fs_cat>-scrtext_m  = TEXT-t11.
          <fs_cat>-scrtext_s  = TEXT-t11.
          <fs_cat>-selddictxt = TEXT-t11.
          <fs_cat>-coltext    = TEXT-t11.
        WHEN 'GIDAT'.
          DELETE rt_fcat INDEX sy-tabix.
        WHEN 'ZLDAT'.
          DELETE rt_fcat INDEX sy-tabix.
        WHEN 'VGART'.
          DELETE rt_fcat INDEX sy-tabix.
        WHEN 'SOBKZ'.
          DELETE rt_fcat INDEX sy-tabix.
        WHEN 'MONAT'.
          DELETE rt_fcat INDEX sy-tabix.
        WHEN 'SPERR'.
          DELETE rt_fcat INDEX sy-tabix.
        WHEN 'ZSTAT'.
          DELETE rt_fcat INDEX sy-tabix.
        WHEN 'DSTAT'.
          DELETE rt_fcat INDEX sy-tabix.
        WHEN 'XBLNI'.
          DELETE rt_fcat INDEX sy-tabix.
        WHEN 'LSTAT'.
          DELETE rt_fcat INDEX sy-tabix.
        WHEN 'XBUFI'.
          DELETE rt_fcat INDEX sy-tabix.
        WHEN 'KEORD'.
          DELETE rt_fcat INDEX sy-tabix.
        WHEN 'ORDNG'.
          DELETE rt_fcat INDEX sy-tabix.
        WHEN 'INVNU1'.
          DELETE rt_fcat INDEX sy-tabix.
        WHEN 'IBLTXT'.
          DELETE rt_fcat INDEX sy-tabix.
        WHEN 'INVART'.
          DELETE rt_fcat INDEX sy-tabix.
        WHEN 'WSTI_BSTAT'.
          DELETE rt_fcat INDEX sy-tabix.
        WHEN 'NFENUM'.
          <fs_cat>-scrtext_l  = TEXT-t01.
          <fs_cat>-scrtext_m  = <fs_cat>-scrtext_l.
          <fs_cat>-scrtext_s  = <fs_cat>-scrtext_l.
          <fs_cat>-selddictxt = <fs_cat>-scrtext_l.
          <fs_cat>-coltext    = <fs_cat>-scrtext_l.
        WHEN 'DOCSTAT_ICON'.
          <fs_cat>-just = 'C'.
          <fs_cat>-scrtext_l  = TEXT-t02.
          <fs_cat>-scrtext_m  = <fs_cat>-scrtext_l.
          <fs_cat>-scrtext_s  = <fs_cat>-scrtext_l.
          <fs_cat>-selddictxt = <fs_cat>-scrtext_l.
          <fs_cat>-coltext    = <fs_cat>-scrtext_l.
        WHEN 'NFENUM_EN'.
          <fs_cat>-scrtext_l  = TEXT-t03.
          <fs_cat>-scrtext_m  = <fs_cat>-scrtext_l.
          <fs_cat>-scrtext_s  = <fs_cat>-scrtext_l.
          <fs_cat>-selddictxt = <fs_cat>-scrtext_l.
          <fs_cat>-coltext    = <fs_cat>-scrtext_l.

          IF gv_nf_en_sa IS INITIAL.
            <fs_cat>-no_out = abap_true.
          ENDIF.
        WHEN 'DOCSTAT_ICON_EN'.
          <fs_cat>-just = 'C'.
          <fs_cat>-scrtext_l  = TEXT-t04.
          <fs_cat>-scrtext_m  = <fs_cat>-scrtext_l.
          <fs_cat>-scrtext_s  = <fs_cat>-scrtext_l.
          <fs_cat>-selddictxt = <fs_cat>-scrtext_l.
          <fs_cat>-coltext    = <fs_cat>-scrtext_l.
          IF gv_nf_en_sa IS INITIAL.
            <fs_cat>-no_out = abap_true.
          ENDIF.
        WHEN 'STATUS_NF_EN'.
          <fs_cat>-just = 'C'.
          <fs_cat>-scrtext_l  = TEXT-t05.
          <fs_cat>-scrtext_m  = <fs_cat>-scrtext_l.
          <fs_cat>-scrtext_s  = <fs_cat>-scrtext_l.
          <fs_cat>-selddictxt = <fs_cat>-scrtext_l.
          <fs_cat>-coltext    = <fs_cat>-scrtext_l.
          IF gv_nf_en_sa IS INITIAL.
            <fs_cat>-no_out = abap_true.
          ENDIF.
        WHEN 'BUCHM'.
          <fs_cat>-scrtext_l  = TEXT-t06.
          <fs_cat>-scrtext_m  = <fs_cat>-scrtext_l.
          <fs_cat>-scrtext_s  = <fs_cat>-scrtext_l.
          <fs_cat>-selddictxt = <fs_cat>-scrtext_l.
          <fs_cat>-coltext    = <fs_cat>-scrtext_l.
        WHEN 'MENGE'.
          <fs_cat>-scrtext_l  = TEXT-t07.
          <fs_cat>-scrtext_m  = <fs_cat>-scrtext_l.
          <fs_cat>-scrtext_s  = <fs_cat>-scrtext_l.
          <fs_cat>-selddictxt = <fs_cat>-scrtext_l.
          <fs_cat>-coltext    = <fs_cat>-scrtext_l.
        WHEN 'DIFMG'.
          <fs_cat>-scrtext_l  = TEXT-t08.
          <fs_cat>-scrtext_m  = <fs_cat>-scrtext_l.
          <fs_cat>-scrtext_s  = <fs_cat>-scrtext_l.
          <fs_cat>-selddictxt = <fs_cat>-scrtext_l.
          <fs_cat>-coltext    = <fs_cat>-scrtext_l.
        WHEN 'DOCNUM_ENTRADA'.
          <fs_cat>-hotspot    = 'X'.
          <fs_cat>-scrtext_l  = TEXT-t09.
          <fs_cat>-scrtext_m  = <fs_cat>-scrtext_l.
          <fs_cat>-scrtext_s  = <fs_cat>-scrtext_l.
          <fs_cat>-selddictxt = <fs_cat>-scrtext_l.
          <fs_cat>-coltext    = <fs_cat>-scrtext_l.
        WHEN 'DOCNUM_SAIDA'.
          <fs_cat>-hotspot    = 'X'.
          <fs_cat>-scrtext_l  = TEXT-t10.
          <fs_cat>-scrtext_m  = <fs_cat>-scrtext_l.
          <fs_cat>-scrtext_s  = <fs_cat>-scrtext_l.
          <fs_cat>-selddictxt = <fs_cat>-scrtext_l.
          <fs_cat>-coltext    = <fs_cat>-scrtext_l.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.

  METHOD hotspot_click.
    DATA: lv_coluna(30) TYPE c.

    lv_coluna = e_column_id.

    READ TABLE gt_out INTO DATA(ls_out) INDEX es_row_no-row_id.

    CHECK sy-subrc IS INITIAL.

    CALL FUNCTION 'ZFMM_CALL_TRANSACTION' STARTING NEW TASK 'TRANS'
      EXPORTING
        is_out    = ls_out
        iv_coluna = lv_coluna.
  ENDMETHOD.

  METHOD handle_finished.
    me->get_data(  ).
    IF go_grid IS NOT INITIAL.
      go_grid->refresh_table_display(  ).
    ENDIF.
    go_timer->run(  ).
  ENDMETHOD.

  METHOD gerar_mi07.
    DATA: lt_items  TYPE TABLE OF bapi_physinv_post_items,
          lt_return TYPE TABLE OF bapiret2,
          lt_main   TYPE TABLE OF ztmm_alivium.

    go_grid->get_selected_rows( IMPORTING et_row_no = DATA(lt_row) ).

    LOOP AT lt_row REFERENCE INTO DATA(ls_row).
      FREE: lt_items, lt_return.

      READ TABLE gt_out ASSIGNING FIELD-SYMBOL(<fs_out>) INDEX ls_row->row_id.
      CHECK sy-subrc IS INITIAL.

      IF <fs_out>-mblnr IS INITIAL.
        CALL FUNCTION 'BAPI_MATPHYSINV_POSTDIFF'
          EXPORTING
            physinventory = <fs_out>-iblnr
            fiscalyear    = <fs_out>-gjahr
            pstng_date    = <fs_out>-budat
          TABLES
            items         = lt_items
            return        = lt_return.

*        READ TABLE lt_return INTO DATA(ls_return) WITH KEY type = 'E'.
*        IF sy-subrc NE 0.
        IF NOT line_exists( lt_return[ type = 'E' ] ).   "#EC CI_STDSEQ
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = 'X'.


          TRY.
              <fs_out>-mblnr = lt_return[ id     = 'M7'
                                          number = '716' ]-message_v2. "#EC CI_STDSEQ

              APPEND INITIAL LINE TO lt_main ASSIGNING FIELD-SYMBOL(<fs_main>).
              MOVE-CORRESPONDING <fs_out> TO <fs_main>.
            CATCH cx_sy_itab_line_not_found.
          ENDTRY.

*          READ TABLE lt_return INTO ls_return WITH KEY id     = 'M7'
*                                                       number = '716'.
*          IF sy-subrc IS INITIAL.
*            <fs_out>-mblnr = ls_return-message_v2.
*
*            APPEND INITIAL LINE TO lt_main ASSIGNING FIELD-SYMBOL(<fs_main>).
*            MOVE-CORRESPONDING <fs_out> TO <fs_main>.
*          ENDIF.
        ENDIF.

        APPEND LINES OF lt_return TO rt_return.

      ELSE.
        rt_return = VALUE #( BASE rt_return ( type   = 'I'
                                              id     = gc_id_msg
                                              number = '002' ) ).
      ENDIF.
    ENDLOOP.

    IF NOT lt_main[] IS INITIAL.
      MODIFY ztmm_alivium FROM TABLE lt_main.
      IF sy-subrc = 0.
        COMMIT WORK.
      ENDIF.
    ENDIF.

    go_grid->refresh_table_display( ).
    cl_gui_cfw=>set_new_ok_code( 'ENTER' ).
  ENDMETHOD.

  METHOD show_log.
    DATA: lt_messages TYPE esp1_message_tab_type.

    LOOP AT it_return ASSIGNING FIELD-SYMBOL(<fs_return>).
      lt_messages = VALUE #( BASE lt_messages (
                                                msgid  = <fs_return>-id
                                                msgty  = <fs_return>-type
                                                msgno  = <fs_return>-number
                                                msgv1  = <fs_return>-message_v1
                                                msgv2  = <fs_return>-message_v2
                                                msgv3  = <fs_return>-message_v3
                                                msgv4  = <fs_return>-message_v4
                                                lineno = sy-tabix ) ).
    ENDLOOP.

    DATA(lo_message) = NEW zclca_messages( ).
    lo_message->messages_show_as_popup( EXPORTING it_message_tab = lt_messages ).
  ENDMETHOD.


ENDCLASS.
