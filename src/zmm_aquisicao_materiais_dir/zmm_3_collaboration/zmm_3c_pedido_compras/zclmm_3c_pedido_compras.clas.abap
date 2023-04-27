"!<p><h2>Classe para Interface 3Collaboration</h2></p>
"!<p>Seleciona e envia dados de Pedidos de Compras para a 3Collaboration</p>
"!<p><strong>Autor:</strong>Jefferson Fujii</p>
"!<p><strong>Data:</strong>05 de ago de 2022</p>
CLASS zclmm_3c_pedido_compras DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      "! <p class="shorttext synchronized">Tipo de estrutura da Tela de Seleção</p>
      BEGIN OF ty_screen,
        s_eindt TYPE RANGE OF eindt,
        s_werks TYPE RANGE OF werks_d,
        s_matnr TYPE RANGE OF matnr,
        p_jobid TYPE sysuuid_x16,
      END OF ty_screen.

    METHODS:
      "! <p class="shorttext synchronized">Método construtor</p>
      "! @parameter is_screen | <p class="shorttext synchronized">Estrutura da tela de seleção</p>
      constructor IMPORTING is_screen TYPE ty_screen,

      "! <p class="shorttext synchronized">Método para tratamentos do evento START-OF-SELECTION</p>
      start_of_selection,

      "! <p class="shorttext synchronized">Método para tratamentos do evento END-OF-SELECTION</p>
      end_of_selection.

  PROTECTED SECTION.

  PRIVATE SECTION.
    CONSTANTS:
      gc_object    TYPE balobj_d  VALUE 'Z3COLLAB',
      gc_subobject TYPE balsubobj VALUE 'PEDCOMP'.

    DATA:
      "! <p class="shorttext synchronized">Log Handle</p>
      gv_log_handle TYPE balloghndl,
      "! <p class="shorttext synchronized">Estrutura para Tela de Seleção</p>
      gs_screen     TYPE ty_screen,
      "! <p class="shorttext synchronized">Estrutura para JOB</p>
      gs_job        TYPE ztmm_3c_job,
      "! <p class="shorttext synchronized">Tabela principal</p>
      gt_data       TYPE TABLE OF zsmm_dt_pedido_de_compra,
      "! <p class="shorttext synchronized">Tabela LogHandle</p>
      gt_log_handle TYPE bal_t_logh.

    METHODS:
      "! <p class="shorttext synchronized">Método para buscar/gerar estrutura do JOB Log</p>
      "! @parameter rs_result | <p class="shorttext synchronized">Estrutura com dados do job</p>
      get_job RETURNING VALUE(rs_result) TYPE ztmm_3c_job,

      "! <p class="shorttext synchronized">Método para seleção dos dados principais</p>
      select_data,

      "! <p class="shorttext synchronized">Método para chamar o Proxy</p>
      "! @parameter is_data | <p class="shorttext synchronized">Estrutura de entrada</p>
      call_proxy IMPORTING is_data TYPE zsmm_dt_pedido_de_compra,

      "! <p class="shorttext synchronized">Método para criar log</p>
      create_log,

      "! <p class="shorttext synchronized">Método para adicionar mensagens no Log</p>
      "! @parameter is_message | <p class="shorttext synchronized">Estrutura de mensagem</p>
      add_log IMPORTING is_message TYPE bal_s_msg OPTIONAL,

      "! <p class="shorttext synchronized">Método para salvar Log</p>
      save_log,

      "! <p class="shorttext synchronized">Método para Limpar</p>
      free.


ENDCLASS.



