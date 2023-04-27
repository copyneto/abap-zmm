class ZCLMM_DOCUMENT_POST definition
  public
  final
  create public .

public section.

  "! Construtor
  methods CONSTRUCTOR .
    "! Processamento principal
    "! @parameter ev_obj_key | Documento
    "! @parameter et_return | Retorno
    "! @parameter cs_document | Dados de processamento
  methods PROCESS
    exporting
      !ET_RETURN type BAPIRET2_TAB
      !EV_OBJ_KEY type BAPIACHE09-OBJ_KEY
    changing
      !CS_DOCUMENT type ZTMM_MOV_CNTRL .
PROTECTED SECTION.
PRIVATE SECTION.

  TYPES:
    BEGIN OF ty_material,
      matnr TYPE mara-matnr,
      matkl TYPE mara-matkl,
      maktx TYPE makt-maktx,
      steuc TYPE marc-steuc,
      mtorg TYPE mbew-mtorg,
      mtuse TYPE mbew-mtuse,
      meins TYPE mara-meins,
    END OF ty_material .
  TYPES:
    BEGIN OF ty_lei_fiscal,
      taxlaw TYPE j_1btaxlw2,
      taxsit TYPE j_1btaxsi2in,
    END OF ty_lei_fiscal .

  CONSTANTS:
    "! Constantes
    BEGIN OF gc_data,
      fixo_03              TYPE char2                   VALUE '03',
      fixo_221             TYPE char3                   VALUE '221',
      ok                   TYPE char1                   VALUE 'S',
      erro                 TYPE char1                   VALUE 'E',
      fixo_ig              TYPE char2                   VALUE 'IG',
      doctyp_1             TYPE j_1bnfdoc-doctyp        VALUE '1',
      direct_2             TYPE j_1bnfdoc-direct        VALUE '2',
      model                TYPE j_1bnfdoc-model         VALUE '55',
      waerk                TYPE j_1bnfdoc-waerk         VALUE 'BRL',
      parvw                TYPE j_1bnfdoc-parvw         VALUE 'AG',
      partyp               TYPE j_1bnfdoc-partyp        VALUE 'C',
      inco1                TYPE j_1bnfdoc-inco1         VALUE 'SRF',
      inco2                TYPE j_1bnfdoc-inco2         VALUE 'SRF',
      fixo_2               TYPE char1                   VALUE '2',
      fixo_1               TYPE char1                   VALUE '1',
      vazio                TYPE char1                   VALUE '',
      tax_ICM3             TYPE j_1btaxtyp              VALUE 'ICM3',
      item                 TYPE bapi_j_1bnflin-itmnum   VALUE '000010',
      doc_type_wa          TYPE blart                   VALUE 'WA',
      fixo_SP              TYPE char2                   VALUE 'SP',
      item_acc01           TYPE bapiacgl09-itemno_acc   VALUE '0000000001',
      fixo_GBB             TYPE t030-ktosl              VALUE 'GBB',
      fixo_PC3C            TYPE t001-ktopl              VALUE 'PC3C',
      fixo_VBR             TYPE t030-komok              VALUE 'VBR',
      modulo               TYPE ztca_param_par-modulo   VALUE 'MM',
      chave1               TYPE ztca_param_par-chave1   VALUE 'MONITOR_IMOBILIZACAO',
      chave2_icms_recolher TYPE ztca_param_par-chave2   VALUE 'ICMS_RECOLHER',
      chave3_cont_icms     TYPE ztca_param_par-chave3   VALUE 'CONT_ICM',
      chave2_pis_recuperar TYPE ztca_param_par-chave2   VALUE 'PIS_RECUPERAR',
      chave3_cont_pis      TYPE ztca_param_par-chave3   VALUE 'CONT_PIS',
      chave2_cof_recuperar TYPE ztca_param_par-chave2   VALUE 'COFINS_RECUPERAR',
      chave3_cont_cof      TYPE ztca_param_par-chave3   VALUE 'CONT_COF',
      chave2_ipi_recolher  TYPE ztca_param_par-chave2   VALUE 'IPI_RECOLHER',
      chave3_cont_ipi      TYPE ztca_param_par-chave3   VALUE 'CONT_IPI',
    END OF gc_data .
  "! Retorno
  DATA gt_return TYPE bapiret2_tab .
  "! Parametros
  DATA gt_param  TYPE TABLE OF ztmm_mov_param .
  "! Conta ICMS
  DATA gv_conta_icms TYPE hkont .
  "! Conta PIS
  DATA gv_conta_pis TYPE hkont .
  "! Conta Cofins
  DATA gv_conta_cof TYPE hkont .
  "! Conta IPI
  DATA gv_conta_ipi TYPE hkont .

  "! Atribuir item
  "! @parameter is_doc | Dados de processamento
  "! @parameter is_msg | Mensagem
  METHODS set_message
    IMPORTING
      !is_doc TYPE ztmm_mov_cntrl
      !is_msg TYPE bapiret2 .
  "! Commit
  METHODS commit_work .
  "! Rollback
  METHODS rollback .

  "! Atualizar dados
  "! @parameter is_doc | Dados de processamento
  METHODS update_table
    IMPORTING
      !is_doc TYPE ztmm_mov_cntrl .
  "! Buscar impostos
  "! @parameter iv_id |Id de processamento
  "! @parameter rs_taxes| Impostos
  METHODS get_taxes
    IMPORTING
      !iv_id          TYPE ztmm_mov_cntrl-id
    RETURNING
      VALUE(rs_taxes) TYPE ztmm_mov_simul .
  "! Atribuir account
  "! @parameter is_document | Dados de processamento
  "! @parameter rt_accountgl | Account
  METHODS set_accountgl
    IMPORTING
      !is_document        TYPE ztmm_mov_cntrl
    RETURNING
      VALUE(rt_accountgl) TYPE bapiacgl09_tab .
  "! Atribuir item account
  "! @parameter cv_item | Item
  "! @parameter rv_item | Item novo
  METHODS set_item_acc
    CHANGING
      !cv_item       TYPE bapiacgl09-itemno_acc
    RETURNING
      VALUE(rv_item) TYPE bapiacgl09-itemno_acc .
  "! Atribuir conta
  "! @parameter is_document | Dados de processamento
  "! @parameter rv_conta | Conta
  METHODS set_conta
    IMPORTING
      !is_document    TYPE ztmm_mov_cntrl
    RETURNING
      VALUE(rv_conta) TYPE hkont .
  "! Atribuir item texto
  "! @parameter iv_docnum | Docnum
  "! @parameter rv_text | Texto
  METHODS set_item_text
    IMPORTING
      !iv_docnum     TYPE ztmm_mov_cntrl-docnum_s
    RETURNING
      VALUE(rv_text) TYPE sgtxt .
  "! Atribuir área de neg.
  "! @parameter iv_werks | Centro
  "! @parameter rv_bus_area | Área de neg.
  METHODS set_bus_area
    IMPORTING
      !iv_werks          TYPE ztmm_mov_cntrl-werks
    RETURNING
      VALUE(rv_bus_area) TYPE t134g-gsber .
  "! Buscar parametros
  METHODS get_tab_param .
  "! Atribuir centro
  "! @parameter is_document | Dados de processamento
  "! @parameter rv_clucro | Centro de lucro
  METHODS set_centro_lucro
    IMPORTING
      !is_document     TYPE ztmm_mov_cntrl
    RETURNING
      VALUE(rv_clucro) TYPE prctr .
  "! Atribuir valor
  "! @parameter is_document | Dados de processamento
  "! @parameter rt_amount | Valor
  METHODS set_amount
    IMPORTING
      !is_document     TYPE ztmm_mov_cntrl
    RETURNING
      VALUE(rt_amount) TYPE bapiaccr09_tab .
  "! Executar BAPI
  "! @parameter ev_obj_key | Doc. gerado
  "! @parameter et_retunr | Tabela de retorno
  "! @parameter  cs_header     | Header
  "! @parameter  ct_accountgl | Account
  "! @parameter  ct_amount    | Valor
  "! @parameter  cs_document    | Dados de processamento
  METHODS call_bapi
    EXPORTING
      !et_retunr    TYPE bapiret2_tab
      !ev_obj_key   TYPE bapiache09-obj_key
    CHANGING
      !cs_header    TYPE bapiache09
      !ct_accountgl TYPE bapiacgl09_tab
      !ct_amount    TYPE bapiaccr09_tab
      !cs_document  TYPE ztmm_mov_cntrl .
  "! Atribuir ICMS
  METHODS set_icms .
  "! Atribuir PIS
  METHODS set_pis .
  "! Atribuir Cofins
  METHODS set_cof .
  "! Atribuir IPI
  METHODS set_ipi .
  "! Atribuir header
  "! @parameter is_document | Dados de processamento
  "! @parameter rs_header | Header
  METHODS set_header
    IMPORTING
      is_document      TYPE ztmm_mov_cntrl
    RETURNING
      VALUE(rs_header) TYPE bapiache09 .
  "! Buscar parametros
  METHODS get_param.

