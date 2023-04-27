***********************************************************************
***                         © 3corações                             ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: EMISSÃO DE NF DE INVENTÁRIO                            *
*** AUTOR : THIAGO DA GRAÇA – META                                    *
*** FUNCIONAL: RODRIGO PRESTES – META                                 *
*** DATA : 29.09.2022                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
***     DATA    |       AUTOR       | DESCRIÇÃO                       *
***-------------------------------------------------------------------*
*** 29.09.2022  | THIAGO DA GRAÇA   | CRIAÇÃO DO REPORT               *
***********************************************************************
REPORT zmmr_emissao_nf_inventario.

***********************************************************************
* INCLUDES                                                            *
***********************************************************************
INCLUDE zmmr_emissao_nf_inventario_top.    " Include
INCLUDE zmmr_emissao_nf_inventario_s01.    " Screen
*INCLUDE zmmr_emissao_nf_inventario_c01.    " Classes
INCLUDE zmmr_emissao_nf_inventario_o01.    " BPO
INCLUDE zmmr_emissao_nf_inventario_i01.    " PAI
INCLUDE zmmr_emissao_nf_inventario_f01.    " Forms

**********************************************************************
* EVENTOS                                                            *
**********************************************************************

INITIALIZATION.
  "Export referencias
perform f_export_referencias.
***********************************************************************
* LOGICA PRINCIPAL                                                    *
***********************************************************************
START-OF-SELECTION.
  PERFORM f_start.

END-OF-SELECTION.

  "Valida se a tabela esta vazia
  IF ( go_inventario->has_data( ) = abap_true ).
    CALL SCREEN 9000.
  ELSE.
    "Não foram encontrados dados para os critérios de seleção informados.
    MESSAGE s001(ZMM_INVENT_FISICO) DISPLAY LIKE 'E'.
  ENDIF.
