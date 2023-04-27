*&---------------------------------------------------------------------*
*& Report zmmf_divisao_remessas
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmmf_divisao_remessas.

TYPE-POOLS:   addi, meein,
              mmpur.

TABLES: nast,
        tnapr.

FORM f_entry_neu USING uv_ent_retco uv_ent_screen.

  DATA: ls_doc        TYPE meein_purchase_doc_print,
        ls_empresa    TYPE zsmm_pedido_compra,
        ls_ctrlop     TYPE ssfctrlop,
        ls_compop     TYPE ssfcompop,
        ls_return     TYPE ssfcrescl,
        ls_ctrlop_aux TYPE ssfctrlop,
        ls_compop_aux TYPE ssfcompop.

  DATA: lv_fm_name     TYPE rs38l_fnam,
        lv_adrnr       TYPE lfa1-adrnr,
        lv_total_pages TYPE sfsy-formpages,
        lv_druvo       LIKE t166k-druvo,
        lv_from_memory,
        lv_kunnr       TYPE t001w-kunnr.

  CLEAR uv_ent_retco.
  IF nast-aende EQ space.
    lv_druvo = '1'. "Nova impressão
  ELSE.
    lv_druvo = '2'. "Alterar impressão
  ENDIF.

  CALL FUNCTION 'ME_READ_PO_FOR_PRINTING'
    EXPORTING
      ix_nast        = nast
      ix_screen      = uv_ent_retco
    IMPORTING
      ex_retco       = uv_ent_retco
      doc            = ls_doc
    CHANGING
      cx_druvo       = lv_druvo
      cx_from_memory = lv_from_memory.

  CHECK uv_ent_retco EQ 0.

  IF ls_doc-xtkomv[]    IS INITIAL
 AND ls_doc-xekko-knumv IS NOT INITIAL.

    SELECT *
      FROM konv
      INTO TABLE ls_doc-xtkomv
     WHERE knumv EQ ls_doc-xekko-knumv.

  ENDIF.

  PERFORM f_busca_entrega TABLES ls_doc-xekpo[]
                           USING ls_doc-xekko-bukrs
                        CHANGING ls_empresa-cnpj_entrega
                                 ls_empresa-entrega
                                 ls_empresa-cobranca.

  PERFORM f_busca_fornecedor USING ls_doc-xekko-lifnr
                          CHANGING ls_empresa-ie_fornecedor
                                   ls_empresa-cnpj_fornecedor
                                   ls_empresa-fornecedor
                                   lv_adrnr.

*  PERFORM f_busca_texto TABLES ls_empresa-obs USING ls_doc-xekko-ebeln
*                                                    ''
*                                                    'F01'
*                                                    'EKKO'.
  PERFORM f_busca_observacoes TABLES ls_empresa-obs[]
                               USING ls_doc-xekko-ebeln.

*  PERFORM f_busca_informacoes_gerais TABLES ls_empresa-inf_gerais USING ls_doc-xekko-bukrs.
  PERFORM f_busca_informacoes_gerais TABLES ls_empresa-inf_gerais[].

  " Dados de Faturamento
  ls_empresa-cabecalho-name1      = |{ ls_empresa-entrega-name1 } { ls_empresa-entrega-name2 }|.
  ls_empresa-kna1-stcd1           = ls_empresa-cnpj_entrega.
  ls_empresa-cabecalho-street     = ls_empresa-entrega-street.
  ls_empresa-cabecalho-house_num1 = ls_empresa-entrega-house_num1.
  ls_empresa-cabecalho-city2(25)  = ls_empresa-entrega-city2(20).
  ls_empresa-cabecalho-city1      = ls_empresa-entrega-city1.
  ls_empresa-cabecalho-post_code1 = ls_empresa-entrega-post_code1.
  ls_empresa-cabecalho-tel_number = ls_empresa-entrega-tel_number.
  ls_empresa-cabecalho-tel_number = ls_empresa-entrega-tel_number.
  ls_empresa-cabecalho-region     = ls_empresa-entrega-region.
  ls_empresa-cabecalho-country    = ls_empresa-entrega-country.

