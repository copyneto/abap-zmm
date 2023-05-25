"!<p><h1>Cockpit de Invent�rio</h1></p>
"!<p><strong>Autor:</strong>Jong Wan Silva</p>
"!<p><strong>Data:</strong>01 de Outubro de 2021</p>
"!<p><strong>Descri��o:</strong>Classe para gerenciar funcionalidades do Cockpit de Invent�rio</p>
CLASS zclmm_inventario DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_stock,
        material                     TYPE i_materialstock-material,
        plant                        TYPE i_materialstock-plant,
        batch                        TYPE i_materialstock-batch,
        storagelocation              TYPE i_materialstock-storagelocation,
        matldoclatestpostgdate       TYPE i_materialstock-matldoclatestpostgdate,
        matlwrhsstkqtyinmatlbaseunit TYPE i_materialstock-matlwrhsstkqtyinmatlbaseunit,
        materialname                 TYPE i_materialtext-materialname,
      END OF ty_stock .
    TYPES:
      ty_t_stock TYPE SORTED TABLE OF ty_stock
                   WITH NON-UNIQUE KEY material plant batch storagelocation matldoclatestpostgdate .
    TYPES:
      BEGIN OF ty_price,
        material             TYPE i_currentmatlpricebycostest-material,
        valuationarea        TYPE i_currentmatlpricebycostest-valuationarea,
        costestimate         TYPE i_currentmatlpricebycostest-costestimate,
        currency             TYPE i_currentmatlpricebycostest-currency,
        materialpriceunitqty TYPE i_currentmatlpricebycostest-materialpriceunitqty,
        inventoryprice       TYPE i_currentmatlpricebycostest-inventoryprice,
      END OF ty_price .
    TYPES:
      ty_t_price TYPE SORTED TABLE OF ty_price
                   WITH NON-UNIQUE KEY material valuationarea .
    TYPES:
      BEGIN OF ty_material,
        material            TYPE mara-matnr,
        materialgrossweight TYPE mara-brgew,
        materialweightunit  TYPE mara-gewei,
        producthierarchy    TYPE mara-prdha,
      END OF ty_material .
    TYPES:
      ty_t_material TYPE SORTED TABLE OF ty_material
                      WITH NON-UNIQUE KEY material .
    TYPES ty_cds_header TYPE zi_mm_inventario_h .
    TYPES ty_cds_item TYPE zi_mm_inventario_item .
    TYPES:
      ty_t_cds_item TYPE STANDARD TABLE OF ty_cds_item .

    "! Realiza carga de arquivo
    "! @parameter iv_filename | Nome do arquivo
    "! @parameter is_media | Arquivo enviado
    "! @parameter es_header | Dados de cabe�alho
    "! @parameter et_item | Dados de item
    "! @parameter et_return | Mensagens de retorno
    METHODS upload
      IMPORTING
        iv_excel    TYPE flag OPTIONAL
        iv_filename TYPE string
        is_media    TYPE /iwbep/if_mgw_appl_srv_runtime=>ty_s_media_resource
      EXPORTING
        es_header   TYPE ztmm_inventory_h
        et_item     TYPE zctgmm_inventory_i
        et_return   TYPE bapiret2_t .
    "! Valida dados dentro do arquivo de carga
    "! @parameter it_file | Arquivo de entrada
    "! @parameter et_return | Mensagens de retorno
    METHODS validate_data
      IMPORTING
        !it_file   TYPE zctgmm_inventory_file
      EXPORTING
        !et_return TYPE bapiret2_t .
    "! Prepara dados de cabe�alho para upload
    "! @parameter it_file | Arquivo de entrada
    "! @parameter es_header | Dados de cabe�alho
    "! @parameter et_return | Mensagens de retorno
    METHODS upload_create_header
      IMPORTING
        !iv_excel  TYPE flag
        !it_file   TYPE zctgmm_inventory_file
      EXPORTING
        !es_header TYPE ztmm_inventory_h
        !et_return TYPE bapiret2_t .
    "! Prepara dados de item para upload
    "! @parameter it_file | Arquivo de entrada
    "! @parameter is_header | Dados de cabe�alho
    "! @parameter it_material | Dados de material
    "! @parameter it_stock | Dados de estoque
    "! @parameter it_price | Dados de pre�o
    "! @parameter et_item | Dados de item
    "! @parameter et_return | Mensagens de retorno
    METHODS upload_create_item
      IMPORTING
        !it_file     TYPE zctgmm_inventory_file
        !is_header   TYPE ztmm_inventory_h
        !it_material TYPE ty_t_material
        !it_stock    TYPE ty_t_stock
        !it_price    TYPE ty_t_price
      EXPORTING
        !et_item     TYPE zctgmm_inventory_i
        !et_return   TYPE bapiret2_t .
    "! Processa um item de invent�rio
    "! @parameter it_material | Dados de material
    "! @parameter it_stock | Dados de estoque
    "! @parameter it_price | Dados de pre�o
    "! @parameter cs_item | Dados de item
    METHODS process_item
      IMPORTING
        !is_header   TYPE ztmm_inventory_h
        !it_material TYPE ty_t_material
        !it_stock    TYPE ty_t_stock
        !it_price    TYPE ty_t_price
      CHANGING
        !cs_item     TYPE ztmm_inventory_i .
    "! Salva registro
    "! @parameter is_header | Dados de cabe�alho
    "! @parameter it_item | Dados de item
    "! @parameter et_return | Mensagens de retorno
    METHODS upload_save
      IMPORTING
        !is_header TYPE ztmm_inventory_h OPTIONAL
        !it_item   TYPE zctgmm_inventory_i OPTIONAL
      EXPORTING
        !et_return TYPE bapiret2_t .
    "! Chamado durante Determina��o da CDS para atualizar os valores
    "! @parameter ct_cds_item | Dados de item
    "! @parameter et_return | Mensagens de retorno
    METHODS determination_update
      IMPORTING
        !is_cds_header TYPE ty_cds_header
      EXPORTING
        !et_return     TYPE bapiret2_t
      CHANGING
        !ct_cds_item   TYPE ty_t_cds_item .
    "! Cancela documento
    "! @parameter iv_documentid | ID do documento
    "! @parameter et_return | Mensagens de retorno
    METHODS cancel
      IMPORTING
        !iv_documentid TYPE ztmm_inventory_h-documentid
      EXPORTING
        !et_return     TYPE bapiret2_t .
    "! Inicia o processo de libera��o
    "! @parameter iv_documentid | ID do documento
    "! @parameter et_return | Mensagens de retorno
    METHODS release
      IMPORTING
        !iv_documentid TYPE ztmm_inventory_h-documentid
      EXPORTING
        !et_return     TYPE bapiret2_t .
    "! Cria documento de invent�rio e contagem
    "! @parameter iv_documentid | ID do documento
    "! @parameter et_return | Mensagens de retorno
    METHODS release_start
      IMPORTING
        !iv_documentid TYPE ztmm_inventory_h-documentid
      EXPORTING
        !et_return     TYPE bapiret2_t .
    "! Recebe mensagens geradas pelo processamento em background
    "! @parameter p_task |Noma da task executada
    METHODS release_return
      IMPORTING
        !p_task TYPE clike .
    "! Salva mensagens geradas durante processo
    "! @parameter iv_documentid | ID do documento
    "! @parameter ct_return | Mensagens de retorno
    METHODS save_log
      IMPORTING
        !iv_documentid TYPE ztmm_inventory_h-documentid
      CHANGING
        !ct_return     TYPE bapiret2_t .
    "! Formata as mensages de retorno
    "! @parameter ct_return | Mensagens de retorno
    METHODS format_return
      CHANGING
        !ct_return TYPE bapiret2_t .

    METHODS process_file
      IMPORTING
        iv_excel  TYPE flag OPTIONAL
        it_file   TYPE zctgmm_inventory_file
      EXPORTING
        es_header TYPE ztmm_inventory_h
        et_item   TYPE zctgmm_inventory_i
        et_return TYPE bapiret2_t.

  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-DATA:
      "!Mensagens de retorno para processamento em background
      gt_return     TYPE bapiret2_t,

      "!Flag de sincroniza��o para processamento em background
      gv_wait_async TYPE abap_bool.

    "! Recupera pr�ximo n�mero GUID
    "! @parameter ev_guid | N�mero GUID
    "! @parameter et_return | Mensagens de retorno
    "! @parameter rv_guid | N�mero GUID
    METHODS get_next_guid
      EXPORTING ev_guid        TYPE sysuuid_x16
                et_return      TYPE bapiret2_t
      RETURNING VALUE(rv_guid) TYPE sysuuid_x16.

    "! Recupera pr�ximo N�mero de documento
    "! @parameter ev_documentno | N�mero do documento
    "! @parameter et_return | Mensagens de retorno
    "! @parameter rv_documentno | N�mero do documento
    METHODS get_next_documentno
      EXPORTING ev_documentno        TYPE ztmm_inventory_h-documentno
                et_return            TYPE bapiret2_t
      RETURNING VALUE(rv_documentno) TYPE ztmm_inventory_h-documentno.

    "! Recupera dados para cria��o dos registros
    "! @parameter it_file | Arquivo de entrada
    "! @parameter et_material | Dados de material
    "! @parameter et_stock | Dados de estoque
    "! @parameter et_price | Dados de pre�o
    METHODS select_data
      IMPORTING it_file     TYPE zctgmm_inventory_file
      EXPORTING et_material TYPE ty_t_material
                et_stock    TYPE ty_t_stock
                et_price    TYPE ty_t_price.

