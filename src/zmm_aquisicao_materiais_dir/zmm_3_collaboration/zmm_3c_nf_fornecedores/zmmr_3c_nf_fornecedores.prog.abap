***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Interface 3Collaboration - Entrada NF Fornecedores     *
*** AUTOR : Jefferson Fujii - META                                    *
*** FUNCIONAL: Cesar Carvalho Rodrigues - META                        *
*** DATA : 06.08.2022                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA       | AUTOR              | DESCRIÇÃO                       *
***-------------------------------------------------------------------*
*** 06.08.2022 | Jefferson Fujii    | Desenvolvimento inicial         *
***********************************************************************
REPORT zmmr_3c_nf_fornecedores MESSAGE-ID zmm_3collaboration.

TABLES: j_1bnfdoc.

DATA: go_3c_nf_fornecedores TYPE REF TO zclmm_3c_nf_fornecedores.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-b01.
  SELECT-OPTIONS: s_pstdat FOR j_1bnfdoc-pstdat OBLIGATORY.
  PARAMETERS: p_jobid  TYPE sysuuid_x16 NO-DISPLAY.

SELECTION-SCREEN END OF BLOCK b1.

INITIALIZATION.
  APPEND VALUE #( sign = 'I' option = 'EQ' low = sy-datum ) TO s_pstdat.

START-OF-SELECTION.
  go_3c_nf_fornecedores = NEW zclmm_3c_nf_fornecedores( VALUE #(
    s_pstdat = s_pstdat[]
    p_jobid  = p_jobid ) ).

  go_3c_nf_fornecedores->start_of_selection( ).

END-OF-SELECTION.
  go_3c_nf_fornecedores->end_of_selection( ).