*  READ TABLE ls_doc-xekpo INTO DATA(ls_ekpo_aux) INDEX 1.
*
*  SELECT SINGLE kunnr FROM t001w
*    INTO lv_kunnr
*      WHERE werks EQ ls_ekpo_aux-werks.
*
*  IF sy-subrc EQ 0.
*
*    SELECT SINGLE * FROM kna1
*      INTO ls_empresa-kna1
*      WHERE kunnr EQ lv_kunnr.
*
*    IF sy-subrc EQ 0.
*
*      SELECT SINGLE * FROM adrc
*        INTO  ls_empresa-cabecalho
*        WHERE addrnumber EQ ls_empresa-kna1-adrnr.
*
*    ENDIF.
*
*  ENDIF.
*
*  DATA: lv_branch     TYPE t001w-j_1bbranch,
*        lv_stcd1      TYPE lfa1-stcd1,
*        lv_addrnumber TYPE lfa1-adrnr.
*
*  IF ls_empresa-kna1-stcd1 IS INITIAL.
*
*    SELECT SINGLE j_1bbranch
*      FROM t001w
*      INTO lv_branch
*      WHERE werks EQ ls_ekpo_aux-werks.
*
*    IF sy-subrc EQ 0.
*
*      PERFORM f_busca_cnpj USING lv_branch
*                                 ls_ekpo_aux-werks
*                           CHANGING ls_empresa-kna1-stcd1.
*
**      SELECT SINGLE stcd1
**        FROM j_1bbranch
**        INTO lv_stcd1
**        WHERE bukrs EQ ls_ekpo_aux-bukrs
**          AND branch EQ lv_branch.
**
**      IF sy-subrc EQ 0.
**        SELECT SINGLE adrnr
**          FROM lfa1
**          INTO lv_addrnumber
**          WHERE stcd1 EQ lv_stcd1.
**
**        IF sy-subrc EQ 0.
**          SELECT SINGLE *
**            FROM adrc
**            INTO  ls_empresa-cabecalho
**            WHERE addrnumber EQ lv_addrnumber.
**        ENDIF.
**
**        IF sy-subrc EQ 0.
**          ls_empresa-kna1-stcd1 = lv_stcd1.
**        ENDIF.
**      ENDIF.
*    ENDIF.
*  ENDIF.

  DATA: lt_tline TYPE STANDARD TABLE OF tline.

  LOOP AT ls_doc-xekpo INTO DATA(ls_ekpo) WHERE matnr NE 'NO_PRINT'.

    CLEAR lt_tline[].

    PERFORM f_busca_texto TABLES lt_tline
                           USING ls_doc-xekko-ebeln
                                 ls_ekpo-ebelp
                                 'F01'
                                 'EKPO'.

    READ TABLE lt_tline INTO DATA(ls_tline) WITH KEY tdformat = '*'.
    IF sy-subrc EQ 0.
      ls_ekpo-txz01 = ls_tline-tdline.
      TRANSLATE ls_ekpo-txz01 TO UPPER CASE.

      CLEAR: ls_ekpo-kzwi4,
             ls_ekpo-kzwi5.

      ls_ekpo-matnr = 'NO_PRINT'.
      APPEND ls_ekpo TO ls_doc-xekpo.
    ENDIF.
  ENDLOOP.

  SORT ls_doc-xekpo BY ebelp.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = tnapr-sform
    IMPORTING
      fm_name            = lv_fm_name
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  ls_compop-tdimmed      = nast-dimme.
  ls_compop-tddest       = nast-ldest.
  ls_ctrlop-no_dialog    = abap_true.
  DATA(lv_user_settings) = abap_true.

  DELETE ls_doc-xtkomv WHERE kschl = 'RA01'
                         AND kwert = 0.
  DELETE ls_doc-xtkomv WHERE kschl = 'ZDAC'
                         AND kwert = 0.

  IF sy-ucomm EQ 'VIEW'
  OR sy-ucomm EQ 'PREVOUTPUT'
  OR sy-xcode EQ '9ANZ'.
    ls_ctrlop-preview = 'X'.
  ELSEIF sy-tcode IS INITIAL.
    CLEAR lv_user_settings.
  ENDIF.
  IF sy-ucomm EQ 'PDF'
  OR ( nast-kschl EQ 'ZNEU' AND nast-nacha EQ '5' AND sy-xcode NE '9ANZ' ).

    ls_ctrlop-getotf = 'X'.

  ELSEIF nast-kschl EQ 'ZNEU'
     AND nast-nacha EQ '5'
     AND nast-vsztp EQ '4'.

    ls_ctrlop-getotf = 'X'.

  ENDIF.

  DATA(lo_object) = NEW zclmm_pricing_po( ).

  lo_object->get_remes_pricing( EXPORTING iv_ebeln = ls_doc-xekko-ebeln
                                IMPORTING et_komp  = DATA(lt_komp)
                                          et_komv  = DATA(lt_komv) ).

  APPEND LINES OF lt_komv TO ls_doc-xtkomv.

  ls_ctrlop_aux-no_dialog = abap_true.
  ls_ctrlop_aux-preview   = space.

  ls_compop_aux-tddest  = 'LOCL'.
  ls_compop_aux-tdimmed = abap_true.

  CALL FUNCTION lv_fm_name
    EXPORTING
      control_parameters = ls_ctrlop_aux
      output_options     = ls_compop_aux
      user_settings      = lv_user_settings
      empresa            = ls_empresa
      pedido             = ls_doc
      iv_penult_page     = lv_total_pages
      it_komp            = lt_komp
    IMPORTING
      job_output_info    = ls_return
      ev_total_pages     = lv_total_pages
    EXCEPTIONS
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      OTHERS             = 5.

  FREE: ls_return.

  IF sy-subrc IS INITIAL.
    lv_total_pages = lv_total_pages - 1.
  ENDIF.

  CALL FUNCTION lv_fm_name
    EXPORTING
      control_parameters = ls_ctrlop
      output_options     = ls_compop
      user_settings      = lv_user_settings
      empresa            = ls_empresa
      pedido             = ls_doc
      iv_penult_page     = lv_total_pages
    IMPORTING
      job_output_info    = ls_return
      ev_total_pages     = lv_total_pages
    EXCEPTIONS
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      OTHERS             = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  IF sy-ucomm EQ 'PDF'.

    PERFORM f_gera_pdf TABLES ls_return-otfdata.

  ELSEIF nast-kschl EQ 'ZNEU'
     AND nast-nacha EQ '5'.

    IF nast-vsztp EQ '4' OR sy-xcode EQ '9AUS'.
