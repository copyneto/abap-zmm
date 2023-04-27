class ZCLMM_CONF_DADOS_RECEBMNT definition
  public
  final
  create public .

public section.

  types:
    ty_bsart TYPE RANGE OF bsart .

  constants:
    BEGIN OF gc_param,
                 modulo      TYPE ze_param_modulo  VALUE 'MM',
                 chav1_int   TYPE ze_param_chave   VALUE 'INTERFACE SAGA',
                 chav2_saga  TYPE ze_param_chave   VALUE 'SAGA',
                 chav3_werks TYPE ze_param_chave_3 VALUE 'WERKS',
                 chav3_lgort TYPE ze_param_chave_3 VALUE 'LGORT',
               END OF gc_param .
  constants:
    BEGIN OF gc_mtart,
                 fert TYPE mara-mtart VALUE 'FERT',
                 hawa TYPE mara-mtart VALUE 'HAWA',
                 zpro TYPE mara-mtart VALUE 'ZPRO',
                 ztre TYPE mara-mtart VALUE 'ZTRE',
               END OF gc_mtart .

  methods GRAVA_RECEB
    importing
      !IS_RECEB type ZCLMM_MT_RECEBIMENTO_QUANTIDAD
    exceptions
      RAISE_ERROR .
  methods MODIFICA_STATUS
    importing
      !IS_STATUS type /XNFE/INHDSTA .
  methods READ_STATUS
    importing
      !IV_GUID type /XNFE/GUID_16
    exporting
      !ET_HDSTA type /XNFE/INHDSTA_T .
  methods SAVE_STATUS .
  methods DEQUEUE_STATUS
    importing
      !IV_GUID type /XNFE/GUID_16 .
*    METHODS processar_nfe
*      IMPORTING
*        !iv_guid    TYPE /xnfe/guid_16
*        !it_pedidos TYPE zctgmm_pedi_mont_logi
*      EXPORTING
*        !et_hdsta   TYPE /xnfe/inhdsta_t .
  methods PROCESSAR_STOCK
    importing
      !IV_GUID type /XNFE/GUID_16
      !IV_CNPJ type /XNFE/CNPJ_EMIT
      !IV_NNF type /XNFE/NNF
      !IV_STEP type /XNFE/PROCTYP
    changing
      !CT_HDSTA type /XNFE/INHDSTA_T .
  methods CONV_MAT
    importing
      !IS_MATERIAL type STRING
    returning
      value(RV_RESULT) type /XNFE/PO_MATNR .
  methods VALIDAR_PEDIDO
    importing
      !IV_EBELN type EBELN
    returning
      value(RV_OK) type CHAR1 .
  methods VALIDAR_ENV_SAGA
    importing
      !IS_KEY type ZSMM_KEY_ENV_SAGA
    returning
      value(RV_OK) type CHAR1 .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS: BEGIN OF gc_values ,
*                 paramt   TYPE ztmm_saga_param-parametro VALUE 'DEPOSITOS_WMS',
                 grconfqu TYPE /xnfe/proc_step           VALUE 'GRCONFQU',
                 grfichck TYPE /xnfe/proc_step           VALUE 'GRFICHCK',
                 grmmchck TYPE /xnfe/proc_step           VALUE 'GRMMCHCK',
                 grpostng TYPE /xnfe/proc_step           VALUE 'GRPOSTNG',
                 ivpostng TYPE /xnfe/proc_step           VALUE 'IVPOSTNG',
                 sendopco TYPE /xnfe/proc_step           VALUE 'SENDOPCO',
                 grstopst TYPE /xnfe/proc_step           VALUE 'GRSTOPST',
                 report   TYPE syst_cprog                VALUE 'ZMMR_SAGA_RECEBIMENTOS',
                 a        TYPE char1                     VALUE 'A',
                 stocktrf TYPE /xnfe/proctyp     VALUE 'STOCKTRF',
                 normprch TYPE /xnfe/proctyp     VALUE 'NORMPRCH',
                 mm       TYPE ze_param_modulo      VALUE 'MM',
                 dep_fech TYPE ze_param_chave       VALUE 'DEPOSITO_FECHADO',
                 saga     TYPE ze_param_chave       VALUE 'SAGA',
                 bsart    TYPE ze_param_chave_3     VALUE 'BSART',
               END OF gc_values.

