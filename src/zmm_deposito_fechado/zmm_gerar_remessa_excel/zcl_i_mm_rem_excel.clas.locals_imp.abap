CLASS lcl_geracaoremessa DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    TYPES: ty_file_excel   TYPE TABLE OF ztmm_rem_excel WITH DEFAULT KEY.

    TYPES ty_emissao_cds   TYPE zi_mm_administrar_emissao_nf .
    TYPES:
      ty_t_emissao_cds     TYPE STANDARD TABLE OF ty_emissao_cds .

    DATA: lt_emissao_final TYPE ty_t_emissao_cds,
          lt_parameters    TYPE tihttpnvp.

    DATA: lv_pedido TYPE char10,
          lv_error  TYPE abap_bool VALUE abap_false.

    CONSTANTS: BEGIN OF lc_values,
                 cockpit         TYPE char30   VALUE 'ZZ1_ADM_EMI_NF',
                 cockpitaction   TYPE char60   VALUE 'manage',
                 centro_origem   TYPE char30   VALUE 'OriginPlant',
                 deposito_origem TYPE char30   VALUE 'OriginStorageLocation',
                 pedido          TYPE char30   VALUE 'PurchaseOrder2',
                 tipo_estoque    TYPE char30   VALUE 'EANType',
               END OF lc_values.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK geracaoremessa.

    METHODS read FOR READ
      IMPORTING keys FOR READ geracaoremessa RESULT result.

    METHODS touploadsimbolica FOR MODIFY
      IMPORTING keys FOR ACTION geracaoremessa~touploadsimbolica.

    METHODS touploadtransporte FOR MODIFY
      IMPORTING keys FOR ACTION geracaoremessa~touploadtransporte.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR geracaoremessa RESULT result.

    METHODS togeturl FOR MODIFY
      IMPORTING keys FOR ACTION geracaoremessa~togeturl RESULT result.

ENDCLASS.

CLASS lcl_geracaoremessa IMPLEMENTATION.

  METHOD lock.                                              "#EC NEEDED
  ENDMETHOD.

  METHOD read.                                              "#EC NEEDED
  ENDMETHOD.

  METHOD touploadsimbolica.

    DATA: lt_emissao_cds TYPE STANDARD TABLE OF zi_mm_administrar_emissao_nf.

    DATA(lo_events) = NEW zclmm_adm_emissao_nf_events( ).

    DATA: lt_emissao_dados   TYPE ty_t_emissao_cds.

    DATA: ls_emissao TYPE ty_emissao_cds.

    DATA: lv_qtd   TYPE p LENGTH 7 DECIMALS 3,
          lv_resto TYPE p LENGTH 7 DECIMALS 3.

    CONSTANTS: lc_sta_init TYPE c LENGTH 2 VALUE '00'.

    lv_error = abap_false.

    CLEAR: lt_emissao_final[],
           lv_pedido.

* ---------------------------------------------------------------------------
* Recupera os dados de Emissão
* ---------------------------------------------------------------------------
    IF keys[] IS NOT INITIAL.

      SELECT *                                          "#EC CI_SEL_DEL
        FROM zi_mm_administrar_emissao_nf
        FOR ALL ENTRIES IN @keys
        WHERE eantype                = @keys-%param-tipo_estoque
          AND material               = @keys-%param-material
          AND originplant            = @keys-%param-centro_origem
          AND originstoragelocation  = @keys-%param-deposito_origem
          AND eantype                = @keys-%param-tipo_estoque
          AND destinyplant           = @keys-%param-centro_destino
          AND destinystoragelocation = @keys-%param-deposito_destino
          AND status                 = @lc_sta_init
        INTO CORRESPONDING FIELDS OF TABLE @lt_emissao_dados.

      IF sy-subrc NE 0.
        FREE lt_emissao_dados.
      ELSE.

        SORT lt_emissao_dados BY material availablestock_conve DESCENDING.

        LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_key>).

          lv_qtd = <fs_key>-%param-qtd_transferencia.

          LOOP AT lt_emissao_dados ASSIGNING FIELD-SYMBOL(<fs_emissao>) WHERE material               = <fs_key>-%param-material "#EC CI_NESTED
                                                                        AND originplant            = <fs_key>-%param-centro_origem
                                                                        AND originstoragelocation  = <fs_key>-%param-deposito_origem
                                                                        AND destinyplant           = <fs_key>-%param-centro_destino
                                                                        AND destinystoragelocation = <fs_key>-%param-deposito_destino. "#EC CI_STDSEQ
            CHECK lv_qtd NE 0.

            DATA(lv_tabix_aux) = sy-tabix.

            IF lv_qtd < <fs_emissao>-availablestock_conve.

              <fs_emissao>-usedstock_conve = lv_qtd.

              <fs_emissao>-availablestock_conve = <fs_emissao>-availablestock_conve - lv_qtd.

              APPEND <fs_emissao> TO lt_emissao_final.

              CLEAR: lv_qtd.

            ELSE.

              lv_resto = lv_qtd - <fs_emissao>-availablestock_conve.

              lv_qtd = lv_resto.

              <fs_emissao>-usedstock_conve = <fs_emissao>-availablestock_conve.

              APPEND <fs_emissao> TO lt_emissao_final.

              DELETE lt_emissao_dados INDEX lv_tabix_aux.

            ENDIF.

          ENDLOOP.

        ENDLOOP.

      ENDIF.

      IF lt_emissao_final IS NOT INITIAL.

        DATA: lt_emissao_new TYPE STANDARD TABLE OF zi_mm_administrar_emissao_nf.

