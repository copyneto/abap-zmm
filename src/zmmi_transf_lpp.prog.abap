***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: MM - Transferência LPP - VPRS                          *
*** AUTOR    : Luís Gustavo Schepp - META                             *
*** FUNCIONAL: Leandro Oliveira                                       *
*** DATA     : 31.05.2022                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA       | AUTOR              | DESCRIÇÃO                       *
***-------------------------------------------------------------------*
*** 31.05.2022 | Luís Gustavo Schepp   | Desenvolvimento inicial      *
***********************************************************************
*&---------------------------------------------------------------------*
*& Include ZMMI_TRANSF_LPP
*&---------------------------------------------------------------------*

  DATA(lt_nf_tax) = nf_tax[].

  SELECT 'I' AS sign,
         'EQ' AS option,
         taxtyp AS low,
         taxtyp AS high
    FROM j_1baj
    INTO TABLE @DATA(lt_ipi)
   WHERE taxgrp EQ 'IPI'
     AND lppact EQ @abap_true.

  SELECT 'I' AS sign,
         'EQ' AS option,
         taxtyp AS low,
         taxtyp AS high
    FROM j_1baj
    INTO TABLE @DATA(lt_icms)
   WHERE taxgrp EQ 'ICMS'
     AND lppact EQ @abap_true.

  SELECT 'I' AS sign,
         'EQ' AS option,
         taxtyp AS low,
         taxtyp AS high
    FROM j_1baj
    INTO TABLE @DATA(lt_icst)
   WHERE taxgrp EQ 'ICST'
     AND lppact EQ @abap_true.

  SELECT SINGLE matnr,
                bwkey,
                bwtar,
                mtuse
    FROM mbew
   WHERE matnr = @p_gs_lpp-matnr
     AND bwkey = @p_gs_lpp-bwkey
     AND bwtar = @p_gs_lpp-bwtar
    INTO @DATA(ls_mbew).

  LOOP AT lt_nf_tax ASSIGNING FIELD-SYMBOL(<fs_nf_tax>)
                                     WHERE buzei EQ bz_rbco-buzei2.

    CALL FUNCTION 'J_1B_READ_J1BAJ'
      EXPORTING
        i_kschl    = <fs_nf_tax>-taxtyp
      IMPORTING
        e_flag_lpp = lv_lpp
        e_flag_ipi = lv_ipi
      EXCEPTIONS
        not_found  = 1
        OTHERS     = 2.

    IF <fs_nf_tax>-taxtyp IN lt_ipi.
      TRY.
          p_recalc-zipival = <fs_nf_tax>-taxval / ( p_menge * p_umrez / p_umren ).
        CATCH cx_sy_zerodivide.
      ENDTRY.

      IF lv_lpp EQ 'I'
      OR lv_ipi EQ abap_true.
        SUBTRACT p_recalc-zipival FROM p_recalc-lppbrt.
      ENDIF.

    ENDIF.

    IF <fs_nf_tax>-taxtyp IN lt_icms
   AND lv_lpp             EQ 'S'.

      TRY.
          p_recalc-icmsval = <fs_nf_tax>-taxval / ( p_menge * p_umrez / p_umren ).
          ADD p_recalc-icmsval TO p_recalc-lppbrt.
*          SUBTRACT p_recalc-subtval FROM p_recalc-lppbrt.
          PERFORM calculate_average USING p_gs_lpp-icmsavr
                                          p_lbkum
                                          p_menge
                                          p_umrez
                                          p_umren
                                          p_recalc-icmsval
                                 CHANGING p_recalc-icmsavr.
        CATCH cx_sy_zerodivide.
      ENDTRY.
    ENDIF.

    IF <fs_nf_tax>-taxtyp IN lt_icst
   AND lv_lpp             EQ 'S'.

      TRY.

          p_recalc-subtval = <fs_nf_tax>-taxval / ( p_menge * p_umrez / p_umren ).

          SUBTRACT p_recalc-subtval FROM p_recalc-lppbrt.
          PERFORM calculate_average USING p_gs_lpp-subtavr
                                          p_lbkum
                                          p_menge
                                          p_umrez
                                          p_umren
                                          p_recalc-subtval
                                 CHANGING p_recalc-subtavr.
        CATCH cx_sy_zerodivide.
      ENDTRY.
    ENDIF.

    p_recalc-lppid = 'S'.

  ENDLOOP.
