***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Interface 3Collaboration - Pedido de Compras           *
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
REPORT zmmr_3c_pedido_compras MESSAGE-ID zmm_3collaboration.

TABLES: ekko,
        ekpo,
        eket.

DATA: go_3c_pedido_compras TYPE REF TO zclmm_3c_pedido_compras.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-b01.
  SELECT-OPTIONS: s_eindt FOR eket-eindt,
                  s_werks FOR ekpo-werks,
                  s_matnr FOR ekpo-matnr.
  PARAMETERS: p_jobid  TYPE sysuuid_x16 NO-DISPLAY.
SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.
  go_3c_pedido_compras = NEW zclmm_3c_pedido_compras( VALUE #(
    s_eindt  = s_eindt[]
    s_werks  = s_werks[]
    s_matnr  = s_matnr[]
    p_jobid  = p_jobid ) ).

  go_3c_pedido_compras->start_of_selection( ).

END-OF-SELECTION.
  go_3c_pedido_compras->end_of_selection( ).