CLASS ZCLMM_3C_PEDIDO_COMPRAS IMPLEMENTATION.


  METHOD constructor.
    free( ).
    gs_screen = is_screen.
    gs_job = get_job( ).
  ENDMETHOD.


  METHOD start_of_selection.
    select_data( ).
  ENDMETHOD.


  METHOD end_of_selection.

    create_log( ).

    LOOP AT gt_data ASSIGNING FIELD-SYMBOL(<fs_data>).
      call_proxy( <fs_data> ).
    ENDLOOP.
    IF sy-subrc NE 0.
      MESSAGE s002 INTO DATA(lv_message).
      add_log( ).
    ENDIF.

    save_log( ).

  ENDMETHOD.


  METHOD select_data.

    TYPES: BEGIN OF ty_supp_name,
             supplier TYPE lifnr,
           END OF ty_supp_name.

    DATA: lt_supp_plant TYPE STANDARD TABLE OF ty_supp_name.
    DATA: ls_supp_plant TYPE ty_supp_name.

    DATA: lv_supp_plant TYPE lifnr.

    SELECT FROM i_purchasingdocument      AS podoc

      INNER JOIN i_purchasingdocumentitem AS poitem
         ON poitem~purchasingdocument       EQ podoc~purchasingdocument

      LEFT JOIN i_materialtext AS material
        ON material~material EQ poitem~material
       AND material~language EQ @sy-langu

    INNER JOIN i_purgdocscheduleline WITH PRIVILEGED ACCESS AS schedule
    ON schedule~purchasingdocument     EQ poitem~purchasingdocument
    AND schedule~purchasingdocumentitem EQ poitem~purchasingdocumentitem

    FIELDS podoc~purchasingdocument,
    podoc~supplier,
    podoc~\_supplier-supplierfullname,
    podoc~supplyingplant,
    podoc~documentcurrency,
    poitem~purchasingdocumentitem,
    poitem~material,
*             poitem~\_material\_text[ language = @sy-langu ]-materialname,
    material~materialname,
    poitem~plant,
    poitem~purchasingdocumentdeletioncode,
    poitem~iscompletelydelivered,
    poitem~orderquantityunit,
    poitem~orderquantity,
    poitem~storagelocation,
    poitem~netamount,
    poitem~goodsreceiptisexpected,
    schedule~scheduleline,
    schedule~schedulelineorderdate,
    schedule~schedulelinedeliverydate,
    schedule~schedlinestscdeliverydate,
    schedule~schedulelineorderquantity,
    schedule~goodsreceiptquantity,
    schedule~schedulelineopenquantity,
    schedule~purchaserequisition,
    schedule~purchaserequisitionitem

    WHERE ( poitem~purchasingdocumentcategory   EQ 'F' OR poitem~purchasingdocumentcategory EQ 'L' )
    AND poitem~purchasingdocumentitemcategory NE '9'
    AND poitem~plant                          IN @gs_screen-s_werks
    AND poitem~material                       IN @gs_screen-s_matnr
    AND schedule~schedulelinedeliverydate     IN @gs_screen-s_eindt

    ORDER BY podoc~purchasingdocument,
             poitem~purchasingdocumentitem,
             schedule~scheduleline

    INTO TABLE @DATA(lt_po).

    IF sy-subrc IS INITIAL.

      LOOP AT lt_po ASSIGNING FIELD-SYMBOL(<fs_po>).
        IF <fs_po>-supplier IS INITIAL.

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = <fs_po>-supplyingplant
            IMPORTING
              output = ls_supp_plant-supplier.

          lt_supp_plant = VALUE #( BASE lt_supp_plant ( supplier = ls_supp_plant-supplier ) ).
        ENDIF.
      ENDLOOP.

      IF lt_supp_plant[] IS NOT INITIAL.
        SELECT supplier,
               supplierfullname
          FROM i_supplier
           FOR ALL ENTRIES IN @lt_supp_plant
         WHERE supplier = @lt_supp_plant-supplier
          INTO TABLE @DATA(lt_supp_name).

        IF sy-subrc IS INITIAL.
          SORT lt_supp_name BY supplier.
        ENDIF.
      ENDIF.

      LOOP AT lt_po ASSIGNING <fs_po>.

        IF <fs_po>-supplier IS INITIAL.

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = <fs_po>-supplyingplant
            IMPORTING
              output = lv_supp_plant.

          READ TABLE lt_supp_name ASSIGNING FIELD-SYMBOL(<fs_supp_name>)
                                                WITH KEY supplier = lv_supp_plant
                                                BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            DATA(lv_suppfullname) = <fs_supp_name>-supplierfullname.
          ELSE.
            CLEAR lv_suppfullname.
          ENDIF.
        ELSE.
          CLEAR lv_suppfullname.
        ENDIF.

        gt_data = VALUE #( BASE gt_data ( data_doc        = <fs_po>-schedulelineorderdate
                                          id_fornecedor   = COND #( WHEN <fs_po>-supplier IS NOT INITIAL THEN <fs_po>-supplier
                                                                    ELSE <fs_po>-supplyingplant )
                                          nome_fornecedor = COND #( WHEN <fs_po>-supplier IS NOT INITIAL THEN <fs_po>-supplierfullname
                                                                    ELSE lv_suppfullname )
                                          id_material     = <fs_po>-material
                                          nome_material   = <fs_po>-materialname
                                          centro_fab      = <fs_po>-plant
                                          deposito        = <fs_po>-storagelocation
                                          qtdpedido       = <fs_po>-orderquantity
                                          ump             = <fs_po>-orderquantityunit
                                          precoliq        = <fs_po>-netamount
                                          moeda           = <fs_po>-documentcurrency
                                          qtdpartdiv      = <fs_po>-orderquantity
                                          datarem         = <fs_po>-schedulelinedeliverydate
                                          dtremest        = <fs_po>-schedlinestscdeliverydate
                                          entrado         = <fs_po>-goodsreceiptquantity
                                          doc_compra      = <fs_po>-purchasingdocument
                                          num_item        = <fs_po>-purchasingdocumentitem
                                          a_fornecer      = <fs_po>-schedulelineopenquantity
                                          eliminar        = <fs_po>-purchasingdocumentdeletioncode
                                          div_remessa     = <fs_po>-scheduleline
                                          remessa_final   = <fs_po>-iscompletelydelivered
                                          ent_merc        = <fs_po>-goodsreceiptisexpected ) ).
      ENDLOOP.

    ENDIF.

