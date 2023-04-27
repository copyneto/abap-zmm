*&---------------------------------------------------------------------*
*& Include zmmi_check_ticketlog
*&---------------------------------------------------------------------*

      DATA(ls_item) = im_item->get_data( ).

      CHECK  ls_item IS NOT INITIAL.

      SELECT SINGLE trackingno FROM ztpm_desc_ticlog
        INTO @DATA(ls_ticketlog)
        WHERE banfn EQ @ls_item-banfn.

      IF sy-subrc EQ 0.

        ls_item-wepos = COND #(
          WHEN ls_item-mtart = 'SERV'
          THEN abap_false
          ELSE abap_true
        ).
        IF ls_item-mtart = 'DIEN'.
           ls_item-wepos = abap_false.
           ls_item-REPOS = abap_true.
           ls_item-WEBRE = abap_false.
        ENDIF.
        im_item->set_data( ls_item ).

      ENDIF.