ENDCLASS.



CLASS zclmm_inventario IMPLEMENTATION.


  METHOD cancel.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Recupera documento
* ---------------------------------------------------------------------------
    SELECT SINGLE documentid, documentno, status
        FROM ztmm_inventory_h
        INTO @DATA(ls_header)
        WHERE documentid EQ @iv_documentid.

* ---------------------------------------------------------------------------
* Aplica valida��es
* ---------------------------------------------------------------------------
    IF sy-subrc NE 0.
      " Documento n�o encontrado.
      et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_INVENTARIO' number = '001' ) ).
      RETURN.
    ENDIF.

    IF ls_header-status EQ gc_status-cancelado.
      " Documento j� foi cancelado.
      et_return[] = VALUE #( BASE et_return ( type = 'W' id = 'ZMM_INVENTARIO' number = '002' message_v1 = |{ ls_header-documentno ALPHA = OUT }| ) ).
      RETURN.
    ENDIF.

    IF ls_header-status EQ gc_status-liberado.
      " Documento liberado, n�o � poss�vel cancelar.
      et_return[] = VALUE #( BASE et_return ( type = 'W' id = 'ZMM_INVENTARIO' number = '003' message_v1 = |{ ls_header-documentno ALPHA = OUT }| ) ).
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Atualiza status para cancelado
* ---------------------------------------------------------------------------
    UPDATE ztmm_inventory_h
        SET status = gc_status-cancelado
        WHERE documentid EQ iv_documentid.

    IF sy-subrc EQ 0.
      " Falha ao atualizar documento.
      et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_INVENTARIO' number = '004' message_v1 = |{ ls_header-documentno ALPHA = OUT }| ) ).
      RETURN.
    ELSE.
      " Documento cancelado.
      et_return[] = VALUE #( BASE et_return ( type = 'S' id = 'ZMM_INVENTARIO' number = '005' message_v1 = |{ ls_header-documentno ALPHA = OUT }| ) ).
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD release.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Recupera cabe�alho do documento
* ---------------------------------------------------------------------------
    SELECT SINGLE COUNT(*)
        FROM ztmm_inventory_h
        WHERE documentid EQ @iv_documentid.          "#EC CI_SEL_NESTED

    IF sy-subrc NE 0.
      " Documento n�o encontrado.
      et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_INVENTARIO' number = '001' ) ).
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Cria documento de invent�rio e realiza contagem (m�todo RELEASE_START)
* ---------------------------------------------------------------------------
    FREE: gt_return, gv_wait_async.

    TRY.
        CALL FUNCTION 'ZFMM_INVENTARIO_LIBERAR'
          STARTING NEW TASK 'INVENTARIO_LIBERAR'
          CALLING release_return ON END OF TASK
          EXPORTING
            iv_documentid = iv_documentid.

        WAIT UNTIL gv_wait_async = abap_true.

        et_return[] = gt_return[].

      CATCH cx_root INTO DATA(lo_root).
        DATA(lv_message) = CONV bapi_msg( lo_root->get_longtext(  ) ).

        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_INVENTARIO' number = '000'
                                               message_v1 = lv_message+0(50)
                                               message_v2 = lv_message+50(50)
                                               message_v3 = lv_message+100(50)
                                               message_v4 = lv_message+150(50) ) ).
    ENDTRY.

