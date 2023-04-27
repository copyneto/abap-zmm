CLASS zclmm_aux_ret_armazenagem DEFINITION INHERITING FROM cl_abap_behv
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS:
      BEGIN OF gc_status,
        inicial          TYPE ztmm_his_dep_fec-status VALUE '00',
        em_processamento TYPE ztmm_his_dep_fec-status VALUE '01',
        incompleto       TYPE ztmm_his_dep_fec-status VALUE '02',
        completo         TYPE ztmm_his_dep_fec-status VALUE '03',
      END OF gc_status,

      BEGIN OF gc_autorizacao,
        criar_nfe TYPE activ_auth VALUE '16' ##NO_TEXT,
      END OF gc_autorizacao.

    TYPES: ty_entity   TYPE zi_mm_ret_armazenagem_app,
           ty_t_entity TYPE STANDARD TABLE OF ty_entity,
           ty_hist     TYPE ztmm_his_dep_fec,
           ty_t_hist   TYPE STANDARD TABLE OF ty_hist WITH DEFAULT KEY,
           ty_reported TYPE RESPONSE FOR REPORTED EARLY zi_mm_ret_armazenagem_app.

    "! Move os dados para o Quantidade Transportada.
    "! @parameter it_entity  | CDS - Principal
    "! @parameter et_entity  | CDS - Principal
    METHODS mover_quantidade
      IMPORTING it_entity TYPE ty_t_entity
                is_popup  TYPE zi_mm_df_qtd_transf_popup OPTIONAL
                iv_useavailablecheckbox  TYPE abap_bool
      EXPORTING et_entity TYPE ty_t_entity
                et_return TYPE bapiret2_t.

    "! Move os dados para o Quantidade Transportada.
    "! @parameter it_entity  | CDS - Principal
    "! @parameter et_entity  | CDS - Principal
    METHODS salvar_historico
      IMPORTING it_entity TYPE ty_t_entity
      EXPORTING et_entity TYPE ty_t_entity
                et_return TYPE bapiret2_t.

    "! Formata as mensages de retorno
    "! @parameter ct_return | Mensagens de retorno
    METHODS format_return
      CHANGING ct_return TYPE bapiret2_t .

    "! Constrói mensagens retorno do aplicativo
    "! @parameter it_return | Mensagens de retorno
    "! @parameter es_reported | Retorno do aplicativo
    METHODS build_reported
      IMPORTING it_return   TYPE bapiret2_t
      EXPORTING es_reported TYPE ty_reported.

    "! Elimina registro da Tabela temporaria.
    "! @parameter it_entity | Mensagens de retorno
    "! @parameter et_return | Retorno do aplicativo
    METHODS apagar_historico
      IMPORTING it_entity TYPE ty_t_entity
      EXPORTING et_return TYPE bapiret2_t.

    "! Altera o Valor do Historico Pelo Campo Transferido.
    "! @parameter it_entity | Mensagens de retorno
    "! @parameter et_return | Retorno do aplicativo
    METHODS alterar_transferencia
      IMPORTING
        it_entity TYPE ty_t_entity
      EXPORTING
        et_return TYPE bapiret2_t.

    "! Converte os Valores da CDS de Pendente de Ordem de Frete para A tabela Historico
    "! @parameter it_entity | Entidade
    "! @parameter rt_result | Retorno da tabela Historico
    METHODS entity_to_table
      IMPORTING it_entity        TYPE ty_t_entity
      RETURNING VALUE(rt_result) TYPE ty_t_hist.

    METHODS get_next_guid
      EXPORTING
        !ev_guid       TYPE sysuuid_x16
        !et_return     TYPE bapiret2_t
      RETURNING
        VALUE(rv_guid) TYPE sysuuid_x16 .

    "! Chama função remota para mudar de status
    "! @parameter iv_actvt | Atividade
    "! @parameter ev_ok | Mensagem de sucesso
    "! @parameter et_return | Mensagens de retorno
    CLASS-METHODS check_permission
      IMPORTING iv_actvt     TYPE activ_auth
      EXPORTING ev_ok        TYPE flag
                et_return    TYPE bapiret2_t
      RETURNING VALUE(rv_ok) TYPE flag.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclmm_aux_ret_armazenagem IMPLEMENTATION.

  METHOD mover_quantidade .

    et_entity = it_entity.
    LOOP AT et_entity ASSIGNING FIELD-SYMBOL(<fs_entity>).

      IF <fs_entity>-estoqueremessaof IS INITIAL .

        "O Campo Estoquer em Ressa OF não possui valores.
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '018' ) ).
        me->format_return( CHANGING ct_return = et_return ).

      ENDIF.

      <fs_entity>-qtdtransportada = COND #( WHEN is_popup IS SUPPLIED
                                            THEN is_popup-newusedstock
                                            ELSE <fs_entity>-estoqueremessaof ).
      <fs_entity>-statushistorico = gc_status-em_processamento.
      <fs_entity>-useavailable    = iv_useavailablecheckbox .

    ENDLOOP.

  ENDMETHOD.

  METHOD salvar_historico.


    DATA(lt_hist) = entity_to_table( it_entity ).

    CHECK lt_hist IS NOT INITIAL.

    MODIFY ztmm_his_dep_fec FROM TABLE lt_hist.
    IF sy-subrc IS NOT INITIAL.
      " Não foi possivel transferir os valores solicitados..
      et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '017' ) ).
      me->format_return( CHANGING ct_return = et_return ).
    ENDIF.


  ENDMETHOD.

  METHOD format_return.

    DATA: ls_return_format TYPE bapiret2.

