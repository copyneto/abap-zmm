FUNCTION zfmmm_get_romaneio_pdf.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IT_KEY_ROM) TYPE  ZCTGMM_ROMANEIO_KEY
*"  EXPORTING
*"     REFERENCE(EV_FILE) TYPE  XSTRING
*"     REFERENCE(EV_FILESIZE) TYPE  INT4
*"     REFERENCE(ET_LINES) TYPE  TLINE_T
*"  TABLES
*"      ET_OTF TYPE  TSFOTF OPTIONAL
*"  EXCEPTIONS
*"      ERRO_GET_FORM
*"      CONVERSION_EXCEPTION
*"----------------------------------------------------------------------

  DATA: lt_romaneio        TYPE STANDARD TABLE OF ty_romaneio,
        lt_observacao      TYPE STANDARD TABLE OF zstm_obs,
        lt_pdf             TYPE STANDARD TABLE OF itcoo,
        lt_allocvaluesnum  TYPE TABLE OF bapi1003_alloc_values_num,
        lt_allocvalueschar TYPE TABLE OF bapi1003_alloc_values_char,
        lt_allocvaluestemp TYPE TABLE OF bapi1003_alloc_values_char,
        lt_allocvaluescurr TYPE TABLE OF bapi1003_alloc_values_curr,
        lt_return          TYPE TABLE OF bapiret2.

  DATA: ls_cab                TYPE zsmm_romaneio_cab,
        lt_ite                TYPE zctgmm_romaneio_ite,
        ls_ite                TYPE zsmm_romaneio_ite,
        lt_carac              TYPE zctgmm_romaneio_caract,
        ls_carac              TYPE zsmm_romaneio_caract,

        ls_return             TYPE ssfcrescl,
        ls_control_parameters TYPE ssfctrlop,
        ls_output_options     TYPE ssfcompop.

  DATA: lv_smartform TYPE rs38l_fnam,
        lv_classnum  TYPE  bapi1003_key-classnum,
        lv_conta     TYPE i,
        lv_linha     TYPE i.

  TRY.
      CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
        EXPORTING
          formname = gc_name_romaneio
        IMPORTING
          fm_name  = lv_smartform.

    CATCH cx_fp_api_repository.
      RAISE erro_get_form.
  ENDTRY.

  SELECT  a~doc_uuid_h,
          b~sequence,
          a~vbeln,
          b~ebeln,
          a~ebelp,
          a~posnr,
          a~charg,
          a~qtde,
          a~qtd_kg_original,
          b~nfnum,
          b~placa,
          b~motorista,
          b~dt_entrada,
          b~dt_chegada,
          c~corretor,
          c~nro_contrato,
          c~observacao
    FROM ztmm_romaneio_in AS b
    LEFT OUTER JOIN ztmm_romaneio_it AS a
    ON a~doc_uuid_h = b~doc_uuid_h
    LEFT OUTER JOIN ztmm_control_cla AS c
    ON c~ebeln = b~ebeln AND
       c~ebelp = a~ebelp
    INTO TABLE @lt_romaneio
    FOR ALL ENTRIES IN @it_key_rom
    WHERE b~sequence = @it_key_rom-romaneio.
  IF sy-subrc = 0.
    SORT lt_romaneio BY doc_uuid_h vbeln ebelp.

    LOOP AT lt_romaneio ASSIGNING FIELD-SYMBOL(<fs_romaneio>).
      <fs_romaneio>-xped     = <fs_romaneio>-ebeln.
      <fs_romaneio>-nitemped = <fs_romaneio>-ebelp.
      <fs_romaneio>-nitemped_aux = '0' && <fs_romaneio>-ebelp.
    ENDLOOP.

    SELECT *
      FROM i_br_nfitem_c
      FOR ALL ENTRIES IN @lt_romaneio
      WHERE purchaseorder = @lt_romaneio-xped
        AND ( purchaseorderitem = @lt_romaneio-nitemped OR
              purchaseorderitem = @lt_romaneio-nitemped_aux )
      INTO TABLE @DATA(lt_nfitem).
    IF sy-subrc = 0.

      SORT lt_nfitem BY purchaseorder purchaseorderitem.
      SELECT *
        FROM c_br_verifynotafiscal
        FOR ALL ENTRIES IN @lt_nfitem
        WHERE br_notafiscal = @lt_nfitem-br_notafiscal
        INTO TABLE @DATA(lt_verifynf).
      IF sy-subrc = 0.
        SORT lt_verifynf BY br_notafiscal.
      ENDIF.

      SELECT matnr,
             meins
        FROM mara
        INTO TABLE @DATA(lt_mara)
        FOR ALL ENTRIES IN @lt_nfitem
       WHERE matnr = @lt_nfitem-material.
      IF sy-subrc = 0.
        SORT lt_mara BY matnr.
      ENDIF.



    ENDIF.
  ENDIF.

  DATA(lo_param) = NEW zclca_tabela_parametros( ).

  TRY.
      lo_param->m_get_single( EXPORTING iv_modulo = gc_param-modulo
                                       iv_chave1 = gc_param-chave1
                                       iv_chave2 = gc_param-chave2
                              IMPORTING ev_param = lv_classnum ).

    CATCH zcxca_tabela_parametros INTO DATA(lo_cx).
      WRITE lo_cx->get_text( ).
  ENDTRY.

  LOOP AT lt_romaneio ASSIGNING <fs_romaneio>.
    DATA(lv_tatix) = sy-tabix.

    CLEAR:  lt_allocvaluesnum[],
            lt_allocvalueschar[],
            lt_allocvaluescurr[],
            lt_return[].

    ls_cab-romaneio        = <fs_romaneio>-sequence.
    ls_cab-nfnum           = <fs_romaneio>-nfnum.
    ls_cab-pedido          = <fs_romaneio>-ebeln.
    ls_cab-placa           = <fs_romaneio>-placa.
    ls_cab-motorista       = <fs_romaneio>-motorista.
    ls_cab-dt_entrada      = <fs_romaneio>-dt_entrada.
    ls_cab-corretor        = <fs_romaneio>-corretor.
    ls_cab-nro_contrato    = <fs_romaneio>-nro_contrato.
    ls_cab-observacao      = <fs_romaneio>-observacao.
    ls_cab-qtde            = <fs_romaneio>-qtde.
    ls_cab-qtd_kg_original = <fs_romaneio>-qtd_kg_original.

    READ TABLE lt_nfitem
          INTO DATA(ls_nfitem)
      WITH KEY purchaseorder      = <fs_romaneio>-xped
               purchaseorderitem  = <fs_romaneio>-nitemped
      BINARY SEARCH.
    IF sy-subrc <> 0.
      READ TABLE lt_nfitem INTO ls_nfitem
        WITH KEY purchaseorder      = <fs_romaneio>-xped
                 purchaseorderitem  = <fs_romaneio>-nitemped_aux
        BINARY SEARCH.
    ENDIF.
    IF sy-subrc = 0.
      READ TABLE lt_verifynf
            INTO DATA(ls_verifynf)
        WITH KEY br_notafiscal = ls_nfitem-br_notafiscal
        BINARY SEARCH.
      IF sy-subrc = 0.
        IF lv_tatix = 1.
          ls_cab-empresa         = ls_verifynf-companycodename.
          ls_cab-des_loc_neg     = ls_verifynf-br_nfreceivernamefrmtddesc.
          ls_cab-des_fornecedor  = ls_verifynf-br_nfissuernamefrmtddesc.
          ls_cab-data_entrega    = ls_verifynf-br_nfpostingdate.
        ENDIF.

        READ TABLE lt_mara
              INTO DATA(ls_mara)
          WITH KEY matnr = ls_nfitem-material
          BINARY SEARCH.
        IF sy-subrc <> 0.
          CLEAR: ls_mara.
        ENDIF.

        DATA lv_e_menge  TYPE ekpo-menge.

        IF ls_nfitem-baseunit = 'BAG'.
          DATA(lv_qtd_saca) = ls_nfitem-quantityinbaseunit.

          CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
            EXPORTING
              i_matnr              = ls_mara-matnr
              i_in_me              = ls_nfitem-baseunit
              i_out_me             = 'KG'
              i_menge              = ls_nfitem-quantityinbaseunit
            IMPORTING
              e_menge              = lv_e_menge
            EXCEPTIONS
              error_in_application = 1
              error                = 2
              OTHERS               = 3.
          IF sy-subrc = 0.
            DATA(lv_qtd_kg) = lv_e_menge.
          ENDIF.
        ELSEIF ls_nfitem-baseunit = 'KG'.
          lv_qtd_kg = ls_nfitem-quantityinbaseunit.

          CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
            EXPORTING
              i_matnr              = ls_mara-matnr
              i_in_me              = ls_nfitem-baseunit
              i_out_me             = 'BAG'
              i_menge              = ls_nfitem-quantityinbaseunit
            IMPORTING
              e_menge              = lv_e_menge
            EXCEPTIONS
              error_in_application = 1
              error                = 2
              OTHERS               = 3.
          IF sy-subrc = 0.
            lv_qtd_saca = lv_e_menge.
          ENDIF.
        ENDIF.