* ---------------------------------------------------------------------------
* Format mensagens de retorno
* ---------------------------------------------------------------------------
    me->format_return( CHANGING ct_return = et_return ).

  ENDMETHOD.


  METHOD release_start.

    DATA: lt_file             TYPE zctgmm_inventory_file,
          lt_bapi_items       TYPE STANDARD TABLE OF bapi_physinv_create_items,
          lt_bapi_count_items TYPE STANDARD TABLE OF bapi_physinv_count_items,
          lt_bapi_return      TYPE STANDARD TABLE OF bapiret2 WITH EMPTY KEY,  "TYPE bapiret2_t,
          ls_bapi_head        TYPE bapi_physinv_create_head,
          lv_status           TYPE ztmm_inventory_h-status,
          lr_iblnr            TYPE RANGE OF iblnr.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Recupera itens do documento
* ---------------------------------------------------------------------------
    SELECT *
        FROM ztmm_inventory_i           " Mudar para ZI (CDS)
        INTO TABLE @DATA(lt_item)
        WHERE documentid EQ @iv_documentid.

    IF sy-subrc NE 0.
      SORT lt_item BY documentid documentitemid.
    ENDIF.

    lt_file[] = CORRESPONDING #( lt_item ).

* ---------------------------------------------------------------------------
* Valida dados ( feitos ap�s altera��o manual
* ---------------------------------------------------------------------------
    me->validate_data( EXPORTING it_file   = lt_file[]
                       IMPORTING et_return = DATA(lt_return) ).

    et_return[] = VALUE #( BASE et_return FOR ls_return IN lt_return ( ls_return ) ).
    CHECK NOT line_exists( et_return[ type = 'E' ] ).    "#EC CI_STDSEQ

* ---------------------------------------------------------------------------
* Monta cabe�alhos
* ---------------------------------------------------------------------------
    DATA(lt_item_key) = lt_item[].
    SORT lt_item_key BY plant storagelocation.
    DELETE ADJACENT DUPLICATES FROM lt_item_key COMPARING plant storagelocation.
    DELETE lt_item_key WHERE physinventory IS NOT INITIAL.

* ---------------------------------------------------------------------------
* Inicia processo de cria��o do documento fiscal.
* ---------------------------------------------------------------------------
    lv_status = gc_status-incompleto.

    LOOP AT lt_item_key[] REFERENCE INTO DATA(ls_item_key).

      FREE: ls_bapi_head, lt_bapi_items, lt_bapi_return.

      ls_bapi_head-plant              = ls_item_key->plant.              " Centro
      ls_bapi_head-stge_loc           = ls_item_key->storagelocation.    " Dep�sito
      ls_bapi_head-doc_date           = sy-datum.                        " Data no documento
      ls_bapi_head-plan_date          = sy-datum.                        " Data prevista para a contagem do invent�rio

      LOOP AT lt_item REFERENCE INTO DATA(ls_item) WHERE plant           = ls_item_key->plant
                                                     AND storagelocation = ls_item_key->storagelocation
                                                     AND physinventory  IS INITIAL
                                                     AND fiscalyear     IS INITIAL. "#EC CI_STDSEQ #EC CI_NESTED

        lt_bapi_items[] = VALUE #( BASE lt_bapi_items ( material   = ls_item->material             " N� do material
                                                        batch      = ls_item->batch                " N�mero do lote
                                                        stock_type = gc_tp_estoque-deposito ) ).   " Tipo de estoque
      ENDLOOP.

      IF lt_bapi_items[] IS INITIAL.
        CONTINUE.
      ENDIF.

      " Chama processo de cria��o f�sica do Ivent�rio
      TRY.
          CALL FUNCTION 'BAPI_MATPHYSINV_CREATE_MULT'
            EXPORTING
              head   = ls_bapi_head
            TABLES
              items  = lt_bapi_items[]
              return = lt_bapi_return[].
        CATCH cx_root.
      ENDTRY.

      IF NOT line_exists( lt_bapi_return[ type = 'E' ] ). "#EC CI_STDSEQ
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.
      ELSE.
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      ENDIF.

      et_return[] = VALUE #( BASE et_return FOR ls_return IN lt_bapi_return ( ls_return ) ).
      CHECK NOT line_exists( lt_bapi_return[ type = 'E' ] ). "#EC CI_STDSEQ

      TRY.
          " Recupera n mero do documento de inventario criado

          IF line_exists( lt_bapi_return[ type = 'S' id = 'M7' number = '710' ] ) .

            SELECT 'EQ' AS option,
                   'I' AS sign,
                   message_v1 AS low,
                    ' ' AS high
            FROM @lt_bapi_return AS result
            WHERE type   = 'S'
              AND id     = 'M7'
              AND number = '710'
              INTO CORRESPONDING FIELDS OF TABLE @lr_iblnr.

            LOOP AT lr_iblnr ASSIGNING FIELD-SYMBOL(<fs_iblnr>).
              <fs_iblnr>-low = |{ <fs_iblnr>-low ALPHA = IN }|.
            ENDLOOP.

          ENDIF.

*          DATA(lv_iblnr) = CONV iblnr( lt_bapi_return[ type = 'S' id = 'M7' number = '710' ]-message_v1 ).

          DATA(lv_gjahr) = CONV gjahr( sy-datum ).

          IF lr_iblnr IS NOT INITIAL.

            SELECT iblnr, matnr, werks, lgort , charg  FROM iseg
            WHERE iblnr IN @lr_iblnr
              AND gjahr = @lv_gjahr
              INTO TABLE @DATA(lt_iseg).

          ENDIF.

        CATCH cx_root INTO DATA(lo_root).
          " Documento de invent rio n o foi encontrado para continuar com a contagem.
          et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_INVENTARIO' number = '006' ) ).
          RETURN.
      ENDTRY.

