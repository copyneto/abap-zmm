CLASS zclmm_3c_nf_faturada_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zclmm_3c_nf_faturada_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS /iwbep/if_mgw_appl_srv_runtime~get_stream
        REDEFINITION .

  PROTECTED SECTION.

    METHODS serverdownloadse_get_entityset
        REDEFINITION.

  PRIVATE SECTION.
ENDCLASS.



CLASS zclmm_3c_nf_faturada_dpc_ext IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_stream.

    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception,
          lt_key       TYPE zclmm_3c_nf_faturada_events=>ty_t_key,
          ls_header    TYPE ihttpnvp,
          ls_stream    TYPE ty_s_media_resource,
          lt_return    TYPE bapiret2_t.

* ----------------------------------------------------------------------
* Recuper as chaves
* ----------------------------------------------------------------------
    TRY.
        DATA(lv_docnum)  = VALUE #( it_key_tab[ name = gc_fields-docnum ]-value ). "#EC CI_STDSEQ
        DATA(lv_doctype) = VALUE #( it_key_tab[ name = gc_fields-doctype ]-value ). "#EC CI_STDSEQ
        DATA(lv_guid)    = VALUE #( it_key_tab[ name = gc_fields-guid ]-value ). "#EC CI_STDSEQ
      CATCH cx_root.
        " Erro ao buscar chave informada.
        lt_return = VALUE #( BASE lt_return ( type = 'E' id = 'ZMM_3C_NF_FATURADA' number = '003' ) ).
    ENDTRY.

    SPLIT lv_docnum  AT ';' INTO TABLE DATA(lt_docnum).
    SPLIT lv_doctype AT ';' INTO TABLE DATA(lt_doctype).
    SPLIT lv_guid    AT ';' INTO TABLE DATA(lt_guid).

    TRY.
        DO lines( lt_docnum ) TIMES.
          DATA(lv_index) = sy-index.
          lt_key[] = VALUE #( BASE lt_key ( NumRegistro = lt_docnum[ lv_index ]
                                            Doctype       = lt_doctype[ lv_index ]
                                            Guid          = cl_soap_wsrmb_helper=>convert_uuid_hyphened_to_raw( lt_guid[ lv_index ] ) ) ).

        ENDDO.
      CATCH cx_root.
    ENDTRY.

* ----------------------------------------------------------------------
* Monta o arquivo ZIP com os XMLs
* ----------------------------------------------------------------------
    DATA(lo_xml) = NEW zclmm_3c_nf_faturada_events( ).

    IF lt_return IS INITIAL.

      lo_xml->build_xml_zip( EXPORTING it_key      = lt_key
                             IMPORTING ev_filename = DATA(lv_filename)
                                       ev_file     = DATA(lv_file)
                                       ev_mimetype = DATA(lv_mimetype)
                                       et_return   = lt_return ).
    ENDIF.

* ----------------------------------------------------------------------
* Tipo comportamento:
* - inline: Não fará download automático
* - outline: Download automático
* ----------------------------------------------------------------------
    ls_header-name  = |Content-Disposition| ##NO_TEXT.
    ls_header-value = |outline; filename="{ lv_filename }";|.

    set_header( is_header = ls_header ).

* ----------------------------------------------------------------------
* Retorna binário do PDF
* ----------------------------------------------------------------------
    ls_stream-mime_type = lv_mimetype.
    ls_stream-value     = lv_file.

    copy_data_to_ref( EXPORTING is_data = ls_stream
                      CHANGING  cr_data = er_stream ).

** ----------------------------------------------------------------------
** Ativa exceção em casos de erro
** ----------------------------------------------------------------------
    IF line_exists( lt_return[ type = 'E' ] ).           "#EC CI_STDSEQ
      lo_message = mo_context->get_message_container( ).
      lo_message->add_messages_from_bapi( it_bapi_messages = lt_return ).
      CREATE OBJECT lo_exception EXPORTING message_container = lo_message.
      RAISE EXCEPTION lo_exception.
    ENDIF.

  ENDMETHOD.


  METHOD serverdownloadse_get_entityset.

    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception,
          lt_key       TYPE zclmm_3c_nf_faturada_events=>ty_t_key,
          lt_return    TYPE bapiret2_t,
          ls_cockpit   TYPE zi_tm_cockpit001,
          lv_acckey    TYPE zttm_gkot001-acckey.

    DATA(lo_file) = NEW zcltm_atc_folder_fo( ).

* ----------------------------------------------------------------------
* Recupera filtro de seleção
* ----------------------------------------------------------------------
    DATA(lt_filter) =  io_tech_request_context->get_filter( )->get_filter_select_options( ).

    TRY.
        DO lines( lt_filter[ property = gc_fields_u-docnum ]-select_options ) TIMES.

          DATA(lv_index) = sy-index.
          lt_key[] = VALUE #( BASE lt_key ( NumRegistro   = lt_filter[ property = gc_fields_u-docnum ]-select_options[ lv_index ]-low
                                            Doctype       = lt_filter[ property = gc_fields_u-doctype ]-select_options[ lv_index ]-low
                                            Guid          = cl_soap_wsrmb_helper=>convert_uuid_hyphened_to_raw( lt_filter[ property = gc_fields_u-guid ]-select_options[ lv_index ]-low ) ) ).
        ENDDO.
      CATCH cx_root.
        " Erro ao buscar chave informada.
        lt_return = VALUE #( BASE lt_return ( type = 'E' id = 'ZMM_3C_NF_FATURADA' number = '003' ) ).
    ENDTRY.

* ----------------------------------------------------------------------
* Monta o arquivo ZIP com os XMLs
* ----------------------------------------------------------------------
    DATA(lo_xml) = NEW zclmm_3c_nf_faturada_events( ).

    IF lt_return IS INITIAL.

      lo_xml->build_xml_zip( EXPORTING it_key      = lt_key
                             IMPORTING ev_filename = DATA(lv_filename)
                                       ev_file     = DATA(lv_file)
                                       ev_mimetype = DATA(lv_mimetype)
                                       et_return   = lt_return ).
    ENDIF.

    IF lt_return IS INITIAL.
      lo_xml->save_file_to_server( EXPORTING iv_filename = lv_filename
                                             iv_file     = lv_file
                                             iv_mimetype = lv_mimetype
                                             iv_dest     = 'S'
                                   IMPORTING et_return   = lt_return ).

    ENDIF.

* ----------------------------------------------------------------------
* Recupera mensagem de retorno
* ----------------------------------------------------------------------
    TRY.
        et_entityset[] = VALUE #( ( docnum  = lt_key[ 1 ]-NumRegistro
                                    doctype = lt_key[ 1 ]-Doctype
                                    guid    = lt_key[ 1 ]-Guid
                                    message = lt_return[ type = 'S' ]-message ) ).
      CATCH cx_root.
    ENDTRY.

* ----------------------------------------------------------------------
* Ativa exceção em casos de erro
* ----------------------------------------------------------------------
    IF line_exists( lt_return[ type = 'E' ] ).           "#EC CI_STDSEQ
      lo_message = mo_context->get_message_container( ).
      lo_message->add_messages_from_bapi( it_bapi_messages = lt_return ).
      CREATE OBJECT lo_exception EXPORTING message_container = lo_message.
      RAISE EXCEPTION lo_exception.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
