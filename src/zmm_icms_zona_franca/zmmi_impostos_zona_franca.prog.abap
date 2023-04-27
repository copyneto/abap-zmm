***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Correção de impostos Zona Franca                       *
*** AUTOR:     Bruno Costa   - META                                   *
*** FUNCIONAL: Cassiano da Silva - META                               *
*** DATA :     06.01.2023                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA       | AUTOR              | DESCRIÇÃO                       *
***-------------------------------------------------------------------*
*** 06.01.2023 | Bruno Costa        | Desenvolvimento inicial         *
***********************************************************************
*&---------------------------------------------------------------------*
*& Include ZMMI_IMPOSTOS_ZONA_FRANCA
*&---------------------------------------------------------------------*

DATA: lt_nf_stx TYPE TABLE OF j_1bnfstx.

ASSIGN ('(SAPLJ1BF)WA_NF_STX[]') TO FIELD-SYMBOL(<fs_wa_nf_stx>).

IF <fs_wa_nf_stx> IS ASSIGNED.

  lt_nf_stx[] = <fs_wa_nf_stx>.

  LOOP AT lt_nf_stx ASSIGNING FIELD-SYMBOL(<fs_nf_stx>).
    IF <fs_nf_stx>-taxtyp EQ 'ZIZF'
      AND <fs_nf_stx>-base IS INITIAL.
      <fs_nf_stx>-base = <fs_nf_stx>-excbas.
      CLEAR <fs_nf_stx>-excbas.
    ENDIF.
  ENDLOOP.

  <fs_wa_nf_stx> = lt_nf_stx[].

ENDIF.
