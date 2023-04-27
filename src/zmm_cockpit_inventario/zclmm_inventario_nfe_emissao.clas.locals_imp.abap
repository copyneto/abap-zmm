CLASS lcl_Inventario DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS encerraInventario FOR MODIFY
      IMPORTING keys FOR ACTION _Inventario~encerraInventario RESULT result.

    METHODS gerarNota FOR MODIFY
      IMPORTING keys FOR ACTION _Inventario~gerarNota RESULT result.

    METHODS gerarContabil FOR MODIFY
      IMPORTING keys FOR ACTION _Inventario~gerarContabil RESULT result.

    METHODS estornarContabil FOR MODIFY
      IMPORTING keys FOR ACTION _Inventario~estornarContabil RESULT result.

ENDCLASS.

CLASS lcl_Inventario IMPLEMENTATION.

  METHOD encerraInventario.

    READ ENTITIES OF zi_mm_inventario_nfe_emissao IN LOCAL MODE
    ENTITY _Inventario
       ALL FIELDS WITH CORRESPONDING #( keys )
       RESULT DATA(lt_invt).


    READ ENTITIES OF zi_mm_inventario_nfe_emissao IN LOCAL MODE
      ENTITY _Inventario
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_result)
         FAILED failed.

    result = VALUE #( FOR ls_result IN lt_result ( %tky = ls_result-%tky ) ).

  ENDMETHOD.

  METHOD gerarNota.

    READ ENTITIES OF zi_mm_inventario_nfe_emissao IN LOCAL MODE
      ENTITY _Inventario
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_invt).


    READ ENTITIES OF zi_mm_inventario_nfe_emissao IN LOCAL MODE
      ENTITY _Inventario
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_result)
         FAILED failed.

    result = VALUE #( FOR ls_result IN lt_result ( %tky = ls_result-%tky ) ).

  ENDMETHOD.

  METHOD gerarContabil.

    READ ENTITIES OF zi_mm_inventario_nfe_emissao IN LOCAL MODE
    ENTITY _Inventario
       ALL FIELDS WITH CORRESPONDING #( keys )
       RESULT DATA(lt_invt).


    READ ENTITIES OF zi_mm_inventario_nfe_emissao IN LOCAL MODE
      ENTITY _Inventario
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_result)
         FAILED failed.

    result = VALUE #( FOR ls_result IN lt_result ( %tky = ls_result-%tky ) ).

  ENDMETHOD.

  METHOD estornarContabil.

    READ ENTITIES OF zi_mm_inventario_nfe_emissao IN LOCAL MODE
    ENTITY _Inventario
       ALL FIELDS WITH CORRESPONDING #( keys )
       RESULT DATA(lt_invt).


    READ ENTITIES OF zi_mm_inventario_nfe_emissao IN LOCAL MODE
      ENTITY _Inventario
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_result)
         FAILED failed.

    result = VALUE #( FOR ls_result IN lt_result ( %tky = ls_result-%tky ) ).

  ENDMETHOD.

ENDCLASS.
