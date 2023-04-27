CLASS zclmm_3c_nf_faturada_events DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES ty_key TYPE zi_mm_3c_nf_faturada .
    TYPES: ty_t_key TYPE STANDARD TABLE OF ty_key .

    TYPES: ty_r_data   TYPE RANGE OF logbr_docdat,
           ty_r_cnpj_e TYPE RANGE OF logbr_nfpartnercnpj,
           ty_r_cnpj_d TYPE RANGE OF logbr_cnpj_bupla.

    CONSTANTS:
      BEGIN OF gc_doctype,
        nfe TYPE zi_mm_3c_nf_faturada-doctype VALUE '1',
        cte TYPE zi_mm_3c_nf_faturada-doctype VALUE '2',
      END OF gc_doctype .

    "! Recupera o XML de cada documento e adiciona no .ZIP
    "! @parameter it_key | Tabela de chaves
    "! @parameter ev_filename | Nome do arquivo
    "! @parameter ev_file | Arquivo
    "! @parameter ev_mimetype | Extensão do arquivo
    "! @parameter et_return | Mensagens de retorno
    METHODS build_xml_zip
      IMPORTING
        !it_key      TYPE ty_t_key
      EXPORTING
        !ev_filename TYPE string
        !ev_file     TYPE xstring
        !ev_mimetype TYPE skwf_mime
        !et_return   TYPE bapiret2_t .
    "! Salva o arquivo .ZIP no servidor
    "! @parameter iv_filename | Nome do arquivo
    "! @parameter iv_file | Arquivo
    "! @parameter iv_mimetype | Extensão do arquivo
    "! @parameter et_return | Mensagens de retorno
    METHODS save_file_to_server
      IMPORTING
        !iv_filename TYPE string
        !iv_file     TYPE xstring
        !iv_mimetype TYPE skwf_mime
        !iv_path     TYPE ze_trm_filename OPTIONAL
        !iv_dest     TYPE char1 OPTIONAL
      EXPORTING
        !et_return   TYPE bapiret2_t .
    "! Formata as mensages de retorno
    "! @parameter ct_return | Mensagens de retorno
    METHODS format_return
      CHANGING
        !ct_return TYPE bapiret2_t .
    METHODS execute_job
      IMPORTING
        !iv_tipo         TYPE ze_mm_3c_doc_type
        !ir_data         TYPE ty_r_data
        !ir_cnpj_e       TYPE ty_r_cnpj_e
        !ir_cnpj_d       TYPE ty_r_cnpj_d
        !iv_nfe          TYPE logbr_nfnum9
        !iv_chave        TYPE /xnfe/id
        !iv_path         TYPE ze_trm_filename
        !iv_dest         TYPE char1
      RETURNING
        VALUE(rt_return) TYPE bapiret2_t .
  PROTECTED SECTION.
private section.

  data GT_XMLS type TY_T_KEY .

  methods GET_DATA_JOB
    importing
      !IV_TIPO type ZE_MM_3C_DOC_TYPE
      !IR_DATA type TY_R_DATA
      !IR_CNPJ_E type TY_R_CNPJ_E
      !IR_CNPJ_D type TY_R_CNPJ_D
      !IV_NFE type LOGBR_NFNUM9
      !IV_CHAVE type /XNFE/ID
    returning
      value(RT_RETURN) type BAPIRET2_T .
  methods PROCESS_DATA_JOB
    importing
      !IV_PATH type ZE_TRM_FILENAME
      !IV_DEST type CHAR1 optional
    returning
      value(RT_RETURN) type BAPIRET2_T .
ENDCLASS.



CLASS ZCLMM_3C_NF_FATURADA_EVENTS IMPLEMENTATION.


  METHOD build_xml_zip.

    DATA: lo_zipper       TYPE REF TO cl_abap_zip.

    FREE: ev_filename, ev_file, ev_mimetype, et_return.

* ----------------------------------------------------------------------
* Recupera os arquivos XML
* ----------------------------------------------------------------------
    IF it_key[] IS NOT INITIAL.

      SELECT NumRegistro, Doctype, Guid, Filename, FileCteXml, FileNfeXml, FileEventCteXml, FileEventNfeXml
          FROM zi_mm_3c_nf_faturada
          FOR ALL ENTRIES IN @it_key
          WHERE NumRegistro = @it_key-NumRegistro
            AND Doctype       = @it_key-Doctype
            AND Guid          = @it_key-Guid
          INTO TABLE @DATA(lt_nf).

      IF sy-subrc NE 0.
        " Nenhum XML encontrado para as chaves informadas.
        et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_3C_NF_FATURADA' number = '001' ) ).
        RETURN.
      ENDIF.
    ENDIF.