*      PERFORM f_envia_pdf_email TABLES ls_return-otfdata USING lv_adrnr
*                                                             ls_doc-xekko-ebeln
*                                                             ls_doc-xekko-bstyp.
    ENDIF.
  ENDIF.
ENDFORM.



*&---------------------------------------------------------------------*
*&      Form  BUSCA_ENTREGA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_lt_DOC_XEKPO  text
*      <--P_lt_EMPRESA_ENTREGA  text
*----------------------------------------------------------------------*
FORM f_busca_entrega  TABLES   lt_lt_doc
                      USING    uv_bukrs
                      CHANGING cv_cnpj_entrega
                               cv_lt_entrega
                               cv_lt_cobranca.
  TABLES: t001w, adrc.
  DATA: ls_ekpo  TYPE ekpo,
        lv_adrnr TYPE lfa1-adrnr.

  READ TABLE lt_lt_doc INTO ls_ekpo INDEX 1.

  IF ls_ekpo-werks EQ '1111'.
    SELECT SINGLE * FROM t001w
     WHERE werks EQ '1110'.
  ELSE.
    SELECT SINGLE * FROM t001w
      WHERE werks EQ ls_ekpo-werks.
  ENDIF.

  IF sy-subrc EQ 0.

    PERFORM f_busca_cnpj USING t001w-j_1bbranch
                               t001w-werks
                         CHANGING cv_cnpj_entrega.

*    SELECT SINGLE stcd1 FROM kna1
*      INTO cv_cnpj_entrega
*        WHERE kunnr EQ t001w-kunnr.

    IF ls_ekpo-adrn2 IS NOT INITIAL AND ls_ekpo-bstyp EQ 'F'.
      SELECT SINGLE * FROM adrc
        WHERE addrnumber EQ ls_ekpo-adrn2.
    ELSEIF ls_ekpo-emlif IS NOT INITIAL AND ls_ekpo-bstyp EQ 'F'.
*      SELECT SINGLE adrnr stcd1 FROM lfa1
*        INTO ( lv_adrnr, cv_cnpj_entrega )
      SELECT SINGLE adrnr FROM lfa1
       INTO ( lv_adrnr )
       WHERE lifnr = ls_ekpo-emlif.

      IF sy-subrc IS INITIAL.
