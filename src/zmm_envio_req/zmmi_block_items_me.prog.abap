*&---------------------------------------------------------------------*
*& Include          ZMMI_BLOCK_ITEMS_ME
*&---------------------------------------------------------------------*
CONSTANTS lc_m    TYPE c VALUE 'M'.
CONSTANTS lc_ZSUB TYPE BBSRT VALUE 'ZSUB'.

DATA(ls_item_block) = im_item->get_data( ).

IF ls_item_block-zz1_statu EQ lc_m.

  LOOP AT ch_fieldselection ASSIGNING <fs1>.

    IF  <fs1>-metafield EQ 236
    OR  <fs1>-metafield EQ 242.

      IF ls_item_block-pstyp EQ 3.
        <fs1>-fieldstatus = '+'.
      ELSE.
        <fs1>-fieldstatus = '-'.
      ENDIF.

    ELSE.

      IF <fs1>-metafield EQ 392
      OR <fs1>-metafield EQ 803
*      OR <fs1>-metafield EQ 508
      OR <fs1>-metafield EQ 070
      OR <fs1>-metafield EQ 071
      OR <fs1>-metafield EQ 072.
        <fs1>-fieldstatus = '-'.
      ELSE.
        <fs1>-fieldstatus = '*'.
      ENDIF.

    ENDIF.

    INSERT <fs1> INTO TABLE lt_fieldselection.

  ENDLOOP.

ENDIF.

  LOOP AT ch_fieldselection ASSIGNING <fs1>.
    check <fs1>-metafield = 135.
    <fs1>-fieldstatus = '.'.
  ENDLOOP.


*
*data: lv_fieldstatus TYPE c.
*
*
*  LOOP AT ch_fieldselection ASSIGNING <fs1>.
*      CHECK <fs1>-metafield = mmmfd_ZZ1_VERID or
*            <fs1>-metafield = mmmfd_zz1_matnr or
*            <fs1>-metafield = 313 or <fs1>-metafield = 135.
*      if ls_item_block-bsart = lc_zsub.
*          if <fs1>-metafield = 313.
*            lv_fieldstatus = <fs1>-fieldstatus.
*            FREE MEMORY ID 'Z_FIELDSTATUS_MEREQ'.
*            EXPORT lv_fieldstatus FROM lv_fieldstatus TO MEMORY ID 'Z_FIELDSTATUS_MEREQ'.
*          ELSE.
*           IMPORT  lv_fieldstatus FROM MEMORY ID 'Z_FIELDSTATUS_MEREQ'.
*           <fs1>-fieldstatus = lv_fieldstatus.
*          endif.
*      else.
*        <fs1>-fieldstatus = '-'.
*      endif.
*      INSERT <fs1> INTO TABLE lt_fieldselection.
*
*  ENDLOOP.