*      LOOP AT lt_item REFERENCE INTO ls_item WHERE plant           = ls_item_key->plant
*                                               AND storagelocation = ls_item_key->storagelocation
*                                               AND physinventory  IS INITIAL. "#EC CI_STDSEQ #EC CI_NESTED

      LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<fs_item>).

        CHECK <fs_item>-physinventory IS INITIAL.

        IF line_exists( lt_iseg[ matnr = <fs_item>-material
                                 werks = <fs_item>-plant
                                 lgort = <fs_item>-storagelocation
                                 charg = <fs_item>-batch ] ).

          <fs_item>-physinventory  = VALUE #( lt_iseg[ matnr = <fs_item>-material
                                                       werks = <fs_item>-plant
                                                       lgort = <fs_item>-storagelocation
                                                       charg = <fs_item>-batch ]-iblnr  OPTIONAL ).
          <fs_item>-fiscalyear     = lv_gjahr.
          <fs_item>-status         = gc_status_item-pendente_contagem.
          lv_status                = gc_status-incompleto.

        ENDIF.

      ENDLOOP.

    ENDLOOP.

    " Atualiza itens com o n�mero do ivent�rio
    MODIFY ztmm_inventory_i FROM TABLE lt_item[].

    " Atualiza cabe�alho com o n�mero do ivent�rio e novo status
    UPDATE ztmm_inventory_h SET   status     = lv_status
                            WHERE documentid EQ iv_documentid.

* ---------------------------------------------------------------------------
* Monta cabe�alhos para o processo de contagem.
* ---------------------------------------------------------------------------
    lt_item_key[] = lt_item[].
    SORT lt_item_key BY physinventory fiscalyear.
    DELETE ADJACENT DUPLICATES FROM lt_item_key COMPARING physinventory fiscalyear.
    DELETE lt_item_key WHERE physinventory IS INITIAL.   "#EC CI_STDSEQ

    IF lt_item_key[] IS INITIAL.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Prepara informa��es para chamada da BAPI
* ---------------------------------------------------------------------------
    lv_status = gc_status-liberado.

    LOOP AT lt_item_key REFERENCE INTO ls_item_key.

      FREE: lt_bapi_count_items, lt_bapi_return.

      DATA(lv_index) = 0.

      LOOP AT lt_item REFERENCE INTO ls_item WHERE physinventory = ls_item_key->physinventory
                                               AND fiscalyear    = ls_item_key->fiscalyear
                                               AND status        NE gc_status_item-liberado. "#EC CI_STDSEQ #EC CI_NESTED

        ADD 1 TO lv_index.

        lt_bapi_count_items[] = VALUE #( BASE lt_bapi_count_items ( item       = lv_index               " Sequencial
                                                                    material   = ls_item->material      " N� do material
                                                                    batch      = ls_item->batch         " N�mero do lote
                                                                    entry_qnt  = ls_item->quantitycount " Quantidade na unidade de medida do registro
                                                                    zero_count = COND abap_bool( WHEN ls_item->quantitycount IS INITIAL THEN abap_true ELSE abap_false ) " Aceitar registros com quantidade zerada
                                                                    entry_uom  = ls_item->unit ) ).     " Unidade de medida do registro
      ENDLOOP.

      IF lt_bapi_count_items[] IS INITIAL.
        CONTINUE.
      ENDIF.

* ---------------------------------------------------------------------------
* Inicia processo de contagem
* ---------------------------------------------------------------------------
      TRY.
          CALL FUNCTION 'BAPI_MATPHYSINV_COUNT'
            EXPORTING
              physinventory = ls_item_key->physinventory
              fiscalyear    = ls_item_key->fiscalyear
            TABLES
              items         = lt_bapi_count_items
              return        = lt_bapi_return.
        CATCH cx_root.
      ENDTRY.

      IF lt_bapi_return IS INITIAL.
        " Contagem realizada com sucesso para doc. invent�rio &1/&2.
        lt_bapi_return = VALUE #( ( type = 'S' id = 'ZMM_INVENTARIO' number = '018' message_v1 = ls_item_key->physinventory message_v2 = ls_item_key->fiscalyear ) ).
      ENDIF.

      IF NOT line_exists( lt_bapi_return[ type = 'E' ] ). "#EC CI_STDSEQ
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.
      ELSE.
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      ENDIF.

      et_return[] = VALUE #( BASE et_return FOR ls_return IN lt_bapi_return ( ls_return ) ).
      CHECK NOT line_exists( lt_bapi_return[ type = 'E' ] ). "#EC CI_STDSEQ

      LOOP AT lt_item REFERENCE INTO ls_item WHERE physinventory = ls_item_key->physinventory
                                               AND fiscalyear    = ls_item_key->fiscalyear
                                               AND status        NE gc_status_item-liberado. "#EC CI_STDSEQ #EC CI_NESTED

        ls_item->status  = gc_status_item-liberado.
      ENDLOOP.

    ENDLOOP.

    " Atualiza itens com o status do ivent�rio
    MODIFY ztmm_inventory_i FROM TABLE lt_item[].

    LOOP AT lt_item REFERENCE INTO ls_item WHERE status NE gc_status_item-liberado. "#EC CI_STDSEQ #EC CI_NESTED
      EXIT.
    ENDLOOP.

    IF sy-subrc NE 0.
      " Atualiza cabe�alho com o novo status
      UPDATE ztmm_inventory_h SET status        = gc_status-liberado
                              WHERE documentid EQ iv_documentid.
    ENDIF.

  ENDMETHOD.


  METHOD release_return.

    RECEIVE RESULTS FROM FUNCTION 'ZFMM_INVENTARIO_LIBERAR'
        IMPORTING et_return = gt_return.

    gv_wait_async = abap_true.

  ENDMETHOD.


  METHOD save_log.

    DATA: lt_log TYPE STANDARD TABLE OF ztmm_inventory_l.

    CHECK ct_return IS NOT INITIAL.

* ---------------------------------------------------------------------------
* Format mensagens de retorno
* ---------------------------------------------------------------------------
    me->format_return( CHANGING ct_return = ct_return ).

* ---------------------------------------------------------------------------
* Recupera �ltima mensagem criada
* ---------------------------------------------------------------------------
    SELECT MAX( seqnr )
        FROM ztmm_inventory_l
        INTO @DATA(lv_seqnr)
        WHERE documentid = @iv_documentid.

    IF sy-subrc NE 0.
      lv_seqnr = 1.
    ENDIF.