* ---------------------------------------------------------------------------
* Format mensagens de retorno
* ---------------------------------------------------------------------------
    LOOP AT ct_return REFERENCE INTO DATA(ls_return).

      CHECK ls_return->message IS INITIAL.

      TRY.
          CALL FUNCTION 'FORMAT_MESSAGE'
            EXPORTING
              id        = ls_return->id
              lang      = sy-langu
              no        = ls_return->number
              v1        = ls_return->message_v1
              v2        = ls_return->message_v2
              v3        = ls_return->message_v3
              v4        = ls_return->message_v4
            IMPORTING
              msg       = ls_return->message
            EXCEPTIONS
              not_found = 1
              OTHERS    = 2.

          IF sy-subrc <> 0.
            CLEAR ls_return->message.
          ENDIF.

        CATCH cx_root INTO DATA(lo_root).
          DATA(lv_message) = lo_root->get_longtext( ).
      ENDTRY.

    ENDLOOP.

  ENDMETHOD.


  METHOD build_reported.

    FIELD-SYMBOLS: <fs_cds>  TYPE any.
    DATA: lo_dataref            TYPE REF TO data.

    LOOP AT it_return INTO DATA(ls_return).

      CREATE DATA  lo_dataref TYPE LINE OF ty_reported-retarmazenagem.
      ASSIGN lo_dataref->* TO <fs_cds>.

