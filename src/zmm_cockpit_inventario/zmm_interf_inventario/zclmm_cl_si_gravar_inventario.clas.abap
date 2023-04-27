class ZCLMM_CL_SI_GRAVAR_INVENTARIO definition
  public
  create public .

public section.

  interfaces ZCLMM_II_SI_GRAVAR_INVENTARIO .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_CL_SI_GRAVAR_INVENTARIO IMPLEMENTATION.


  METHOD zclmm_ii_si_gravar_inventario~si_gravar_inventario_fisico_in.
    TRY.
        NEW zclmm_interface_inventario( )->processa_interface_inventario( is_input = input ).
      CATCH zclmm_cx_interf_inventario INTO DATA(lo_cx_erro).
        CALL METHOD cl_proxy_fault=>raise
          EXPORTING
            exception_class_name = 'ZCLMM_CX_FMT_INVENTARIO_FISICO'
            bapireturn_tab       = lo_cx_erro->get_bapireturn_tab( ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
