*&---------------------------------------------------------------------*
*& Include ZMMI_TOTAL_NF_FCP_CTE
*&---------------------------------------------------------------------*

 CONSTANTS:
   lc_mm     TYPE ztca_param_par-modulo VALUE 'MM',
   lc_nftot  TYPE ztca_param_par-chave1 VALUE 'NF_TOTAL_VALUE',
   lc_zfcp   TYPE j_1bnfstx-taxtyp      VALUE 'ZFCP',
   lc_taxtyp TYPE ztca_param_par-chave2 VALUE 'FCP1',
   lc_6      TYPE i VALUE '6'.

 DATA lr_nftype_cte TYPE RANGE OF j_1bnfdoc-nftype.
 DATA lr_cond_icms  TYPE RANGE OF j_1bnfstx-taxtyp.
 DATA lv_ebeln      TYPE eslh-ebeln.
 DATA lv_ebelp      TYPE eslh-ebelp.

 DATA(lo_nftype_cte) = zclca_tabela_parametros=>get_instance( ). " CHANGE - LSCHEPP - 24.07.2023

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

 lv_ebeln = nf_item-xped(10).
 DATA(lv_lines) = strlen( nf_item-nitemped ).
 IF lv_lines EQ lc_6 .
   lv_ebelp = nf_item-nitemped+1(5).
 ELSE.
   lv_ebelp = nf_item-nitemped(5).
 ENDIF.

 SELECT packno, ebeln, ebelp
   FROM eslh
   INTO TABLE @DATA(lt_eslh)
*   WHERE ebeln EQ @nf_item-xped
   WHERE ebeln EQ @lv_ebeln
*   AND ebelp   EQ @nf_item-nitemped
   AND ebelp   EQ @lv_ebelp
   .
 IF sy-subrc IS INITIAL.

   DATA(lt_eslh_aux) = lt_eslh[].
   SORT lt_eslh_aux BY packno.
   DELETE ADJACENT DUPLICATES FROM lt_eslh_aux COMPARING packno.
   IF lt_eslh_aux[] IS NOT INITIAL.
     SELECT packno, mwskz
       FROM esll
       INTO TABLE @DATA(lt_esll)
       FOR ALL ENTRIES IN @lt_eslh_aux
       WHERE packno  EQ @lt_eslh_aux-packno
       AND   package EQ @abap_false
       .
   ENDIF.
 ENDIF.

 IF nf_item-matnr IS INITIAL .
   IF lt_esll[] IS NOT INITIAL.

     DATA(lt_esll_aux) = lt_esll[].
     SORT lt_esll_aux BY mwskz.
     DELETE ADJACENT DUPLICATES FROM lt_esll_aux COMPARING mwskz.
     IF lt_esll_aux[] IS NOT INITIAL.

       SELECT *
       FROM a003
       INTO TABLE @DATA(lt_a003)
       FOR ALL ENTRIES IN @lt_esll_aux
      WHERE kappl = 'TX'
        AND mwskz = @lt_esll_aux-mwskz
        AND kschl = @lc_zfcp
           .
     ENDIF.
   ENDIF.
 ELSE.

   SELECT COUNT( * )
   FROM a003
  WHERE kappl = 'TX'
    AND mwskz = nf_item-mwskz
    AND kschl = lc_zfcp.

 ENDIF.

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
           <fs_total_tax>-base = <fs_total_tax>-othbas.
           CLEAR <fs_total_tax>-othbas.
         ENDIF.

         IF <fs_total_tax>-othbasser IS NOT INITIAL.
           <fs_total_tax>-baseser = <fs_total_tax>-othbasser.
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
