"!<p><h2>Classe para Interface 3Collaboration</h2></p>
"!<p>Seleciona e envia dados de Entradas de NF de Fornecedores para a 3Collaboration</p>
"!<p><strong>Autor:</strong>Jefferson Fujii</p>
"!<p><strong>Data:</strong>05 de ago de 2022</p>
CLASS zclmm_3c_nf_fornecedores DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      "! <p class="shorttext synchronized">Tipo de estrutura da Tela de Seleção</p>
      BEGIN OF ty_screen,
        s_pstdat TYPE RANGE OF j_1bpstdat,
        p_jobid  TYPE sysuuid_x16,
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
      gc_subobject TYPE balsubobj VALUE 'NFFORN'.

    DATA:
      "! <p class="shorttext synchronized">Log Handle</p>
      gv_log_handle TYPE balloghndl,
      "! <p class="shorttext synchronized">Estrutura para Tela de Seleção</p>
      gs_screen     TYPE ty_screen,
      "! <p class="shorttext synchronized">Estrutura para JOB</p>
      gs_job        TYPE ztmm_3c_job,
      "! <p class="shorttext synchronized">Tabela principal</p>
      gt_data       TYPE TABLE OF zsmm_dt_entrada_nf,
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
      call_proxy IMPORTING is_data TYPE zsmm_dt_entrada_nf,

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



CLASS ZCLMM_3C_NF_FORNECEDORES IMPLEMENTATION.


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

    SELECT FROM i_br_nfdocument      AS nfdoc

      INNER JOIN i_br_nfitem         AS nfitem
        ON nfitem~br_notafiscal EQ nfdoc~br_notafiscal

      LEFT OUTER JOIN m_v_m2s_pd_itm AS po
        ON po~ebeln EQ nfitem~purchaseorder
       AND po~ebelp EQ nfitem~purchaseorderitem

      LEFT OUTER JOIN i_br_nfeactive AS nfactive
        ON nfactive~br_notafiscal EQ nfdoc~br_notafiscal

      FIELDS nfdoc~br_notafiscal,
             nfdoc~br_nfissuedate,
             nfdoc~br_nfpostingdate,
             nfdoc~br_nfpartner,
             nfdoc~br_nfpartnercnpj,
             nfdoc~br_nfpartnercpf,
             nfdoc~supplierinvoice,
             nfdoc~br_nfseries,

             nfitem~material,
             nfitem~purchaseorder,
             nfitem~purchaseorderitem,
             nfitem~plant,
             nfitem~br_nfsourcedocumentnumber,
             nfitem~br_nfsourcedocumentitem,
             nfitem~br_cfopcode,

             CASE
              WHEN nfdoc~br_nfpartnercnpj NE ' ' THEN nfdoc~br_nfpartnercnpj
              WHEN nfdoc~br_nfpartnercpf  NE ' ' THEN nfdoc~br_nfpartnercpf
             END AS br_nfpartnerdoc,

             po~aedat AS pocreationdate,
             po~menge AS poquantity,

             concat( concat( concat( concat( concat( concat( concat( concat(
               nfactive~region,
               nfactive~br_nfeissueyear ),
               nfactive~br_nfeissuemonth ),
               nfactive~br_nfeaccesskeycnpjorcpf ),
               nfactive~br_nfemodel ),
               nfactive~br_nfeseries ),
               nfactive~br_nfenumber ),
               nfactive~br_nferandomnumber ),
               nfactive~br_nfecheckdigit ) AS acckey,
               concat( concat( nfdoc~br_nfenumber,  '-' ), nfdoc~br_nfseries ) as ref_data,
               nfitem~quantityinbaseunit
      WHERE nfdoc~br_nfpostingdate IN @gs_screen-s_pstdat
        AND nfdoc~br_nfpartnertype EQ 'V'
        AND nfdoc~br_nfiscanceled  EQ @space
        AND nfdoc~br_nfdirection   EQ '1'
        AND nfdoc~br_nfdocumenttype IN ( '1', '2', '6' )

      ORDER BY nfdoc~br_notafiscal

      INTO TABLE @DATA(lt_nf).

    LOOP AT lt_nf ASSIGNING FIELD-SYMBOL(<fs_nf>).
      <fs_nf>-material = CONV matnr18( <fs_nf>-material ).
    ENDLOOP.

    gt_data = CORRESPONDING #( lt_nf
      MAPPING dtlanc          = br_nfpostingdate
              id_material     = material
              chave_nfe       = acckey
              id_fornecedor   = br_nfpartner
              cnpj_fornecedor = br_nfpartnerdoc
              doc_compra      = purchaseorder
              dtdoc           = br_nfissuedate
              qtde_material   = quantityinbaseunit
              centro          = plant
              referencia      = ref_data
              nitem           = br_nfsourcedocumentitem
              cfop            = br_cfopcode ).

  ENDMETHOD.


  METHOD call_proxy.

    TRY.
        NEW zclmm_co_enviar_entrada_nf_out( )->si_enviar_entrada_nfout(
          VALUE #( mt_entrada_nf = is_data ) ).
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
      WHERE jobname   EQ 'JOB_NF_FORNECEDORES'
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
          jobname               = |JOB_NF_FORNECEDORES|
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
