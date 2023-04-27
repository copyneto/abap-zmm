*&---------------------------------------------------------------------*
*& Include ZMMI_TOTAL_NF_FCP_CTE
*&---------------------------------------------------------------------*

 CONSTANTS:
   lc_mm     TYPE ztca_param_par-modulo VALUE 'MM',
   lc_nftot  TYPE ztca_param_par-chave1 VALUE 'NF_TOTAL_VALUE',
   lc_zfcp   TYPE j_1bnfstx-taxtyp      VALUE 'ZFCP',
   lc_taxtyp TYPE ztca_param_par-chave2 VALUE 'FCP1'.

 DATA lr_nftype_cte TYPE RANGE OF j_1bnfdoc-nftype.
 DATA lr_cond_icms  TYPE RANGE OF j_1bnfstx-taxtyp.

 DATA(lo_nftype_cte) = NEW zclca_tabela_parametros( ).

 TRY.
     lo_nftype_cte->m_get_range(
       EXPORTING
         iv_modulo = lc_mm
         iv_chave1 = 'NF_TOTAL_VALUE'
         iv_chave2 = 'FCP1'
       IMPORTING
         et_range  = lr_nftype_cte ).
   CATCH zcxca_tabela_parametros.
 ENDTRY.

 TRY.
     lo_nftype_cte->m_get_range(
       EXPORTING
         iv_modulo = lc_mm
         iv_chave1 = 'PRICING_MM'
         iv_chave2 = 'ICMS'
       IMPORTING
         et_range  = lr_cond_icms ).
   CATCH zcxca_tabela_parametros.
 ENDTRY.

 SELECT COUNT( * )
   FROM a003
  WHERE kappl = 'TX'
    AND mwskz = nf_item-mwskz
    AND kschl = lc_zfcp.

 IF sy-subrc IS INITIAL.

   IF ( lr_nftype_cte IS NOT INITIAL
  AND   nf_header-nftype IN lr_nftype_cte
  AND   lr_cond_icms IS NOT INITIAL
      ).
     TRY.
         DATA(lv_valor_fcp) = ext_total_tax[ taxtyp = lc_taxtyp ]-taxvalser.
         ext_header-nftot  = ext_header-nftot  - lv_valor_fcp.
         ext_header-nfnett = ext_header-nfnett - lv_valor_fcp.
         ext_header-nfnet  = ext_header-nfnet  - lv_valor_fcp.
       CATCH cx_sy_itab_line_not_found.
     ENDTRY.

     LOOP AT lr_cond_icms ASSIGNING FIELD-SYMBOL(<fs_cond_icms>).
       READ TABLE ext_total_tax ASSIGNING FIELD-SYMBOL(<fs_total_tax>) WITH KEY taxtyp = <fs_cond_icms>-low.
       IF ( sy-subrc IS INITIAL AND <fs_total_tax> IS ASSIGNED ).
         IF <fs_total_tax>-othbas IS NOT INITIAL.
           <fs_total_Tax>-base = <fs_total_tax>-othbas.
           CLEAR <fs_total_tax>-othbas.
         ENDIF.

         IF <fs_total_tax>-othbasser IS NOT INITIAL.
           <fs_total_Tax>-baseser = <fs_total_tax>-othbasser.
           CLEAR <fs_total_tax>-othbasser.
         ENDIF.
       ENDIF.

       LOOP AT nf_item_tax ASSIGNING FIELD-SYMBOL(<fs_item_tax>) WHERE taxtyp = <fs_cond_icms>-low.
         IF <fs_item_tax>-othbas IS NOT INITIAL.
           <fs_item_tax>-base = <fs_item_tax>-othbas.
           CLEAR <fs_item_tax>-othbas.
         ENDIF.
       ENDLOOP.

     ENDLOOP.
   ENDIF.

 ENDIF.