ENDCLASS.



CLASS ZCLMM_DOCUMENT_POST IMPLEMENTATION.


  METHOD UPDATE_TABLE.

    DATA ls_update TYPE ztmm_mov_cntrl.

    ls_update = CORRESPONDING #( is_doc ).

    MODIFY ztmm_mov_cntrl FROM ls_update.

  ENDMETHOD.


  METHOD set_pis.

      DATA(lo_param) = NEW zclca_tabela_parametros( ).

      TRY.
          lo_param->m_get_single(
            EXPORTING
              iv_modulo = gc_data-modulo
              iv_chave1 = gc_data-chave1
              iv_chave2 = gc_data-chave2_pis_recuperar
              iv_chave3 = gc_data-chave3_cont_pis
            IMPORTING
              ev_param  = gv_conta_pis
          ).
        CATCH zcxca_tabela_parametros.

      ENDTRY.

  ENDMETHOD.


  METHOD SET_MESSAGE.

    DATA ls_message TYPE bapiret2.

    ls_message-type        = is_msg-type.
    ls_message-id          = is_msg-id.
    ls_message-number      = is_msg-number.
    ls_message-message_v1  = is_msg-message_v1.
    ls_message-message_v2  = is_msg-message_v2.
    ls_message-message_v3  = is_msg-message_v3.
    ls_message-message_v4  = is_msg-message_v4.

    MESSAGE   ID        ls_message-id
              TYPE      ls_message-type
              NUMBER    ls_message-number
              WITH      ls_message-message_v1
                        ls_message-message_v2
                        ls_message-message_v3
                        ls_message-message_v4
              INTO      ls_message-message.

    APPEND ls_message TO gt_return.

  ENDMETHOD.


  METHOD set_item_text.

    rv_text = |{ TEXT-001 }| && space && | { iv_docnum  } |.

  ENDMETHOD.


  METHOD set_item_acc.

    ADD 1 TO cv_item.

    rv_item = cv_item.

  ENDMETHOD.


  METHOD set_ipi.

    DATA(lo_param) = NEW zclca_tabela_parametros( ).

    TRY.
        lo_param->m_get_single(
          EXPORTING
            iv_modulo = gc_data-modulo
            iv_chave1 = gc_data-chave1
            iv_chave2 = gc_data-chave2_ipi_recolher
            iv_chave3 = gc_data-chave3_cont_ipi
          IMPORTING
            ev_param  = gv_conta_ipi
        ).
      CATCH zcxca_tabela_parametros.

    ENDTRY.

  ENDMETHOD.


  METHOD set_icms.

    DATA(lo_param) = NEW zclca_tabela_parametros( ).

    TRY.
        lo_param->m_get_single(
          EXPORTING
            iv_modulo = gc_data-modulo
            iv_chave1 = gc_data-chave1
            iv_chave2 = gc_data-chave2_icms_recolher
            iv_chave3 = gc_data-chave3_cont_icms
          IMPORTING
            ev_param  = gv_conta_icms
        ).
      CATCH zcxca_tabela_parametros.

    ENDTRY.

  ENDMETHOD.


  METHOD set_header.

    rs_header = VALUE #(
                    username    = sy-uname
                    comp_code   = is_document-bukrs "|{ is_document-werks ALPHA = IN }|
                    doc_date    = sy-datum
                    pstng_date  = sy-datum
                    doc_type    = gc_data-doc_type_wa
                    ref_doc_no  = gc_data-fixo_sp && |{ is_document-docnum_s ALPHA = IN }|

                         ).

  ENDMETHOD.


  METHOD set_conta.

    SELECT SINGLE d~konts
       FROM mbew AS a
       INNER JOIN t001k AS b
       ON a~bwkey = b~bwkey
       INNER JOIN t001 AS c
       ON b~bukrs = c~bukrs
       AND c~ktopl = gc_data-fixo_pc3c
       INNER JOIN t030 AS d "#EC CI_BUFFJOIN
       ON d~bklas = a~bklas
       AND d~ktopl = c~ktopl
       AND d~ktosl = gc_data-fixo_gbb
       and d~komok = gc_data-fixo_vbr
     INTO rv_conta
    WHERE a~matnr = is_document-matnr1
      AND b~bwkey = is_document-werks
      AND c~bukrs = is_document-bukrs.


  ENDMETHOD.


  METHOD set_cof.

      DATA(lo_param) = NEW zclca_tabela_parametros( ).

      TRY.
          lo_param->m_get_single(
            EXPORTING
              iv_modulo = gc_data-modulo
              iv_chave1 = gc_data-chave1
              iv_chave2 = gc_data-chave2_cof_recuperar
              iv_chave3 = gc_data-chave3_cont_cof
            IMPORTING
              ev_param  = gv_conta_cof
          ).
        CATCH zcxca_tabela_parametros.

      ENDTRY.

  ENDMETHOD.


  METHOD set_centro_lucro.

    SELECT SINGLE prctr
    FROM marc
    INTO rv_clucro
    WHERE matnr = is_document-matnr1
      AND werks = is_document-werks.

  ENDMETHOD.


  METHOD set_bus_area.

    SELECT SINGLE gsber
      FROM t134g
      INTO rv_bus_area
     WHERE werks = iv_werks.

  ENDMETHOD.


  METHOD set_amount.

    DATA lv_item TYPE bapiacgl09-itemno_acc.

    DATA(ls_taxes) = get_taxes( iv_id = is_document-id ).


