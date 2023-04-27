CLASS zclmm_dep_fechado_centro_fat DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .
  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_dados_filtro,
        origin_plant             TYPE RANGE OF ztmm_prm_dep_fec-origin_plant,
        origin_storage_location  TYPE RANGE OF ztmm_prm_dep_fec-origin_storage_location,
        destiny_plant            TYPE RANGE OF ztmm_prm_dep_fec-destiny_plant,
        destiny_storage_location TYPE RANGE OF ztmm_prm_dep_fec-destiny_storage_location,
        process_step             TYPE ze_mm_df_process_step,
      END OF   ty_dados_filtro.

    METHODS:
      executar
        IMPORTING
          is_dados_filtro   TYPE ty_dados_filtro
        RETURNING
          VALUE(rt_retorno) TYPE bapiret2_t.

  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_dados_para_processar,
        matnr                    TYPE zi_mm_mard_armazenagem_agr-matnr,
        origin_plant             TYPE ztmm_prm_dep_fec-origin_plant,
        origin_plant_type        TYPE ztmm_prm_dep_fec-origin_plant_type,
        origin_storage_location  TYPE ztmm_prm_dep_fec-origin_storage_location,
        charg                    TYPE zi_mm_mard_armazenagem_agr-charg,
        destiny_plant            TYPE ztmm_prm_dep_fec-destiny_plant,
        destiny_plant_type       TYPE ztmm_prm_dep_fec-destiny_plant_type,
        destiny_storage_location TYPE ztmm_prm_dep_fec-destiny_storage_location,
        originunit               TYPE zi_mm_df_material_unidade-originunit,
        unit                     TYPE zi_mm_df_material_unidade-unit,
        avaliblestock            TYPE zi_mm_mard_armazenagem_agr-avaliblestock,
      END OF  ty_dados_para_processar,
      tt_dados_para_processar TYPE STANDARD TABLE OF ztmm_his_dep_fec WITH DEFAULT KEY.

    METHODS:
      seleciona_dados_para_processar
        IMPORTING
          is_dados_filtro   TYPE ty_dados_filtro
        RETURNING
          VALUE(rt_retorno) TYPE tt_dados_para_processar.

    CONSTANTS:
      gc_status_centro_faturamento TYPE ze_mm_df_status VALUE '10'.

ENDCLASS.



CLASS ZCLMM_DEP_FECHADO_CENTRO_FAT IMPLEMENTATION.


  METHOD executar.

    DATA(lt_dados_processar) = seleciona_dados_para_processar( is_dados_filtro ).

    IF lt_dados_processar IS NOT INITIAL.

      DATA(lr_adm_emissao_nf_events) = NEW zclmm_adm_emissao_nf_events( ).

      lr_adm_emissao_nf_events->bapi_create_documents( EXPORTING it_historico_key  = lt_dados_processar
                                                                 iv_status         = gc_status_centro_faturamento
                                                                 iv_job_centro_fat = abap_true
                                                       IMPORTING et_return         = DATA(lt_return_po) ).

      lr_adm_emissao_nf_events->job_delivery( EXPORTING it_historico_key = lt_dados_processar
                                                        iv_status        = gc_status_centro_faturamento
                                              IMPORTING et_return        = DATA(lt_return_delivery) ).

      APPEND LINES OF lt_return_po TO lt_return_delivery.

      rt_retorno = lt_return_delivery.
    ENDIF.
  ENDMETHOD.


  METHOD seleciona_dados_para_processar.

    DATA(lv_tipo_centro_origem) = COND ze_mm_origin_plant_type(
      WHEN is_dados_filtro-process_step = 'F05'
        THEN 01
      ELSE 02 ).

    SELECT DISTINCT
           dep~matnr AS material,
           conf~origin_plant AS plant,
           conf~origin_storage_location AS storage_location,
           dep~charg AS batch,
           conf~destiny_plant AS plant_dest,
           conf~destiny_storage_location AS storage_location_dest,
