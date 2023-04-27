*&---------------------------------------------------------------------*
*& Include zmmi_block_itens
*&---------------------------------------------------------------------*


*    CONSTANTS: BEGIN OF gc_values,
*                 txt1         TYPE string VALUE 'Item',
*                 txt2         TYPE string VALUE 'já foi integrado ao ME,',
*                 txt3         TYPE string VALUE 'campo',
*                 txt4         TYPE string VALUE 'não pode ser modificado.',
*                 e            TYPE char1 VALUE 'E',
*                 m            TYPE char1 VALUE 'M',
*                 creationdate TYPE fieldname  VALUE 'CREATIONDATE',
*               END OF gc_values.
*
*    DATA: lt_ret      TYPE catsxt_compare_wa_itab.


*      LOOP AT im_eban ASSIGNING FIELD-SYMBOL(<fs_eban>).
*
*        IF <fs_eban>-zz1_statu EQ gc_values-m.
*
*          DATA(ls_eban_old) = VALUE #( im_eban_old[ banfn = <fs_eban>-banfn bnfpo = <fs_eban>-bnfpo ] OPTIONAL ).
*
*          CALL FUNCTION 'CATSXT_COMPARE_STRUCTURES'
*            EXPORTING
*              im_structure_name        = 'UEBAN'
*              im_structure_one         = <fs_eban>
*              im_structure_two         = ls_eban_old
*              im_stop_after_first_diff = ABAP_fALSE
*            IMPORTING
*              ex_results               = lt_ret
*            EXCEPTIONS
*              structure_not_found      = 1
*              OTHERS                   = 2.
*
*          IF sy-subrc EQ 0.
*
*            IF ls_eban_old NE <fs_eban>.
*
*              IF lines( im_eban ) NE lines( im_eban_old ).
*                CONTINUE.
*              ENDIF.
*
*              CONCATENATE gc_values-txt1 <fs_eban>-bnfpo gc_values-txt2 gc_values-txt4 INTO DATA(lv_message) SEPARATED BY space.
*              MESSAGE lv_message TYPE gc_values-e.
*
*            ENDIF.
*
*          ENDIF.
*
*        ENDIF.
*      ENDLOOP.
*