* ---------------------------------------------------------------------------
* Recupera a chave e os novos dados informados
* ---------------------------------------------------------------------------
        lt_emissao_new[] = VALUE #( FOR ls_keys IN lt_emissao_final ( material                = ls_keys-material
                                                                      originplant             = ls_keys-originplant
                                                                      originstoragelocation   = ls_keys-originstoragelocation
                                                                      originunit              = ls_keys-originunit
                                                                      unit                    = ls_keys-unit
                                                                      guid                    = ls_keys-guid
                                                                      batch                   = ls_keys-batch
                                                                      prmdepfecid             = ls_keys-prmdepfecid
                                                                      processstep             = ls_keys-processstep
                                                                      eantype                 = COND #( WHEN ls_keys-eantype IS INITIAL THEN '00' ELSE ls_keys-eantype )
                                                                      usedstock               = ls_keys-usedstock_conve "ls_keys-%param-newusedstock
                                                                      useavailable            = abap_false ) ).

* ---------------------------------------------------------------------------
* Salva os dados de emissão
* ---------------------------------------------------------------------------
*        DATA(lo_events) = NEW zclmm_adm_emissao_nf_events( ).

        lo_events->save_issue( EXPORTING it_emissao_cds = lt_emissao_new
                                         iv_checkbox    = abap_false
                               IMPORTING et_return      = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
        lo_events->build_reported( EXPORTING it_return   = lt_return
                                   IMPORTING es_reported = DATA(lt_reported) ).

        reported-geracaoremessa = VALUE #( FOR ls_mensagem IN lt_return (
                %msg = new_message( id       = ls_mensagem-id
                                    number   = ls_mensagem-number
                                    severity = COND #( WHEN ls_mensagem-type = 'W'
                                                       THEN if_abap_behv_message=>severity-information
                                                       ELSE CONV #( ls_mensagem-type ) )
                                    v1       = ls_mensagem-message_v1
                                    v2       = ls_mensagem-message_v2
                                    v3       = ls_mensagem-message_v3
                                    v4       = ls_mensagem-message_v4 ) ) ) .


      ENDIF.

    ENDIF.

    IF reported-geracaoremessa IS NOT INITIAL.

      APPEND VALUE #( %tky = keys[ 1 ]-%tky ) TO failed-geracaoremessa.

    ELSE.

      IF lt_emissao_final IS NOT INITIAL.

        SELECT SINGLE low
          FROM ztca_param_val
          WHERE modulo = 'MM'
            AND chave1 = 'LIMITADOR_ITENS'
            AND chave2 = 'QTDE_ITENS_NF'
            AND chave3 IS INITIAL
          INTO @DATA(lv_limitador_itens).

        lt_emissao_cds[] = VALUE #( FOR ls_keys IN lt_emissao_final ( material              = ls_keys-material
                                                                      originplant           = ls_keys-originplant
                                                                      originstoragelocation = ls_keys-originstoragelocation
                                                                      originunit            = ls_keys-originunit
                                                                      unit                  = ls_keys-unit
                                                                      guid                  = ls_keys-guid
                                                                      batch                 = ls_keys-batch
                                                                      processstep           = ls_keys-processstep
                                                                      prmdepfecid           = ls_keys-prmdepfecid
                                                                      eantype               = ls_keys-eantype ) ).

