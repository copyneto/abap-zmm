**&---------------------------------------------------------------------*
**& Include          ZMMI_VALIDATE_ME
**&---------------------------------------------------------------------*

CONSTANTS: lc_m TYPE c VALUE 'M'.

DATA(ls_header) = im_header->get_data( ).
DATA(lt_itens) = im_header->get_items( ).

LOOP AT lt_itens ASSIGNING FIELD-SYMBOL(<fs_itens>).

  DATA(lo_object) = <fs_itens>-item.

  DATA(ls_data) = lo_object->get_data( ).

  IF ls_data-zz1_statu EQ lc_m.
    MESSAGE TEXT-t02 TYPE if_abap_behv_message=>severity-success DISPLAY LIKE if_abap_behv_message=>severity-warning.
  ENDIF.

ENDLOOP.