*   item 1
    APPEND VALUE #(
        itemno_acc      = set_item_acc( CHANGING cv_item = lv_item )
        currency        = gc_data-waerk
        amt_doccur      = ls_taxes-taxval_bx13
      ) TO rt_amount.

*   item 2
    APPEND VALUE #(
        itemno_acc      = set_item_acc( CHANGING cv_item = lv_item )
        currency        = gc_data-waerk
        amt_doccur      = ls_taxes-taxval_bx13 * - 1
      ) TO rt_amount.

*   item 3
    APPEND VALUE #(
        itemno_acc      = set_item_acc( CHANGING cv_item = lv_item )
        currency        = gc_data-waerk
        amt_doccur      = ls_taxes-taxval_bx82
      ) TO rt_amount.

*   item 4
    APPEND VALUE #(
        itemno_acc      = set_item_acc( CHANGING cv_item = lv_item )
        currency        = gc_data-waerk
        amt_doccur      = ls_taxes-taxval_bx82 * - 1
      ) TO rt_amount.


*   item 5
    APPEND VALUE #(
        itemno_acc      = set_item_acc( CHANGING cv_item = lv_item )
        currency        = gc_data-waerk
        amt_doccur      = ls_taxes-taxval_bx72
      ) TO rt_amount.


*   item 6
    APPEND VALUE #(
        itemno_acc      = set_item_acc( CHANGING cv_item = lv_item )
        currency        = gc_data-waerk
        amt_doccur      = ls_taxes-taxval_bx72 * - 1
      ) TO rt_amount.