ENDCLASS.



CLASS ZCLMM_CONF_DADOS_RECEBMNT IMPLEMENTATION.


  METHOD dequeue_status.

    CALL FUNCTION 'DEQUEUE_/XNFE/ENQ_INFEHD'
      EXPORTING
        mode_/xnfe/innfehd = 'E'
        mandt              = sy-mandt
        guid_header        = iv_guid
        _scope             = '1'.

  ENDMETHOD.


  METHOD grava_receb.

    TYPES: BEGIN OF ty_forn,
             lifnr TYPE lfa1-lifnr,
           END OF ty_forn.

    DATA: lt_pedidos TYPE zclmm_dt_recebimento_quant_tab,
          lt_forn    TYPE STANDARD TABLE OF ty_forn.

    DATA: lt_wms_receb TYPE STANDARD TABLE OF ztmm_wms_receb WITH EMPTY KEY,
          lt_aux       TYPE STANDARD TABLE OF ztmm_wms_receb WITH EMPTY KEY,
          lv_nfenum    TYPE ztmm_wms_receb-nfenum,
          lv_lifnr     TYPE ztmm_wms_receb-lifnr,
          lv_itmnum    TYPE ztmm_wms_receb-itmnum.

    CHECK is_receb IS NOT INITIAL.

    lt_pedidos[] = is_receb-mt_recebimento_quantidade-pedidos[].

    LOOP AT lt_pedidos ASSIGNING FIELD-SYMBOL(<fs_pedidos>).

      LOOP AT <fs_pedidos>-itens ASSIGNING FIELD-SYMBOL(<fs_itens>).

        lt_aux[] = VALUE #( BASE lt_aux ( nfenum     = <fs_pedidos>-numeroexterno
                                          lifnr      = <fs_pedidos>-fornec
                                          itmnum     = <fs_itens>-itmnum
                                          charg      = <fs_itens>-lote
                                          zqtde_cont = <fs_itens>-quantidadereal
                                          zqtde_nf   = <fs_itens>-quantidadeprevista ) ).

      ENDLOOP.
    ENDLOOP.

    IF lt_aux[] IS NOT INITIAL.

      SELECT *
        FROM ztmm_wms_receb
         FOR ALL ENTRIES IN @lt_aux
       WHERE nfenum  = @lt_aux-nfenum
         AND lifnr   = @lt_aux-lifnr
         AND itmnum  = @lt_aux-itmnum
        INTO TABLE @DATA(lt_remes_pednv).

      IF sy-subrc IS INITIAL.

        SORT lt_remes_pednv BY nfenum
                               lifnr
                               itmnum.

        LOOP AT lt_pedidos ASSIGNING <fs_pedidos>.

          LOOP AT <fs_pedidos>-itens ASSIGNING <fs_itens>.

            lv_nfenum = <fs_pedidos>-numeroexterno.
            lv_lifnr  = <fs_pedidos>-fornec.
            lv_itmnum = <fs_itens>-itmnum.

            READ TABLE lt_remes_pednv TRANSPORTING NO FIELDS
                                                    WITH KEY nfenum  = lv_nfenum
                                                             lifnr   = lv_lifnr
                                                             itmnum  = lv_itmnum
                                                             BINARY SEARCH.

            LOOP AT lt_remes_pednv ASSIGNING FIELD-SYMBOL(<fs_remes_pednv>) FROM sy-tabix.
              IF <fs_remes_pednv>-nfenum NE lv_nfenum
              OR <fs_remes_pednv>-lifnr  NE lv_lifnr
              OR <fs_remes_pednv>-itmnum NE lv_itmnum.
                EXIT.
              ENDIF.

              lt_wms_receb[] = VALUE #( BASE lt_wms_receb ( nfenum     = <fs_remes_pednv>-nfenum
                                                            lifnr      = <fs_remes_pednv>-lifnr
                                                            stcd1      = <fs_remes_pednv>-stcd1
                                                            itmnum     = <fs_remes_pednv>-itmnum
                                                            charg      = <fs_remes_pednv>-charg
                                                            werks      = <fs_remes_pednv>-werks
                                                            matnr      = <fs_remes_pednv>-matnr
                                                            zqtde_nf   = <fs_itens>-quantidadeprevista
                                                            zqtde_cont = <fs_itens>-quantidadereal
                                                            zconcl     = <fs_remes_pednv>-zconcl
                                                            zarmaz     = <fs_remes_pednv>-zarmaz
                                                            idnfenum   = <fs_remes_pednv>-idnfenum ) ).

            ENDLOOP.
          ENDLOOP.
        ENDLOOP.

        IF lt_wms_receb IS NOT INITIAL.

          MODIFY ztmm_wms_receb FROM TABLE lt_wms_receb.

          IF sy-subrc IS INITIAL.
            COMMIT WORK.
          ELSE.
            RAISE raise_error.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

