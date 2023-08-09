*&---------------------------------------------------------------------*
*& Include ZMME_GET_VALUES
*&---------------------------------------------------------------------*
* ---------------------------------------------------------------------------
* Processo de Depósito Fechado
* ---------------------------------------------------------------------------
 CONSTANTS: BEGIN OF lc_values,
              mod     TYPE ze_param_modulo  VALUE 'MM',
              c1      TYPE ze_param_chave   VALUE 'CODIGO_IVA',
              tax1    TYPE j_1btaxlw1       VALUE 'W61',
              tax2    TYPE j_1btaxlw1       VALUE 'I55',
              tax4    TYPE j_1btaxlw1       VALUE 'C70',
              tax5    TYPE j_1btaxlw1       VALUE 'W61',
              zdep    TYPE char4            VALUE 'ZDEP',
              kalsm_d TYPE kalsm_d          VALUE 'TAXBRA',
              mm      TYPE ze_param_modulo  VALUE 'MM',
              enhan   TYPE ze_param_chave   VALUE 'ENHACEMENT_GAP376',
              ce      TYPE ze_param_modulo  VALUE 'CE',
              mg      TYPE ze_param_modulo  VALUE 'MG',
            END OF lc_values.

 DATA: lv_continue,
       lv_chave2 TYPE ztca_param_par-chave2.

 TRY.

     zclca_tabela_parametros=>get_instance( )->m_get_single( " CHANGE - LSCHEPP - 24.07.2023
       EXPORTING
         iv_modulo = lc_values-mm
         iv_chave1 = lc_values-enhan
       IMPORTING
         ev_param  = lv_continue ).

     IF lv_continue EQ abap_true.

       EXPORT e_lips-vgbel e_lips-vgpos TO MEMORY ID lc_values-zdep.

       SELECT SINGLE COUNT( * )
         FROM ekko
        WHERE ebeln EQ e_lips-vgbel
          AND bsart EQ 'ZDF'.

       IF sy-subrc EQ 0.

         SELECT SINGLE regio
           INTO @DATA(lv_regio)
           FROM t001w
          WHERE werks = @e_lips-werks.

         IF lv_regio = lc_values-ce
         OR lv_regio = lc_values-mg.

           lv_chave2 = lv_regio.

         ENDIF.

         zclca_tabela_parametros=>get_instance( )->m_get_single( " CHANGE - LSCHEPP - 24.07.2023
           EXPORTING
             iv_modulo = lc_values-mod
             iv_chave1 = lc_values-c1
             iv_chave2 = lv_chave2
           IMPORTING
             ev_param  = e_lips-j_1btxsdc ).

         SELECT SINGLE j_1btaxlw1,
                       j_1btaxlw2,
                       j_1btaxlw4,
                       j_1btaxlw5
           FROM t007a
          WHERE kalsm = @lc_values-kalsm_d
            AND mwskz = @e_lips-j_1btxsdc
           INTO @DATA(ls_t007a).

         IF sy-subrc = 0.
           wloc-taxlw1 = e_lips-j_1btaxlw1 = ls_t007a-j_1btaxlw1.
           wloc-taxlw2 = e_lips-j_1btaxlw2 = ls_t007a-j_1btaxlw2.
           wloc-taxlw4 = e_lips-j_1btaxlw4 = ls_t007a-j_1btaxlw4.
           wloc-taxlw5 = e_lips-j_1btaxlw5 = ls_t007a-j_1btaxlw5.
         ENDIF.

       ENDIF.

     ENDIF.

   CATCH zcxca_tabela_parametros.

 ENDTRY.
