***********************************************************************
*** © 3corações ***
***********************************************************************
*** *
*** DESCRIÇÃO: Manifestacao Automatica de NF-e entrada manualmente no ECC(MIGO/MIRO)*
*** AUTOR : Everthon Costa – Meta *
*** FUNCIONAL:  Leandro Neto - Meta *
*** DATA : [DATA] *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES *
***-------------------------------------------------------------------*
*** DATA | AUTOR | DESCRIÇÃO *
***-------------------------------------------------------------------*
*** 01.04.2022 | ECOSTA | Desenvolvimento inicial *
***********************************************************************
REPORT zmmr_nfe_mde_process.

*--------------------------------------------------------------------*
* Declarações
*--------------------------------------------------------------------*
TABLES: j_1bnfdoc,
        j_1bnfe_active.


*--------------------------------------------------------------------*
* Tela
*--------------------------------------------------------------------*
SELECT-OPTIONS s_pstdat FOR j_1bnfdoc-pstdat NO INTERVALS
                                             NO-EXTENSION.
                                             "OBLIGATORY.

SELECTION-SCREEN SKIP.

SELECT-OPTIONS:
        s_bukrs    FOR j_1bnfdoc-bukrs,
        s_branch   FOR j_1bnfdoc-branch.

SELECTION-SCREEN SKIP.

SELECT-OPTIONS:
      s_docnum FOR j_1bnfdoc-docnum.



*--------------------------------------------------------------------*
* Início de processamento
*--------------------------------------------------------------------*
START-OF-SELECTION.


  TRY.

      NEW zclmm_nfe_mdfe_process( ir_pstdat =   s_pstdat[]
                                  ir_bukrs  =   s_bukrs[]
                                  ir_branch =   s_branch[]
                                  ir_docnum =   s_docnum[]
      )->execute( ).

    CATCH cx_root.

  ENDTRY.
