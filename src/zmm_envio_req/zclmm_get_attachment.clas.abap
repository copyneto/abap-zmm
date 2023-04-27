CLASS zclmm_get_attachment DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: ty_requ TYPE STANDARD TABLE OF ztmm_envio_req.

    METHODS: get_attach
      IMPORTING
        iv_classname TYPE bds_clsnam
        it_req       TYPE ty_requ
        is_ret       TYPE zmt_requisicao_compra_resp
      EXPORTING
        et_msg       TYPE bapiret2_tab
      RAISING
        cx_ai_system_fault.

  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS: gc_txt    TYPE char4     VALUE 'TXT',
               gc_id     TYPE symsgid   VALUE 'ZMM_REQ_COMPRAS',
               gc_number TYPE symsgno   VALUE '003',
               gc_erro   TYPE bapi_mtype VALUE 'E'.

    DATA: gv_classname  TYPE bds_clsnam,
          gv_objkey     TYPE swotobjid-objkey,

          gt_req        TYPE ty_requ,
          gt_ret        TYPE bapiret2_tab,
          gt_connection TYPE STANDARD TABLE OF bdn_con,

          gs_attach     TYPE zmt_anexo_requisicao_compra,
          gv_ret        TYPE zmt_requisicao_compra_resp.

    METHODS retrieve_list
      RAISING
        cx_ai_system_fault .
    METHODS send_attach
      RAISING
        cx_ai_system_fault .
    METHODS trigger_me
      IMPORTING
        iv_string_64 TYPE string
        is_connect   TYPE bdn_con
        is_doc_data  TYPE sofolenti1
        iv_extensao  TYPE char4 OPTIONAL
      RAISING
        cx_ai_system_fault .
    METHODS message
      IMPORTING iv_number TYPE symsgno.
ENDCLASS.



CLASS zclmm_get_attachment IMPLEMENTATION.


  METHOD get_attach.

    gv_classname = iv_classname.
    gt_req       = it_req.
    gv_ret       = is_ret.

    me->retrieve_list( ).

    et_msg = gt_ret.

  ENDMETHOD.


  METHOD retrieve_list.

    DATA: lv_lgsystm TYPE logsys,
          lv_objkey  TYPE swo_typeid.

    CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
      IMPORTING
        own_logical_system             = lv_lgsystm
      EXCEPTIONS
        own_logical_system_not_defined = 1
        OTHERS                         = 2.

    IF sy-subrc NE 0.
      EXIT.
    ENDIF.

    DELETE ADJACENT DUPLICATES FROM gt_req COMPARING doc_sap.

    LOOP AT gt_req ASSIGNING FIELD-SYMBOL(<fs_req>).

      REFRESH gt_connection.

      CALL FUNCTION 'BDS_GOS_CONNECTIONS_GET'
        EXPORTING
          logical_system     = lv_lgsystm
          classname          = gv_classname
          objkey             = CONV swo_typeid( <fs_req>-doc_sap )
          client             = sy-mandt
        TABLES
          gos_connections    = gt_connection[]
        EXCEPTIONS
          no_objects_found   = 1
          internal_error     = 2
          internal_gos_error = 3
          OTHERS             = 4.
      IF sy-subrc <> 0.
        EXIT.
      ELSE.
        me->send_attach(  ).
      ENDIF.

    ENDLOOP.


  ENDMETHOD.


  METHOD send_attach.

    DATA: lv_docid             TYPE so_entryid,
          ls_doc_data          TYPE sofolenti1,
          lv_line              TYPE i,
          lv_input_len         TYPE i,
          lv_xstring           TYPE xstring,
          lv_string            TYPE string,
          lt_content           TYPE STANDARD TABLE OF solisti1,
          lt_cont_hex          TYPE STANDARD TABLE OF solix,
          ls_output            TYPE xstring,
          lv_b64data           TYPE  string,
          lt_objcont           TYPE STANDARD TABLE OF soli INITIAL SIZE 0,
          ls_fol_id            TYPE soodk,
          ls_doc_id            TYPE soodk,
          ls_object_hd_display TYPE sood2,
          lt_object_header     TYPE TABLE OF solisti1.

    LOOP AT gt_connection ASSIGNING FIELD-SYMBOL(<fs_connect>).

      TRANSLATE <fs_connect>-docuclass TO UPPER CASE.
      MOVE <fs_connect>-loio_id TO lv_docid.

      IF <fs_connect>-docuclass NE gc_txt.

        CALL FUNCTION 'SO_DOCUMENT_READ_API1'        "#EC CI_SEL_NESTED
          EXPORTING
            document_id                = lv_docid
          IMPORTING
            document_data              = ls_doc_data
          TABLES
            object_header              = lt_object_header[]
            object_content             = lt_content[]
            contents_hex               = lt_cont_hex[]
          EXCEPTIONS
            document_id_not_exist      = 1
            operation_no_authorization = 2
            x_error                    = 3
            OTHERS                     = 4.
        IF sy-subrc <> 0.
          EXIT.
        ENDIF.

        IF ls_doc_data IS NOT INITIAL.

          CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
            EXPORTING
              input_length = CONV i( ls_doc_data-doc_size )
              first_line   = 0
              last_line    = 0
            IMPORTING
              buffer       = lv_xstring
            TABLES
              binary_tab   = lt_cont_hex
            EXCEPTIONS
              failed       = 1
              OTHERS       = 2.

          IF sy-subrc <> 0.
            CLEAR lv_xstring.
          ENDIF.

          CALL FUNCTION 'SSFC_BASE64_ENCODE'
            EXPORTING
              bindata = lv_xstring
            IMPORTING
              b64data = lv_b64data.
          IF sy-subrc <> 0.

          ENDIF.

          IF sy-subrc NE 0.
            EXIT.
          ELSE.
