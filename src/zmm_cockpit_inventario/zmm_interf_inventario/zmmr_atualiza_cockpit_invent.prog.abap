***********************************************************************
*** © 3corações ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Atualizar Status docs COCKPIT DE INVENTARIO            *
*** AUTOR : Emilio Matheus – Meta                                     *
*** FUNCIONAL: Cassiano - Meta                                        *
*** DATA : 24.05.2023                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES *
***-------------------------------------------------------------------*
*** DATA | AUTOR | DESCRIÇÃO *
***-------------------------------------------------------------------*
*** | | *
***********************************************************************
REPORT zmmr_atualiza_cockpit_invent.

TABLES: iseg.

SELECTION-SCREEN BEGIN OF BLOCK txt1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS:  s_doc FOR iseg-iblnr.
SELECTION-SCREEN END OF BLOCK txt1.

DATA: gt_iblnr      TYPE STANDARD TABLE OF iblnr WITH EMPTY KEY,
      gt_documentid TYPE STANDARD TABLE OF sysuuid_x16.

START-OF-SELECTION.

  PERFORM p_concluidos.
  PERFORM p_cancelados.

end-of-SELECTION.

  WRITE: TEXT-002.


FORM p_concluidos.

  SELECT a~documentid, b~physinventory FROM ztmm_inventory_h AS a
  INNER JOIN ztmm_inventory_i AS b
  ON a~documentid = b~documentid
  WHERE b~physinventory IS NOT INITIAL
    AND b~status EQ '01'
    AND a~documentno IN @s_doc
    INTO TABLE @DATA(lt_itens).

  IF sy-subrc EQ 0.

    " Concluidos

    SELECT PhysicalInventoryDocument, PhysicalInventoryDocumentitem FROM i_physinvtrydocitem
    FOR ALL ENTRIES IN @lt_itens
    WHERE PhysicalInventoryDocument = @lt_itens-physinventory
      AND PostingDate IS NOT INITIAL
    INTO TABLE @DATA(lt_concluidos).

    IF sy-subrc EQ 0.

      LOOP AT lt_itens ASSIGNING FIELD-SYMBOL(<fs_itens>) GROUP BY ( physinventory = <fs_itens>-physinventory ).

        DATA(lv_itens_atua) = REDUCE i( INIT lv_x = 0 FOR ls_x IN lt_itens WHERE ( physinventory = <fs_itens>-physinventory ) NEXT lv_x = lv_x + 1 ).

        DATA(lv_concluidos) = REDUCE i( INIT lv_y = 0 FOR ls_y IN lt_concluidos WHERE ( PhysicalInventoryDocument = <fs_itens>-physinventory ) NEXT lv_y = lv_y + 1 ).

        CHECK lv_concluidos EQ lv_itens_atua.

        APPEND <fs_itens>-physinventory TO gt_iblnr.
        APPEND <fs_itens>-documentid    TO gt_documentid.

      ENDLOOP.

      CHECK gt_iblnr IS NOT INITIAL.

      DELETE ADJACENT DUPLICATES FROM gt_documentid COMPARING ALL FIELDS.

      LOOP AT gt_documentid ASSIGNING FIELD-SYMBOL(<fs_document>).

        UPDATE ztmm_inventory_h
           SET status = '03'
         WHERE documentid = <fs_document>.

      ENDLOOP.

      LOOP AT gt_iblnr ASSIGNING FIELD-SYMBOL(<ls_iblnr>).

        UPDATE ztmm_inventory_i
           SET status = '03'
         WHERE physinventory = <ls_iblnr>.

      ENDLOOP.

      COMMIT WORK.
    ENDIF.
  ENDIF.

  REFRESH: gt_iblnr, gt_documentid.

ENDFORM.

FORM p_cancelados.

  SELECT a~documentid, b~physinventory FROM ztmm_inventory_h AS a
 INNER JOIN ztmm_inventory_i AS b
 ON a~documentid = b~documentid
 WHERE b~physinventory IS NOT INITIAL
   AND b~status EQ '01'
   AND a~documentno IN @s_doc
   INTO TABLE @DATA(lt_itens_atua).

  IF sy-subrc EQ 0.

    " Cancelados

    SELECT iblnr FROM iseg
    FOR ALL ENTRIES IN @lt_itens_atua
    WHERE iblnr = @lt_itens_atua-physinventory
    INTO TABLE @DATA(lt_iseg).

    LOOP AT lt_itens_atua ASSIGNING FIELD-SYMBOL(<fs_itens>) GROUP BY ( physinventory = <fs_itens>-physinventory ).

      IF NOT line_exists( lt_iseg[ iblnr = <fs_itens>-physinventory ] ).

        APPEND <fs_itens>-physinventory TO gt_iblnr.
        APPEND <fs_itens>-documentid    TO gt_documentid.

      ENDIF.

    ENDLOOP.

    CHECK gt_iblnr IS NOT INITIAL.

    DELETE ADJACENT DUPLICATES FROM gt_documentid COMPARING ALL FIELDS.

    LOOP AT gt_documentid ASSIGNING FIELD-SYMBOL(<fs_document>).

      UPDATE ztmm_inventory_h
         SET status = '02'
       WHERE documentid = <fs_document>.

    ENDLOOP.

    LOOP AT gt_iblnr ASSIGNING FIELD-SYMBOL(<ls_iblnr>).

      UPDATE ztmm_inventory_i
         SET status = '04'
       WHERE physinventory = <ls_iblnr>.

    ENDLOOP.

    COMMIT WORK.

  ENDIF.

  REFRESH: gt_iblnr, gt_documentid.

ENDFORM.