*    IF is_receb-fornec IS NOT INITIAL.
*
*      lv_lifnr = is_receb-fornec(10).
*
*      SELECT SINGLE lifnr, stcd1 FROM lfa1
*       WHERE lifnr = @lv_lifnr
*        INTO @DATA(ls_lfa1).
*
*    ENDIF.
*
*    LOOP AT is_receb-itens ASSIGNING FIELD-SYMBOL(<fs_itens>).
*
*      lt_wms_receb = VALUE #( BASE lt_wms_receb ( nfenum     = is_receb-numeroexterno
*                                                  lifnr      = is_receb-fornec
*                                                  itmnum     = <fs_itens>-itmnum
*                                                  charg      = <fs_itens>-lote
*                                                  zqtde_cont = <fs_itens>-quantidadereal
*                                                  zqtde_nf   = <fs_itens>-quantidadeprevista ) ).
*
*    ENDLOOP.
*
*    IF lt_wms_receb IS NOT INITIAL.
*
*      SELECT * FROM ztmm_wms_receb
*        FOR ALL ENTRIES IN @lt_wms_receb
*        WHERE nfenum   = @lt_wms_receb-nfenum
*           AND lifnr   = @lt_wms_receb-lifnr
*           AND itmnum  = @lt_wms_receb-itmnum
*        INTO TABLE @DATA(lt_remes_pednv).
*
*      IF lt_remes_pednv IS NOT INITIAL.
*
*        DATA(lt_wms_cop) = lt_wms_receb.
*
*        lt_wms_receb = VALUE #( FOR ls_receb IN lt_remes_pednv (
*                                  nfenum   = ls_receb-nfenum
*                                  lifnr    = ls_receb-lifnr
*                                  stcd1    = ls_receb-stcd1
*                                  itmnum   = ls_receb-itmnum
*                                  charg    = ls_receb-charg
*                                  werks    = ls_receb-werks
*                                  matnr    = ls_receb-matnr
*                                  zqtde_nf   = VALUE #( lt_wms_cop[ itmnum = ls_receb-itmnum ]-zqtde_nf   OPTIONAL )
*                                  zqtde_cont = VALUE #( lt_wms_cop[ itmnum = ls_receb-itmnum ]-zqtde_cont OPTIONAL )
*                                  zconcl   = ls_receb-zconcl
*                                  zarmaz   = ls_receb-zarmaz
*                                  idnfenum = ls_receb-idnfenum
*                               ) ).
*
*        IF lt_wms_receb IS NOT INITIAL.
*
*          MODIFY ztmm_wms_receb FROM TABLE lt_wms_receb.
*
*          IF sy-subrc IS INITIAL.
*            COMMIT WORK.
*          ELSE.
*            RAISE raise_error.
*          ENDIF.
*        ENDIF.
*      ENDIF.
*    ENDIF.

  ENDMETHOD.


  METHOD modifica_status.

    CALL FUNCTION '/XNFE/B2BNFE_MODIFY_STATUS'
      EXPORTING
        is_status          = is_status
      EXCEPTIONS
        nfe_does_not_exist = 1
        technical_error    = 2
        OTHERS             = 3.

    IF sy-subrc IS INITIAL.
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1
*                                                             sy-msgv2
*                                                             sy-msgv3
*                                                             sy-msgv4.
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD processar_stock.

    CHECK iv_cnpj IS NOT INITIAL.