* Seleciona o endereço de entrega
        SELECT SINGLE * FROM adrc
          WHERE addrnumber EQ lv_adrnr.
      ENDIF.
    ELSE.
* Seleciona o endereço de entrega
      SELECT SINGLE * FROM adrc
        WHERE addrnumber EQ t001w-adrnr.
    ENDIF.
    IF sy-subrc EQ 0.
      MOVE adrc TO cv_lt_entrega.

    ENDIF.
  ENDIF.


  SELECT SINGLE * FROM t001w
      WHERE werks EQ '1000'.
  IF sy-subrc EQ 0.
    SELECT SINGLE * FROM adrc
      WHERE addrnumber EQ t001w-adrnr.
    IF sy-subrc EQ 0.
      MOVE adrc TO cv_lt_cobranca.
      IF uv_bukrs EQ '3CAF'.
        SELECT SINGLE butxt AS name1 FROM t001
          INTO CORRESPONDING FIELDS OF cv_lt_cobranca
            WHERE bukrs EQ uv_bukrs.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.                    " BUSCA_ENTREGA

*&---------------------------------------------------------------------*
*&      Form  BUSCA_FORNECEDOR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_lt_DOC_XEKKO  text
*      <--P_lt_EMPRESA_CNPJ_FORNECEDOR  text
*      <--P_lt_EMPRESA_FORNECEDOR  text
*----------------------------------------------------------------------*
FORM f_busca_fornecedor  USING uv_lifnr
                       CHANGING cv_ie_fornecedor
                                cv_cnpj_fornecedor
                                cv_fornecedor
                                cv_adrnr.

  DATA: lv_stcd1 TYPE lfa1-stcd1,
        lv_stcd3 TYPE lfa1-stcd3,
        lv_adrnr TYPE lfa1-adrnr.

* Seleciona o código do endereço do fornecedor
  SELECT SINGLE adrnr stcd1 stcd3 FROM lfa1
    INTO ( lv_adrnr, lv_stcd1, lv_stcd3 )
    WHERE lifnr EQ uv_lifnr.
  IF sy-subrc EQ 0.
    cv_cnpj_fornecedor = lv_stcd1.
    cv_ie_fornecedor   = lv_stcd3.
* Seleciona o endereço do fornecedor
    SELECT SINGLE * FROM adrc
      INTO cv_fornecedor
      WHERE addrnumber EQ lv_adrnr.

    cv_adrnr = lv_adrnr.
  ENDIF.

ENDFORM.                    " BUSCA_FORNECEDOR
*&---------------------------------------------------------------------*
*&      Form  BUSCA_TEXTO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_lt_DOC_XEKKO_EBELN  text
*----------------------------------------------------------------------*
FORM f_busca_texto TABLES lt_obs
                    USING uv_ebeln
                          uv_item
                          uv_id
                          uv_object.

  DATA: lt_lines TYPE STANDARD TABLE OF tline.

  DATA: ls_inserc TYPE tline,
        ls_thead  TYPE thead.

  DATA: lv_lenght TYPE string.

  IF uv_item IS NOT INITIAL.
    CONCATENATE uv_ebeln uv_item INTO ls_thead-tdname.
  ELSE.
    ls_thead-tdname = uv_ebeln.
  ENDIF.

  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      client                  = sy-mandt
      id                      = uv_id
      language                = sy-langu
      name                    = ls_thead-tdname
      object                  = uv_object
    TABLES
      lines                   = lt_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.

  IF sy-subrc IS NOT INITIAL.
    RETURN.
  ENDIF.

  IF lt_lines[] IS NOT INITIAL.
    LOOP AT lt_lines INTO DATA(ls_lines).

      IF strlen( ls_lines-tdline ) EQ '1'
     AND ls_lines-tdline NS sy-abcde.
        CONTINUE.
      ENDIF.

      CONDENSE ls_lines-tdline.

      IF ls_lines-tdformat EQ '*'.
        IF ls_inserc-tdline IS NOT INITIAL.
          APPEND ls_inserc TO lt_obs.
          ls_inserc-tdline = ls_lines-tdline.
          CONTINUE.
        ELSE.
          ls_inserc-tdline = ls_lines-tdline.
          CONTINUE.
        ENDIF.
      ELSE.

        IF ls_inserc-tdline IS NOT INITIAL.
          lv_lenght = |{ ls_inserc-tdline } { ls_lines-tdline } |.

          IF strlen( lv_lenght ) GT '123'.

            ls_inserc-tdline = lv_lenght(123).
            APPEND ls_inserc TO lt_obs.
            CLEAR ls_inserc.

            ls_inserc-tdline = lv_lenght+123.

            IF strlen( ls_inserc-tdline ) EQ '1'
           AND ls_inserc-tdline NS sy-abcde.
              CLEAR ls_inserc-tdline.
              CONTINUE.
            ENDIF.

            CONDENSE ls_inserc-tdline.
            CONTINUE.

          ELSE.
            ls_inserc-tdline = |{ ls_inserc-tdline } { ls_lines-tdline } |.
