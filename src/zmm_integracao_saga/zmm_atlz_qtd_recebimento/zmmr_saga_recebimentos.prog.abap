***********************************************************************
***                      © 3Corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Etapas de recebimento - SAGA                           *
*** AUTOR    : Alysson Anjos - META                                   *
*** FUNCIONAL: Fábio Delgado                                          *
*** DATA     : 14/03/2022                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR        | DESCRIÇÃO                              *
***-------------------------------------------------------------------*
***           |              |                                        *
***********************************************************************
*&---------------------------------------------------------------------*
*& Report ZMMR_SAGA_RECEBIMENTOS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmmr_saga_recebimentos.

TABLES: j_1bnfdoc.

SELECTION-SCREEN BEGIN OF BLOCK bloco1 WITH FRAME
  TITLE TEXT-001.

  SELECT-OPTIONS: s_nf FOR j_1bnfdoc-nfenum.

SELECTION-SCREEN END OF BLOCK bloco1.

START-OF-SELECTION.
  PERFORM f_main.

FORM f_main.

  DATA(lo_object) = NEW zclmm_saga_etapas_recebimento( ).

  IF s_nf IS NOT INITIAL.

    LOOP AT s_nf ASSIGNING FIELD-SYMBOL(<fs_nf>).
      UNPACK <fs_nf>-high TO <fs_nf>-high.
      UNPACK <fs_nf>-low  TO <fs_nf>-low.
    ENDLOOP.

  ENDIF.

  lo_object->main( s_nf[] ).

ENDFORM.