*    CASE iv_step.
*      WHEN gc_values-stocktrf.
*
*        SELECT SINGLE ponumber, poitem FROM /xnfe/innfehd AS h
*        INNER JOIN /xnfe/innfeit AS i
*        ON h~guid_header = i~guid_header
*               WHERE h~cnpj_emit  = @iv_cnpj
*                 AND h~nnf        = @iv_nnf
*                 INTO @DATA(ls_resul).
*
*        IF ls_resul IS NOT INITIAL.
*
*          DATA(lv_item) = ( 10 * ls_resul-poitem ).
*
*          SELECT ebeln,
*                 ebelp,
*                 werks,
*                 lgort
*            FROM ekpo
*           WHERE ebeln = @ls_resul-ponumber
*             AND ebelp IN ( @ls_resul-poitem, @lv_item )
*            INTO TABLE @DATA(lt_ekpo).
*
*          IF sy-subrc EQ 0.
*            EXIT.
*          ENDIF.
*
*          IF lt_ekpo IS NOT INITIAL.
*
**            DATA(lt_ekpo_fae) = lt_ekpo[].
**            SORT lt_ekpo_fae BY werks
**                                lgort.
**            DELETE ADJACENT DUPLICATES FROM lt_ekpo_fae COMPARING werks
**                                                                  lgort.
*
**            SELECT werks,
**                   valor
**              FROM ztmm_saga_param
**               FOR ALL ENTRIES IN @lt_ekpo_fae
**             WHERE werks     = @lt_ekpo_fae-werks
**               AND lgort     = @lt_ekpo_fae-lgort
**               AND parametro = @gc_values-paramt
**              INTO TABLE @DATA(lt_param).
*
*          ENDIF.
*        ENDIF.
*
*      WHEN gc_values-normprch.
*
*    SELECT SINGLE guidheader
*      FROM zi_mm_innfehd
*     WHERE cnpjemit  = @iv_cnpj
*       AND nnf       = @iv_nnf
*      INTO @DATA(lv_guid_header).
*
*    ENDCASE.

*    IF lv_guid_header IS NOT INITIAL.
*    OR lt_param       IS NOT INITIAL.
*
*      me->read_status(
*          EXPORTING
*             iv_guid  = COND #( WHEN lv_guid_header IS INITIAL THEN iv_guid
*                                                               ELSE lv_guid_header )
*           IMPORTING
*             et_hdsta = DATA(lt_hdsta) ).
*
*      IF sy-subrc EQ 0.

    IF sy-cprog EQ gc_values-report.

      DATA(ls_hsdta) = VALUE #( ct_hdsta[ procstep = COND #( WHEN iv_step = gc_values-stocktrf THEN gc_values-grstopst
                                                             WHEN iv_step = gc_values-normprch THEN gc_values-grpostng ) ] OPTIONAL ).

      IF ls_hsdta IS NOT INITIAL.

        ls_hsdta-autoproc = gc_values-a.

        me->modifica_status( EXPORTING is_status = ls_hsdta ).
        me->save_status( ).

        ct_hdsta[ procstep = COND #( WHEN iv_step = gc_values-stocktrf THEN gc_values-grstopst
                                     WHEN iv_step = gc_values-normprch THEN gc_values-grpostng ) ] = ls_hsdta.

      ENDIF.

    ELSE.

      DO 4 TIMES.

        ls_hsdta       = VALUE #( ct_hdsta[ procstep = COND #(   WHEN sy-index EQ 1 THEN gc_values-grconfqu
                                                                 WHEN sy-index EQ 2 THEN gc_values-grfichck
                                                                 WHEN sy-index EQ 3 THEN gc_values-grmmchck
                                                                 WHEN sy-index EQ 4 THEN COND #( WHEN iv_step = gc_values-stocktrf THEN gc_values-grstopst
                                                                                                 WHEN iv_step = gc_values-normprch THEN gc_values-grpostng )
                                                           ) ] OPTIONAL ).

        IF ls_hsdta IS NOT INITIAL.

          IF sy-index EQ 4.
            ls_hsdta-autoproc = abap_false.
          ELSE.
            ls_hsdta-deactiv  = abap_true.
          ENDIF.

          me->modifica_status( EXPORTING is_status = ls_hsdta ).
          me->save_status( ).

          ct_hdsta[ procstep = COND #( WHEN sy-index EQ 1 THEN gc_values-grconfqu
                                       WHEN sy-index EQ 2 THEN gc_values-grfichck
                                       WHEN sy-index EQ 3 THEN gc_values-grmmchck
                                       WHEN sy-index EQ 4 THEN COND #( WHEN iv_step = gc_values-stocktrf THEN gc_values-grstopst
                                                                       WHEN iv_step = gc_values-normprch THEN gc_values-grpostng )
                                        ) ] = ls_hsdta.

          CLEAR: ls_hsdta.

        ENDIF.
      ENDDO.

    ENDIF.


