*&---------------------------------------------------------------------*
*& Include          ZMMI_DEPOSITO_FECHADO
*&---------------------------------------------------------------------*

DATA(lo_cockpit_transf) = NEW zclmm_cockpit_transf( ).
lo_cockpit_transf->deposito_fechado_xml( it_doc = it_doc
                                         it_lin = it_lin ).
