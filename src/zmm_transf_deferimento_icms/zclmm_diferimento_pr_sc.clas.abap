CLASS zclmm_diferimento_pr_sc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS atualiza_valor_provisao_icms
      IMPORTING
        !is_header          TYPE j_1bnfdoc
        !it_itens_nf        TYPE j_1bnflin_tab
      CHANGING
        !ct_itens_adicional TYPE j_1bnf_badi_item_tab
        !cs_header          TYPE j_1bnf_badi_header.
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES: ty_t_nfetx TYPE TABLE OF j_1bnfftx.

    CONSTANTS: BEGIN OF gc_values,
                 b  TYPE j_1bpartyp  VALUE  'B',
                 v2 TYPE j_1bitmtyp  VALUE '02',
               END OF gc_values.

ENDCLASS.



CLASS ZCLMM_DIFERIMENTO_PR_SC IMPLEMENTATION.


  METHOD atualiza_valor_provisao_icms.

    DATA: lv_novokzwi6 TYPE prcd_elements-kbetr,
          lv_kzwi6_aux TYPE prcd_elements-kbetr,
          lv_vicmsdif  TYPE j_1bnfstx-taxval,
          lv_taxval    TYPE char18,
          ls_sadr      TYPE sadr,
          lv_rate      TYPE j_1btxic1-rate,
          lv_validf    TYPE j_1btxdatf,
          lv_vltot     TYPE j_1btaxval.


    TYPES: ty_wnfstx TYPE TABLE OF j_1bnfstx.

    FIELD-SYMBOLS: <fs_wnfstx_tab> TYPE ty_wnfstx,
                   <fs_nfetx_tab>  TYPE ty_t_nfetx.

    ASSIGN ('(SAPLJ1BF)WA_NF_STX[]') TO <fs_wnfstx_tab>.
    ASSIGN ('(SAPLJ1BF)WA_NF_FTX[]') TO <fs_nfetx_tab>.

    SELECT SINGLE *
    INTO @DATA(ls_param_val)
    FROM ztca_param_val
    WHERE modulo = 'MM'
      AND chave1 = 'REGIAO DIFERIMENTO'.

    CHECK sy-subrc EQ 0.

    CALL FUNCTION 'J_1BREAD_BRANCH_DATA'
      EXPORTING
        branch            = is_header-branch
        bukrs             = is_header-bukrs
      IMPORTING
        address           = ls_sadr
      EXCEPTIONS
        branch_not_found  = 1
        address_not_found = 2
        company_not_found = 3
        OTHERS            = 4.

    CHECK sy-subrc EQ 0.

    IF ls_sadr-regio EQ ls_param_val-low.

      CONCATENATE sy-datum+6(2) sy-datum+4(2) sy-datum(4) INTO lv_validf.

      LOOP AT it_itens_nf INTO DATA(ls_item_nf) WHERE reftyp IS INITIAL.

        CHECK ls_item_nf-taxsit EQ gc_values-b.
        CHECK ls_item_nf-itmtyp EQ gc_values-v2.

        READ TABLE ct_itens_adicional ASSIGNING FIELD-SYMBOL(<fs_item_adicional>)
        WITH KEY itmnum = ls_item_nf-itmnum.

        IF sy-subrc = 0.
          IF <fs_wnfstx_tab> IS ASSIGNED.

            READ TABLE <fs_wnfstx_tab> ASSIGNING FIELD-SYMBOL(<fs_wnfstx>) WITH KEY itmnum = ls_item_nf-itmnum taxtyp = 'ICM3'.

            CHECK sy-subrc EQ 0.

            CALL FUNCTION 'J_1B_READ_TXIC1'
              EXPORTING
                country    = ls_sadr-land1
                state_from = ls_sadr-regio
                state_to   = is_header-regio
                date       = lv_validf
              IMPORTING
                rate       = lv_rate.

            "CHECK sy-subrc EQ 0.

            "Altera o percentual do ICM3
            <fs_wnfstx>-rate = lv_rate.

            lv_kzwi6_aux  = '33.3333'.
            lv_novokzwi6 = 1 - ( lv_kzwi6_aux / 100 ).
            lv_vicmsdif   = ( <fs_wnfstx>-taxval / lv_novokzwi6  ) * lv_kzwi6_aux.
            lv_vicmsdif = lv_vicmsdif / 100.
            <fs_item_adicional>-vicmsdif = lv_vicmsdif.
*            <fs_wnfstx>-rate = ( ( <fs_item_adicional>-vicmsdif + <fs_wnfstx>-taxval ) / <fs_wnfstx>-base ) * 100.

            lv_vltot = lv_vltot + lv_vicmsdif.

          ENDIF.

        ENDIF.
      ENDLOOP.

      IF is_header-partyp        = gc_values-b AND
         it_itens_nf[ 1 ]-itmtyp = gc_values-v2 AND lv_vltot > 0.

        CHECK <fs_nfetx_tab> IS ASSIGNED." AND
*            cs_header-infcpl IS INITIAL.

        DATA(lt_nfetx) = <fs_nfetx_tab>.

***        LOOP AT lt_nfetx ASSIGNING FIELD-SYMBOL(<fs_nfe>).
***          IF sy-tabix EQ 1.
***            cs_header-infcpl = <fs_nfe>-message.
***          ELSE.
***            cs_header-infcpl = |{ cs_header-infcpl }| && |{ ' - ' }| && |{ <fs_nfe>-message }|.
***          ENDIF.
***        ENDLOOP.

        lv_taxval = lv_vltot.
        REPLACE ALL OCCURRENCES OF '.' IN lv_taxval WITH ','.
        CONDENSE lv_taxval NO-GAPS.

        APPEND VALUE j_1bnfftx( seqnum  = VALUE #( lt_nfetx[ lines( lt_nfetx ) ]-seqnum OPTIONAL ) + 01
                                                     linnum  = 01
                                                     message =  |{ TEXT-001 }: { lv_taxval }| ) TO <fs_nfetx_tab>.

        FIND |{ TEXT-001 }: { lv_taxval }| IN cs_header-infcpl.
        IF sy-subrc NE 0.
          cs_header-infcpl = |{ cs_header-infcpl } - { TEXT-001 }: { lv_taxval }|.
        ENDIF.

      ENDIF.

    ENDIF.

    CONDENSE cs_header-infcpl.

  ENDMETHOD.
ENDCLASS.
