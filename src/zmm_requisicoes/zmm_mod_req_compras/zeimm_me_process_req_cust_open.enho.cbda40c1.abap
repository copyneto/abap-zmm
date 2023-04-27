"Name: \PR:SAPLMEREQ\TY:LCL_INSTANCE_FACTORY\IN:IF_PURCHASE_REQ_FACTORY\ME:CREATE_HEADER\SE:END\EI
ENHANCEMENT 0 ZEIMM_ME_PROCESS_REQ_CUST_OPEN.
    CALL FUNCTION 'MEREQBADI_OPEN'
      EXPORTING
        im_trtyp        = l_doc-trtyp
        im_header       = l_header
      CHANGING
        ch_valid        = l_valid
        ch_display_only = l_display_only.

*- switch to display mode?
    IF l_display_only NE mmpur_no.
      l_header->my_state->aktyp = l_header->my_state->trtyp = anz.
    ENDIF.

*- deregistration ----------------------------------------------------*
    IF ( l_failure EQ mmpur_yes OR l_valid EQ mmpur_no ) AND
       l_protect EQ mmpur_yes.

      CALL METHOD me->unregister( im_header = l_header ).
      CLEAR ex_instance.

    ELSE.

      ex_instance ?= l_header.

    ENDIF.

*- register GOS manager
    IF im_gos IS BOUND.                                     "913251
      l_header->set_gos_manager( im_gos ).
    ENDIF.

*- messages
    CALL METHOD cl_message_handler_mm=>get_handler
      IMPORTING
        ex_handler = l_hd.

* get messages in case header was unregistered because of no authority   "1493589
    IF l_header IS INITIAL OR ex_instance IS INITIAL.
      CALL METHOD l_hd->getlist
        IMPORTING
          ex_evnt = ex_events.
    ELSE.
      CALL METHOD l_hd->getlist
        EXPORTING
          im_object                = l_header
          im_include_child_objects = mmpur_yes
        IMPORTING
          ex_evnt                  = ex_events.
    ENDIF.

    IF l_failure EQ mmpur_yes OR
       l_valid EQ mmpur_no.                                 "938007

      CALL METHOD l_hd->remove_by_bo
        EXPORTING
          im_business_obj          = l_header
          im_include_child_objects = mmpur_yes.
      RAISE failure.
    ENDIF.
ENDENHANCEMENT.