* ---------------------------------------------------------------------------
* Cria NFe
* ---------------------------------------------------------------------------
        DATA(lo_events_) = NEW zclmm_adm_emissao_nf_events( ).

        IF lv_limitador_itens IS NOT INITIAL.
          IF lines( keys ) > lv_limitador_itens.
            DATA(lt_return1) = VALUE bapiret2_t( ( type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '041' message_v1 = lv_limitador_itens ) ).

            lo_events_->build_reported( EXPORTING it_return   = lt_return1
                                       IMPORTING es_reported = DATA(lt_reported1) ).

            reported = CORRESPONDING #( DEEP lt_reported1 ).

            RETURN.
          ENDIF.
        ENDIF.

        lo_events_->create_documents_f02( EXPORTING it_emissao_cds = lt_emissao_cds[]
                                          IMPORTING et_return      = lt_return1 ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
        lo_events_->build_reported( EXPORTING it_return   = lt_return1
                                   IMPORTING es_reported = lt_reported1 ).

        reported-geracaoremessa = VALUE #(
            FOR ls_mensagem IN lt_return1 (
              %msg = new_message( id       = ls_mensagem-id
                                  number   = ls_mensagem-number
                                  severity = COND #( WHEN ls_mensagem-type = 'W'
                                                     THEN if_abap_behv_message=>severity-information
                                                     ELSE CONV #( ls_mensagem-type ) )
                                  v1       = ls_mensagem-message_v1
                                  v2       = ls_mensagem-message_v2
                                  v3       = ls_mensagem-message_v3
                                  v4       = ls_mensagem-message_v4 ) ) ) .

        IF line_exists( lt_return1[ type = 'E' ] ).      "#EC CI_STDSEQ

          lv_error = abap_true.

        ENDIF.

        IF line_exists( lt_return1[ type = 'S' ] ).      "#EC CI_STDSEQ

          lv_pedido = lt_return1[ type = 'S' ]-message_v1. "#EC CI_STDSEQ

        ENDIF.

        IF failed-geracaoremessa IS INITIAL AND lv_error EQ abap_false.

          TRY.
              DATA(lo_generator) = cl_uuid_factory=>create_system_uuid(  ).
              DATA(lv_guid) = lo_generator->create_uuid_x16( ).
            CATCH cx_uuid_error.

          ENDTRY.

          READ TABLE lt_emissao_final ASSIGNING FIELD-SYMBOL(<fs_arquivo>) INDEX 1.
          IF sy-subrc IS INITIAL.

            DATA(lt_files) = VALUE ty_file_excel( ( guid              = lv_guid
                                                    created_date      = sy-datum
                                                    created_time      = sy-uzeit
                                                    created_user      = sy-uname
                                                    file_directory    = keys[ 1 ]-%param-file_directory
                                                    centro_origem     = <fs_arquivo>-originplant
                                                    deposito_origem   = <fs_arquivo>-originstoragelocation
                                                    tipo_estoque      = <fs_arquivo>-eantype
                                                    pedido            = lv_pedido
                                                    tipo_remessa      = keys[ 1 ]-%param-tipo_remessa ) ).

            MODIFY ztmm_rem_excel FROM TABLE lt_files.

          ENDIF.

        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.

  METHOD touploadtransporte.

    DATA: lt_emissao_cds TYPE STANDARD TABLE OF zi_mm_administrar_emissao_nf.

    DATA(lo_events) = NEW zclmm_adm_emissao_nf_events( ).

    DATA: lt_emissao_dados TYPE ty_t_emissao_cds.

    DATA: ls_emissao TYPE ty_emissao_cds.

    DATA: lv_qtd   TYPE p LENGTH 7 DECIMALS 3,
          lv_resto TYPE p LENGTH 7 DECIMALS 3.

    CONSTANTS: lc_sta_init TYPE c LENGTH 2 VALUE '00'.

    lv_error = abap_false.

    CLEAR: lt_emissao_final[],
           lv_pedido.

