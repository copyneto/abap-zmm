class ZCLMM_ENTR_SERV_NBS_DPC_EXT definition
  public
  inheriting from ZCLMM_ENTR_SERV_NBS_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_STREAM
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_ENTR_SERV_NBS_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_stream.

    TYPES: BEGIN OF ty_file,
             matnr TYPE mara-matnr,
             nbs   TYPE ztmm_nbs-nbs,
           END OF ty_file.

    DATA: lt_return TYPE bapiret2_t,
          lt_file   TYPE STANDARD TABLE OF ty_file,
          lt_table  TYPE STANDARD TABLE OF ztmm_nbs.

    DATA: ls_table TYPE ztmm_nbs,
          ls_arquivo TYPE zclmm_entr_serv_nbs_mpc=>ts_upload.

    DATA lv_mimetype TYPE w3conttype.

    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception.

    CONSTANTS: lc_e   TYPE c LENGTH 1 VALUE 'E',
               lc_id  TYPE sy-msgid VALUE 'ZMM_NBS_MSG',
               lc_000 TYPE sy-msgno VALUE 000.

* ---------------------------------------------------------------------------
* Valida tipo de arquivo
* ---------------------------------------------------------------------------
    CALL FUNCTION 'SDOK_MIMETYPE_GET'
      EXPORTING
        extension = 'XLSX'
      IMPORTING
        mimetype  = lv_mimetype.

    IF is_media_resource-mime_type NE lv_mimetype.
      " Formato de arquivo não suportado. Realizar nova carga com formato "xlsx".
      lt_return[] = VALUE #( BASE lt_return ( type = 'E' id = 'ZBP_EXPANSAO_BP' number = '003' ) ).
    ENDIF.

    CHECK NOT line_exists( lt_return[ type = 'E' ] ).    "#EC CI_STDSEQ

* ---------------------------------------------------------------------------
* Converte arquivo excel para tabela
* ---------------------------------------------------------------------------
    DATA(lo_excel) = NEW zclca_excel( iv_filename = iv_slug
                                      iv_file     = is_media_resource-value ).

    lo_excel->get_sheet( IMPORTING et_return = DATA(lt_return2)
                         CHANGING  ct_table  = lt_file[] ).

    LOOP AT lt_file ASSIGNING FIELD-SYMBOL(<fs_file>).

      CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
        EXPORTING
          input  = <fs_file>-matnr
        IMPORTING
          output = <fs_file>-matnr.

    ENDLOOP.

    lt_return[] = VALUE #( BASE lt_return FOR ls_return IN lt_return2 ( ls_return ) ).

    IF lt_file IS NOT INITIAL.

      SELECT matnr,
             bismt
        FROM mara
        INTO TABLE @DATA(lt_mara)
        FOR ALL ENTRIES IN @lt_file
        WHERE bismt = @lt_file-matnr.

      IF sy-subrc IS INITIAL.
        SORT lt_mara BY bismt.
      ENDIF.

      IF lt_mara IS NOT INITIAL.

        SELECT matnr,
                   created_at,
                   created_by
              FROM ztmm_nbs
              INTO TABLE @DATA(lt_ztmm_nbs)
              FOR ALL ENTRIES IN @lt_mara
              WHERE matnr = @lt_mara-matnr.

        IF sy-subrc IS INITIAL.
          SORT lt_ztmm_nbs BY matnr.
        ENDIF.

      ENDIF.
    ENDIF.

    LOOP AT lt_file INTO DATA(ls_file).            "#EC CI_LOOP_INTO_WA
      READ TABLE lt_mara INTO DATA(ls_mara) WITH KEY bismt = ls_file-matnr BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        ls_table-matnr = ls_mara-matnr.
        ls_table-nbs = ls_file-nbs.
        GET TIME STAMP FIELD ls_table-last_changed_at.
        ls_table-last_changed_by = sy-uname.
      ELSE.
        lt_return = VALUE #( BASE lt_return ( id = lc_id
                                              number = lc_000
                                              type = lc_e
                                              message_v1 = ls_file-matnr ) ).
        CONTINUE.
      ENDIF.
      READ TABLE lt_ztmm_nbs INTO DATA(ls_ztmm_nbs) WITH KEY matnr = ls_mara-matnr BINARY SEARCH.
      IF sy-subrc IS NOT INITIAL.
        GET TIME STAMP FIELD ls_table-created_at.
        ls_table-created_by = sy-uname.
      ELSE.
        ls_table-created_at = ls_ztmm_nbs-created_at.
        ls_table-created_by = ls_ztmm_nbs-created_by.
      ENDIF.
      APPEND ls_table TO lt_table.
      CLEAR ls_table.
    ENDLOOP.

    IF lt_return IS INITIAL AND lt_table IS NOT INITIAL.

      MODIFY ztmm_nbs FROM TABLE lt_table.

      IF sy-subrc IS INITIAL.
        COMMIT WORK.
      ENDIF.

      ls_arquivo-filename = iv_slug.

      copy_data_to_ref( EXPORTING is_data = ls_arquivo
                         CHANGING cr_data = er_entity ).

    ENDIF.

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
ENDCLASS.