* ---------------------------------------------------------------------------
* Prepara mensagens
* ---------------------------------------------------------------------------
    LOOP AT ct_return INTO DATA(ls_return).

      lt_log[] = VALUE #( BASE lt_log ( documentid = iv_documentid
                                        seqnr      = sy-tabix + lv_seqnr
                                        msgty      = ls_return-type
                                        msgid      = ls_return-id
                                        msgno      = ls_return-number
                                        msgv1      = ls_return-message_v1
                                        msgv2      = ls_return-message_v2
                                        msgv3      = ls_return-message_v3
                                        msgv4      = ls_return-message_v4
                                        message    = ls_return-message
                                        created_by = sy-uname
                                        created_at = sy-datum ) ).
    ENDLOOP.

* ---------------------------------------------------------------------------
* Salva mensagens
* ---------------------------------------------------------------------------
    IF lt_log[] IS NOT INITIAL.

      MODIFY ztmm_inventory_l FROM TABLE lt_log[].

      IF sy-subrc NE 0.
        " Falha ao salvar mensagens
        ct_return[] = VALUE #( BASE ct_return ( type = 'W' id = 'ZMM_INVENTARIO' number = '007' ) ).
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Format mensagens de retorno
* ---------------------------------------------------------------------------
    me->format_return( CHANGING ct_return = ct_return ).

  ENDMETHOD.


  METHOD format_return.

    DATA: ls_return_format TYPE bapiret2.

* ---------------------------------------------------------------------------
* Format mensagens de retorno
* ---------------------------------------------------------------------------
    LOOP AT ct_return REFERENCE INTO DATA(ls_return).

      CHECK ls_return->message IS INITIAL.

      TRY.
          CALL FUNCTION 'FORMAT_MESSAGE'
            EXPORTING
              id        = ls_return->id
              lang      = sy-langu
              no        = ls_return->number
              v1        = ls_return->message_v1
              v2        = ls_return->message_v2
              v3        = ls_return->message_v3
              v4        = ls_return->message_v4
            IMPORTING
              msg       = ls_return->message
            EXCEPTIONS
              not_found = 1
              OTHERS    = 2.

          IF sy-subrc <> 0.
            CLEAR ls_return->message.
          ENDIF.

        CATCH cx_root INTO DATA(lo_root).
          DATA(lv_message) = lo_root->get_longtext( ).
      ENDTRY.

    ENDLOOP.

  ENDMETHOD.


  METHOD upload.

    DATA: lt_file     TYPE zctgmm_inventory_file,
          lv_mimetype TYPE w3conttype.

    FREE: es_header, et_item, et_return.

* ---------------------------------------------------------------------------
* Valida tipo de arquivo
* ---------------------------------------------------------------------------
    CALL FUNCTION 'SDOK_MIMETYPE_GET'
      EXPORTING
        extension = 'XLSX'
      IMPORTING
        mimetype  = lv_mimetype.

    IF is_media-mime_type NE lv_mimetype.
      " Formato de arquivo n�o suportado. Realizar nova carga com formato "xlsx".
      et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_INVENTARIO' number = '008' ) ).
    ENDIF.

* ---------------------------------------------------------------------------
* Converte arquivo excel para tabela
* ---------------------------------------------------------------------------
    DATA(lo_excel) = NEW zclca_excel(
      iv_filename = iv_filename
      iv_file     = is_media-value ).

    lo_excel->get_sheet( IMPORTING et_return = DATA(lt_return)
                         CHANGING  ct_table  = lt_file[] ).

    et_return[] = VALUE #( BASE et_return FOR ls_return IN lt_return ( ls_return ) ).
    CHECK NOT line_exists( et_return[ type = 'E' ] ).    "#EC CI_STDSEQ

* ---------------------------------------------------------------------------
* Processa dados do arquivo
* ---------------------------------------------------------------------------
    me->process_file( EXPORTING iv_excel  = iv_excel
                                it_file   = lt_file[]
                      IMPORTING es_header = es_header
                                et_item   = et_item[]
                                et_return = lt_return[] ).

    et_return[] = VALUE #( BASE et_return FOR ls_return IN lt_return ( ls_return ) ).
    CHECK NOT line_exists( et_return[ type = 'E' ] ).    "#EC CI_STDSEQ

  ENDMETHOD.


  METHOD determination_update.

    DATA: lt_file   TYPE zctgmm_inventory_file,
          lt_item   TYPE zctgmm_inventory_i,
          ls_header TYPE ztmm_inventory_h.

    FREE: et_return.

    ls_header = CORRESPONDING #( is_cds_header ).
    lt_item   = CORRESPONDING #( ct_cds_item ).
    lt_file   = CORRESPONDING #( ct_cds_item ).

* ---------------------------------------------------------------------------
* Recupera dados
* ---------------------------------------------------------------------------
    me->select_data( EXPORTING it_file     = lt_file[]
                     IMPORTING et_material = DATA(lt_material)
                               et_stock    = DATA(lt_stock)
                               et_price    = DATA(lt_price) ).

    IF lt_item IS NOT INITIAL.
      SELECT FROM ztmm_inventory_i
        FIELDS documentid,
               documentitemid,
               material,
               plant,
               storagelocation,
               batch
        FOR ALL ENTRIES IN @lt_item
        WHERE documentid     EQ @lt_item-documentid
          AND documentitemid EQ @lt_item-documentitemid
        ORDER BY PRIMARY KEY
        INTO TABLE @DATA(lt_item_db).
    ENDIF.

* ---------------------------------------------------------------------------
* Recalcula valores
* ---------------------------------------------------------------------------
    LOOP AT lt_item REFERENCE INTO DATA(ls_item).

      READ TABLE lt_item_db INTO DATA(ls_item_db)
        WITH KEY documentid     = ls_item->documentid
                 documentitemid = ls_item->documentitemid BINARY SEARCH.
      IF sy-subrc EQ 0.
        IF ls_item->material NE ls_item_db-material
        OR ls_item->plant    NE ls_item_db-plant
        OR ls_item->storagelocation NE ls_item_db-storagelocation
        OR ls_item->batch NE ls_item_db-batch.
          CLEAR: ls_item->quantitystock.
        ENDIF.
      ENDIF.

      me->process_item( EXPORTING is_header   = ls_header
                                  it_material = lt_material
                                  it_stock    = lt_stock
                                  it_price    = lt_price
                        CHANGING  cs_item     = ls_item->* ).

      ls_item->last_changed_by  = sy-uname.
      GET TIME STAMP FIELD ls_item->last_changed_at.

    ENDLOOP.

