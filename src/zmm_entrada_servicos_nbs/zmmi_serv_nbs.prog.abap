***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Entrada de Serviço NBS                                 *
*** AUTOR    : Alysson Anjos – META                                   *
*** FUNCIONAL: Ricardo Meotti – META                                  *
*** DATA     : 13/03/20023                                            *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR        | DESCRIÇÃO                              *
***-------------------------------------------------------------------*
***           |              |                                        *
***********************************************************************
*&---------------------------------------------------------------------*
*& Include ZMMI_SERV_NBS
*&---------------------------------------------------------------------*

 CONSTANTS: lc_modulo TYPE ztca_param_par-modulo VALUE 'MM',
            lc_key1   TYPE ztca_param_par-chave1 VALUE 'NBS',
            lc_key2   TYPE ztca_param_par-chave2 VALUE 'ATIVA'.

 DATA: lv_ativo TYPE char1.

 DATA(lo_object) = NEW zclca_tabela_parametros( ).

 TRY.
     lo_object->m_get_single( EXPORTING iv_modulo = lc_modulo
                                        iv_chave1 = lc_key1
                                        iv_chave2 = lc_key2
                              IMPORTING ev_param  = lv_ativo ).
   CATCH zcxca_tabela_parametros. " Classe de exceção Tabela de Parâmetros
 ENDTRY.

 IF lv_ativo IS NOT INITIAL
AND gbobj_item[] IS NOT INITIAL.

   SELECT matnr,
          nbs
     FROM ztmm_nbs
      FOR ALL ENTRIES IN @gbobj_item[]
    WHERE matnr = @gbobj_item-matnr
     INTO TABLE @DATA(lt_nbs).

   IF sy-subrc IS INITIAL.
     SORT lt_nbs BY matnr.
   ENDIF.

   LOOP AT gbobj_item[] ASSIGNING FIELD-SYMBOL(<fs_gbobj_item>).
     IF <fs_gbobj_item>-nbs IS INITIAL.
       READ TABLE lt_nbs ASSIGNING FIELD-SYMBOL(<fs_nbs>)
                                       WITH KEY matnr = <fs_gbobj_item>-matnr
                                       BINARY SEARCH.
       IF sy-subrc IS INITIAL.
         <fs_gbobj_item>-nbs = <fs_nbs>-nbs.
       ENDIF.
     ENDIF.

   ENDLOOP.
 ENDIF.
