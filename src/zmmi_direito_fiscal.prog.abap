*&---------------------------------------------------------------------*
*& Include zmmi_direito_fiscal
*&---------------------------------------------------------------------*

DATA lv_tax_text TYPE string.

IF lines( it_nflin ) GT 0.

  TRY.

      DATA(lv_dummy) = it_nflin[ reftyp = 'MD' ].

      SELECT DISTINCT *
        FROM zi_ca_taxlaw
         FOR ALL ENTRIES IN @it_nflin
       WHERE ( Taxlaw = @it_nflin-taxlw1 ) OR "ICMS
             ( Taxlaw = @it_nflin-taxlw2 ) OR "IPI
             ( Taxlaw = @it_nflin-taxlw4 ) OR "COFINS
             ( Taxlaw = @it_nflin-taxlw5 )    "PIS
        INTO TABLE @DATA(lt_taxlaw).

      LOOP AT lt_taxlaw ASSIGNING FIELD-SYMBOL(<fs_taxlaw>).
        CONDENSE <fs_taxlaw>-taxtext.
        SEARCH cs_header-infcpl FOR <fs_taxlaw>-taxtext.
        IF sy-subrc NE 0.
          cs_header-infcpl = |{ <fs_taxlaw>-taxtext } { cs_header-infcpl }|.
        ENDIF.
      ENDLOOP.

    CATCH cx_sy_itab_line_not_found.

  ENDTRY.

  CONDENSE cs_header-infcpl.

****  ASSIGN ('(SAPLJ_1B_NFE)XMLH') TO <fs_tax_xmlh>.
****  IF <fs_tax_xmlh> IS NOT ASSIGNED.
****    RETURN.
****  ENDIF.
****
****  IF <fs_tax_xmlh> IS ASSIGNED.
****
****    LOOP AT lt_taxlaw ASSIGNING FIELD-SYMBOL(<fs_taxlaw>).
****      CONDENSE <fs_taxlaw>-taxtext.
****      SEARCH <fs_tax_xmlh>-infcomp FOR <fs_taxlaw>-taxtext.
****      IF sy-subrc NE 0.
****        <fs_tax_xmlh>-infcomp = |{ <fs_taxlaw>-taxtext } { <fs_tax_xmlh>-infcomp }|.
****      ENDIF.
****    ENDLOOP.
****
****    CONDENSE <fs_tax_xmlh>-infcomp.
****

ENDIF.