* ---------------------------------------------------------------------------
* Converte mensagem
* ---------------------------------------------------------------------------
      ASSIGN COMPONENT '%msg' OF STRUCTURE <fs_cds> TO FIELD-SYMBOL(<fs_msg>).

      IF sy-subrc EQ 0.
        TRY.
            <fs_msg>  = new_message( id       = ls_return-id
                                     number   = ls_return-number
                                     v1       = ls_return-message_v1
                                     v2       = ls_return-message_v2
                                     v3       = ls_return-message_v3
                                     v4       = ls_return-message_v4
                                     severity = CONV #( ls_return-type ) ).
          CATCH cx_root.
        ENDTRY.
      ENDIF.

* ---------------------------------------------------------------------------
* Marca o campo com erro
* ---------------------------------------------------------------------------
      IF ls_return-field IS NOT INITIAL.
        ASSIGN COMPONENT |%element-{ ls_return-field }| OF STRUCTURE <fs_cds> TO FIELD-SYMBOL(<fs_field>).

        IF sy-subrc EQ 0.
          TRY.
              <fs_field> = if_abap_behv=>mk-on.
            CATCH cx_root.
          ENDTRY.
        ENDIF.
      ENDIF.

* ---------------------------------------------------------------------------
* Adiciona o erro na CDS correspondente
* ---------------------------------------------------------------------------
      es_reported-retarmazenagem[]  = VALUE #( BASE es_reported-retarmazenagem[] ( CORRESPONDING #( <fs_cds> ) ) ).

    ENDLOOP.

  ENDMETHOD.


  METHOD apagar_historico.

    DATA(lt_hist) = entity_to_table( it_entity ).

    DELETE ztmm_his_dep_fec FROM TABLE lt_hist.

    IF sy-subrc NE 0.
      " Falha ao eliminar o registro.
      et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '002' ) ).
      me->format_return( CHANGING ct_return = et_return ).
      RETURN.
    ENDIF.

  ENDMETHOD.

  METHOD entity_to_table.
    DATA lt_return type bapiret2_t .
    GET TIME STAMP FIELD DATA(lv_timestamp).

    rt_result = VALUE ty_t_hist(
      FOR ls_entity IN it_entity (
        freight_order_id          = ls_entity-numeroordemdefrete
        delivery_document         = |{ ls_entity-numerodaremessa ALPHA = IN }|
        material                  = ls_entity-material
        plant                     = ls_entity-CentroOrigem
        storage_location          = ls_entity-DepositoOrigem
        plant_dest                = ls_entity-CentroDestino
        storage_location_dest     = ls_entity-DepositoDestino
        batch                     = ls_entity-Lote
        origin_unit               = ls_entity-umborigin
        unit                      = ls_entity-umbdestino
        process_step              = 'F05'
        order_quantity            = ls_entity-qtdtransportada
        order_quantity_unit       = ls_entity-umbdestino
        status                    = ls_entity-statushistorico
*        available_stock           = ls_entity-estoquelivreutilizacao
        use_available             = ls_entity-useavailable
        used_stock                = ls_entity-qtdtransportada
        used_stock_conv           = ls_entity-qtdtransportada
        guid                      = COND #(
                                    WHEN ls_entity-guid IS INITIAL
                                    THEN me->get_next_guid( IMPORTING et_return = lt_return )
                                    ELSE ls_entity-guid )
        prm_dep_fec_id            = ls_entity-prmdepfecid
        description               = ls_entity-description
        origin_plant              = ls_entity-CentroOrigem
        origin_plant_type         = ls_entity-originplanttype
        origin_storage_location   = ls_entity-DepositoOrigem
        destiny_plant             = ls_entity-CentroDestino
        destiny_plant_type        = ls_entity-destinyplanttype
        destiny_storage_location  = ls_entity-DepositoDestino
        carrier                   = ls_entity-transportador
        driver                    = ls_entity-driver
        equipment                 = ls_entity-equipment
        shipping_conditions       = ls_entity-shipping_conditions
        shipping_type             = ls_entity-shipping_type
        equipment_tow1            = ls_entity-equipment_tow1
        equipment_tow2            = ls_entity-equipment_tow2
        equipment_tow3            = ls_entity-equipment_tow3
        freight_mode              = ls_entity-freight_mode
        created_by                = COND #( WHEN ls_entity-createdby IS NOT INITIAL
                                            THEN ls_entity-createdby
                                            ELSE sy-uname )
        created_at                = COND #( WHEN ls_entity-createdat IS NOT INITIAL
                                            THEN ls_entity-createdat
                                            ELSE lv_timestamp )
        last_changed_by           = sy-uname
        last_changed_at           = lv_timestamp
        local_last_changed_at     = lv_timestamp
    ) ) .

* ---------------------------------------------------------------------------
* Recupera dados completos do histórico
* ---------------------------------------------------------------------------
    IF rt_result[] IS NOT INITIAL.

      SELECT *
          FROM ztmm_his_dep_fec
          INTO TABLE @DATA(lt_historico)
          FOR ALL ENTRIES IN @rt_result
          WHERE material                = @rt_result-material
            AND plant                   = @rt_result-plant
            AND storage_location        = @rt_result-storage_location
            AND batch                   = @rt_result-batch
            AND plant_dest              = @rt_result-plant_dest
            AND storage_location_dest   = @rt_result-storage_location_dest
            AND freight_order_id        = @rt_result-freight_order_id
            AND delivery_document       = @rt_result-delivery_document
            AND process_step            = @rt_result-process_step
            AND guid                    = @rt_result-guid.

      IF sy-subrc EQ 0.
        SORT lt_historico BY material
                             plant
                             storage_location
                             batch
                             plant_dest
                             storage_location_dest
                             freight_order_id
                             delivery_document
                             process_step
                             guid.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Transfere os dados antigos do histórico
