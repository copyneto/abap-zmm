"!<p>Essa classe é utilizada para validar o Pré Pedido do <strong>Mercado Eletronico</strong>
"!<p><strong>Autor:</strong> Bruno Costa - Meta</p>
"!<p><strong>Data:</strong> 25/10/2021</p>
CLASS zclmm_valida_pre_pedido DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    "! Método para ser chamado no Objeto que vai disparar o processo
    "! @parameter is_arquivo_me  | Arquivo do Mercado Eletronico
    "! @parameter iv_pedido      | Numero do Pedido SAP
    "! @parameter iv_pedido_me   | Numero do Pedido Mercado Eletronico
    METHODS process
      IMPORTING
        !is_arquivo_me TYPE zsmm_arquivo_me
        !iv_pedido     TYPE ekko-ebeln
        !iv_pedido_me  TYPE ekko-ihrez
      EXPORTING
        !ev_status     TYPE num03
        !ev_obserp     TYPE string.


  PROTECTED SECTION.

  PRIVATE SECTION.

    TYPES: BEGIN OF ty_ped,
             purchaseorder           TYPE ebeln,
             purchaseorderitem       TYPE ebelp,
             pricingdocument         TYPE knumv,
             pricingdocumentitem     TYPE kposn,
             pricingprocedurestep    TYPE stunr,
             pricingprocedurecounter TYPE vfprc_cond_count,
             conditiontype           TYPE kscha,
             conditionamount         TYPE vfprc_element_value,
           END OF ty_ped.

    DATA: gs_arquivo_me TYPE zsmm_arquivo_me.

    DATA: gv_ebeln TYPE ekko-ebeln,
          gv_ihrez TYPE ekko-ihrez.

    DATA: BEGIN OF gs_param,
            modulo TYPE ztca_param_par-modulo VALUE 'MM',
            chave1 TYPE ztca_param_par-chave1 VALUE 'ME',
            chave2 TYPE ztca_param_par-chave2 VALUE 'PRCD_ELEMENTS',
            ipi    TYPE ztca_param_par-chave3 VALUE 'IPI',
            icms   TYPE ztca_param_par-chave3 VALUE 'ICMS',
            zipi   TYPE ztca_param_par-chave3 VALUE 'ZIPI',
            zicms  TYPE ztca_param_par-chave3 VALUE 'ZICMS',
            s      TYPE c VALUE 'S',
            e      TYPE c VALUE 'e',
          END OF gs_param.

    "! Selecionar para verificar o valor do pedido (SAP x ME)
    "! @parameter ev_status | Código de retorno status
    "! @parameter ev_obserp | Mensagem de retorno
    METHODS verifica_valor
      EXPORTING
        !ev_status TYPE num03
        !ev_obserp TYPE string.

    "! Atualizar o pedido SAP via BAPI
    METHODS atualiza_pedido.

    "! Atualizar a tabela de controle de interface
    "! @parameter iv_obserp | Mensagem de retorno
    METHODS atualiza_controle_interface
      IMPORTING
        iv_obserp TYPE string.

    METHODS calc_percentual
      IMPORTING
        is_purord          TYPE ty_ped OPTIONAL
        is_item_me         TYPE zsmm_item_me OPTIONAL
        iv_tipo            TYPE ze_param_chave_3
        iv_netpr_me        TYPE netpr OPTIONAL
        iv_netpr_sap       TYPE netpr OPTIONAL
      EXPORTING
        ev_conditionamount TYPE wertv8
        ev_1perc           TYPE wertv8
        ev_dif             TYPE wertv8.

ENDCLASS.