*   item 7
    APPEND VALUE #(
        itemno_acc      = set_item_acc( CHANGING cv_item = lv_item )
        currency        = gc_data-waerk
        amt_doccur      = ls_taxes-taxval_bx23
      ) TO rt_amount.


*   item 8
    APPEND VALUE #(
        itemno_acc      = set_item_acc( CHANGING cv_item = lv_item )
        currency        = gc_data-waerk
        amt_doccur      = ls_taxes-taxval_bx23 * - 1
      ) TO rt_amount.


  ENDMETHOD.


  METHOD set_accountgl.

    DATA lv_item TYPE bapiacgl09-itemno_acc.

    DATA(lv_conta)      = set_conta( is_document ).
    DATA(lv_text)       = set_item_text( is_document-docnum_s ).
    data(lv_bus_area)   = set_bus_area( is_document-werks ).
    data(lv_clucro)     = set_centro_lucro( is_document ).


*   item 1
    APPEND VALUE #(
        itemno_acc      = set_item_acc( CHANGING cv_item = lv_item )
        gl_account      = lv_conta
        item_text       = lv_text
        bus_area        = lv_bus_area
        wbs_element     = is_document-posid
      ) TO rt_accountgl.

*   item 2
    APPEND VALUE #(
        itemno_acc      = set_item_acc( CHANGING cv_item = lv_item )
        gl_account      = gv_conta_icms
        item_text       = lv_text
        bus_area        = lv_bus_area
        profit_ctr      = lv_clucro
      ) TO rt_accountgl.

*   item 3
    APPEND VALUE #(
        itemno_acc      = set_item_acc( CHANGING cv_item = lv_item )
        gl_account      = lv_conta
        item_text       = lv_text
        bus_area        = lv_bus_area
        wbs_element     = is_document-posid
      ) TO rt_accountgl.

