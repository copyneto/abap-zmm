class ZCLMM_DEV_VENDAS_DEPS_FECH definition
  public
  final
  create public .

public section.

  methods MAIN
    importing
      !IT_VBAP type TT_VBAPVB
    changing
      !CT_VBPA type TT_VBPAVB .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_DEV_VENDAS_DEPS_FECH IMPLEMENTATION.


  METHOD main.
     CHECK 1 = 2.
    DATA: lv_parvw TYPE parvw.

    CONSTANTS: lc_status_centro_faturamento TYPE ze_mm_df_status VALUE '10',
               lc_process_step_f02          TYPE ze_mm_df_process_step VALUE 'F05'.

    DATA(lt_xvbap_dpf) = it_vbap[].

    READ TABLE lt_xvbap_dpf INTO DATA(ls_xvbap_dpf) INDEX 1.
    IF sy-subrc IS INITIAL.

      SELECT conf~origin_plant,
             conf~origin_plant_type,
             conf~origin_storage_location,
             conf~destiny_plant,
             conf~destiny_plant_type,
             conf~destiny_storage_location
        FROM ztmm_prm_dep_fec AS conf
       WHERE conf~destiny_plant      = @ls_xvbap_dpf-werks
         AND conf~destiny_plant_type = 01
        INTO TABLE @DATA(lt_deps_fechado).

      IF sy-subrc IS INITIAL.

        READ TABLE lt_deps_fechado ASSIGNING FIELD-SYMBOL(<fs_deps>) INDEX 1.
        IF sy-subrc IS INITIAL.

          SELECT SINGLE werks,
                        kunnr
            FROM t001w
           WHERE werks = @<fs_deps>-origin_plant
            INTO @DATA(ls_t001w).
          IF sy-subrc IS INITIAL.

            DATA(lo_param) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 21.07.2023

            TRY.
                lo_param->m_get_single( EXPORTING iv_modulo = 'MM'
                                                  iv_chave1 = 'DEP_FECHADO'
*                                              iv_chave2 =
*                                              iv_chave3 =
                                        IMPORTING ev_param  = lv_parvw ).
              CATCH zcxca_tabela_parametros.
            ENDTRY.

            SORT ct_vbpa BY posnr
                            parvw.

            READ TABLE ct_vbpa ASSIGNING FIELD-SYMBOL(<fs_vbpa>)
                                             WITH KEY posnr = '000000'
                                                      parvw = lv_parvw
                                                      BINARY SEARCH.
            IF sy-subrc = 0.
              <fs_vbpa>-kunnr = ls_t001w-kunnr.
            ENDIF.
*            ct_vbpa = VALUE #( BASE ct_vbpa ( posnr = '000000'
*                                              parvw = lv_parvw
*                                              kunnr = ls_t001w-kunnr ) ).

            DATA(ls_his_dep_fec) = VALUE ztmm_his_dep_fec( material                = ls_xvbap_dpf-matnr
                                                           plant                   = <fs_deps>-destiny_plant "<fs_deps>-origin_plant
                                                           storage_location        = <fs_deps>-destiny_storage_location "<fs_deps>-origin_storage_location
                                                           batch                   = ls_xvbap_dpf-charg
                                                           plant_dest              = <fs_deps>-origin_plant     "<fs_deps>-destiny_plant
                                                           storage_location_dest   = <fs_deps>-destiny_storage_location
                                                           process_step            = lc_process_step_f02
                                                           status                  = lc_status_centro_faturamento
                                                           origin_plant            = <fs_deps>-destiny_plant "<fs_deps>-origin_plant
                                                           origin_plant_type       = <fs_deps>-destiny_plant_type "<fs_deps>-origin_plant_type
                                                           origin_storage_location = <fs_deps>-destiny_storage_location "<fs_deps>-origin_storage_location
                                                           destiny_plant           = <fs_deps>-origin_plant "<fs_deps>-destiny_plant
                                                           destiny_plant_type      = <fs_deps>-origin_plant_type "<fs_deps>-destiny_plant_type
                                                           destiny_storage_location = <fs_deps>-destiny_storage_location
                                                           origin_unit             = ls_xvbap_dpf-meins
                                                           unit                    = ls_xvbap_dpf-meins
                                                           available_stock         = ls_xvbap_dpf-klmeng
                                                           used_stock              = ls_xvbap_dpf-klmeng
                                                           used_stock_conv         = ls_xvbap_dpf-klmeng
                                                         ).

            CALL FUNCTION 'ZFMMM_DEVOLUCAO_VENDAS'
              STARTING NEW TASK 'MM_DEVOLUCAO_VENDAS'
              EXPORTING
                is_his_dep_fec = ls_his_dep_fec.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
