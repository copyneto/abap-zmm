CLASS lcl_app DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR app RESULT result.

ENDCLASS.

CLASS lcl_app IMPLEMENTATION.

  METHOD get_authorizations.
   RETURN.
  ENDMETHOD.

ENDCLASS.
