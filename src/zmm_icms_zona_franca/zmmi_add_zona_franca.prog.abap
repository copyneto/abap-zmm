*&---------------------------------------------------------------------*
*& Include          ZMMI_ADD_ZONA_FRANCA
*&---------------------------------------------------------------------*

    TRY.
        DATA(lo_zona_franca) = NEW zclmm_add_zona_franca( ).

        IF is_header-direct = '2'.
          lo_zona_franca->calcula_zf_saida(
            EXPORTING
              is_header = is_header
              it_nflin  = it_nflin
              it_nfstx  = it_nfstx ).
        ENDIF.

        IF is_header-direct = '1'.
          lo_zona_franca->calcula_zf_entrada_transf(
            EXPORTING
              is_header = is_header
              it_nflin  = it_nflin
              it_mseg   = it_mseg ).
        ENDIF.

      CATCH cx_root INTO DATA(lo_root).
    ENDTRY.
