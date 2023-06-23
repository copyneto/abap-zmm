*&---------------------------------------------------------------------*
*& Include ZMME_0032
*&---------------------------------------------------------------------*
    DATA(lo_dep_fech) = NEW zclmm_dep_fechado_grc( ).
    lo_dep_fech->mb_create_goods_movement_enha( it_mseg = xmseg[] ).
    lo_dep_fech->mb_create_goods_movement_venda( it_imseg = imseg[] ).
    lo_dep_fech->mb_create_goods_movement_trans( it_mseg = xmseg[] ).
