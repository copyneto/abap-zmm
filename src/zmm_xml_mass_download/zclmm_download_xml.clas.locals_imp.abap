*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_download IMPLEMENTATION.

  METHOD constructor.

    me->gt_emissor_tax   = it_emi_tax.
    me->gt_emissor_regio = it_emi_reg.
    me->gt_recebe_tax    = it_rec_tax.
    me->gt_recebe_regio  = it_rec_reg.
    me->gt_pstdat        = it_pstdat.
    me->gt_docdat        = it_docdat.
    me->gt_bukrs         = it_bukrs.
    me->gt_branch        = it_branch.
    me->gt_nfenum        = it_nfenum.
    me->gt_docnum        = it_docnum.

  ENDMETHOD.

  METHOD get_data.

*    DATA ls_address TYPE sadr.
*    DATA ls_company TYPE t001.

    CONSTANTS: lc_nftype TYPE j_1bnftype VALUE 'YH'.

    SELECT j~docnum, j~nfenum, j~pstdat, j~docdat, j~bukrs, j~branch,
           xhd~cnpj_emit AS emissor_nfis, xhd~c_xnome AS emissor, xhd~uf_emit AS emissor_uf,
           xhd~cnpj_dest AS recebe_nfis, xhd~c_xnome AS recebedor, xhd~uf_dest AS recebe_uf
      FROM j_1bnfdoc AS j
      INNER JOIN /xnfe/innfehd AS xhd
         ON j~nfenum = xhd~nnf
    WHERE j~docnum IN @me->gt_docnum
       AND j~nfenum IN @me->gt_nfenum
       AND j~pstdat IN @me->gt_pstdat
       AND j~docdat IN @me->gt_docdat
       AND j~bukrs  IN @me->gt_bukrs
       AND j~branch IN @me->gt_branch
       AND direct EQ @me->gc_direct
       AND xhd~cnpj_emit IN @me->gt_emissor_tax
       AND xhd~uf_emit IN @me->gt_emissor_regio
       AND xhd~cnpj_dest IN @me->gt_recebe_tax
       AND xhd~uf_dest IN @me->gt_recebe_regio
       AND j~cancel EQ @abap_false
       AND j~nftype NE @lc_nftype
     ORDER BY (iv_sort)
      INTO CORRESPONDING FIELDS OF TABLE @rt_result.

    SORT rt_result BY bukrs ASCENDING.

    DATA(lt_bukrs) = VALUE fte_t_bukrs( FOR ls_result IN rt_result ( ls_result-bukrs ) ).
    DELETE ADJACENT DUPLICATES FROM lt_bukrs.

    LOOP AT lt_bukrs ASSIGNING FIELD-SYMBOL(<fs_bukrs>).
      IF NOT zclmm_auth_zmmbukrs=>check_custom( EXPORTING iv_bukrs = <fs_bukrs> iv_actvt = '03' ).
        DELETE rt_result WHERE bukrs EQ <fs_bukrs>.
      ENDIF.
    ENDLOOP.

*    IF sy-subrc EQ 0.
*
*      LOOP AT rt_result ASSIGNING FIELD-SYMBOL(<fs_result>). "#EC CI_SEL_NESTED
*
*        CALL FUNCTION 'J_1BREAD_BRANCH_DATA'
*          EXPORTING
*            branch            = <fs_result>-branch
*            bukrs             = <fs_result>-bukrs
*          IMPORTING
*            address           = ls_address
**           branch_data       =
**           cgc_number        =
**           address1          =
*          EXCEPTIONS
*            branch_not_found  = 1
*            address_not_found = 2
*            company_not_found = 3
*            OTHERS            = 4.
*        IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**   WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*        ELSE.
*          <fs_result>-recebedor = |{ ls_address-anred } { ls_address-name1 }|.
*          <fs_result>-recebe_uf = |{ ls_address-regio }|.
*        ENDIF.
*
*        CALL FUNCTION 'COMPANY_CODE_READ'
*          EXPORTING
*            i_bukrs           = <fs_result>-bukrs
*          IMPORTING
*            e_t001            = ls_company
*          EXCEPTIONS
*            country_not_found = 1
*            no_such_code      = 2
*            space_input       = 3
*            wrong_kkber       = 4
*            OTHERS            = 5.
*        IF sy-subrc <> 0.
**         MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**           WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*        ELSE.
*          <fs_result>-butxt = ls_company-butxt.
*        ENDIF.
*
*      ENDLOOP.
*
*    ENDIF.

*    IF lines( me->gt_recebe_tax ) GT 0.
*      DELETE rt_result WHERE recebe_nfis NOT IN me->gt_recebe_tax.
*    ENDIF.
*
*    IF lines( me->gt_recebe_regio ) GT 0.
*      DELETE rt_result WHERE recebe_nfis NOT IN me->gt_recebe_regio.
*    ENDIF.


  ENDMETHOD.

ENDCLASS.
