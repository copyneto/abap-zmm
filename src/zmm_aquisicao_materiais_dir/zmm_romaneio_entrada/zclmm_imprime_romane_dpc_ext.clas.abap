CLASS zclmm_imprime_romane_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zclmm_imprime_romane_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS /iwbep/if_mgw_appl_srv_runtime~get_stream
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclmm_imprime_romane_dpc_ext IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_stream.

    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception,
          lt_key_tab   TYPE ty_t_key_tab,
          lt_key_rom   TYPE zctgmm_romaneio_key,
          ls_header    TYPE ihttpnvp,
          ls_stream    TYPE ty_s_media_resource,
          lv_filename	 TYPE string,
          lv_nfeid     TYPE /xnfe/innfehd-nfeid.

    lt_key_tab = it_key_tab[].

    CASE iv_entity_name.
* ----------------------------------------------------------------------
* Entidade responsável pelo envio do binário do arquivo
* ----------------------------------------------------------------------
      WHEN gc_entity-imprimir.
        DATA(lv_romaneio) = CONV ze_romaneio( |{ lt_key_tab[ name = gc_name-romaneio ]-value WIDTH = 10 ALIGN = RIGHT PAD = '0' }| ).
        TRY.
            lt_key_rom = VALUE #( ( romaneio = lv_romaneio ) ).
          CATCH cx_root.
        ENDTRY.

        DATA(lo_object) = NEW zclmm_proc_ordem_descarga( ).

        lo_object->status_andamnt( it_key_rom = lt_key_rom ).

        lo_object->gera_pdf( EXPORTING it_key_rom   = lt_key_rom
                             IMPORTING ev_filename  = lv_filename
                                       ev_file      = DATA(lv_file)
                                       et_return    = DATA(lt_return) ).

        IF lv_file IS NOT INITIAL.

          " ----------------------------------------------------------------------
          " Muda nome do arquivo
          " ----------------------------------------------------------------------
          " Tipo comportamento:
          " - inline: Não fará download automático
          " - outline: Download automático
          " ----------------------------------------------------------------------

          ls_header-name  = |Content-Disposition|.
          ls_header-value = |outline; filename="{ lv_filename }";|.

          set_header( is_header = ls_header ).

          " ----------------------------------------------------------------------
          " Retorna binário do XML
          " ----------------------------------------------------------------------
          ls_stream-mime_type = 'application/pdf'.
          ls_stream-value     = lv_file.

          copy_data_to_ref( EXPORTING is_data = ls_stream
                            CHANGING  cr_data = er_stream ).

        ENDIF.

      WHEN OTHERS.
    ENDCASE.

** ----------------------------------------------------------------------
** Ativa exceção em casos de erro
** ----------------------------------------------------------------------
    IF line_exists( lt_return[ type = 'E' ] ).
      lo_message = mo_context->get_message_container( ).
      lo_message->add_messages_from_bapi( it_bapi_messages = lt_return ).
      CREATE OBJECT lo_exception EXPORTING message_container = lo_message.
      RAISE EXCEPTION lo_exception.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