*            APPEND ls_inserc TO lt_obs.
*            CLEAR ls_inserc.
          ENDIF.

        ELSE.
          ls_inserc-tdline = ls_lines-tdline.
        ENDIF.

      ENDIF.
    ENDLOOP.

    IF ls_inserc-tdline IS NOT INITIAL.
      APPEND ls_inserc TO lt_obs.
      CLEAR ls_inserc.
    ENDIF.
  ENDIF.

ENDFORM.                    " BUSCA_TEXTO
*&---------------------------------------------------------------------*
*&      Form  BUSCA_INFORMACOES_GERAIS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_busca_informacoes_gerais TABLES lt_inf_gerais.

  CONSTANTS:
    BEGIN OF lc_inf_gerais,
      id     TYPE thead-tdid VALUE 'ST',
      object TYPE thead-tdobject VALUE 'TEXT',
      name   TYPE thead-tdname VALUE 'ZMM_PROGRAMAREMESSA',
    END OF lc_inf_gerais.

*  TYPES: BEGIN OF ty_infgerais,
*           mandt TYPE mandt,
*           linha TYPE int1,
*           spras TYPE spras,
*           bukrs TYPE bukrs,
*           msg   TYPE tdline,
*         END OF ty_infgerais.
*
*  DATA: lt_zinfgerais TYPE STANDARD TABLE OF ty_infgerais,
*        ls_zinfgerais TYPE ty_infgerais,
*        ls_inf_gerais TYPE tline.
*
*  IF sy-subrc EQ 0.
*
*    DELETE lt_zinfgerais WHERE bukrs NE uv_bukrs AND bukrs IS NOT INITIAL.
*
*    SORT lt_zinfgerais BY linha.
*
*    LOOP AT lt_zinfgerais INTO ls_zinfgerais .
*
*      CLEAR ls_inf_gerais.
*
*      ls_inf_gerais-tdline = ls_zinfgerais-msg.
*
*      APPEND ls_inf_gerais TO lt_inf_gerais.
*
*    ENDLOOP.
*
*  ENDIF.

  PERFORM f_busca_texto TABLES lt_inf_gerais USING lc_inf_gerais-name
                                            ''
                                            lc_inf_gerais-id
                                            lc_inf_gerais-object.

ENDFORM.                    " BUSCA_INFORMACOES_GERAIS

*&---------------------------------------------------------------------*
*&      Form  GERA_PDF
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_gera_pdf TABLES lt_otfdata.

  DATA: lv_name     TYPE string,
        lv_path     TYPE string,
        lv_filter   TYPE string,
        lv_fullpath TYPE string,
        lv_uact     TYPE i,
        lv_guiobj   TYPE REF TO cl_gui_frontend_services.

  DATA: lt_pdf TYPE STANDARD TABLE OF tline.

  REFRESH: lt_pdf.
  CLEAR:   lt_pdf.

  CALL FUNCTION 'CONVERT_OTF'
    EXPORTING
      format                = 'PDF'
      max_linewidth         = 132
    TABLES
      otf                   = lt_otfdata
      lines                 = lt_pdf
    EXCEPTIONS
      err_max_linewidth     = 1
      err_format            = 2
      err_conv_not_possible = 3
      OTHERS                = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
         WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CONCATENATE nast-objky TEXT-001 INTO lv_name.
  CREATE OBJECT lv_guiobj.
  CALL METHOD lv_guiobj->file_save_dialog
    EXPORTING
      default_extension = 'pdf'
      default_file_name = lv_name
      file_filter       = lv_filter
    CHANGING
      filename          = lv_name
      path              = lv_path
      fullpath          = lv_fullpath
      user_action       = lv_uact.
  IF lv_uact = lv_guiobj->action_cancel.
    EXIT.
  ENDIF.

  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
