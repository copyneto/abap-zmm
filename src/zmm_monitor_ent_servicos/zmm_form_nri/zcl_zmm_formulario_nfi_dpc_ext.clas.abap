CLASS zcl_zmm_formulario_nfi_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zmm_formulario_nfi_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS /iwbep/if_mgw_appl_srv_runtime~get_stream
        REDEFINITION .
  PROTECTED SECTION.

    METHODS pdffileset_get_entityset
        REDEFINITION .
    METHODS pdffileset_get_entity
        REDEFINITION .
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_zmm_formulario_nfi_dpc_ext IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_stream.

    CONSTANTS: lc_pdf_header_name TYPE string VALUE 'content-disposition'.

    DATA: lt_sorted_keys     TYPE SORTED TABLE OF /iwbep/s_mgw_tech_pair  WITH UNIQUE KEY name,
          lt_Return          TYPE bapiret2_t,
          ls_stream          TYPE ty_s_media_resource,
          ls_lheader         TYPE ihttpnvp,
          ls_meta            TYPE sfpmetadata,
          lv_pdf_file        TYPE xstring,
          lt_campos_chave    TYPE zctgmm_monitor_ent,
          lt_resultado       TYPE zctgmm_monitor_ent,
          lt_item            TYPE STANDARD TABLE OF vdm_purchaseorderitem,
          lt_calculated_data TYPE STANDARD TABLE OF zi_mm_02_nri_item WITH DEFAULT KEY.

    DATA: lo_fp     TYPE REF TO if_fp,
          lo_pdfobj TYPE REF TO if_fp_pdf_object.

    TRY.

        DATA(lt_keys) = io_tech_request_context->get_keys( ).
        lt_sorted_keys = lt_keys.

      CATCH cx_root.
    ENDTRY.

    lt_campos_chave = VALUE #(  BASE lt_campos_chave (  filePdf = VALUE #( lt_sorted_keys[ name = 'FILEPDF' ]-value           OPTIONAL )
                                                  purchaseorder = VALUE #( lt_sorted_keys[ name = 'PURCHASEORDER' ]-value     OPTIONAL )
                                              purchaseorderitem = VALUE #( lt_sorted_keys[ name = 'PURCHASEORDERITEM' ]-value OPTIONAL ) ) ).

    IF lt_campos_chave IS NOT INITIAL.

      IF lt_campos_chave[ 1 ]-filepdf IS NOT INITIAL.

        SPLIT lt_campos_chave[ 1 ]-filepdf AT ';' INTO TABLE lt_item.

        LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<fs_item>).
          UNPACK <fs_item> TO <fs_item>.
        ENDLOOP.

      ELSE.

        APPEND lt_campos_chave[ 1 ]-purchaseorderitem TO lt_item.

      ENDIF.

      DATA(lv_po) = VALUE ebeln( lt_campos_chave[ 1 ]-PurchaseOrder OPTIONAL ).

      IF lv_po IS NOT INITIAL.

        SELECT * FROM  zi_mm_02_nri_item
           FOR ALL ENTRIES IN @lt_item
           WHERE PurchaseOrder      = @lv_po
             AND PurchaseOrderItem  = @lt_item-table_line
            INTO TABLE @DATA(lt_res).

        IF lt_res IS NOT INITIAL.

          SELECT * FROM C_Businesspartnertaxnumber "#EC CI_NO_TRANSFORM
            FOR ALL ENTRIES IN @lt_res
            WHERE BusinessPartner = @lt_res-BusinessPartner
            INTO TABLE @DATA(lt_resul).

          IF sy-subrc EQ 0.

            LOOP AT lt_res ASSIGNING FIELD-SYMBOL(<fs_calc>).

              <fs_calc>-cnpj          = COND #( WHEN line_exists( lt_resul[ BPTaxType = 'BR1' ] ) THEN VALUE #( lt_resul[ BPTaxType = 'BR1' ]-BPTaxNumber OPTIONAL ) ).
              <fs_calc>-cpf           = COND #( WHEN line_exists( lt_resul[ BPTaxType = 'BR3' ] ) THEN VALUE #( lt_resul[ BPTaxType = 'BR3' ]-BPTaxNumber OPTIONAL ) ).
              <fs_calc>-InsEstadual   = COND #( WHEN line_exists( lt_resul[ BPTaxType = 'BR3' ] ) THEN VALUE #( lt_resul[ BPTaxType = 'BR3' ]-BPTaxNumber OPTIONAL ) ).
              <fs_calc>-InsMunicipal  = COND #( WHEN line_exists( lt_resul[ BPTaxType = 'BR4' ] ) THEN VALUE #( lt_resul[ BPTaxType = 'BR4' ]-BPTaxNumber OPTIONAL ) ).
              <fs_calc>-f_cnpj        = COND #( WHEN line_exists( lt_resul[ BPTaxType = 'BR1' ] ) THEN VALUE #( lt_resul[ BPTaxType = 'BR1' ]-BPTaxNumber OPTIONAL ) ).
              <fs_calc>-F_InsEstadual = COND #( WHEN line_exists( lt_resul[ BPTaxType = 'BR3' ] ) THEN VALUE #( lt_resul[ BPTaxType = 'BR3' ]-BPTaxNumber OPTIONAL ) ).

            ENDLOOP.

          ENDIF.

        ENDIF.

        lt_resultado = CORRESPONDING #( lt_res ).

        NEW zclmm_emitir_nri(  )->execute(
        EXPORTING
          it_data = lt_resultado
          IMPORTING
            ev_pdf  = lv_pdf_file
            ev_erro = DATA(lv_erro_boleto)
          ).

        " Monta o arquivo PDF
        IF lv_pdf_file IS INITIAL.
          RETURN.
        ENDIF.

        " Monta nome do arquivo
        DATA(lv_nome_arquivo) = CONV string( TEXT-001 ).

        " Atualiza Metadata do arquivo PDF
        TRY.
            "Cria o objeto PDF.
            lo_fp = cl_fp=>get_reference( ).
            lo_pdfobj = lo_fp->create_pdf_object( connection = 'ADS' ).
            lo_pdfobj->set_document( pdfdata = lv_pdf_file ).

            "Determina o título do arquivo
            ls_meta-title = lv_nome_arquivo.

            lo_pdfobj->set_metadata( metadata = ls_meta ).
            lo_pdfobj->execute( ).

            "Get the PDF content back with title
            lo_pdfobj->get_document( IMPORTING pdfdata = lv_pdf_file ).

          CATCH cx_root.
        ENDTRY.

        " Muda nome do arquivo
        " Tipo comportamento:
        " - inline: Não fará download automático
        " - outline: Download automático


        ls_lheader-name  = lc_pdf_header_name.
        ls_lheader-value = COND #( WHEN lt_campos_chave[ 1 ]-filepdf IS INITIAL THEN 'inline; filename="'
                                                                                ELSE 'outline;filename="'  ) && |{ lv_nome_arquivo }| && '.pdf";'.

        set_header( is_header = ls_lheader ).

        " Retorna binário do PDF
        ls_stream-mime_type = 'application/pdf'.
        ls_stream-value     = lv_pdf_file.

        copy_data_to_ref( EXPORTING is_data = ls_stream
                          CHANGING  cr_data = er_stream ).

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD pdffileset_get_entity.
    RETURN.
  ENDMETHOD.


  METHOD pdffileset_get_entityset.

* ======================================================================
* Método para manipular múltiplos registros (filtros)
* ======================================================================

    DATA(lt_filter) = io_tech_request_context->get_filter( ).

  ENDMETHOD.
ENDCLASS.