* ----------------------------------------------------------------------
* Existem Documentos com mesmo GUID. Mantemos apenas o Documento mais recente
* ----------------------------------------------------------------------
    SORT lt_nf BY guid ASCENDING NumRegistro DESCENDING.
    DELETE ADJACENT DUPLICATES FROM lt_nf COMPARING guid.

* ----------------------------------------------------------------------
* Adiciona cada arquivo XML no ZIP
* ----------------------------------------------------------------------
    CREATE OBJECT lo_zipper.

    LOOP AT lt_nf REFERENCE INTO DATA(ls_nf).

      IF ev_filename IS INITIAL.
        " Nome do arquivo
        ev_filename = COND #( WHEN ls_nf->Doctype = gc_doctype-nfe THEN |INNFE_{ sy-datum }{ sy-uzeit }.zip|
                                                                   ELSE |INCTE_{ sy-datum }{ sy-uzeit }.zip| ).
      ENDIF.

      " Adiciona arquivo no .ZIP
      lo_zipper->add( EXPORTING  name           = CONV #( ls_nf->Filename )
                                 content        = COND #( WHEN ls_nf->FileCteXml IS NOT INITIAL
                                                            THEN ls_nf->FileCteXml
                                                          WHEN ls_nf->FileEventCteXml IS NOT INITIAL
                                                            THEN ls_nf->FileEventCteXml
                                                          WHEN ls_nf->FileNfeXml IS NOT INITIAL
                                                            THEN ls_nf->FileNfeXml
                                                          WHEN ls_nf->FileEventNfeXml IS NOT INITIAL
                                                            THEN ls_nf->FileEventNfeXml ) ).
    ENDLOOP.

    " Recupera Arquivo
    ev_file     = lo_zipper->save( ).

* ----------------------------------------------------------------------
* Recupera Mimetype
* ----------------------------------------------------------------------
    CALL FUNCTION 'SDOK_MIMETYPE_GET'
      EXPORTING
        extension = 'ZIP'
      IMPORTING
        mimetype  = ev_mimetype.

  ENDMETHOD.


  METHOD save_file_to_server.

    DATA: lt_data     TYPE STANDARD TABLE OF x255,
          lv_filesize TYPE i,
          lv_length   TYPE i,
          lv_filename TYPE string.

    FREE: et_return.

    CASE iv_dest.

      WHEN 'S'.

        IF iv_path IS NOT INITIAL.

          DATA(lv_path) = iv_path.

        ELSE.

          " Recupera diretório do servidor, configurado na tabela de parâmetros
          SELECT SINGLE ServerFolder
              FROM zi_mm_3c_vh_pasta_servidor
              INTO @lv_path.

          IF sy-subrc NE 0.
            " Nenhum diretório de servidor cadastrado no parâmetro: &1 / &2 / &3
            et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_3C_NF_FATURADA' number = '008'
                                      message_v1 = 'MM' message_v2 = '3COLLABORATION' message_v3 = 'PASTASERV' ) ).
            me->format_return( CHANGING ct_return = et_return ).
            RETURN.
          ENDIF.
        ENDIF.

        lv_filename = lv_path && iv_filename.

        OPEN DATASET lv_filename FOR OUTPUT IN BINARY MODE.

        IF sy-subrc NE 0.
          "Erro ao copiar arquivo para pasta de destino
          et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_3C_NF_FATURADA' number = '006' ) ).
          me->format_return( CHANGING ct_return = et_return ).
          RETURN.
        ENDIF.

        TRANSFER iv_file TO lv_filename.

        CLOSE DATASET lv_filename.

      WHEN 'L'.

        lv_filename = iv_path && iv_filename.

        CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
          EXPORTING
            buffer        = iv_file
          IMPORTING
            output_length = lv_length
          TABLES
            binary_tab    = lt_data.

        cl_gui_frontend_services=>gui_download(
              EXPORTING
                bin_filesize              = lv_length
                filename                  = lv_filename
                filetype                  = 'BIN'
              IMPORTING
                filelength                = lv_filesize
              CHANGING
                data_tab                  = lt_data
              EXCEPTIONS
                file_write_error          = 1
                no_batch                  = 2
                gui_refuse_filetransfer   = 3
                invalid_type              = 4
                no_authority              = 5
                unknown_error             = 6
                header_not_allowed        = 7
                separator_not_allowed     = 8
                filesize_not_allowed      = 9
                header_too_long           = 10
                dp_error_create           = 11
                dp_error_send             = 12
                dp_error_write            = 13
                unknown_dp_error          = 14
                access_denied             = 15
                dp_out_of_memory          = 16
                disk_full                 = 17
                dp_timeout                = 18
                file_not_found            = 19
                dataprovider_exception    = 20
                control_flush_error       = 21
                not_supported_by_gui      = 22
                error_no_gui              = 23
                OTHERS                    = 24 ).

        IF sy-subrc IS NOT INITIAL.
          et_return = VALUE #( BASE et_return ( type = sy-msgty
                                                id = sy-msgid
                                                number = sy-msgno
                                                message_v1 = sy-msgv1
                                                message_v2 = sy-msgv2
                                                message_v3 = sy-msgv3
                                                message_v4 = sy-msgv4 ) ).
          RETURN.
        ENDIF.
    ENDCASE.

    " Arquivo &1 salvo com sucesso no servidor.
    et_return = VALUE #( BASE et_return ( type = 'S' id = 'ZMM_3C_NF_FATURADA' number = '004' message_v1 = iv_filename ) ).
    me->format_return( CHANGING ct_return = et_return ).

  ENDMETHOD.


  METHOD format_return.

    DATA: ls_return_format TYPE bapiret2.

