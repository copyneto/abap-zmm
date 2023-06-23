*&---------------------------------------------------------------------*
*& Include ZMME_CHANGE_TAXL
*&---------------------------------------------------------------------*

 CONSTANTS: lc_direct TYPE j_1bdirect VALUE '1'.

 TRY.

     IF f_direct = lc_direct.
       NEW zclmm_change_taxl( )->change_taxl( EXPORTING is_laws = f_tax_laws IMPORTING et_laws = DATA(lt_laws) ).

       IF lt_laws[] IS NOT INITIAL.
         REFRESH f_tax_laws.
         DATA(ls_data)      = lt_laws[ 1 ].
         f_tax_laws-icmslaw = ls_data-icmslaw.
         f_tax_laws-ipilaw  = ls_data-ipilaw.
         f_tax_laws-coflaw  = ls_data-coflaw.
         f_tax_laws-pislaw  = ls_data-pislaw.
         APPEND f_tax_laws.
       ENDIF.
     ENDIF.

   CATCH cx_root.
 ENDTRY.