*   item 4
    APPEND VALUE #(
        itemno_acc      = set_item_acc( CHANGING cv_item = lv_item )
        gl_account      = gv_conta_pis
        item_text       = lv_text
        bus_area        = lv_bus_area
        profit_ctr      = lv_clucro
      ) TO rt_accountgl.


*   item 5
    APPEND VALUE #(
        itemno_acc      = set_item_acc( CHANGING cv_item = lv_item )
        gl_account      = lv_conta
        item_text       = lv_text
        bus_area        = lv_bus_area
        wbs_element     = is_document-posid
      ) TO rt_accountgl.

*   item 6
    APPEND VALUE #(
        itemno_acc      = set_item_acc( CHANGING cv_item = lv_item )
        gl_account      = gv_conta_cof
        item_text       = lv_text
        bus_area        = lv_bus_area
        profit_ctr      = lv_clucro
      ) TO rt_accountgl.

*   item 7
    APPEND VALUE #(
        itemno_acc      = set_item_acc( CHANGING cv_item = lv_item )
        gl_account      = lv_conta
        item_text       = lv_text
        bus_area        = lv_bus_area
        wbs_element     = is_document-posid
      ) TO rt_accountgl.

*   item 8
    APPEND VALUE #(
        itemno_acc      = set_item_acc( CHANGING cv_item = lv_item )
        gl_account      = gv_conta_ipi
        item_text       = lv_text
        bus_area        = lv_bus_area
        profit_ctr      = lv_clucro
      ) TO rt_accountgl.

  ENDMETHOD.


  METHOD ROLLBACK.

    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

  ENDMETHOD.


  METHOD process.

    get_param( ).

    DATA(ls_header)     = set_header( cs_document ).

    DATA(lt_accountgl)  = set_accountgl( cs_document ).

    DATA(lt_amount)     = set_amount( cs_document ).


    call_bapi(  IMPORTING
                    et_retunr       = et_return
                    ev_obj_key      = ev_obj_key
                CHANGING
                    cs_header       = ls_header
                    ct_accountgl    = lt_accountgl
                    ct_amount       = lt_amount
                    cs_document = cs_document
    ).

  ENDMETHOD.


  METHOD get_taxes.

    SELECT SINGLE * "#EC CI_ALL_FIELDS_NEEDED
    FROM ztmm_mov_simul
    INTO rs_taxes
    WHERE id = iv_id.


  ENDMETHOD.


  METHOD get_tab_param.

    set_icms( ).

    set_pis( ).

    set_cof( ).

    set_ipi( ).

  ENDMETHOD.


METHOD constructor.

    get_tab_param( ).


ENDMETHOD.


  METHOD commit_work.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.


  ENDMETHOD.


  METHOD call_bapi.


    CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
      EXPORTING
        documentheader = cs_header
      IMPORTING
        obj_key        = ev_obj_key
      TABLES
        accountgl      = ct_accountgl
        currencyamount = ct_amount
        return         = gt_return.

    READ TABLE gt_return ASSIGNING FIELD-SYMBOL(<fs_line>) WITH KEY type = gc_data-erro. "#EC CI_STDSEQ

    IF sy-subrc <> 0.

      cs_document-belnr     = ev_obj_key(10).
      cs_document-gjahr_dc  = ev_obj_key+14(4).
      cs_document-bukrs_dc  = cs_document-bukrs.
      CLEAR: cs_document-belnr_est,
             cs_document-gjahr_est,
             cs_document-bldat_est.

      set_message( is_doc   = cs_document
                   is_msg   = VALUE #( type       = gc_data-ok
                                       id         = 'ZMM_BENS_CONSUMO'
                                       number     = '008'
                                       message_v1 = cs_document-belnr
                                       message_v2 = cs_document-gjahr_dc ) ).

      update_table( cs_document ).

      commit_work( ).

    ELSE.

      set_message( is_doc   = cs_document
               is_msg   = VALUE #( type       = gc_data-erro
                                   id         = 'ZMM_BENS_CONSUMO'
                                   number     = '009'
                                    ) ).
      rollback( ).

    ENDIF.

    et_retunr = gt_return.

  ENDMETHOD.


  METHOD get_param.

    SELECT *
      FROM ztmm_mov_param
      INTO TABLE gt_param
     WHERE direcao = gc_data-fixo_2.

  ENDMETHOD.
ENDCLASS.
