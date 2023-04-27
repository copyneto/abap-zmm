***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Lista Solicitações de Viagens - ARGO                   *
*** AUTOR    : Alysson Anjos – META                                   *
*** FUNCIONAL: Luis Moraes – META                                     *
*** DATA     : 19/10/2021                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR        | DESCRIÇÃO                              *
***-------------------------------------------------------------------*
***           |              |                                        *
***********************************************************************
*&---------------------------------------------------------------------*
*& Report ZMMR_LISTAR_SOLICIT_ARGO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmmr_listar_solicit_argo.

SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME.

  PARAMETERS: p_aut  TYPE char1 RADIOBUTTON GROUP g1,
              p_proc TYPE char1 RADIOBUTTON GROUP g1.

SELECTION-SCREEN END OF BLOCK a1.

START-OF-SELECTION.
  PERFORM f_main.

FORM f_main.

  DATA: lt_solics TYPE zctgmm_list_solic_argo.

  CONSTANTS: lc_error  TYPE sy-msgty VALUE 'E',
             lc_sucess TYPE sy-msgty VALUE 'S'.

  DATA(lo_proxy) = NEW zclmm_argo_solicitacoes( ).

  IF lo_proxy IS BOUND.
    lo_proxy->listar_solicitacao( EXPORTING iv_criar         = p_aut
                                  EXCEPTIONS param_not_found  = 1
                                             error_connection = 2
                                             OTHERS           = 3 ).

  ENDIF.

  CASE sy-subrc.
    WHEN 0.
      MESSAGE TEXT-t02 TYPE lc_sucess.
      COMMIT WORK.
    WHEN 1.
      MESSAGE TEXT-t03 TYPE lc_error.
    WHEN 2.
      MESSAGE TEXT-t04 TYPE lc_error.
    WHEN OTHERS.
      MESSAGE TEXT-t01 TYPE lc_error.
  ENDCASE.

ENDFORM.
