class ZCLMM_MONITOR_SERVIC_DPC_EXT definition
  public
  inheriting from ZCLMM_MONITOR_SERVIC_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_STREAM
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_STREAM
    redefinition .
protected section.

  methods GETLINESSET_GET_ENTITY
    redefinition .
  methods PDFURLSET_GET_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCLMM_MONITOR_SERVIC_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_stream.

    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception.

    DATA ls_anexo TYPE ztmm_anexo_nf.

    io_tech_request_context->get_converted_source_keys(
      IMPORTING
        es_key_values = ls_anexo ).

    DATA(lo_object) = NEW zclmm_anexo_monit_serv( ).

    lo_object->anexar( EXPORTING iv_filename = iv_slug
                                 is_media    = is_media_resource
                                 is_key      = ls_anexo
                       IMPORTING ev_linha    = ls_anexo-linha
                                 et_return   = DATA(lt_return) ).

    copy_data_to_ref( EXPORTING is_data = ls_anexo
                       CHANGING cr_data = er_entity ).

*----------------------------------------------------------------------
*Ativa exceção em casos de erro
*----------------------------------------------------------------------
    IF lt_return[] IS NOT INITIAL.
      lo_message = mo_context->get_message_container( ).
      lo_message->add_messages_from_bapi( it_bapi_messages = lt_return ).
      CREATE OBJECT lo_exception EXPORTING message_container = lo_message.
      RAISE EXCEPTION lo_exception.
    ENDIF.

  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_stream.

    DATA: lo_fp     TYPE REF TO if_fp,
          lo_pdfobj TYPE REF TO if_fp_pdf_object.

    DATA: lt_return      TYPE bapiret2_t,
          ls_stream      TYPE ty_s_media_resource,
          ls_lheader     TYPE ihttpnvp,
          ls_meta        TYPE sfpmetadata,
          lt_sorted_keys TYPE SORTED TABLE OF /iwbep/s_mgw_tech_pair  WITH UNIQUE KEY name.

    DATA: ls_campos_chave TYPE zsmm_mntserv_anexo_key.

    CONSTANTS: lc_inlinefln  TYPE string    VALUE 'inline; filename="',
               lc_outlinefln TYPE string    VALUE 'outline; filename="',
               lc_finl       TYPE string    VALUE '";',
               lc_param1     TYPE fieldname VALUE 'NR_NF',
               lc_param2     TYPE fieldname VALUE 'CNPJ_CPF',
               lc_param3     TYPE fieldname VALUE 'LINHA',
               lc_objct_ads  TYPE rfcdest   VALUE 'ADS'.

    CASE iv_entity_name.
      WHEN 'ShowPDF'.
        TRY.
            DATA(lt_keys) = io_tech_request_context->get_keys( ).
            lt_sorted_keys = lt_keys.
          CATCH cx_root.
        ENDTRY.

        ls_campos_chave = VALUE zsmm_mntserv_anexo_key(
                                   nr_nf    =  lt_sorted_keys[ name = lc_param1 ]-value
                                   cnpj_cpf =  lt_sorted_keys[ name = lc_param2 ]-value
                                   linha    =  lt_sorted_keys[ name = lc_param3 ]-value ).

        SELECT SINGLE nr_nf,
                      cnpj_cpf,
                      linha,
                      filename,
                      mimetype,
                      conteudo
          FROM ztmm_anexo_nf
         WHERE nr_nf    = @ls_campos_chave-nr_nf
           AND cnpj_cpf = @ls_campos_chave-cnpj_cpf
           AND linha    = @ls_campos_chave-linha
          INTO @DATA(ls_anexo).

* ----------------------------------------------------------------------
* Atualizar Metadata ao arquivo
* ----------------------------------------------------------------------
        TRY. " Create PDF Object.
            lo_fp = cl_fp=>get_reference( ).
            lo_pdfobj = lo_fp->create_pdf_object( connection = lc_objct_ads ).
            lo_pdfobj->set_document( pdfdata = ls_anexo-conteudo ).

            " Nome do arquivo
            ls_meta-title = ls_anexo-filename.
            lo_pdfobj->set_metadata( metadata = ls_meta ).
            lo_pdfobj->execute( ).

            "Get the PDF content back with title
            lo_pdfobj->get_document( IMPORTING pdfdata = ls_anexo-conteudo ).
          CATCH cx_root.
        ENDTRY.

* ----------------------------------------------------------------------
* Muda nome do arquivo
* ----------------------------------------------------------------------
* Tipo comportamento:
* - inline: Não fará download automático
* - outline: Download automático
* ----------------------------------------------------------------------
        ls_lheader-name = TEXT-t01. " Content-Disposition
        ls_lheader-value = lc_inlinefln && ls_anexo-filename && lc_finl.

        set_header( is_header = ls_lheader ).

        ls_stream-mime_type = ls_anexo-mimetype.
        ls_stream-value     = ls_anexo-conteudo.

        copy_data_to_ref( EXPORTING is_data = ls_stream
                           CHANGING cr_data = er_stream ).

      WHEN 'Anexo'.
        TRY.
            lt_keys = io_tech_request_context->get_keys( ).
            lt_sorted_keys = lt_keys.
          CATCH cx_root.
        ENDTRY.

        ls_campos_chave = VALUE zsmm_mntserv_anexo_key(
                                   nr_nf    =  lt_sorted_keys[ name = lc_param1 ]-value
                                   cnpj_cpf =  lt_sorted_keys[ name = lc_param2 ]-value
                                   linha    =  lt_sorted_keys[ name = lc_param3 ]-value ).

        SELECT SINGLE nr_nf,
                      cnpj_cpf,
                      linha,
                      filename,
                      mimetype,
                      conteudo
          FROM ztmm_anexo_nf
         WHERE nr_nf    = @ls_campos_chave-nr_nf
           AND cnpj_cpf = @ls_campos_chave-cnpj_cpf
           AND linha    = @ls_campos_chave-linha
          INTO @ls_anexo.