* ---------------------------------------------------------------------------
* Retorna novos valores
* ---------------------------------------------------------------------------
    ct_cds_item[] = CORRESPONDING #( lt_item ).

    " Valores recalculados com sucesso.
    et_return[] = VALUE #( BASE et_return ( type = 'S' id = 'ZMM_INVENTARIO' number = '015' ) ).

* ---------------------------------------------------------------------------
* Atualiza status
* ---------------------------------------------------------------------------
    IF ls_header-status = gc_status-criado.
*      ls_header-status                 = gc_status-incompleto.
      ls_header-last_changed_by             = sy-uname.
      GET TIME STAMP FIELD ls_header-last_changed_at.
      ls_header-local_last_changed_at  = ls_header-last_changed_at.
      MODIFY ztmm_inventory_h FROM ls_header.
    ENDIF.

  ENDMETHOD.


  METHOD validate_data.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Valida Centro
* ---------------------------------------------------------------------------
    DATA(lt_file) = it_file[].
    SORT lt_file BY plant.
    DELETE ADJACENT DUPLICATES FROM lt_file COMPARING plant.

    IF lines( lt_file ) NE 1.
      " Somente um centro permitido no arquivo de carga.
      et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_INVENTARIO' number = '009' ) ).
    ELSE.

      DATA(lv_plant) = lt_file[ 1 ]-plant.

      SELECT SINGLE COUNT(*)
        FROM t001w
        WHERE werks EQ lv_plant.                         "#EC CI_BYPASS

      IF sy-subrc NE 0.
        " Centro & n�o existe.
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_INVENTARIO' number = '010' message_v1 = lv_plant ) ).
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Valida Data da Contagem
* ---------------------------------------------------------------------------
    lt_file[] = it_file[].
    SORT lt_file BY datesel.
    DELETE ADJACENT DUPLICATES FROM lt_file COMPARING datesel.

    IF lines( lt_file ) NE 1.
      " Somente um centro permitido no arquivo de carga.
      et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_INVENTARIO' number = '011' ) ).
    ENDIF..

** ---------------------------------------------------------------------------
** Valida Dep�sito
** ---------------------------------------------------------------------------
*    lt_file[] = it_file[].
*    SORT lt_file BY storagelocation.
*    DELETE ADJACENT DUPLICATES FROM lt_file COMPARING storagelocation.
*
*    IF lines( lt_file ) NE 1.
*      " Somente um dep�sito permitido no arquivo de carga.
*      et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_INVENTARIO' number = '012' ) ).
*    ENDIF.

* ---------------------------------------------------------------------------
* Valida Material
* ---------------------------------------------------------------------------
    lt_file[] = it_file[].
    SORT lt_file BY material.
    DELETE ADJACENT DUPLICATES FROM lt_file COMPARING material.

    SELECT matnr
        FROM mara
        FOR ALL ENTRIES IN @lt_file
        WHERE matnr EQ @lt_file-material
        INTO TABLE @DATA(lt_mara).              "#EC CI_FAE_NO_LINES_OK

    IF sy-subrc EQ 0.
      SORT lt_mara BY matnr.
    ENDIF.

    LOOP AT lt_file REFERENCE INTO DATA(ls_file).
      IF NOT line_exists( lt_mara[  matnr = ls_file->material ] ). "#EC CI_STDSEQ
        " Material & n�o existe.
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_INVENTARIO' number = '013'  message_v1 = ls_file->material ) ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD upload_create_header.

    FREE: es_header, et_return.

