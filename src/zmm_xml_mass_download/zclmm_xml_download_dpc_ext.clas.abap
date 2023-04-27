"! <p class="short text synchronized" lang="pt">Data Provider Secondary Class</p>
CLASS zclmm_xml_download_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zclmm_xml_download_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS /iwbep/if_mgw_appl_srv_runtime~get_stream
        REDEFINITION .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLMM_XML_DOWNLOAD_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_stream.

    DATA ls_stream TYPE ty_s_media_resource.
    DATA lt_docnum TYPE TABLE OF efg_ranges.
    DATA lt_accesskey TYPE TABLE OF efg_ranges.
    DATA lt_files TYPE zctgmm_xml_download.
    DATA lt_return TYPE bapiret2_tab.

    DATA(lo_message) = mo_context->get_message_container( ).

    APPEND VALUE #( sign = 'I' option = 'EQ' low = it_key_tab[ name = gc_prop-docnum ]-value ) TO lt_docnum.

    DATA(lv_inline) = COND string( WHEN it_key_tab[ name = gc_prop-inline ]-value EQ abap_true THEN gc_prop-inline ELSE gc_prop-outline ).
    DATA(lv_server) = CONV abap_bool( it_key_tab[ name = gc_prop-server ]-value ).
    DATA(lv_filepath) = it_key_tab[ name = gc_prop-filepath ]-value.

    IF lv_filepath IS INITIAL.
      lv_filepath = '/usr/sap/tmp/'.
    ENDIF.

    SELECT j~docnum, j~nfenum, j~pstdat, j~docdat, j~bukrs, j~branch,
           xhd~cnpj_emit AS emissor_nfis, xhd~c_xnome AS emissor, xhd~uf_emit AS emissor_uf,
           xhd~cnpj_dest AS recebe_nfis, xhd~c_xnome AS recebedor, xhd~uf_dest AS recebe_uf,
    concat( a~regio, concat( a~nfyear, concat( a~nfmonth, concat( a~stcd1, concat( a~model, concat( a~serie, concat( a~nfnum9, concat( a~docnum9, a~cdv ) ) ) ) ) ) ) ) AS accesskey
      FROM j_1bnfe_active AS a
     INNER JOIN j_1bnfdoc AS j
        ON a~docnum = j~docnum
     INNER JOIN /xnfe/innfehd AS xhd
        ON j~nfenum = xhd~nnf
     WHERE a~docnum IN @lt_docnum
      INTO TABLE @DATA(lt_active).

    DATA(ls_active) = lt_active[ 1 ].

    APPEND VALUE #( sign = 'I' option = 'EQ' low = ls_active-accesskey ) TO lt_accesskey.

    CASE iv_entity_name.

      WHEN gc_entity-cte.

        CALL FUNCTION 'ZFM_DOWNLOAD_XML_CTE'
          EXPORTING
            iv_docnum   = CONV j_1bdocnum( lt_docnum[ 1 ]-low )
          TABLES
            t_nfeid     = lt_accesskey
            t_nfxml     = lt_files
            t_return    = lt_return.

      WHEN gc_entity-nfe.

        CALL FUNCTION 'ZFM_DOWNLOAD_XML_IN'
          EXPORTING
            iv_docnum    = CONV j_1bdocnum( lt_docnum[ 1 ]-low )
            iv_cnpj_emit = ls_active-emissor_nfis
            iv_cnpj_dest = ls_active-recebe_nfis
            iv_uf_emit   = ls_active-emissor_uf
            iv_uf_dest   = ls_active-recebe_uf
          TABLES
            t_nfeid      = lt_accesskey
            t_nfxml      = lt_files
            t_return     = lt_return.

      WHEN OTHERS.

    ENDCASE.

    IF lines( lt_files ) GT 0 AND lv_server EQ abap_false.

* ----------------------------------------------------------------------
* Tipo comportamento:
* - inline: Não fará download automático
* - outline: Download automático
* ----------------------------------------------------------------------

      set_header( is_header = VALUE #( name = gc_headername value = |{ lv_inline }; filename="{ lt_files[ 1 ]-filename }";| ) ).

      ls_stream-mime_type = gc_mimetype .
      ls_stream-value = lt_files[ 1 ]-filestring.

      copy_data_to_ref( EXPORTING is_data = ls_stream
                         CHANGING cr_data = er_stream ).

    ENDIF.

    CHECK lines( lt_return ) GT 0.

    lo_message->add_message_from_bapi(
      EXPORTING
        is_bapi_message           = lt_return[ 1 ]
        it_key_tab                = it_key_tab
        iv_message_target         = '/#TRANSIENT#'
        iv_is_transition_message  = abap_true
    ).


  ENDMETHOD.
ENDCLASS.