** ----------------------------------------------------------------------
** Atualizar Metadata ao arquivo
** ----------------------------------------------------------------------
*        TRY. "Create PDF Object.
*            lo_fp = cl_fp=>get_reference( ).
*            lo_pdfobj = lo_fp->create_pdf_object( connection = 'ADS' ).
*            lo_pdfobj->set_document( pdfdata = lv_binr ).
*
*            "Set PDF title name.
*            ls_meta-title = 'File'.
*            lo_pdfobj->set_metadata( metadata = ls_meta ).
*            lo_pdfobj->execute( ).
*
*            "Get the PDF content back with title
*            lo_pdfobj->get_document( IMPORTING pdfdata = lv_binr ).
*          CATCH cx_root.
*        ENDTRY.

* ----------------------------------------------------------------------
* Muda nome do arquivo
* ----------------------------------------------------------------------
* Tipo comportamento:
* - inline: Não fará download automático
* - outline: Download automático
* ----------------------------------------------------------------------
        ls_lheader-name = TEXT-t01.
        ls_lheader-value = lc_outlinefln && ls_anexo-filename && lc_finl.

        set_header( is_header = ls_lheader ).

        ls_stream-mime_type = ls_anexo-mimetype.
        ls_stream-value     = ls_anexo-conteudo.

        copy_data_to_ref( EXPORTING is_data = ls_stream
                           CHANGING cr_data = er_stream ).

      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.


  METHOD getlinesset_get_entity.

    DATA: lt_sorted_keys TYPE SORTED TABLE OF /iwbep/s_mgw_tech_pair  WITH UNIQUE KEY name,
          lt_return      TYPE bapiret2_t.

    DATA: ls_campos_chave TYPE zsmm_mntserv_anexo_key.

    CASE iv_entity_name.
      WHEN 'GetLines'.

        TRY.
            DATA(lt_keys) = io_tech_request_context->get_keys( ).
            lt_sorted_keys = lt_keys.
          CATCH cx_root.
        ENDTRY.

        ls_campos_chave = VALUE zsmm_mntserv_anexo_key(
                                   nr_nf    =  lt_sorted_keys[ name = 'NR_NF' ]-value
                                   cnpj_cpf =  lt_sorted_keys[ name = 'CNPJ_CPF' ]-value ).

        SELECT nr_nf,
               cnpj_cpf,
               linha
          FROM ztmm_anexo_nf
         WHERE nr_nf    = @ls_campos_chave-nr_nf
           AND cnpj_cpf = @ls_campos_chave-cnpj_cpf
          INTO TABLE @DATA(lt_anexo).

        IF sy-subrc IS INITIAL.
          LOOP AT lt_anexo ASSIGNING FIELD-SYMBOL(<fs_anexo>).

            IF sy-tabix = 1.
              er_entity-lines = <fs_anexo>-linha.
            ELSE.
              er_entity-lines = |{ er_entity-lines }{ ';' }{ <fs_anexo>-linha }|.
            ENDIF.

          ENDLOOP.

          er_entity-nr_nf    = ls_campos_chave-nr_nf.
          er_entity-cnpj_cpf = ls_campos_chave-cnpj_cpf.
        ENDIF.

      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.


  METHOD pdfurlset_get_entity.

    DATA: lt_sorted_keys TYPE SORTED TABLE OF /iwbep/s_mgw_tech_pair  WITH UNIQUE KEY name,
          lt_return      TYPE bapiret2_t.

    DATA: ls_campos_chave TYPE zsmm_mntserv_anexo_key.

    CASE iv_entity_name.
      WHEN 'Pdfurl'.
        TRY.
            DATA(lt_keys) = io_tech_request_context->get_keys( ).
            lt_sorted_keys = lt_keys.
          CATCH cx_root.
        ENDTRY.

        ls_campos_chave = VALUE zsmm_mntserv_anexo_key(
                                   nr_nf    =  lt_sorted_keys[ name = 'NR_NF' ]-value
                                   cnpj_cpf =  lt_sorted_keys[ name = 'CNPJ_CPF' ]-value
                                   linha    =  lt_sorted_keys[ name = 'LINHA' ]-value
                                   ).

        SELECT SINGLE nr_nf,
                      cnpj_cpf,
                      linha,
                      conteudo
          FROM ztmm_anexo_nf
         WHERE nr_nf    = @ls_campos_chave-nr_nf
           AND cnpj_cpf = @ls_campos_chave-cnpj_cpf
           AND linha    = @ls_campos_chave-linha
          INTO @DATA(ls_anexo).

        IF sy-subrc IS INITIAL.
          er_entity-url = NEW zclca_pdf_url( ls_anexo-conteudo )->gerar_url( ).
        ENDIF.

      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
