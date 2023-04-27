*&---------------------------------------------------------------------*
*& Include          ZMMI_ENVIO_LIBERACAO_PEDIDO
*&---------------------------------------------------------------------*

***********************************************************************
***                         © 3corações                             ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Envio liberação pedido                                 *
*** AUTOR : Mikaelly A Saraiva - Dongkuk                              *
*** FUNCIONAL: Thiago Ferreira                                        *
*** DATA : 12/04/2022                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA | AUTOR | DESCRIÇÃO                                          *
***-------------------------------------------------------------------*
*** 12.04.2022 | MAS | GAP 438 - RICEFW – 18J-438I04                  *
***********************************************************************

 CONSTANTS: lc_po_aprov TYPE c LENGTH 2 VALUE '05',
            lc_po_rejei TYPE c LENGTH 2 VALUE '08',
            lc_s        TYPE c VALUE 'S',
            lc_e        TYPE c VALUE 'E'.

 DATA: lv_output   TYPE zclmm_mt_pedido_compra1.

 IF im_ekko-procstat EQ lc_po_aprov OR im_ekko-procstat EQ lc_po_rejei.

* Item pedido
   SELECT SINGLE banfn, brtwr
     FROM ekpo
     INTO @DATA(lv_item)
     WHERE ebeln EQ @im_ekko-ebeln
       AND banfn NE @space.

   IF sy-subrc IS INITIAL.

* Dados Fluig - Requisicao
     SELECT SINGLE *
       FROM ztmm_fluig_rc
       INTO @DATA(lv_fluig_rc)
       WHERE banfn = @lv_item-banfn.

     IF sy-subrc IS INITIAL.

* Dados Fornecedor
       SELECT SINGLE name1, stcd1, adrnr
         FROM lfa1
         INTO @DATA(lv_lfa1)
         WHERE lifnr EQ @im_ekko-lifnr.

       IF sy-subrc IS INITIAL.

* Dados e-mail Fornecedor
         SELECT SINGLE smtp_addr
           FROM adr6
           INTO @DATA(lv_adrnr)
           WHERE addrnumber EQ @lv_lfa1-adrnr
             AND home_flag  EQ @abap_true.

         "IF sy-subrc IS INITIAL.

           DATA(lv_msgtx) = SWITCH #( im_ekko-procstat
                              WHEN lc_po_aprov THEN | { text-001 } ' ' { im_ekko-ebeln } ' ' { text-002 } |
                              WHEN lc_po_rejei THEN | { text-001 } ' ' { im_ekko-ebeln } ' ' { text-003 } | ).
           TRY.

               DATA(lo_enviar_pedido) = NEW zclmm_co_si_enviar_pedido_comp( ).

               lv_output-mt_pedido_compra = VALUE #(
                          idsol      = lv_fluig_rc-idsol
                          ebeln      = im_ekko-ebeln
                          msgtyp     = SWITCH #( im_ekko-procstat WHEN lc_po_aprov THEN lc_s WHEN lc_po_rejei THEN lc_e )
                          msgtx      = lv_msgtx
                          stcd1      = lv_lfa1-stcd1
                          name1      = lv_lfa1-name1
                          smtp_addr  = lv_adrnr
                          rlwrt      = lv_item-brtwr
                      ).

               lo_enviar_pedido->si_enviar_pedido_compras_out( output = lv_output ).

             CATCH cx_ai_system_fault.

           ENDTRY.

         "ENDIF.

       ENDIF.

     ENDIF.

   ENDIF.

 ENDIF.