*     BIN_FILESIZE            =
      filename                = lv_name
      filetype                = 'BIN'
    TABLES
      data_tab                = lt_pdf
*     FIELDNAMES              =
    EXCEPTIONS
      file_write_error        = 1
      no_batch                = 2
      gui_refuse_filetransfer = 3
      invalid_type            = 4
      no_authority            = 5
      unknown_error           = 6
      header_not_allowed      = 7
      separator_not_allowed   = 8
      filesize_not_allowed    = 9
      header_too_long         = 10
      dp_error_create         = 11
      dp_error_send           = 12
      dp_error_write          = 13
      unknown_dp_error        = 14
      access_denied           = 15
      dp_out_of_memory        = 16
      disk_full               = 17
      dp_timeout              = 18
      file_not_found          = 19
      dataprovider_exception  = 20
      control_flush_error     = 21
      OTHERS                  = 22.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
         WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_busca_cnpj
*&---------------------------------------------------------------------*
*& Busca CNPJ do centro
*&---------------------------------------------------------------------*
FORM f_busca_cnpj  USING    uv_branch
                            uv_werks
                   CHANGING cv_cnpj.

  DATA:
    lv_branch TYPE j_1bbranch-branch,
    lv_bukrs  TYPE j_1bbranch-bukrs,
    lv_cnpj   TYPE j_1bwfield-cgc_number.

  lv_branch = uv_branch.
  lv_bukrs = uv_werks.

  CALL FUNCTION 'J_1BREAD_BRANCH_DATA'
    EXPORTING
      branch            = lv_branch
      bukrs             = lv_bukrs
    IMPORTING
      cgc_number        = lv_cnpj
    EXCEPTIONS
      branch_not_found  = 1
      address_not_found = 2
      company_not_found = 3
      OTHERS            = 4.

  IF sy-subrc EQ 0.
    cv_cnpj = lv_cnpj.
  ELSE.
    CLEAR cv_cnpj.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BUSCA_OBSERVACOES
*&---------------------------------------------------------------------*
*       Busca texto de Observações
*----------------------------------------------------------------------*
FORM f_busca_observacoes  TABLES lt_obs
                          USING  uv_ebeln.

  CONSTANTS:
    lc_object_observacoes TYPE thead-tdobject VALUE 'EKKO'.

  CONSTANTS:
    BEGIN OF lc_id_observacoes,
      id_1 TYPE thead-tdid VALUE 'L01',
      id_2 TYPE thead-tdid VALUE 'L02',
      id_3 TYPE thead-tdid VALUE 'L03',
      id_4 TYPE thead-tdid VALUE 'L04',
      id_5 TYPE thead-tdid VALUE 'L05',
      id_6 TYPE thead-tdid VALUE 'L06',
      id_7 TYPE thead-tdid VALUE 'L07',
    END OF lc_id_observacoes.

  PERFORM f_busca_texto TABLES lt_obs USING uv_ebeln
                                            ''
                                            lc_id_observacoes-id_1
                                            lc_object_observacoes.

  PERFORM f_busca_texto TABLES lt_obs USING uv_ebeln
                                            ''
                                            lc_id_observacoes-id_2
                                            lc_object_observacoes.

  PERFORM f_busca_texto TABLES lt_obs USING uv_ebeln
                                            ''
                                            lc_id_observacoes-id_3
                                            lc_object_observacoes.

  PERFORM f_busca_texto TABLES lt_obs USING uv_ebeln
                                            ''
                                            lc_id_observacoes-id_4
                                            lc_object_observacoes.

  PERFORM f_busca_texto TABLES lt_obs USING uv_ebeln
                                            ''
                                            lc_id_observacoes-id_5
                                            lc_object_observacoes.

  PERFORM f_busca_texto TABLES lt_obs USING uv_ebeln
                                            ''
                                            lc_id_observacoes-id_6
                                            lc_object_observacoes.

  PERFORM f_busca_texto TABLES lt_obs USING uv_ebeln
                                            ''
                                            lc_id_observacoes-id_7
                                            lc_object_observacoes.

ENDFORM.                    " BUSCA_OBSERVACOES
