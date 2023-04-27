*&---------------------------------------------------------------------*
*& Include          ZMMI_ADD_TEXT_DEPOSITO_FECHADO
*&---------------------------------------------------------------------*

*DATA(lo_cockpit_transf) = NEW zclmm_cockpit_transf( ).
*lo_cockpit_transf->xml_text_deposito_fechado( EXPORTING is_header  = is_header
*                                                        it_nflin   = it_nflin
*                                                        it_partner = it_partner
*                                              CHANGING  cv_infcpl  = cs_header-infcpl ).

*lo_cockpit_transf->deposito_fechado( EXPORTING is_header  = is_header
*                                               it_nflin   = it_nflin
*                                               it_partner = it_partner
*                                      CHANGING cs_doc     = cs_header
*                                               ct_lin     = ct_itens_adicional ).