*      ENDIF.

*      ct_hdsta[] = lt_hdsta[].

*    ENDIF.

  ENDMETHOD.


  METHOD read_status.

    CALL FUNCTION '/XNFE/B2BNFE_READ'
      EXPORTING
        iv_guid_header     = iv_guid
        with_enqueue       = abap_true
      IMPORTING
        et_hdsta           = et_hdsta
      EXCEPTIONS
        nfe_does_not_exist = 1
        nfe_locked         = 2
        technical_error    = 3
        OTHERS             = 4.

    IF sy-subrc IS INITIAL.
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1
*                                                             sy-msgv2
*                                                             sy-msgv3
*                                                             sy-msgv4.
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD save_status.

    CALL FUNCTION '/XNFE/B2BNFE_DB_UPDATE'
      EXPORTING
*       wo_dequeue = abap_false
        wo_dequeue = abap_true
      EXCEPTIONS
        db_error   = 1
        OTHERS     = 2.

    IF sy-subrc IS INITIAL.
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1
*                                                             sy-msgv2
*                                                             sy-msgv3
*                                                             sy-msgv4.
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD conv_mat.

    UNPACK is_material TO rv_result.

  ENDMETHOD.


  METHOD validar_pedido.

    DATA: lr_bsart TYPE RANGE OF bsart.

    CHECK iv_ebeln IS NOT INITIAL.

    TRY.
        NEW zclca_tabela_parametros( )->m_get_range(
                               EXPORTING
                                 iv_modulo = gc_values-mm
                                 iv_chave1 = gc_values-dep_fech
                                 iv_chave2 = gc_values-saga
                                 iv_chave3 = gc_values-bsart
                               IMPORTING
                                 et_range  = lr_bsart ).

      CATCH zcxca_tabela_parametros.
    ENDTRY.

    IF lr_bsart IS NOT INITIAL.

      SELECT SINGLE bsart
        FROM ekko
       WHERE ebeln EQ @iv_ebeln
         AND bsart IN @lr_bsart
        INTO @DATA(lv_resul).

      IF sy-subrc EQ 0.
        rv_ok = abap_true.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD validar_env_saga.

    DATA: lr_werks TYPE RANGE OF werks_d,
          lr_lgort TYPE RANGE OF lgort_d.

    SELECT SINGLE matnr,
                  mtart
      FROM mara
     WHERE matnr = @is_key-matnr
      INTO @DATA(ls_mara).

    IF sy-subrc IS INITIAL.

      IF ls_mara-mtart = gc_mtart-fert
      OR ls_mara-mtart = gc_mtart-hawa
      OR ls_mara-mtart = gc_mtart-zpro
      OR ls_mara-mtart = gc_mtart-ztre.

        SELECT SINGLE ebeln,
                      ebelp,
                      werks,
                      lgort
          FROM ekpo
         WHERE ebeln = @is_key-ponumber
           AND ebelp = @is_key-poitem
          INTO @DATA(ls_ekpo).

        IF sy-subrc IS INITIAL.

          DATA(lo_object) = NEW zclca_tabela_parametros( ).

          TRY.
              lo_object->m_get_range( EXPORTING iv_modulo = gc_param-modulo
                                                iv_chave1 = gc_param-chav1_int
                                                iv_chave2 = gc_param-chav2_saga
                                                iv_chave3 = gc_param-chav3_werks
                                      IMPORTING et_range  = lr_werks ).

              lo_object->m_get_range( EXPORTING iv_modulo = gc_param-modulo
                                                iv_chave1 = gc_param-chav1_int
                                                iv_chave2 = gc_param-chav2_saga
                                                iv_chave3 = gc_param-chav3_lgort
                                      IMPORTING et_range  = lr_lgort ).
            CATCH zcxca_tabela_parametros. " Classe de exceção Tabela de Parâmetros
          ENDTRY.

          IF lr_werks      IS NOT INITIAL
         AND lr_lgort      IS NOT INITIAL
         AND ls_ekpo-werks IN lr_werks
         AND ls_ekpo-lgort IN lr_lgort.
            rv_ok = abap_true.
          ENDIF.

        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