* ---------------------------------------------------------------------------
* Recupera os dados de Emissão
* ---------------------------------------------------------------------------
    IF keys[] IS NOT INITIAL.

      SELECT *                                          "#EC CI_SEL_DEL
        FROM zi_mm_administrar_emissao_nf
        FOR ALL ENTRIES IN @keys
        WHERE eantype                = @keys-%param-tipo_estoque
          AND material               = @keys-%param-material
          AND originplant            = @keys-%param-centro_origem
          AND originstoragelocation  = @keys-%param-deposito_origem
          AND eantype                = @keys-%param-tipo_estoque
          AND destinyplant           = @keys-%param-centro_destino
          AND destinystoragelocation = @keys-%param-deposito_destino
          AND status                 = @lc_sta_init
        INTO CORRESPONDING FIELDS OF TABLE @lt_emissao_dados.

      IF sy-subrc NE 0.
        FREE lt_emissao_dados.
      ELSE.

        SORT lt_emissao_dados BY material availablestock_conve DESCENDING.

        LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_key>).

          lv_qtd = <fs_key>-%param-qtd_transferencia.

          LOOP AT lt_emissao_dados ASSIGNING FIELD-SYMBOL(<fs_emissao>) WHERE material               = <fs_key>-%param-material "#EC CI_STDSEQ
                                                                        AND originplant            = <fs_key>-%param-centro_origem
                                                                        AND originstoragelocation  = <fs_key>-%param-deposito_origem
                                                                        AND destinyplant           = <fs_key>-%param-centro_destino
                                                                        AND destinystoragelocation = <fs_key>-%param-deposito_destino. "#EC CI_NESTED

            <fs_emissao>-newcarrier            = <fs_key>-%param-transportador.                    "Transportador
            <fs_emissao>-newdriver             = <fs_key>-%param-motorista.                      "Motorista
            <fs_emissao>-newequipment          = <fs_key>-%param-veiculo.                 "Placa do veículo
            <fs_emissao>-newshippingconditions = <fs_key>-%param-cond_expedicao.          "Condição expedição
            <fs_emissao>-newshippingtype       = <fs_key>-%param-tipo_expedicao.                "Tipo de expedição
            <fs_emissao>-newequipmenttow1      = <fs_key>-%param-semireboque1.               "Placa Semi-reboque 1
            <fs_emissao>-newequipmenttow2      = <fs_key>-%param-semireboque2.               "Placa Semi-reboque 2
            <fs_emissao>-newequipmenttow3      = <fs_key>-%param-semireboque3.              "Placa Semi-reboque 3
            <fs_emissao>-newfreightmode        = <fs_key>-%param-modalidadefrete.            "Modalidade Frete

            CHECK lv_qtd NE 0.

            DATA(lv_tabix_aux) = sy-tabix.

            IF lv_qtd < <fs_emissao>-availablestock_conve.

              <fs_emissao>-usedstock_conve = lv_qtd.

              <fs_emissao>-availablestock_conve = <fs_emissao>-availablestock_conve - lv_qtd.

              APPEND <fs_emissao> TO lt_emissao_final.

              CLEAR: lv_qtd.

            ELSE.

              lv_resto = lv_qtd - <fs_emissao>-availablestock_conve.

              lv_qtd = lv_resto.

              <fs_emissao>-usedstock_conve = <fs_emissao>-availablestock_conve.

              APPEND <fs_emissao> TO lt_emissao_final.

              DELETE lt_emissao_dados INDEX lv_tabix_aux.

            ENDIF.

          ENDLOOP.

        ENDLOOP.

      ENDIF.

      IF lt_emissao_final IS NOT INITIAL.

        DATA: lt_emissao_new TYPE STANDARD TABLE OF zi_mm_administrar_emissao_nf.

* ---------------------------------------------------------------------------
* Recupera a chave e os novos dados informados
* ---------------------------------------------------------------------------
        lt_emissao_new[] = VALUE #( FOR ls_keys IN lt_emissao_final ( material                = ls_keys-material
                                                                      originplant             = ls_keys-originplant
                                                                      originstoragelocation   = ls_keys-originstoragelocation
                                                                      originunit              = ls_keys-originunit
                                                                      unit                    = ls_keys-unit
                                                                      guid                    = ls_keys-guid
                                                                      batch                   = ls_keys-batch
                                                                      prmdepfecid             = ls_keys-prmdepfecid
                                                                      processstep             = ls_keys-processstep
                                                                      eantype                 = COND #( WHEN ls_keys-eantype IS INITIAL THEN '00' ELSE ls_keys-eantype )
                                                                      usedstock               = ls_keys-usedstock_conve "ls_keys-%param-newusedstock
                                                                      useavailable            = abap_false ) ).