* ---------------------------------------------------------------------------
    LOOP AT rt_result REFERENCE INTO DATA(ls_result).

      READ TABLE lt_historico INTO DATA(ls_historico) WITH KEY material                 = ls_result->material
                                                               plant                    = ls_result->plant
                                                               storage_location         = ls_result->storage_location
                                                               batch                    = ls_result->batch
                                                               plant_dest               = ls_result->plant_dest
                                                               storage_location_dest    = ls_result->storage_location_dest
                                                               freight_order_id         = ls_result->freight_order_id
                                                               delivery_document        = ls_result->delivery_document
                                                               process_step             = ls_result->process_step
                                                               guid                     = ls_result->guid
                                                               BINARY SEARCH.
      CHECK sy-subrc EQ 0.

      ls_result->status                           = COND #( WHEN ls_result->status IS NOT INITIAL
                                                            THEN ls_result->status
                                                            ELSE ls_historico-status ).

      ls_result->order_quantity                   = COND #( WHEN ls_result->status NE gc_status-incompleto
                                                             AND ls_result->status NE gc_status-completo
                                                             AND ls_result->order_quantity IS NOT INITIAL
                                                            THEN ls_result->order_quantity
                                                            ELSE ls_historico-order_quantity ).
      ls_result->order_quantity_unit              = COND #( WHEN ls_result->status NE gc_status-incompleto
                                                             AND ls_result->status NE gc_status-completo
                                                             AND ls_result->order_quantity_unit IS NOT INITIAL
                                                            THEN ls_result->order_quantity_unit
                                                            ELSE ls_historico-order_quantity_unit ).
      ls_result->available_stock                  = COND #( WHEN ls_result->status NE gc_status-incompleto
                                                             AND ls_result->status NE gc_status-completo
                                                             AND ls_result->available_stock IS NOT INITIAL
                                                            THEN ls_result->available_stock
                                                            ELSE ls_historico-available_stock ).
      ls_result->use_available                    = COND #( WHEN ls_result->status NE gc_status-incompleto
                                                             AND ls_result->status NE gc_status-completo
