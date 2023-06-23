*&---------------------------------------------------------------------*
*& Include ZMME_TRIGGER_BAPIS
*&---------------------------------------------------------------------*
* ---------------------------------------------------------------------------
* Processo de Depósito Fechado
* ---------------------------------------------------------------------------

 CONSTANTS: lc_proctype TYPE /xnfe/proctyp VALUE 'SUBCON1A'.

 TRY.
     NEW zclmm_change_values( )->trigger_bapis(
         EXPORTING iv_invnumber = ev_invnumber
                   iv_year      = ev_byear
                   is_header    = is_header
                   it_item      = et_item
         IMPORTING et_return    = et_bapiret2 ).
   CATCH cx_root.
 ENDTRY.

*    "Etapa de Subcontratação
 IF is_header-proctyp = lc_proctype.

   DATA(lo_cfop) = zclmm_atualiza_cfop=>get_instance( ).
   lo_cfop->save_guid_header( is_header-guid_header ).
   lo_cfop->save_guid16( is_header_data-access_key ).
   lo_cfop->update_cfop_sc( CHANGING  ct_item = et_item  ).

 ENDIF.
