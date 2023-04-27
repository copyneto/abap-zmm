CLASS lcl_Cafe DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

*    METHODS lock FOR LOCK
*      IMPORTING keys FOR LOCK Cafe.

    METHODS read FOR READ
      IMPORTING keys FOR READ Cafe RESULT result.

    METHODS armazenar FOR MODIFY
      IMPORTING keys FOR ACTION Cafe~armazenar RESULT result.

ENDCLASS.

CLASS lcl_Cafe IMPLEMENTATION.

*  METHOD lock.
*    RETURN.
*  ENDMETHOD.

  METHOD read.
    RETURN.
  ENDMETHOD.

  METHOD armazenar.

    DATA: ls_result TYPE zi_mm_01_cafe.

*    READ ENTITIES OF zi_mm_01_cafe ENTITY Cafe
*         ALL FIELDS WITH CORRESPONDING #( keys )
*         RESULT DATA(lt_cafe)
*         FAILED failed.
    IF keys IS NOT INITIAL.
      SELECT * FROM zi_mm_01_cafe
           FOR  ALL ENTRIES IN @keys
           WHERE sequence     = @keys-sequence
             AND ebeln        = @keys-ebeln
             AND EBELp        = @keys-EBELp
             AND nfnum        = @keys-nfnum
             AND companycode  = @keys-companycode
             AND material     = @keys-material
             AND plant        = @keys-plant
            INTO TABLE  @DATA(lt_cafe).
    ENDIF.

    CHECK lt_cafe IS NOT INITIAL.

    DATA(lo_cafe) =  NEW zclmm_ord_arm( is_order_arm = CORRESPONDING zi_mm_01_cafe( lt_cafe[ 1 ] )  ).

    reported-cafe = VALUE #( FOR ls_mensagem IN lo_cafe->execute( )
                           (  %msg    = new_message(
                                 id       = ls_mensagem-id
                                 number   = ls_mensagem-number
                                 severity = CONV #( ls_mensagem-type )
                                 v1       = ls_mensagem-message_v1
                                 v2       = ls_mensagem-message_v2
                                 v3       = ls_mensagem-message_v3
                                 v4       = ls_mensagem-message_v4 )
                     ) ) .


  ENDMETHOD.

ENDCLASS.

CLASS lcl_ZI_MM_01_CAFE DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lcl_ZI_MM_01_CAFE IMPLEMENTATION.

  METHOD check_before_save.
    RETURN.
  ENDMETHOD.

  METHOD finalize.
    RETURN.
  ENDMETHOD.

  METHOD save.
    RETURN.
  ENDMETHOD.

ENDCLASS.