*                                                             AND ls_result->use_available IS NOT INITIAL
                                                            THEN ls_result->use_available
                                                            ELSE ls_historico-use_available ).
      ls_result->used_stock                       = COND #( WHEN ls_result->status NE gc_status-incompleto
                                                             AND ls_result->status NE gc_status-completo
                                                             AND ls_result->used_stock IS NOT INITIAL
                                                            THEN ls_result->used_stock
                                                            ELSE ls_historico-used_stock ).
      ls_result->used_stock_conv                  = COND #( WHEN ls_result->status NE gc_status-incompleto
                                                             AND ls_result->status NE gc_status-completo
                                                             AND ls_result->used_stock_conv IS NOT INITIAL
                                                            THEN ls_result->used_stock_conv
                                                            ELSE ls_historico-used_stock_conv ).
      ls_result->guid                             = COND #( WHEN ls_result->status NE gc_status-incompleto
                                                             AND ls_result->status NE gc_status-completo
                                                             AND ls_result->guid IS NOT INITIAL
                                                            THEN ls_result->guid
                                                            ELSE ls_historico-guid ).
      ls_result->prm_dep_fec_id                   = COND #( WHEN ls_result->status NE gc_status-incompleto
                                                             AND ls_result->status NE gc_status-completo
                                                             AND ls_result->prm_dep_fec_id IS NOT INITIAL
                                                            THEN ls_result->prm_dep_fec_id
                                                            ELSE ls_historico-prm_dep_fec_id ).
      ls_result->description                      = COND #( WHEN ls_result->status NE gc_status-incompleto
                                                             AND ls_result->status NE gc_status-completo
                                                             AND ls_result->description IS NOT INITIAL
                                                            THEN ls_result->description
                                                            ELSE ls_historico-description ).
      ls_result->origin_plant                     = COND #( WHEN ls_result->status NE gc_status-incompleto
                                                             AND ls_result->status NE gc_status-completo
                                                             AND ls_result->origin_plant IS NOT INITIAL
                                                            THEN ls_result->origin_plant
                                                            ELSE ls_historico-origin_plant ).
      ls_result->origin_plant_type                = COND #( WHEN ls_result->status NE gc_status-incompleto
                                                             AND ls_result->status NE gc_status-completo
                                                             AND ls_result->origin_plant_type IS NOT INITIAL
                                                            THEN ls_result->origin_plant_type
                                                            ELSE ls_historico-origin_plant_type ).
      ls_result->origin_storage_location          = COND #( WHEN ls_result->status NE gc_status-incompleto
                                                             AND ls_result->status NE gc_status-completo
                                                             AND ls_result->origin_storage_location IS NOT INITIAL
                                                            THEN ls_result->origin_storage_location
                                                            ELSE ls_historico-origin_storage_location ).
      ls_result->destiny_plant                    = COND #( WHEN ls_result->status NE gc_status-incompleto
                                                             AND ls_result->status NE gc_status-completo
                                                             AND ls_result->destiny_plant IS NOT INITIAL
                                                            THEN ls_result->destiny_plant
                                                            ELSE ls_historico-destiny_plant ).
      ls_result->destiny_plant_type               = COND #( WHEN ls_result->status NE gc_status-incompleto
                                                             AND ls_result->status NE gc_status-completo
                                                             AND ls_result->destiny_plant_type IS NOT INITIAL
                                                            THEN ls_result->destiny_plant_type
                                                            ELSE ls_historico-destiny_plant_type ).
      ls_result->destiny_storage_location         = COND #( WHEN ls_result->status NE gc_status-incompleto
                                                             AND ls_result->status NE gc_status-completo
                                                             AND ls_result->destiny_storage_location IS NOT INITIAL
                                                            THEN ls_result->destiny_storage_location
                                                            ELSE ls_historico-destiny_storage_location ).
      ls_result->carrier                          = COND #( WHEN ls_result->status NE gc_status-incompleto
                                                             AND ls_result->status NE gc_status-completo
                                                             AND ls_result->carrier IS NOT INITIAL
                                                            THEN ls_result->carrier
                                                            ELSE ls_historico-carrier ).
      ls_result->driver                           = COND #( WHEN ls_result->status NE gc_status-incompleto
                                                             AND ls_result->status NE gc_status-completo
                                                             AND ls_result->driver IS NOT INITIAL
                                                            THEN ls_result->driver
                                                            ELSE ls_historico-driver ).
      ls_result->equipment                        = COND #( WHEN ls_result->status NE gc_status-incompleto
                                                             AND ls_result->status NE gc_status-completo
                                                             AND ls_result->equipment IS NOT INITIAL
                                                            THEN ls_result->equipment
                                                            ELSE ls_historico-equipment ).
      ls_result->shipping_conditions              = COND #( WHEN ls_result->status NE gc_status-incompleto
                                                             AND ls_result->status NE gc_status-completo
                                                             AND ls_result->shipping_conditions IS NOT INITIAL
                                                            THEN ls_result->shipping_conditions
                                                            ELSE ls_historico-shipping_conditions ).
      ls_result->shipping_type                    = COND #( WHEN ls_result->status NE gc_status-incompleto
                                                             AND ls_result->status NE gc_status-completo
                                                             AND ls_result->shipping_type IS NOT INITIAL
                                                            THEN ls_result->shipping_type
                                                            ELSE ls_historico-shipping_type ).
      ls_result->equipment_tow1                   = COND #( WHEN ls_result->status NE gc_status-incompleto
                                                             AND ls_result->status NE gc_status-completo
                                                             AND ls_result->equipment_tow1 IS NOT INITIAL
                                                            THEN ls_result->equipment_tow1
                                                            ELSE ls_historico-equipment_tow1 ).
      ls_result->equipment_tow2                   = COND #( WHEN ls_result->status NE gc_status-incompleto
                                                             AND ls_result->status NE gc_status-completo
                                                             AND ls_result->equipment_tow2 IS NOT INITIAL
                                                            THEN ls_result->equipment_tow2
                                                            ELSE ls_historico-equipment_tow2 ).
      ls_result->equipment_tow3                   = COND #( WHEN ls_result->status NE gc_status-incompleto
                                                             AND ls_result->status NE gc_status-completo
                                                             AND ls_result->equipment_tow3 IS NOT INITIAL
                                                            THEN ls_result->equipment_tow3
                                                            ELSE ls_historico-equipment_tow3 ).
      ls_result->freight_mode                     = COND #( WHEN ls_result->status NE gc_status-incompleto
                                                             AND ls_result->status NE gc_status-completo
                                                             AND ls_result->freight_mode IS NOT INITIAL
                                                            THEN ls_result->freight_mode
                                                            ELSE ls_historico-freight_mode ).
      ls_result->ean_type                         = ls_historico-ean_type.
      ls_result->main_plant                       = ls_historico-main_plant.
      ls_result->main_purchase_order              = ls_historico-main_purchase_order.
      ls_result->main_purchase_order_item         = ls_historico-main_purchase_order_item.
      ls_result->main_material_document           = ls_historico-main_material_document.
      ls_result->main_material_document_year      = ls_historico-main_material_document_year.
      ls_result->main_material_document_item      = ls_historico-main_material_document_item.
      ls_result->batch                            = ls_historico-batch.
      ls_result->purchase_order                   = ls_historico-purchase_order.
      ls_result->purchase_order_item              = ls_historico-purchase_order_item.
      ls_result->incoterms1                       = ls_historico-incoterms1.
      ls_result->incoterms2                       = ls_historico-incoterms2.
      ls_result->out_sales_order                  = ls_historico-out_sales_order.
      ls_result->out_sales_order_item             = ls_historico-out_sales_order_item.
      ls_result->out_delivery_document            = ls_historico-out_delivery_document.
      ls_result->out_delivery_document_item       = ls_historico-out_delivery_document_item.
      ls_result->out_material_document            = ls_historico-out_material_document.
      ls_result->out_material_document_year       = ls_historico-out_material_document_year.
      ls_result->out_material_document_item       = ls_historico-out_material_document_item.
      ls_result->out_br_nota_fiscal               = ls_historico-out_br_nota_fiscal.
      ls_result->out_br_nota_fiscal_item          = ls_historico-out_br_nota_fiscal_item.
      ls_result->rep_br_nota_fiscal               = ls_historico-rep_br_nota_fiscal.
      ls_result->in_delivery_document             = ls_historico-in_delivery_document.
      ls_result->in_delivery_document_item        = ls_historico-in_delivery_document_item.
      ls_result->in_material_document             = ls_historico-in_material_document.
      ls_result->in_material_document_year        = ls_historico-in_material_document_year.
      ls_result->in_material_document_item        = ls_historico-in_material_document_item.
      ls_result->in_br_nota_fiscal                = ls_historico-in_br_nota_fiscal.
      ls_result->in_br_nota_fiscal_item           = ls_historico-in_br_nota_fiscal_item.
      ls_result->created_by                       = ls_historico-created_by.
      ls_result->created_at                       = ls_historico-created_at.
      ls_result->last_changed_by                  = ls_historico-last_changed_by.
      ls_result->last_changed_at                  = ls_historico-last_changed_at.
      ls_result->local_last_changed_at            = ls_historico-local_last_changed_at.

    ENDLOOP.

  ENDMETHOD.


  METHOD alterar_transferencia.

    DATA(lt_entity) = it_entity.
    LOOP AT lt_entity ASSIGNING FIELD-SYMBOL(<fs_entity>).

      <fs_entity>-statushistorico = gc_status-em_processamento.
      <fs_entity>-useavailable = abap_false .

    ENDLOOP.

    DATA(lt_hist) = entity_to_table( it_entity = lt_entity ).

    MODIFY ztmm_his_dep_fec FROM TABLE lt_hist.

    IF sy-subrc NE 0.
      " Não foi possivel transferir os valores solicitados..
      et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '017' ) ).
      me->format_return( CHANGING ct_return = et_return ).
      RETURN.
    ENDIF.

  ENDMETHOD.

  METHOD check_permission.

    FREE: et_return, ev_ok.

* ---------------------------------------------------------------------------
* Botões mapeados no objeto de autorização
* ---------------------------------------------------------------------------
* 16 - Botão Criar NFe
* ---------------------------------------------------------------------------
*    AUTHORITY-CHECK OBJECT 'ZMM376F12'
*     ID 'ACTVT' FIELD iv_actvt.
*
*    IF sy-subrc NE 0.
*      " Sem autorização para acessar esta funcionalidade.
*      et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '036' ) ).
*    ELSE.
    rv_ok = ev_ok = abap_true.
*    ENDIF.

  ENDMETHOD.

  METHOD get_next_guid.

    FREE: ev_guid, et_return.

    TRY.
        rv_guid = ev_guid = cl_system_uuid=>create_uuid_x16_static( ).

      CATCH cx_root INTO DATA(lo_root).
        DATA(lv_message) = CONV bapi_msg( lo_root->get_longtext( ) ).
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '000'
                                                message_v1 = lv_message+0(50)
                                                message_v2 = lv_message+50(50)
                                                message_v3 = lv_message+100(50)
                                                message_v4 = lv_message+150(50) ) ).

        me->format_return( CHANGING ct_return = et_return ).
        RETURN.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
