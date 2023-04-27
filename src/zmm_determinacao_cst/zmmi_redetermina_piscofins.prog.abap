*&---------------------------------------------------------------------*
*& Include          ZMMI_REDETERMINA_PISCOFINS
*&---------------------------------------------------------------------*

TRY.
    NEW zclmm_redetermina_piscof_event( )->redetermine_pis_cofins(
      EXPORTING
        is_nfdoc  = obj_header
      CHANGING
        ct_nflin  = obj_item[] ).

  CATCH cx_root INTO DATA(lo_root_exit).
    DATA(lv_message_exit) = lo_root_exit->get_longtext( ).

ENDTRY.
