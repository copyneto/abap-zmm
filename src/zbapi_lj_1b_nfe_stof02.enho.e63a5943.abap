"Name: \PR:SAPLJ_1B_NFE_STO\FO:FILL_GOODS_MOVEMENT\SE:END\EI
ENHANCEMENT 0 ZBAPI_LJ_1B_NFE_STOF02.
types: BEGIN OF ty_lips,
          VBELN type  VBELN_VL,
          POSNR TYPE  pOSNR_VL,
      end OF ty_lips.

 data lt_DELIVITEM type TABLE of ty_lips.


  LOOP AT pt_imseg ASSIGNING FIELD-SYMBOL(<fs_imseg>).
    CHECK <fs_imseg>-bwtar is INITIAL.
    append VALUE #( VBELN = <fs_imseg>-vbeln POSNR = <fs_imseg>-posnr ) to lt_DELIVITEM.
  ENDLOOP.

  sort lt_DELIVITEM. delete ADJACENT DUPLICATES FROM lt_DELIVITEM.

  if lt_DELIVITEM is not INITIAL.
    select VBELN, POSNR, bwtar
      from LIPS
      FOR ALL ENTRIES IN @lt_delivitem
      where vbeln = @lt_delivitem-vbeln
        and posnr = @lt_delivitem-posnr
      into TABLE @data(lt_LIPS).

      sort lt_LIPS by vbeln bwtar.
  endif.

  LOOP AT pt_imseg ASSIGNING <fs_imseg>.
    CHECK <fs_imseg>-bwtar is INITIAL.
    read TABLE lt_LIPS ASSIGNING FIELD-SYMBOL(<fs_LIPS>) WITH key vbeln = <fs_imseg>-vbeln posnr = <fs_imseg>-posnr.
    if <fs_LIPS> is ASSIGNED.
      <fs_imseg>-bwtar = <fs_LIPS>-bwtar.
      UNASSIGN <fs_LIPS>.
    endif.
  ENDLOOP.

ENDENHANCEMENT.