* ---------------------------------------------------------------------------
* Prepera dados de cabe�alho
* ---------------------------------------------------------------------------
    es_header-documentid             = me->get_next_guid( ).
    es_header-documentno = me->get_next_documentno( IMPORTING et_return = et_return ).
    es_header-countid                = COND #( WHEN iv_excel IS NOT INITIAL
                                               THEN |EXCEL_{ sy-datum }|
                                               ELSE |WMS_SAGA_{ sy-datum }| ).

    TRY.
        es_header-datesel            = it_file[ 1 ]-datesel.
        es_header-plant            = it_file[ 1 ]-plant.
      CATCH cx_root.
    ENDTRY.

    es_header-status                 = gc_status-criado.
    es_header-created_by             = sy-uname.
    GET TIME STAMP FIELD es_header-created_at.
    es_header-local_last_changed_at  = es_header-created_at.

  ENDMETHOD.


  METHOD get_next_guid.

    FREE: ev_guid, et_return.

    TRY.
        rv_guid = ev_guid = cl_system_uuid=>create_uuid_x16_static( ).

      CATCH cx_root INTO DATA(lo_root).
        DATA(lv_message) = CONV bapi_msg( lo_root->get_longtext( ) ).
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZCA_EXCEL' number = '000'
                                                message_v1 = lv_message+0(50)
                                                message_v2 = lv_message+50(50)
                                                message_v3 = lv_message+100(50)
                                                message_v4 = lv_message+150(50) ) ).
        RETURN.
    ENDTRY.

  ENDMETHOD.


  METHOD process_item.

    IF cs_item-quantitystock IS INITIAL.

      cs_item-quantitystock     = REDUCE ze_quantity_stock(
                                  INIT lv_qtd_stock TYPE ze_quantity_stock
                                  FOR ls_stock IN FILTER #( it_stock WHERE material                = cs_item-material
                                                                       AND plant                   = cs_item-plant
                                                                       AND batch                   = cs_item-batch
                                                                       AND storagelocation         = cs_item-storagelocation
                                                                       AND matldoclatestpostgdate <= is_header-datesel )

                                  NEXT lv_qtd_stock = lv_qtd_stock + ls_stock-matlwrhsstkqtyinmatlbaseunit ).

      cs_item-quantitystock =  COND #( WHEN cs_item-quantitystock >= 0
                                       THEN cs_item-quantitystock
                                       ELSE 0 ).
    ENDIF.

    cs_item-quantitycurrent   = REDUCE ze_quantity_current(
                                INIT lv_qtd_current TYPE ze_quantity_current
                                FOR ls_stock IN FILTER #( it_stock WHERE material                = cs_item-material
                                                                     AND plant                   = cs_item-plant
                                                                     AND batch                   = cs_item-batch
                                                                     AND storagelocation         = cs_item-storagelocation
                                                                     AND matldoclatestpostgdate <= sy-datum )

                                NEXT lv_qtd_current = lv_qtd_current + ls_stock-matlwrhsstkqtyinmatlbaseunit ).

    cs_item-quantitycurrent =  COND #( WHEN cs_item-quantitycurrent >= 0
                                       THEN cs_item-quantitycurrent
                                       ELSE 0 ).

    cs_item-balance           = cs_item-quantitycount - cs_item-quantitystock.
    cs_item-balancecurrent    = cs_item-quantitycount - cs_item-quantitycurrent.

    DATA(lv_inventoryprice)   = REDUCE ze_price_calculation(
                                INIT lv_price TYPE ze_price_calculation
                                FOR ls_price IN FILTER #( it_price WHERE material      = cs_item-material
                                                                     AND valuationarea = cs_item-plant )

                                NEXT lv_price = lv_price + ls_price-inventoryprice ).

    DATA(lv_inventoryqty)     = REDUCE nsdm_stock_qty(
                                INIT lv_qty TYPE nsdm_stock_qty
                                FOR ls_price IN FILTER #( it_price WHERE material      = cs_item-material
                                                                     AND valuationarea = cs_item-plant )
                                NEXT lv_qty = lv_qty + ls_price-materialpriceunitqty ).


    TRY.
        cs_item-pricestock    = ( lv_inventoryprice / lv_inventoryqty ) * cs_item-quantitystock.
      CATCH cx_root.
        cs_item-pricestock    = 0.
    ENDTRY.

    TRY.
        cs_item-pricecount    = ( lv_inventoryprice / lv_inventoryqty ) * cs_item-quantitycount.
      CATCH cx_root.
        cs_item-pricecount    = 0.
    ENDTRY.

    TRY.
        cs_item-pricediff = abs( ( lv_inventoryprice / lv_inventoryqty ) * cs_item-balance ).
      CATCH cx_root.
        cs_item-pricediff     = 0.
    ENDTRY.

    TRY.
        cs_item-currency      = it_price[ material      = cs_item-material
                                          valuationarea = cs_item-plant  ]-currency.

      CATCH cx_root.
    ENDTRY.

    DATA(lv_grossweight)      = REDUCE brgew(
                                INIT lv_weight TYPE brgew
                                FOR ls_material IN FILTER #( it_material WHERE material      = cs_item-material )

                                NEXT lv_weight = lv_weight + ls_material-materialgrossweight ).

    TRY.
        cs_item-weight        =  lv_grossweight * cs_item-balance.
      CATCH cx_root.
        cs_item-weight        = 0.
    ENDTRY.

    TRY.
        cs_item-weightunit    = it_material[ material = cs_item-material ]-materialweightunit.
      CATCH cx_root.
        cs_item-weightunit    = space.
    ENDTRY.

    TRY.
          cs_item-accuracy      = ( 1 - ( cs_item-pricediff / cs_item-pricestock ) ) * 100.
      CATCH cx_root.
        cs_item-accuracy      = 0.
    ENDTRY.

  ENDMETHOD.


  METHOD get_next_documentno.

    DATA: ls_return TYPE bapiret2,
          lv_object TYPE nrobj VALUE 'ZMM_INV',
          lv_range  TYPE nrnr  VALUE '01'.

    FREE: et_return, ev_documentno.

* ---------------------------------------------------------------------------
* Travar objeto de numera��o
* ---------------------------------------------------------------------------
    CALL FUNCTION 'NUMBER_RANGE_ENQUEUE'
      EXPORTING
        object           = lv_object
      EXCEPTIONS
        foreign_lock     = 1
        object_not_found = 2
        system_failure   = 3
        OTHERS           = 4.

    IF sy-subrc NE 0.
      et_return[] =  VALUE #( BASE et_return ( type = sy-msgty id = sy-msgid number = sy-msgno
                                               message_v1 = sy-msgv1
                                               message_v2 = sy-msgv2
                                               message_v3 = sy-msgv3
                                               message_v4 = sy-msgv4 ) ).
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Recuperar novo n�mero da requisi��o
* ---------------------------------------------------------------------------
    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = lv_range
        object                  = lv_object
      IMPORTING
        number                  = ev_documentno
      EXCEPTIONS
        interval_not_found      = 1
        number_range_not_intern = 2
        object_not_found        = 3
        quantity_is_0           = 4
        quantity_is_not_1       = 5
        interval_overflow       = 6
        buffer_overflow         = 7
        OTHERS                  = 8.

    IF sy-subrc NE 0.
      et_return[] =  VALUE #( BASE et_return ( type = sy-msgty id = sy-msgid number = sy-msgno
                                               message_v1 = sy-msgv1
                                               message_v2 = sy-msgv2
                                               message_v3 = sy-msgv3
                                               message_v4 = sy-msgv4 ) ).
    ENDIF.

* ---------------------------------------------------------------------------
* Destravar objeto de numera��o
* ---------------------------------------------------------------------------
    CALL FUNCTION 'NUMBER_RANGE_DEQUEUE'
      EXPORTING
        object           = lv_object
      EXCEPTIONS
        object_not_found = 1
        OTHERS           = 2.

    IF sy-subrc NE 0.
      et_return[] =  VALUE #( BASE et_return ( type = sy-msgty id = sy-msgid number = sy-msgno
                                               message_v1 = sy-msgv1
                                               message_v2 = sy-msgv2
                                               message_v3 = sy-msgv3
                                               message_v4 = sy-msgv4 ) ).
    ENDIF.

    rv_documentno = ev_documentno.

  ENDMETHOD.


  METHOD select_data.

    FREE: et_material, et_price, et_stock.

    " Monta tabela de chaves
    DATA(lt_file_key) = it_file[].
    SORT lt_file_key BY material.
    DELETE ADJACENT DUPLICATES FROM lt_file_key COMPARING material.

* ---------------------------------------------------------------------------
* Recupera dados de material
* ---------------------------------------------------------------------------
    IF lt_file_key[] IS NOT INITIAL.

      SELECT matnr AS material,
             brgew AS materialgrossweight,
             gewei AS materialweightunit,
             prdha AS producthierarchy
        FROM mara AS material
        FOR ALL ENTRIES IN @lt_file_key
        WHERE material~matnr EQ @lt_file_key-material
        INTO TABLE @et_material.

      IF sy-subrc NE 0.
        FREE et_material.
      ENDIF.
    ENDIF.

    " Monta tabela de chaves
    lt_file_key[] = it_file[].
    SORT lt_file_key BY material plant batch storagelocation.
    DELETE ADJACENT DUPLICATES FROM lt_file_key COMPARING material plant batch storagelocation.