*    gt_data = CORRESPONDING #( lt_po
*      MAPPING
*        data_doc        = schedulelineorderdate
*        id_fornecedor   = supplier
*        nome_fornecedor = supplierfullname
*        id_material     = material
*        nome_material   = materialname
*        centro_fab      = plant
*        deposito        = storagelocation
*        qtdpedido       = orderquantity
*        ump             = orderquantityunit
*        precoliq        = netamount
*        moeda           = documentcurrency
*        qtdpartdiv      = orderquantity
*        datarem         = schedulelinedeliverydate
*        dtremest        = schedlinestscdeliverydate
*        entrado         = goodsreceiptquantity
*        doc_compra      = purchasingdocument
*        num_item        = purchasingdocumentitem
*        a_fornecer      = schedulelineopenquantity
*        eliminar        = purchasingdocumentdeletioncode
*        div_remessa     = scheduleline
*        remessa_final   = iscompletelydelivered ).

  ENDMETHOD.


  METHOD call_proxy.

    TRY.
        NEW zclmm_co_enviar_pedido_compras( )->si_enviar_pedido_de_compra_out(
          VALUE #( mt_pedido_de_compra = is_data ) ).
        COMMIT WORK.

        MESSAGE s004 INTO DATA(lv_message).
        add_log( ).

      CATCH cx_ai_system_fault INTO DATA(lo_exception).
        MESSAGE e000 WITH lo_exception->textid INTO lv_message.
        add_log( ).
    ENDTRY.
  ENDMETHOD.


  METHOD create_log.

    CALL FUNCTION 'BAL_LOG_CREATE'
      EXPORTING
        i_s_log      = VALUE bal_s_log(
                         object    = gc_object
                         subobject = gc_subobject
                         extnumber = gs_job-jobname
                         aldate    = sy-datum
                         altime    = sy-uzeit
                         aluser    = sy-uname
                         alprog    = sy-repid )
      IMPORTING
        e_log_handle = gv_log_handle
      EXCEPTIONS
        OTHERS       = 1.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    APPEND gv_log_handle TO gt_log_handle.

    IF NOT sy-batch IS INITIAL.
      CALL FUNCTION 'BP_ADD_APPL_LOG_HANDLE'
        EXPORTING
          loghandle = gv_log_handle
        EXCEPTIONS
          OTHERS    = 4.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD add_log.
    IF is_message IS NOT INITIAL.
      DATA(ls_message) = is_message.
    ELSE.
      ls_message = VALUE #( msgty = sy-msgty
                            msgid = sy-msgid
                            msgno = sy-msgno
                            msgv1 = sy-msgv1
                            msgv2 = sy-msgv2
                            msgv3 = sy-msgv3
                            msgv4 = sy-msgv4 ).
    ENDIF.

    CALL FUNCTION 'BAL_LOG_MSG_ADD'
      EXPORTING
        i_log_handle     = gv_log_handle
        i_s_msg          = ls_message
      EXCEPTIONS
        log_not_found    = 1
        msg_inconsistent = 2
        log_is_full      = 3
        OTHERS           = 4.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDMETHOD.


  METHOD save_log.
    DATA: lt_job_log TYPE TABLE OF ztmm_3c_job_log.

    IF gt_log_handle IS INITIAL.
      RETURN.
    ENDIF.

    CALL FUNCTION 'BAL_DB_SAVE'
      EXPORTING
        i_save_all     = abap_true
        i_t_log_handle = gt_log_handle
      EXCEPTIONS
        OTHERS         = 4.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    lt_job_log = VALUE #( FOR ls_log_handle IN gt_log_handle
      ( loghandle = ls_log_handle
        jobuuid   = gs_job-jobuuid ) ).

    MODIFY ztmm_3c_job_log FROM TABLE lt_job_log.
    COMMIT WORK.

  ENDMETHOD.


  METHOD get_job.

    IF gs_screen-p_jobid IS NOT INITIAL.
      SELECT SINGLE FROM ztmm_3c_job
        FIELDS jobuuid,
               jobname,
               object,
               subobject
        WHERE jobuuid EQ @gs_screen-p_jobid
        INTO CORRESPONDING FIELDS OF @rs_result.
      RETURN.
    ENDIF.

    SELECT FROM ztmm_3c_job
      FIELDS jobuuid,
             jobname,
             object,
             subobject
      WHERE jobname   EQ 'JOB_PEDIDO_COMPRAS'
        AND object    EQ @gc_object
        AND subobject EQ @gc_subobject
      ORDER BY created_at DESCENDING
      INTO CORRESPONDING FIELDS OF @rs_result
      UP TO 1 ROWS.
      RETURN.
    ENDSELECT.

    CONVERT DATE sy-datlo TIME sy-timlo
      INTO TIME STAMP DATA(lv_timestamp) TIME ZONE sy-zonlo.

    TRY.
        rs_result = VALUE #(
          jobuuid               = cl_system_uuid=>create_uuid_x16_static( )  " create uuid_x16
          jobname               = |JOB_PEDIDO_COMPRAS|
          object                = gc_object
          subobject             = gc_subobject
          created_by            = sy-uname
          created_at            = lv_timestamp
          last_changed_by       = sy-uname
          last_changed_at       = lv_timestamp
          local_last_changed_at = lv_timestamp ).

        MODIFY ztmm_3c_job FROM rs_result.
        COMMIT WORK AND WAIT.

      CATCH cx_uuid_error cx_root INTO DATA(lo_exception).
        MESSAGE e000 WITH lo_exception->get_text( ) INTO DATA(lv_message).
        add_log( ).
    ENDTRY.

  ENDMETHOD.


  METHOD free.
    FREE: gs_screen,
          gs_job,
          gt_log_handle,
          gt_data,
          gt_log_handle.
  ENDMETHOD.
ENDCLASS.
