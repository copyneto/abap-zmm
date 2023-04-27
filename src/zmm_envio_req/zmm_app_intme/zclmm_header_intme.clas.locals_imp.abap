CLASS lcl_item DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validateEkgrp FOR DETERMINE ON SAVE
      IMPORTING keys FOR Item~validateEkgrp.

ENDCLASS.

CLASS lcl_item IMPLEMENTATION.

  METHOD validateEkgrp.

    READ ENTITIES OF zi_mm_header_intme IN LOCAL MODE
              ENTITY Item
              FIELDS ( Ekgrp )
              WITH CORRESPONDING #( keys )
              RESULT DATA(lt_ekgrp)
              FAILED DATA(ls_erros).

    IF lt_ekgrp IS NOT INITIAL.

      DATA(lv_ekgrp) = lt_ekgrp[ 1 ]-ekgrp.

      SELECT SINGLE CompGroupCode FROM zi_ca_vh_ekgrp
        WHERE CompGroupCode = @lv_ekgrp
         INTO @DATA(lv_result) .

      IF sy-subrc NE 0.

        APPEND VALUE #( %tky = keys[ 1 ]-%tky
                        %msg = new_message(
                          id       = 'ZMM_REQ_COMPRAS'
                          number   = 008
                          severity = if_abap_behv_message=>severity-error ) )
                     TO reported-header.

      ENDIF.

    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_Header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Header RESULT result.
    METHODS validateBsar FOR VALIDATE ON SAVE
      IMPORTING keys FOR header~validateBsar.

ENDCLASS.

CLASS lcl_Header IMPLEMENTATION.

  METHOD get_authorizations.
    RETURN.
  ENDMETHOD.

  METHOD validateBsar.

    READ ENTITIES OF zi_mm_header_intme IN LOCAL MODE
              ENTITY Header
              FIELDS ( Bsart )
              WITH CORRESPONDING #( keys )
              RESULT DATA(lt_bsart)
              FAILED DATA(ls_erros).

    IF lt_bsart IS NOT INITIAL.

      DATA(lv_bsart) = lt_bsart[ 1 ]-bsart.

      SELECT SINGLE Bsart FROM zi_ca_vh_bsart
        WHERE Bsart = @lv_bsart
         INTO @DATA(lv_result) .

      IF sy-subrc NE 0.

        APPEND VALUE #( %tky = keys[ 1 ]-%tky )
                            TO failed-header.

        APPEND VALUE #( %tky = keys[ 1 ]-%tky
                 %msg = new_message(
                          id       = 'ZMM_REQ_COMPRAS'
                          number   = 007
                          severity = if_abap_behv_message=>severity-error ) )
                     TO reported-header.


      ENDIF.

    ENDIF.

  ENDMETHOD.

ENDCLASS.
