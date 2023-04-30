***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Habilita campos de fornecedor na IQ09                  *
*** AUTOR : Anderson Miazato - META                                   *
*** FUNCIONAL: Vanderleison Freitas - META                       *
*** DATA : 07.06.2022                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA       | AUTOR              | DESCRIÇÃO                       *
***-------------------------------------------------------------------*
*** 07.06.2022 | Anderson Miazato   | Desenvolvimento inicial         *
***********************************************************************

*&---------------------------------------------------------------------*
*& Include ZMMI_NUM_SERIE_REPORT
*&---------------------------------------------------------------------*

NEW zclmm_forn_cliente_relat( )->habilita_colunas(
  CHANGING
    ct_fieldcat = it_fieldcat
).