CLASS zclmm_valida_pre_pedido IMPLEMENTATION.


  METHOD process.

    gs_arquivo_me = is_arquivo_me.
    gv_ebeln      = iv_pedido.
    gv_ihrez      = iv_pedido_me.

    verifica_valor( IMPORTING  ev_status = ev_status
                               ev_obserp = ev_obserp ).

    CASE ev_status.
      WHEN 104."Sucesso
        atualiza_pedido(  ).
      WHEN 109."Erro
        atualiza_controle_interface( iv_obserp = ev_obserp ).
    ENDCASE.

  ENDMETHOD.


  METHOD verifica_valor.

    TYPES: ty_taxes   TYPE TABLE OF kscha WITH DEFAULT KEY.

    DATA: lv_netpr   TYPE netpr,
          lv_netpr_2 TYPE bprei,
          lr_taxes   TYPE RANGE OF rspopname,
          lt_taxes   TYPE TABLE OF kscha WITH DEFAULT KEY,
          ls_itens   TYPE string.

    IF gs_arquivo_me-cancelado EQ gs_param-s.

      ev_status = 3.
      ev_obserp = |{ TEXT-013 }| & | | & |{ gv_ebeln }| & | | & |{ TEXT-014 }|.

    ELSE.

      SELECT SINGLE purchaseorder
               FROM i_purorditmpricingelementapi01
               INTO @DATA(lv_purchaseorder)
              WHERE purchaseorder EQ @gv_ebeln.

      IF sy-subrc NE 0.

        ev_status = 109.
        ev_obserp =  |{ TEXT-001 }| & | | & |{ gv_ebeln }| & | | & |{ TEXT-002 }| & | | & |{ gv_ihrez }|.
        EXIT.

      ENDIF.

      SELECT ebeln, ebelp, netpr
        FROM purgdocitem
          INTO TABLE @DATA(lt_purgdocitem)
         WHERE ebeln EQ @gv_ebeln.

      IF sy-subrc EQ 0.

        CLEAR lv_netpr.

        LOOP AT lt_purgdocitem ASSIGNING FIELD-SYMBOL(<fs_purgdocitem>).
          ADD <fs_purgdocitem>-netpr TO lv_netpr.
        ENDLOOP.

      ENDIF.

      CLEAR lv_netpr_2.

      LOOP AT gs_arquivo_me-item ASSIGNING FIELD-SYMBOL(<fs_item_me>).
        <fs_item_me>-precosemimposto = ( <fs_item_me>-precosemimposto / <fs_item_me>-peinh ).
        ADD <fs_item_me>-precosemimposto TO lv_netpr_2.
        CONCATENATE ls_itens <fs_item_me>-bnfpo  INTO ls_itens SEPARATED BY ', '.
      ENDLOOP.

      IF  lv_netpr NE lv_netpr_2.

        calc_percentual(
      EXPORTING
          iv_tipo      = space
          iv_netpr_me  = lv_netpr_2
          iv_netpr_sap = lv_netpr
      IMPORTING
      ev_1perc           = DATA(lv_1perc)
      ev_conditionamount = DATA(lv_conditionamount)
      ev_dif             = DATA(lv_dif) ).

        IF lv_dif GT lv_1perc.

          ev_status = 112.
          ev_obserp =  |{ TEXT-001 }| & | | & |{ gv_ebeln }| & | | &
                       |{ TEXT-003 }| & | | & |{ gv_ihrez }| & | | &
                       |{ TEXT-004 }| & | | & |{ lv_netpr }| & | | &
                       |{ TEXT-005 }| & | | & |{ lv_netpr_2 }|.

          EXIT.
        ENDIF.

      ENDIF.

      DATA(lo_parametro) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 21.07.2023

      DO 2 TIMES.

        TRY.

            lo_parametro->m_get_range(
              EXPORTING
                iv_modulo = gs_param-modulo
                iv_chave1 = gs_param-chave1
                iv_chave2 = gs_param-chave2
                iv_chave3 = COND #( WHEN sy-index EQ 1 THEN gs_param-ipi ELSE gs_param-icms )
              IMPORTING
                et_range  = lr_taxes ).

            IF lr_taxes IS NOT INITIAL.

              DATA(lt_taxes_ref) = VALUE ty_taxes( FOR ls_range IN lr_taxes (  ls_range-low  ) ).

              APPEND LINES OF lt_taxes_ref TO lt_taxes.

              CLEAR: lr_taxes[], lt_taxes_ref[].

            ENDIF.

          CATCH zcxca_tabela_parametros.

        ENDTRY.

      ENDDO.

      IF lt_taxes IS NOT INITIAL.

        SELECT purchaseorder, purchaseorderitem, pricingdocument, pricingdocumentitem, pricingprocedurestep,
               pricingprocedurecounter, conditiontype, conditionamount
          FROM i_purorditmpricingelementapi01
          FOR ALL ENTRIES IN @lt_taxes
         WHERE purchaseorder EQ @gv_ebeln
           AND conditiontype EQ @lt_taxes-table_line
                 INTO TABLE @DATA(lt_purorditmpricing).

        IF sy-subrc EQ 0.

          SORT gs_arquivo_me-item BY ebelp.

          LOOP AT lt_purorditmpricing ASSIGNING FIELD-SYMBOL(<fs_purorditmpricing>).

            CLEAR: lv_conditionamount,
                   lv_1perc,
                   lv_dif.

            READ TABLE gs_arquivo_me-item ASSIGNING <fs_item_me> WITH KEY ebelp = ( <fs_purorditmpricing>-purchaseorderitem / 10 ) BINARY SEARCH.

            CHECK sy-subrc EQ 0.

            CASE <fs_purorditmpricing>-conditiontype.

              WHEN gs_param-zicms.

                calc_percentual(
                    EXPORTING
                        is_purord  = <fs_purorditmpricing>
                        is_item_me = <fs_item_me>
                        iv_tipo    = gs_param-zicms
                    IMPORTING
                    ev_1perc           = lv_1perc
                    ev_conditionamount = lv_conditionamount
                    ev_dif             = lv_dif ).

                IF <fs_purorditmpricing>-conditionamount NE lv_conditionamount
                AND lv_dif GT lv_1perc.

                  DATA(lv_div_item) = abap_true.
                  ev_obserp = |{ TEXT-006 }| & | | &
                              |{ TEXT-007 }| & | | &
                              |{ <fs_purorditmpricing>-purchaseorderitem }| & | | &
                              |{ TEXT-004 }| & | | &
                              |{ <fs_purorditmpricing>-conditionamount }| & | { gs_param-e } | &
                              |{ TEXT-008 }| & | | &
                              |{ lv_conditionamount }| & | . |.

                ENDIF.

              WHEN gs_param-zipi.

                calc_percentual(
                                   EXPORTING
                                       is_purord  = <fs_purorditmpricing>
                                       is_item_me = <fs_item_me>
                                       iv_tipo    = gs_param-zipi
                                   IMPORTING
                                   ev_1perc           = lv_1perc
                                   ev_conditionamount = lv_conditionamount
                                   ev_dif             = lv_dif ).



                IF <fs_purorditmpricing>-conditionamount NE lv_conditionamount
                AND lv_dif GT lv_1perc.

                  lv_div_item = abap_true.
                  ev_obserp = |{ TEXT-006 }| & | | &
                              |{ TEXT-007 }| & | | &
                              |{ <fs_purorditmpricing>-purchaseorderitem }| & | | &
                              |{ TEXT-004 }| & | | &
                              |{ <fs_purorditmpricing>-conditionamount }| & | { gs_param-e } | &
                              |{ TEXT-011 }| & | | &
                              |{ lv_conditionamount }| & | . |.

                ENDIF.

            ENDCASE.

          ENDLOOP.
        ENDIF.
      ENDIF.

      IF lv_div_item NE abap_true.

        ev_status = 104.
        ev_obserp = |{ TEXT-012 }|.

      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD atualiza_pedido.

    DATA: lv_purchaseorder TYPE bapimepoheader-po_number,
          ls_poheader      TYPE bapimepoheader,
          ls_poheaderx     TYPE bapimepoheaderx.

    lv_purchaseorder        = gs_arquivo_me-ebeln.

    ls_poheader-memory      = space.
    ls_poheader-memorytype  = space.

    ls_poheaderx-memory     = abap_true.
    ls_poheaderx-memorytype = abap_true.

    CALL FUNCTION 'BAPI_PO_CHANGE'
      EXPORTING
        purchaseorder = lv_purchaseorder
        poheader      = ls_poheader
        poheaderx     = ls_poheaderx.

  ENDMETHOD.


  METHOD atualiza_controle_interface.

    DATA ls_control_int TYPE ztmm_control_int.

    ls_control_int-tp_processo   = '5'.
    ls_control_int-categoria_doc = 'F'.
    ls_control_int-doc_sap       = gv_ebeln.
    ls_control_int-dt_integracao = sy-datum.
    ls_control_int-log           = iv_obserp.

    UPDATE ztmm_control_int FROM ls_control_int.
    IF sy-subrc EQ 0.
      COMMIT WORK AND WAIT.
    ENDIF.

  ENDMETHOD.

  METHOD calc_percentual.

    CASE iv_tipo.

      WHEN gs_param-zicms.
        ev_1perc = ( is_purord-conditionamount / 100 ).

        ev_conditionamount = ( ( is_item_me-netpr - is_item_me-precosemimposto ) * is_item_me-menge ).

        ev_dif = ev_conditionamount - is_purord-conditionamount.

        DATA(lv_string) = CONV string( ev_dif ).

        REPLACE ALL OCCURRENCES OF '-' IN lv_string WITH space.

        ev_dif = lv_string.

      WHEN gs_param-zipi.

        ev_1perc = ( is_purord-conditionamount / 100 ).

        ev_conditionamount = is_item_me-menge * is_item_me-valoripi.

        ev_dif = ev_conditionamount - is_purord-conditionamount.

        lv_string = CONV string( ev_dif ).

        REPLACE ALL OCCURRENCES OF '-' IN lv_string WITH space.

        ev_dif = lv_string.

      WHEN OTHERS.

        ev_1perc = ( iv_netpr_sap / 100 ).

        ev_dif = iv_netpr_sap - iv_netpr_me.

        lv_string = CONV string( ev_dif ).

        REPLACE ALL OCCURRENCES OF '-' IN lv_string WITH space.

        ev_dif = lv_string.

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