* ---------------------------------------------------------------------------
* Salva os dados de emissão
* ---------------------------------------------------------------------------

        lo_events->save_issue( EXPORTING it_emissao_cds = lt_emissao_new
                                         iv_checkbox    = abap_false
                               IMPORTING et_return      = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
        lo_events->build_reported( EXPORTING it_return   = lt_return
                                   IMPORTING es_reported = DATA(lt_reported) ).

        reported-geracaoremessa = VALUE #( FOR ls_mensagem IN lt_return (
                %msg = new_message( id       = ls_mensagem-id
                                    number   = ls_mensagem-number
                                    severity = COND #( WHEN ls_mensagem-type = 'W'
                                                       THEN if_abap_behv_message=>severity-information
                                                       ELSE CONV #( ls_mensagem-type ) )
                                    v1       = ls_mensagem-message_v1
                                    v2       = ls_mensagem-message_v2
                                    v3       = ls_mensagem-message_v3
                                    v4       = ls_mensagem-message_v4 ) ) ) .


      ENDIF.

    ENDIF.

    IF reported-geracaoremessa IS NOT INITIAL.

      APPEND VALUE #( %tky = keys[ 1 ]-%tky ) TO failed-geracaoremessa.

    ELSE.

      CHECK lt_emissao_final IS NOT INITIAL.

      SELECT SINGLE low
        FROM ztca_param_val
        WHERE modulo = 'MM'
          AND chave1 = 'LIMITADOR_ITENS'
          AND chave2 = 'QTDE_ITENS_NF'
          AND chave3 IS INITIAL
        INTO @DATA(lv_limitador_itens).

      LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_key_aux>).

        IF <fs_key_aux>-%param-transportador IS INITIAL.

          APPEND VALUE #( %tky                = <fs_key_aux>-%tky ) TO failed-geracaoremessa.

          APPEND VALUE #( %tky                = <fs_key_aux>-%tky
                          %msg                = new_message(  id       = 'ZMM_DEPOSITO_FECHADO'
                                                              number   = '042' " Document cannot be extended into the past
                                                              severity = if_abap_behv_message=>severity-error )
                          ) TO reported-geracaoremessa.

          lv_error = abap_true.
        ENDIF.

      ENDLOOP.

      CHECK lv_error = abap_false.

      lt_emissao_cds[] = VALUE #( FOR ls_keys IN lt_emissao_final ( material              = ls_keys-material                      "Material
                                                                    originplant           = ls_keys-originplant                   "Centro Origem
                                                                    originstoragelocation = ls_keys-originstoragelocation         "Deposito
                                                                    originunit            = ls_keys-originunit                    "Unidade Original
                                                                    unit                  = ls_keys-unit                          "Unidade
                                                                    guid                  = ls_keys-guid
                                                                    batch                 = ls_keys-batch
                                                                    processstep           = ls_keys-processstep
                                                                    prmdepfecid           = ls_keys-prmdepfecid
                                                                    eantype               = ls_keys-eantype                        "Ctg.de número do nº europeu do artigo - mean-EANTP
                                                                    newcarrier            = ls_keys-newcarrier                     "Transportador
                                                                    newdriver             = ls_keys-newdriver                      "Motorista
                                                                    newequipment          = ls_keys-newequipment                   "Placa do veículo
                                                                    newshippingconditions = ls_keys-newshippingconditions          "Condição expedição
                                                                    newshippingtype       = ls_keys-newshippingtype                "Tipo de expedição
                                                                    newequipmenttow1      = ls_keys-newequipmenttow1               "Placa Semi-reboque 1
                                                                    newequipmenttow2      = ls_keys-newequipmenttow2               "Placa Semi-reboque 2
                                                                    newequipmenttow3      = ls_keys-newequipmenttow3               "Placa Semi-reboque 3
                                                                    newfreightmode        = ls_keys-newfreightmode ) ).            "Modalidade Frete

