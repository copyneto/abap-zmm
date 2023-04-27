*&---------------------------------------------------------------------*
*& Include zmmi_tag_fci
*&---------------------------------------------------------------------*
  DATA: lt_fci_aux  TYPE SORTED TABLE OF ztmm_fci WITH UNIQUE KEY centro cod_material,
        lt_messages TYPE /letnis/fci_t_nfe_message,
        lo_xmltext  TYPE REF TO /letnis/fci_cl_danfe_xml_messa.

  DATA ls_fci_aux LIKE LINE OF lt_fci_aux.

  IF is_header-direct = '2' AND it_nflin[] IS NOT INITIAL.

    CREATE OBJECT lo_xmltext.

    DATA(lt_nflin_aux) = it_nflin[].
***    DELETE lt_nflin_aux WHERE matorg NE '0'.
    LOOP AT lt_nflin_aux  ASSIGNING FIELD-SYMBOL(<fs_nflin_aux>).
      IF <fs_nflin_aux>-matorg NE '3' AND
         <fs_nflin_aux>-matorg NE '5' AND
         <fs_nflin_aux>-matorg NE '8'.
        DELETE lt_nflin_aux INDEX sy-tabix.
      ENDIF.
    ENDLOOP.

    IF NOT lt_nflin_aux IS INITIAL.
      SELECT DISTINCT centro, cod_material, data_envio, hora_envio, num_controle_fci
        FROM ztmm_fci
        FOR ALL ENTRIES IN @lt_nflin_aux
      WHERE empresa         EQ @is_header-bukrs
        AND centro          EQ @lt_nflin_aux-werks
        AND cod_material    EQ @lt_nflin_aux-matnr
        AND inativo         EQ @abap_false
      INTO TABLE @DATA(lt_fci).
    ENDIF.

    IF lt_fci[] IS NOT INITIAL.

      SORT lt_fci BY centro cod_material data_envio DESCENDING hora_envio DESCENDING.

      LOOP AT lt_fci ASSIGNING FIELD-SYMBOL(<fs_fci>).
        READ TABLE lt_fci_aux TRANSPORTING NO FIELDS BINARY SEARCH
          WITH KEY centro = <fs_fci>-centro cod_material = <fs_fci>-cod_material.

        IF sy-subrc IS NOT INITIAL.
          ls_fci_aux-centro = <fs_fci>-centro.
          ls_fci_aux-cod_material = <fs_fci>-cod_material.
          ls_fci_aux-num_controle_fci = <fs_fci>-num_controle_fci.
          APPEND ls_fci_aux TO lt_fci_aux.
        ENDIF.

      ENDLOOP.

      LOOP AT lt_nflin_aux INTO DATA(ls_nflin_aux).

        READ TABLE lt_fci_aux INTO DATA(ls_fci) WITH KEY centro = ls_nflin_aux-werks cod_material = ls_nflin_aux-matnr BINARY SEARCH.
        CHECK sy-subrc IS INITIAL AND ls_fci-num_controle_fci IS NOT INITIAL.

        LOOP AT et_item ASSIGNING FIELD-SYMBOL(<fs_item_fci>).
          IF <fs_item_fci>-itmnum = ls_nflin_aux-itmnum.
            <fs_item_fci>-nfci = ls_fci-num_controle_fci.
            EXIT.
          ENDIF.
        ENDLOOP.

      ENDLOOP.

    ENDIF.

    LOOP AT lt_nflin_aux ASSIGNING <fs_nflin_aux>.
      REFRESH lt_messages.
      LOOP AT et_item ASSIGNING <fs_item_fci>.
        IF <fs_item_fci>-itmnum = <fs_nflin_aux>-itmnum.
          CALL METHOD lo_xmltext->fill_infadprod
            EXPORTING
              in_doc  = is_header
              in_lin  = <fs_nflin_aux>
            CHANGING
              out_msg = lt_messages.
          LOOP AT lt_messages ASSIGNING FIELD-SYMBOL(<fs_messages>) WHERE param NE ''.
            <fs_item_fci>-nfci = <fs_messages>-param.
            TRANSLATE <fs_item_fci>-nfci TO UPPER CASE.
          ENDLOOP.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

  ENDIF.
