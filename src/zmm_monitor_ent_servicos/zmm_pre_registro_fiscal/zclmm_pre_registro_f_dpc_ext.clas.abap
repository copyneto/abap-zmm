class ZCLMM_PRE_REGISTRO_F_DPC_EXT definition
  public
  inheriting from ZCLMM_PRE_REGISTRO_F_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_STREAM
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_STREAM
    redefinition .
protected section.

  methods PDFURLSET_GET_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCLMM_PRE_REGISTRO_F_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_stream.

    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception.

*    TYPES:
*      BEGIN OF ty_anexo_nf,
*        NrNf    TYPE ztmm_anexo_nf-nr_nf,
*        CnpjCpf TYPE ztmm_anexo_nf-cnpj_cpf,
*      END OF ty_anexo_nf.
*
*    DATA ls_anexo TYPE ty_anexo_nf.

    DATA ls_anexo TYPE ztmm_anexo_nf.

    DATA: lv_nome_arq TYPE rsfilenm,
          lv_guid     TYPE guid_16.

    DATA lv_mime_type TYPE char100 VALUE 'application/pdf'.


    io_tech_request_context->get_converted_source_keys(
      IMPORTING
        es_key_values = ls_anexo ).

    DATA(lt_key) = io_tech_request_context->get_source_keys( ).

    LOOP AT lt_key ASSIGNING FIELD-SYMBOL(<fs_key>).

      CASE <fs_key>-name.
        WHEN 'NRNF'.
          ls_anexo-nr_nf = <fs_key>-value.

        WHEN 'CNPJCPF'.
          ls_anexo-cnpj_cpf = <fs_key>-value.

        WHEN OTHERS.
      ENDCASE.

    ENDLOOP.

    DATA(lo_object) = NEW zclmm_anexo_monit_serv( ).

    lo_object->anexar( EXPORTING iv_filename = iv_slug
                                 is_media    = is_media_resource
                                 is_key      = ls_anexo
                       IMPORTING ev_linha    = ls_anexo-linha
                                 et_return   = DATA(lt_return) ).

    copy_data_to_ref( EXPORTING is_data = ls_anexo
                      CHANGING  cr_data = er_entity ).

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


    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception,
          ls_stream    TYPE ty_s_media_resource,
          ls_lheader   TYPE ihttpnvp,
          lv_extension TYPE char40.

    CASE iv_entity_name.

* ===========================================================================
* Gerencia Botão do aplicativo "Download"
* ===========================================================================
      WHEN gc_entity-download.

        DATA(lt_read_key) = IT_KEY_tAB.

        SORT lt_read_key BY name.
        READ TABLE lt_read_key INTO DATA(lv_id)
          WITH KEY name = gc_fields-id BINARY SEARCH.
        IF sy-subrc NE 0.
          RETURN.
        ENDIF.

* ----------------------------------------------------------------------
* Recupera arquivo de layout
* ----------------------------------------------------------------------
        zclpp_planejamento_producao=>download_arquivo( EXPORTING iv_id       = lv_id
                                                       IMPORTING ev_filename = DATA(lv_filename)
                                                                 ev_file     = DATA(lv_file)
                                                                 ev_mimetype = DATA(lv_mimetype)
                                                                 et_return   = DATA(lt_return) ).

      WHEN OTHERS.
        RETURN.

    ENDCASE.

* ----------------------------------------------------------------------
* Retorna binário do arquivo
* ----------------------------------------------------------------------
    ls_stream-mime_type = lv_mimetype.
    ls_stream-value     = lv_file.

    copy_data_to_ref( EXPORTING is_data = ls_stream
                      CHANGING  cr_data = er_stream ).

* ----------------------------------------------------------------------
* Muda nome do arquivo
* ----------------------------------------------------------------------
* Tipo comportamento:
* - inline : Não fará download automático
* - outline: Download automático
* ----------------------------------------------------------------------
    ls_lheader-name  = |Content-Disposition| ##NO_TEXT.
    ls_lheader-value = |outline; filename="{ lv_filename }";| ##NO_TEXT.

    set_header( is_header = ls_lheader ).

* ----------------------------------------------------------------------
* Ativa exceção em casos de erro
* ----------------------------------------------------------------------
    IF lt_return[] IS NOT INITIAL.
      lo_message = mo_context->get_message_container( ).
      lo_message->add_messages_from_bapi( it_bapi_messages = lt_return ).
      CREATE OBJECT lo_exception EXPORTING message_container = lo_message.
      RAISE EXCEPTION lo_exception.
    ENDIF.



  ENDMETHOD.


  METHOD pdfurlset_get_entity.

    DATA: lt_sorted_keys TYPE SORTED TABLE OF /iwbep/s_mgw_tech_pair  WITH UNIQUE KEY name,
          lt_return      TYPE bapiret2_t.

    DATA: ls_campos_chave TYPE zsmm_mntserv_anexo_key.

    CASE iv_entity_name.

      WHEN 'PdfURL'.
        TRY.
            DATA(lt_keys) = io_tech_request_context->get_keys( ).
            lt_sorted_keys = lt_keys.
          CATCH cx_root.
        ENDTRY.

        ls_campos_chave = VALUE zsmm_mntserv_anexo_key(
                                   nr_nf    =  lt_sorted_keys[ name = 'NR_NF' ]-value
                                   cnpj_cpf =  lt_sorted_keys[ name = 'CNPJ_CPF' ]-value
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

*        SELECT SINGLE value
*          FROM ztfi_cont_anexo
*          WHERE doc_uuid_h = '005056B095991EDC9AA917165F3BA306'
*            AND contrato = '00010'
*            AND aditivo = '00010'
*          AND doc_uuid_doc = '005056B095991EDC9C97EDCF7B22B5A4'
*          INTO @DATA(lv_binr).

        IF sy-subrc IS INITIAL.
          er_entity-url = NEW zclca_pdf_url( ls_anexo-conteudo )->gerar_url( ).
        ENDIF.

      WHEN OTHERS.

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