*               his_dep_fec~ AS process_step,
           CAST( '10' AS NUMC ) AS status,
           conf~origin_plant AS origin_plant,
           conf~origin_plant_type AS origin_plant_type,
           conf~origin_storage_location AS origin_storage_location,
           conf~destiny_plant AS destiny_plant,
           conf~destiny_plant_type AS destiny_plant_type,
           conf~destiny_storage_location AS destiny_storage_location,
           mat_unid~originunit AS origin_unit,
           mat_unid~unit AS unit,
           dep~avaliblestock AS available_stock,
           dep~avaliblestock AS used_stock,
           dep~avaliblestock AS used_stock_conv,
           his_dep_fec~purchase_order AS purchase_order,
           his_dep_fec~purchase_order_item AS purchase_order_item,
           his_dep_fec~guid AS guid,
           his_dep_fec~out_sales_order,
           his_dep_fec~out_sales_order_item ,
           his_dep_fec~out_delivery_document,
           his_dep_fec~out_delivery_document_item ,
           his_dep_fec~out_material_document  ,
           his_dep_fec~out_material_document_year ,
           his_dep_fec~out_material_document_item ,
           his_dep_fec~out_br_nota_fiscal  ,
           his_dep_fec~out_br_nota_fiscal_item  ,
           his_dep_fec~rep_br_nota_fiscal ,
           his_dep_fec~in_delivery_document  ,
           his_dep_fec~in_delivery_document_item ,
           his_dep_fec~in_material_document  ,
           his_dep_fec~in_material_document_year  ,
           his_dep_fec~in_material_document_item  ,
           his_dep_fec~in_br_nota_fiscal  ,
           his_dep_fec~in_br_nota_fiscal_item
      FROM ztmm_prm_dep_fec AS conf
      LEFT JOIN zi_mm_mard_armazenagem_agr AS dep
             ON dep~werks = conf~origin_plant
            AND dep~lgort = conf~origin_storage_location
      LEFT JOIN zi_mm_df_material_unidade AS mat_unid
             ON mat_unid~material = dep~matnr
            AND mat_unid~plant    = dep~werks
      LEFT JOIN ztmm_his_dep_fec AS his_dep_fec
             ON his_dep_fec~material              = dep~matnr
            AND his_dep_fec~plant                 = conf~origin_plant
            AND his_dep_fec~storage_location      = conf~origin_storage_location
            AND his_dep_fec~batch                 = dep~charg
            AND his_dep_fec~plant_dest            = conf~destiny_plant
            AND his_dep_fec~storage_location_dest = conf~destiny_storage_location
            AND his_dep_fec~origin_unit           = mat_unid~originunit
            AND his_dep_fec~unit                  = mat_unid~unit
            AND his_dep_fec~used_stock            = dep~avaliblestock
            AND his_dep_fec~process_step          = @is_dados_filtro-process_step
     WHERE conf~origin_plant_type      = @lv_tipo_centro_origem
       AND dep~avaliblestock             > 0
       AND mat_unid~eantype              = '00'
       AND conf~origin_plant             IN @is_dados_filtro-origin_plant
       AND conf~origin_storage_location  IN @is_dados_filtro-origin_storage_location
       AND conf~destiny_plant            IN @is_dados_filtro-destiny_plant
       AND conf~destiny_storage_location IN @is_dados_filtro-destiny_storage_location
     ORDER BY matnr                    ASCENDING,
              origin_plant             ASCENDING,
              origin_plant_type        ASCENDING,
              origin_storage_location  ASCENDING,
              charg                    ASCENDING,
              destiny_plant            ASCENDING,
              destiny_plant_type       ASCENDING,
              destiny_storage_location ASCENDING,
              guid                     DESCENDING
      INTO CORRESPONDING FIELDS OF TABLE @rt_retorno.

    IF rt_retorno IS NOT INITIAL.
      LOOP AT rt_retorno ASSIGNING FIELD-SYMBOL(<fs_retorno>).
        <fs_retorno>-process_step = is_dados_filtro-process_step.
      ENDLOOP.

      MODIFY ztmm_his_dep_fec FROM  TABLE rt_retorno.
      WAIT UP TO 4 SECONDS.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