****        Obter a extensão correta
            READ TABLE lt_object_header ASSIGNING FIELD-SYMBOL(<fs_object_header>) INDEX 1.
            IF sy-subrc = 0.
              SPLIT <fs_object_header> AT '.' INTO TABLE DATA(lt_extensao).
              SORT lt_extensao BY table_line DESCENDING.
              READ TABLE lt_extensao ASSIGNING FIELD-SYMBOL(<fs_extensao>) INDEX 1.
              IF sy-subrc = 0.
                DATA: lv_extensao(4) TYPE c.
                lv_extensao = <fs_extensao>.
                TRANSLATE lv_extensao TO UPPER CASE.
              ENDIF.
            ENDIF.

            me->trigger_me( iv_string_64 = lv_b64data
                            is_connect   = <fs_connect>
                            is_doc_data  = ls_doc_data
                            iv_extensao  = lv_extensao ).
          ENDIF.

          CLEAR: lt_content[], lt_cont_hex[], lv_xstring.

        ENDIF.

      ELSE.

        MOVE <fs_connect>-loio_id TO ls_fol_id.
        MOVE <fs_connect>-loio_id+17(25) TO ls_doc_id.

        CALL FUNCTION 'SO_OBJECT_READ'
          EXPORTING
            folder_id                  = ls_fol_id
            object_id                  = ls_doc_id
          IMPORTING
            object_hd_display          = ls_object_hd_display
          TABLES
            objcont                    = lt_objcont
          EXCEPTIONS
            active_user_not_exist      = 1
            communication_failure      = 2
            component_not_available    = 3
            folder_not_exist           = 4
            folder_no_authorization    = 5
            object_not_exist           = 6
            object_no_authorization    = 7
            operation_no_authorization = 8
            owner_not_exist            = 9
            parameter_error            = 10
            substitute_not_active      = 11
            substitute_not_defined     = 12
            system_failure             = 13
            x_error                    = 14
            OTHERS                     = 15.
        IF sy-subrc <> 0.
          EXIT.
        ENDIF.

        LOOP AT lt_objcont ASSIGNING FIELD-SYMBOL(<fs_objcont>).
          CONCATENATE lv_string <fs_objcont>-line INTO lv_string.
        ENDLOOP.

        CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
          EXPORTING
            text   = lv_string
          IMPORTING
            buffer = lv_xstring
          EXCEPTIONS
            failed = 1
            OTHERS = 2.

        IF sy-subrc NE 0.
          me->message( gc_number ).
        ELSE.

          CALL FUNCTION 'SSFC_BASE64_ENCODE'
            EXPORTING
              bindata = lv_xstring
            IMPORTING
              b64data = lv_b64data.

          IF lv_b64data IS INITIAL.
            me->message( gc_number ).
          ELSE.

            me->trigger_me( iv_string_64 = lv_b64data
                            is_connect   = <fs_connect>
                            is_doc_data  = ls_doc_data
                            iv_extensao  = COND #( WHEN <fs_connect>-docuclass EQ gc_txt THEN gc_txt ELSE lv_extensao ) ).

          ENDIF.

          CLEAR: lt_content[], lt_cont_hex[], lv_xstring.

        ENDIF.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD trigger_me.

    CONSTANTS: lc_true TYPE string VALUE 'true',
               lc_p    TYPE char1 VALUE '.',
               lc_tag  TYPE string VALUE '3CREQ',
               lc_r    TYPE string VALUE 'R',
               lc_n    TYPE string VALUE 'N'.

    DATA: lt_req_envio TYPE zclmm_send_req=>tt_req_att.

    CLEAR: gs_attach.

    DATA(ls_req) = VALUE #( gt_req[ doc_sap = is_connect-objkey ] OPTIONAL ).

    gs_attach-mt_anexo_requisicao_compra = VALUE #(
        is_loaded             = lc_true
        anexo_id              = gv_ret-mt_requisicao_compra_resp-result
        identif               = ls_req-doc_sap
        tag                   = lc_tag
*        nome_arquivo_original = is_connect-comp_id && lc_p && is_connect-docuclass
        nome_arquivo_original = is_connect-descript && lc_p && iv_extensao
*        nome_arquivo_fisico   = is_connect-comp_id && lc_p && is_connect-docuclass
        nome_arquivo_fisico   = is_connect-descript && lc_p && iv_extensao
        data_criacao          = is_connect-crea_time(8)
        data_atualizacao      = is_connect-crea_time(8)
        arquivo_base64        = iv_string_64

    ).

    APPEND VALUE #(
        identific       = ls_req-doc_sap
        tipo_documento  = lc_r
        excluido        = lc_n
    ) TO gs_attach-mt_anexo_requisicao_compra-documentos-anexo_arquivo.

    TRY.

        NEW zco_si_enviar_anexo_requisicao(  )->si_enviar_anexo_requisicao_com(
        EXPORTING
          output = gs_attach
        IMPORTING
          input = DATA(ls_iput)
        ).

        IF sy-subrc EQ 0.

          lt_req_envio = VALUE zclmm_send_req=>tt_req_att(
                 FOR <fs_init> IN gt_req
               ( VALUE #(
               BASE  <fs_init>
                  token  = COND #( WHEN <fs_init>-token IS INITIAL THEN ls_iput-mt_anexo_requisicao_compra_res-result
                                                                   ELSE <fs_init>-token && ';' && ls_iput-mt_anexo_requisicao_compra_res-result )
                  ) ) ) .

          IF lt_req_envio IS NOT INITIAL.

            UPDATE ztmm_envio_req FROM TABLE lt_req_envio.

            COMMIT WORK.

          ENDIF.

        ENDIF.

      CATCH cx_ai_system_fault INTO DATA(lo_erro).

        DATA(ls_erro) = VALUE zsmm_exchange_fault_data1( fault_text = lo_erro->get_text( ) ).

    ENDTRY.

  ENDMETHOD.

  METHOD message.

    gt_ret = VALUE #( ( type   = gc_erro
                        id     = gc_id
                        number = iv_number ) ).

  ENDMETHOD.

ENDCLASS.