* ---------------------------------------------------------------------------
* Recupera C�lculo do estoque do material
* ---------------------------------------------------------------------------
    IF lt_file_key[] IS NOT INITIAL.

      SELECT stock~material,
             stock~plant,
             stock~batch,
             stock~storagelocation,
             stock~matldoclatestpostgdate,
             stock~matlwrhsstkqtyinmatlbaseunit,
             text~materialname
          FROM i_materialstock AS stock
          INNER JOIN i_materialtext AS text
            ON  text~material = stock~material
            AND text~language = @sy-langu
          FOR ALL ENTRIES IN @lt_file_key
          WHERE stock~material        EQ @lt_file_key-material
            AND stock~plant           EQ @lt_file_key-plant
            AND stock~batch           EQ @lt_file_key-batch
            AND stock~storagelocation EQ @lt_file_key-storagelocation
          INTO TABLE @et_stock.

      IF sy-subrc NE 0.
        FREE et_stock.
      ENDIF.
    ENDIF.

    " Monta tabela de chaves
    lt_file_key[] = it_file[].
    SORT lt_file_key BY material plant.
    DELETE ADJACENT DUPLICATES FROM lt_file_key COMPARING material plant.

* ---------------------------------------------------------------------------
* Recupera Pre�o do material atual por c�lculo de custos
* ---------------------------------------------------------------------------
    IF lt_file_key[] IS NOT INITIAL.

      SELECT material,
             valuationarea,
             costestimate,
             currency,
             materialpriceunitqty,
             inventoryprice
        FROM i_currentmatlpricebycostest AS price
        FOR ALL ENTRIES IN @lt_file_key
        WHERE price~material      EQ @lt_file_key-material
          AND price~valuationarea EQ @lt_file_key-plant
        INTO TABLE @et_price.

      IF sy-subrc NE 0.
        FREE et_price.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD upload_save.

    FREE: et_return.

    IF is_header IS NOT INITIAL.

      MODIFY ztmm_inventory_h FROM is_header.

      IF sy-subrc NE 0.
        " Falha ao salvar dados de carga.
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_INVENTARIO' number = '014' ) ).
        RETURN.
      ENDIF.
    ENDIF.

    IF it_item IS NOT INITIAL.

      MODIFY ztmm_inventory_i FROM TABLE it_item.

      IF sy-subrc NE 0.
        " Falha ao salvar dados de carga.
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_INVENTARIO' number = '014' ) ).
        RETURN.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD process_file.

* ---------------------------------------------------------------------------
* Valida dados do arquivo de carga
* ---------------------------------------------------------------------------
    me->validate_data( EXPORTING it_file   = it_file[]
                       IMPORTING et_return = DATA(lt_return) ).

    et_return[] = VALUE #( BASE et_return FOR ls_return IN lt_return ( ls_return ) ).
    CHECK NOT line_exists( et_return[ type = 'E' ] ).    "#EC CI_STDSEQ

* ---------------------------------------------------------------------------
* Recupera dados
* ---------------------------------------------------------------------------
    me->select_data( EXPORTING it_file     = it_file[]
                     IMPORTING et_material = DATA(lt_material)
                               et_stock    = DATA(lt_stock)
                               et_price    = DATA(lt_price) ).

* ---------------------------------------------------------------------------
* Monta cabe�alho
* ---------------------------------------------------------------------------
    me->upload_create_header( EXPORTING iv_excel  = iv_excel
                                        it_file   = it_file[]
                              IMPORTING es_header = es_header
                                        et_return = lt_return[] ).

    et_return[] = VALUE #( BASE et_return FOR ls_return IN lt_return ( ls_return ) ).
    CHECK NOT line_exists( et_return[ type = 'E' ] ).    "#EC CI_STDSEQ

* ---------------------------------------------------------------------------
* Monta itens
* ---------------------------------------------------------------------------
    me->upload_create_item( EXPORTING it_file     = it_file[]
                                      is_header   = es_header
                                      it_material = lt_material[]
                                      it_stock    = lt_stock[]
                                      it_price    = lt_price[]
                            IMPORTING et_item     = et_item[]
                                      et_return   = lt_return[] ).

    et_return[] = VALUE #( BASE et_return FOR ls_return IN lt_return ( ls_return ) ).
    CHECK NOT line_exists( et_return[ type = 'E' ] ).    "#EC CI_STDSEQ

* ---------------------------------------------------------------------------
* Salva registros
* ---------------------------------------------------------------------------
    me->upload_save( EXPORTING is_header = es_header
                               it_item   = et_item[]
                     IMPORTING et_return = lt_return[] ).

    et_return[] = VALUE #( BASE et_return FOR ls_return IN lt_return ( ls_return ) ).
    CHECK NOT line_exists( et_return[ type = 'E' ] ).    "#EC CI_STDSEQ

  ENDMETHOD.


  METHOD upload_create_item.

    DATA: ls_item TYPE ztmm_inventory_i.

    FREE: et_item, et_return.

* ---------------------------------------------------------------------------
* Monta dados de item
* ---------------------------------------------------------------------------
    LOOP AT it_file REFERENCE INTO DATA(ls_file).

      CLEAR ls_item.
      ls_item-documentid        = is_header-documentid.
      ls_item-documentitemid    = me->get_next_guid( ).
      ls_item-material          = ls_file->material.
      ls_item-plant             = ls_file->plant.
      ls_item-storagelocation   = ls_file->storagelocation.
      ls_item-batch             = ls_file->batch.
      ls_item-quantitycount     = ls_file->quantitycount.
      ls_item-unit              = ls_file->unit.
      ls_item-physinventory     = space.
      ls_item-fiscalyear        = space.
*      ls_item-prctr        = ls_file->.

      me->process_item( EXPORTING is_header   = is_header
                                  it_material = it_material
                                  it_stock    = it_stock
                                  it_price    = it_price
                        CHANGING  cs_item     = ls_item ).

      ls_item-created_by            = is_header-created_by.
      ls_item-created_at            = is_header-created_at.
      ls_item-last_changed_by       = is_header-last_changed_by.
      ls_item-last_changed_at       = is_header-last_changed_at.
      ls_item-local_last_changed_at = is_header-local_last_changed_at.
      APPEND ls_item TO et_item[].

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