*        DATA(lv_in_me)   = ls_nfitem-baseunit.
*        DATA(lv_i_menge) = ls_nfitem-quantityinbaseunit.
*
*
*        CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
*          EXPORTING
*            i_matnr              = ls_mara-matnr
*            i_in_me              = lv_in_me
*            i_out_me             = ls_mara-meins
*            i_menge              = lv_i_menge
*          IMPORTING
*            e_menge              = lv_e_menge
*          EXCEPTIONS
*            error_in_application = 1
*            error                = 2
*            OTHERS               = 3.
*        IF sy-subrc = 0.
*          lv_e_menge = lv_e_menge.
*        ENDIF.

    ls_cab-qtde            = lv_qtd_saca.
    ls_cab-qtd_kg_original = lv_qtd_kg.
        APPEND VALUE #( romaneio        = <fs_romaneio>-sequence
                        recebimento     = <fs_romaneio>-vbeln
                        item            = <fs_romaneio>-ebelp
                        pedido          = <fs_romaneio>-ebeln
                        material        = ls_nfitem-br_nfitemtitle
                        lote            = |TC{ <fs_romaneio>-sequence }|
                        qtde            = lv_qtd_saca
                        qtd_kg_original = lv_qtd_kg )
              TO lt_ite.

        DATA(lv_objectkey) = CONV objnum( |{ ls_nfitem-material }{ <fs_romaneio>-charg }| ).

        CALL FUNCTION 'BAPI_OBJCL_GETDETAIL'
          EXPORTING
            objectkey        = lv_objectkey
            objecttable      = 'MCH1'
            classnum         = lv_classnum
            classtype        = '023'
            unvaluated_chars = abap_true
          TABLES
            allocvaluesnum   = lt_allocvaluesnum
            allocvalueschar  = lt_allocvalueschar
            allocvaluescurr  = lt_allocvaluescurr
            return           = lt_return.

        lt_allocvaluestemp = VALUE #( FOR <fs_allocvaluesnum>
                                   IN lt_allocvaluesnum
                                 ( charact_descr = <fs_allocvaluesnum>-charact_descr
                                   value_char    = <fs_allocvaluesnum>-value_relation ) ).
        APPEND LINES OF lt_allocvaluestemp TO lt_allocvalueschar.

        lv_conta = 0.
        lv_linha = 0.
        ls_carac-romaneio        = <fs_romaneio>-sequence.
        ls_carac-recebimento     = <fs_romaneio>-vbeln.
        ls_carac-item            = <fs_romaneio>-ebelp.

        DATA: lv_campo TYPE string,
              lv_stcon TYPE n LENGTH 2.

        FIELD-SYMBOLS: <fs_field> TYPE any.

        LOOP AT lt_allocvalueschar INTO DATA(ls_allocvalueschar). "#EC CI_NESTED
          DATA(lv_tabix_carac) = sy-tabix.
          lv_conta = lv_conta + 1.
          lv_stcon = lv_conta.

          CONCATENATE 'ls_carac-descr'
                      lv_stcon
                 INTO lv_campo.

          ASSIGN (lv_campo) TO <fs_field>.
          IF <fs_field> IS ASSIGNED.
            <fs_field> = ls_allocvalueschar-charact_descr.
          ENDIF.
          UNASSIGN <fs_field>.

          CONCATENATE 'ls_carac-value'
                      lv_stcon
                 INTO lv_campo.

          ASSIGN (lv_campo) TO <fs_field>.
          IF <fs_field> IS ASSIGNED.
            <fs_field> = ls_allocvalueschar-value_char.
          ENDIF.
          UNASSIGN <fs_field>.

          IF lv_conta = 4.
            lv_conta = 0.
            lv_linha = lv_linha + 1.
            ls_carac-linha = lv_linha.
            APPEND ls_carac TO lt_carac.
          ENDIF.
        ENDLOOP.
        IF lv_conta < 4 AND
           lv_conta > 0.
          APPEND ls_carac TO lt_carac.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.

  IF lt_carac[] IS NOT INITIAL.
    " Solicitado que as linhas de 'Solicitação' fiquem no final
    LOOP AT lt_carac ASSIGNING FIELD-SYMBOL(<fs_carac>).

      IF <fs_carac>-descr01 CS 'Localização'.
        <fs_carac>-linha = '999'.
      ELSEIF <fs_carac>-descr01 CS 'Quantidade'.
        <fs_carac>-linha = '001'.
      ENDIF.

    ENDLOOP.

    SORT lt_carac BY romaneio
                     recebimento
                     item
                     linha.
  ENDIF.

  IF ls_cab IS NOT INITIAL.
    IF lt_ite[] IS INITIAL.
      APPEND VALUE #( romaneio        = <fs_romaneio>-sequence
                      recebimento     = <fs_romaneio>-vbeln
                      item            = <fs_romaneio>-ebelp
                      pedido          = <fs_romaneio>-ebeln )
            TO lt_ite.
    ENDIF.
    ls_control_parameters-no_dialog = abap_true.
    ls_control_parameters-getotf    = abap_true.
    ls_control_parameters-preview   = space.
    ls_output_options-tddest        = gc_printer.

    CALL FUNCTION lv_smartform
      EXPORTING
        control_parameters = ls_control_parameters
        output_options     = ls_output_options
        user_settings      = space
        is_cab             = ls_cab
        it_ite             = lt_ite
        it_caract          = lt_carac
      IMPORTING
        job_output_info    = ls_return
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.

    IF sy-subrc IS INITIAL.


      lt_pdf   = ls_return-otfdata.
      et_otf[] = lt_pdf[].

      CALL FUNCTION 'CONVERT_OTF'
        EXPORTING
          format                = 'PDF'
        IMPORTING
          bin_filesize          = ev_filesize
          bin_file              = ev_file
        TABLES
          otf                   = lt_pdf
          lines                 = et_lines
        EXCEPTIONS
          err_max_linewidth     = 1
          err_format            = 2
          err_conv_not_possible = 3
          err_bad_otf           = 4
          OTHERS                = 5.
      IF sy-subrc NE 0.
        RAISE conversion_exception.
      ENDIF.

    ENDIF.
  ENDIF.


ENDFUNCTION.
