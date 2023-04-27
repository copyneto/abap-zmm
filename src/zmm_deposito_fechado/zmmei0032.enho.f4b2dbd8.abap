"Name: \FU:MB_CREATE_GOODS_MOVEMENT\SE:END\EN:ZMMEI0031\SE:END\EI
ENHANCEMENT 0 ZMMEI0032.

    data(lo_dep_fech) = new zclmm_dep_fechado_grc( ).
    lo_dep_fech->mb_create_goods_movement_enha( it_mseg = xmseg[] ).
    lo_dep_fech->mb_create_goods_movement_venda( it_imseg = imseg[] ).
    lo_dep_fech->mb_create_goods_movement_trans( it_mseg = xmseg[] ).


ENDENHANCEMENT.