* ---------------------------------------------------------------------------
* Cria NFe
* ---------------------------------------------------------------------------

      IF lv_limitador_itens IS NOT INITIAL.
        IF lines( keys ) > lv_limitador_itens.
          DATA(lt_return1) = VALUE bapiret2_t( ( type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '041' message_v1 = lv_limitador_itens ) ).

          lo_events->build_reported( EXPORTING it_return   = lt_return1
                                     IMPORTING es_reported = DATA(lt_reported1) ).

          reported = CORRESPONDING #( DEEP lt_reported1 ).

          RETURN.
        ENDIF.
      ENDIF.

      lo_events->create_documents_f02( EXPORTING it_emissao_cds = lt_emissao_cds[]
                                       IMPORTING et_return      = lt_return1 ).
      DATA(lt_return_aux) = lt_return1.

      LOOP AT lt_return1 ASSIGNING FIELD-SYMBOL(<fs_return>).
        DATA(lv_tabix) = sy-tabix.
        READ TABLE lt_return1 TRANSPORTING NO FIELDS WITH KEY message = <fs_return>-message. "#EC CI_STDSEQ
        IF sy-subrc = 0 AND sy-tabix <> lv_tabix.
          DELETE lt_return1 INDEX lv_tabix.
        ENDIF.
      ENDLOOP.

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
      lo_events->build_reported( EXPORTING it_return   = lt_return1
                                 IMPORTING es_reported = lt_reported1 ).

      reported-geracaoremessa = VALUE #(
        FOR ls_mensagem IN lt_return1 (
          %msg = new_message( id       = ls_mensagem-id
                              number   = ls_mensagem-number
                              severity = COND #( WHEN ls_mensagem-type = 'W'
                                                 THEN if_abap_behv_message=>severity-information
                                                 ELSE CONV #( ls_mensagem-type ) )
                              v1       = ls_mensagem-message_v1
                              v2       = ls_mensagem-message_v2
                              v3       = ls_mensagem-message_v3
                              v4       = ls_mensagem-message_v4 ) ) ) .

      IF line_exists( lt_return1[ type = 'E' ] ).        "#EC CI_STDSEQ

        lv_error = abap_true.

      ENDIF.

      IF line_exists( lt_return1[ type = 'S' ] ).        "#EC CI_STDSEQ

        lv_pedido = lt_return1[ type = 'S' ]-message_v1. "#EC CI_STDSEQ

      ENDIF.

      IF failed-geracaoremessa IS INITIAL AND lv_error EQ abap_false.

        TRY.
            DATA(lo_generator) = cl_uuid_factory=>create_system_uuid(  ).
            DATA(lv_guid) = lo_generator->create_uuid_x16( ).
          CATCH cx_uuid_error.

        ENDTRY.

        READ TABLE lt_emissao_final ASSIGNING FIELD-SYMBOL(<fs_arquivo>) INDEX 1.
        IF sy-subrc IS INITIAL.

          DATA(lt_files) = VALUE ty_file_excel( ( guid              = lv_guid
                                                  created_date      = sy-datum
                                                  created_time      = sy-uzeit
                                                  created_user      = sy-uname
                                                  file_directory    = keys[ 1 ]-%param-file_directory
                                                  centro_origem     = <fs_arquivo>-originplant
                                                  deposito_origem   = <fs_arquivo>-originstoragelocation
                                                  tipo_estoque      = <fs_arquivo>-eantype
                                                  pedido            = lv_pedido
                                                  tipo_remessa      = keys[ 1 ]-%param-tipo_remessa ) ).

          MODIFY ztmm_rem_excel FROM TABLE lt_files.

        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.

  METHOD get_features.                                      "#EC NEEDED
  ENDMETHOD.

  METHOD togeturl.

    DATA(lv_guid) = keys[ 1 ]-guid.

    SELECT SINGLE *
        FROM ztmm_rem_excel
        WHERE guid EQ @lv_guid
        INTO @DATA(ls_arquivo).

    IF sy-subrc IS INITIAL.

      lt_parameters = VALUE #( ( name  = lc_values-centro_origem
                        value = ls_arquivo-centro_origem )

                        ( name  = lc_values-deposito_origem
                        value = ls_arquivo-deposito_origem )

                        ( name  = lc_values-pedido
                        value = ls_arquivo-pedido )

                        ( name  = lc_values-tipo_estoque
                        value = ls_arquivo-tipo_estoque )
                         ).

      DATA(lv_url) = cl_lsapi_manager=>create_flp_url( object     = lc_values-cockpit
                                                       action     = lc_values-cockpitaction
                                                       parameters = lt_parameters ).

      APPEND VALUE #( %msg = new_message( id       = 'ZSD_INTERC_UPLD'
                                          number   = '000'
                                          severity = if_abap_behv_message=>severity-success
                                          v1       = |{ lv_url(50) }|
                                          v2       = |{ lv_url+50(50) }|
                                          v3       = |{ lv_url+100 }|
                                          v4       = |{ lv_url+150 }| )
                    ) TO reported-geracaoremessa.

    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_zi_mm_rem_excel DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lcl_zi_mm_rem_excel IMPLEMENTATION.

  METHOD check_before_save.                                 "#EC NEEDED
  ENDMETHOD.

  METHOD finalize.                                          "#EC NEEDED
  ENDMETHOD.

  METHOD save.                                              "#EC NEEDED
  ENDMETHOD.

ENDCLASS.