* ---------------------------------------------------------------------------
* Formata mensagens de retorno
* ---------------------------------------------------------------------------
    LOOP AT ct_return REFERENCE INTO DATA(ls_return).

      IF  ls_return->message IS INITIAL.

        TRY.
            CALL FUNCTION 'FORMAT_MESSAGE'
              EXPORTING
                id        = ls_Return->id
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

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD execute_job.

    rt_return = get_data_job( EXPORTING iv_tipo   = iv_tipo
                                        ir_data   = ir_data
                                        ir_cnpj_e = ir_cnpj_e
                                        ir_cnpj_d = ir_cnpj_d
                                        iv_nfe    = iv_nfe
                                        iv_chave  = iv_chave ).
    IF gt_xmls IS NOT INITIAL.
      rt_return = process_data_job( EXPORTING iv_path = iv_path
                                              iv_dest = iv_dest  ).
    ENDIF.

  ENDMETHOD.


  METHOD get_data_job.

    DATA: lv_where TYPE string.

    lv_where = 'doctype = @iv_tipo'.

    IF ir_data[] IS NOT INITIAL.
      lv_where = |{ lv_where } AND DtDocumento IN @ir_data|.
    ENDIF.

    IF ir_cnpj_d[] IS NOT INITIAL.
      lv_where = |{ lv_where } AND CNPJDestinatario IN @ir_cnpj_d|.
    ENDIF.

    IF ir_cnpj_e[] IS NOT INITIAL.
      lv_where = |{ lv_where } AND CNPJEmissor IN @ir_cnpj_e|.
    ENDIF.

    IF iv_nfe IS NOT INITIAL.
      lv_where = |{ lv_where } AND br_nfenumber = @iv_nfe|.
    ENDIF.

    IF iv_chave IS NOT INITIAL.
      lv_where = |{ lv_where } AND accesskey = @iv_chave|.
    ENDIF.

    SELECT *
      FROM zi_mm_3c_nf_faturada
     WHERE (lv_where)
      INTO TABLE @gt_xmls.

    IF sy-subrc IS INITIAL.
      SORT gt_xmls BY DtDocumento.
    ELSE.
      rt_return = VALUE #( BASE rt_return ( type = 'E' id = 'ZMM_3C_NF_FATURADA' number = '007' ) ).
    ENDIF.

  ENDMETHOD.


  METHOD process_data_job.

    build_xml_zip(  EXPORTING it_key        = gt_xmls
                    IMPORTING ev_filename   = DATA(lv_filename)
                              ev_file       = DATA(lv_file)
                              ev_mimetype   = DATA(lv_mimetype)
                              et_return     = rt_return ).

    IF rt_return IS INITIAL.

      save_file_to_server( EXPORTING iv_filename    = lv_filename
                                     iv_file        = lv_file
                                     iv_mimetype    = lv_mimetype
                                     iv_path        = iv_path
                                     iv_dest        = iv_dest
                           IMPORTING et_return      = rt_return ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
