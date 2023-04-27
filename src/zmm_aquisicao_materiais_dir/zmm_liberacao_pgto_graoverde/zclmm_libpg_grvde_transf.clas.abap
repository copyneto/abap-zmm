class ZCLMM_LIBPG_GRVDE_TRANSF definition
  public
  inheriting from ZCLMM_LIBPG_GRVDE_OP
  final
  create public .

public section.

  methods SETUP_MESSAGES
    importing
      !P_TASK type CLIKE .

  methods ZIFMM_LIB_PGTO_GRAOVERDE~EXECUTAR
    redefinition .
  PROTECTED SECTION.

private section.

  constants GC_FUNCTION type FUNCT_PI value 'C' ##NO_TEXT.
  constants:
    BEGIN OF gc_koart,
                 k TYPE koart VALUE 'K',
                 p TYPE koart VALUE 'P',
               END OF gc_koart .
  constants:
    BEGIN OF gc_shkzg,
                 h TYPE shkzg VALUE 'H',
                 s TYPE shkzg VALUE 'S',
               END OF gc_shkzg .
  constants:
    BEGIN OF gc_bschl,
                 val40 TYPE bschl VALUE '40',
                 val50 TYPE bschl VALUE '50',
               END OF gc_bschl .
  constants:
    BEGIN OF gc_kind,
                 auglv    TYPE auglv VALUE 'AUGLV',    "    Purpose
                 ausgzahl TYPE auglv VALUE 'AUSGZAHL', "    Outgoing payment
                 eingzahl TYPE auglv VALUE 'EINGZAHL', "    Incoming payment
                 gutschri TYPE auglv VALUE 'GUTSCHRI', "    Credit memo
                 umbuchng TYPE auglv VALUE 'UMBUCHNG', "    Transfer posting with clearing
               END OF gc_kind .
  constants:
    BEGIN OF gc_blart,
                 modulo TYPE ze_param_modulo VALUE 'FI-AP',
                 chave1 TYPE ze_param_chave  VALUE 'COMPENSACAOGV',
                 chave2 TYPE ze_param_chave  VALUE 'TIPODOC',
               END OF gc_blart .
  constants:
    BEGIN OF gc_intf_clear,
                 tcode   TYPE syst_tcode VALUE 'FB05',
                 sgfunct TYPE sgfunct_pi VALUE 'C',
                 no_auth TYPE abap_bool  VALUE abap_true,
                 xsimu   TYPE char1      VALUE space,
               END OF gc_intf_clear .
  data GT_FTCLEAR type FEB_T_FTCLEAR .
  data GT_FTPOST type FEB_T_FTPOST .
  data GS_RETURN type BAPIRET2 .
  data GV_SUBRC type SY-SUBRC .

  methods SET_CLEAR .
  methods SET_POST .
ENDCLASS.



CLASS ZCLMM_LIBPG_GRVDE_TRANSF IMPLEMENTATION.


  METHOD zifmm_lib_pgto_graoverde~executar.

    DATA: lv_subrc TYPE syst_subrc,
          lt_blntab TYPE STANDARD TABLE OF blntab,
          lt_fttax  TYPE STANDARD TABLE OF fttax.

    me->get_parameter( EXPORTING iv_modulo = me->gc_blart-modulo
                                 iv_chave1 = me->gc_blart-chave1
                                 iv_chave2 = me->gc_blart-chave2
                       IMPORTING et_param  = me->gt_tipodoc_rng ).

    me->set_clear( ).
    me->set_post( ).

    CALL FUNCTION 'ZFMFI_POSTING_INTERFACE'
      STARTING NEW TASK 'FI_POSTING_INTERFACE'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        iv_function       = gc_function
        iv_auglv          = gc_kind-umbuchng
        iv_tcode          = gc_intf_clear-tcode
        iv_sgfunct        = gc_intf_clear-sgfunct
        iv_no_auth        = gc_intf_clear-no_auth
        iv_xsimu          = gc_intf_clear-xsimu
        it_blntab         = lt_blntab
        it_ftclear        = me->gt_ftclear
        it_ftpost         = me->gt_ftpost
        it_fttax          = lt_fttax
        iv_xref1          = me->gv_xref1
        iv_xref2          = me->gv_xref2.

    WAIT UNTIL gv_wait = abap_true.

    APPEND gs_return TO me->gt_return.

    IF NOT line_exists( me->gt_return[ type = 'E ' ] ).
      me->gt_return[] = VALUE #( BASE me->gt_return ( type = 'S' id = 'ZMM_LIB_PGTO_GV' number = '010' ) ).
    ELSE.
      me->gt_return[] = VALUE #( BASE me->gt_return ( type = 'E' id = 'ZMM_LIB_PGTO_GV' number = '011' ) ).
    ENDIF.

    super->zifmm_lib_pgto_graoverde~executar( ).

  ENDMETHOD.


  METHOD set_clear.


    me->gt_ftclear = VALUE #( BASE me->gt_ftclear FOR ls_properties IN me->gt_properties ( agkoa = me->gc_koart-k
                                                                                           agkon = ls_properties-fornecedor
                                                                                           agbuk = ls_properties-empresa
                                                                                           xnops = abap_true
                                                                                           agums = 'ABCDE'
                                                                                           "selfd = ls_properties-numdocumento
                                                                                           selfd = 'BELNR'
                                                                                          selvon = |{ ls_properties-numdocumento }{ ls_properties-ano }{ ls_properties-item }| ) ).

  ENDMETHOD.


  METHOD set_post.

    READ TABLE me->gt_properties ASSIGNING FIELD-SYMBOL(<fs_property>) WITH KEY tipodocumento = 'RE'.
    DATA: lv_total TYPE dmbtr,
          lv_total_conv TYPE dmbtr,
          lv_c_total TYPE char50.

    SELECT SINGLE VlTotal
    FROM ZI_MM_LIB_PGTO_TOT
    WHERE numdocumento = @<fs_property>-numdocumentoref
    INTO @lv_total.
    "INTO @DATA(lv_total).

    SELECT SINGLE SGTXT FROM bseg
    WHERE bukrs = @<fs_property>-empresa
    AND belnr = @<fs_property>-numdocumento
    AND gjahr = @<fs_property>-ano
    AND buzei = @<fs_property>-item
    INTO @DATA(lv_sgtxt).

    me->gv_xref1 = 'RESIDUAL-LIB-GV'.
    me->gv_xref2 = <fs_property>-numdocumentoref.

    lv_total_conv = ABS( lv_total ).

    lv_c_total = lv_total_conv.
    TRANSLATE lv_c_total USING '.,'.
    CONDENSE lv_c_total.


    DATA(lv_data) = sy-datum+6(2) && sy-datum+4(2) && sy-datum+0(4).

    me->gt_ftpost = VALUE #( ( stype = me->gc_koart-k count = 1 fnam = 'BKPF-BLDAT'    fval = lv_data )
                             ( stype = me->gc_koart-k count = 1 fnam = 'BKPF-BUDAT'    fval = lv_data )
                             ( stype = me->gc_koart-k count = 1 fnam = 'BKPF-BLART'    fval = me->gt_tipodoc_rng[ 1 ]-low )
                             ( stype = me->gc_koart-k count = 1 fnam = 'BKPF-BUKRS'    fval = <fs_property>-Empresa )
                             ( stype = me->gc_koart-k count = 1 fnam = 'BKPF-WAERS'    fval = me->gc_waers )
                             ( stype = me->gc_koart-k count = 1 fnam = 'BKPF-XBLNR'    fval = <fs_property>-docreferencia )
                             ( stype = me->gc_koart-k count = 1 fnam = 'BKPF-BKTXT'    fval = <fs_property>-textocab )
                             "( stype = me->gc_koart-k count = 1 fnam = 'BKPF-XREF1_HD' fval = 'RESIDUAL-LIB-GV' )
                             "( stype = me->gc_koart-k count = 1 fnam = 'BKPF-XREF2_HD' fval = <fs_property>-numdocumentoref )
                             ( stype = me->gc_koart-p count = 1 fnam = 'RF05A-NEWBS'   fval = COND #( WHEN lv_total < 0 THEN '31 ' ELSE '21' ) )
                             ( stype = me->gc_koart-p count = 1 fnam = 'BSEG-HKONT'    fval = <fs_property>-fornecedor )
                             ( stype = me->gc_koart-p count = 1 fnam = 'BSEG-WRBTR'    fval = lv_c_total  )
                             ( stype = me->gc_koart-p count = 1 fnam = 'BSEG-BUPLA'    fval = <fs_property>-localnegocio )
                             ( stype = me->gc_koart-p count = 1 fnam = 'BSEG-ZTERM'    fval = '' )
                             ( stype = me->gc_koart-p count = 1 fnam = 'BSEG-ZBD1T'    fval = '' )
                             ( stype = me->gc_koart-p count = 1 fnam = 'BSEG-ZLSPR'    fval = '' )
                             ( stype = me->gc_koart-p count = 1 fnam = 'BSEG-SGTXT'    fval = lv_sgtxt )
                             ( stype = me->gc_koart-p count = 1 fnam = 'BSEG-ZUONR'    fval = <fs_property>-atribuicao )
                             ( stype = me->gc_koart-p count = 1 fnam = 'BSEG-ZFBDT'    fval = <fs_property>-dtvencimentoliquido+6(2) && <fs_property>-dtvencimentoliquido+4(2) && <fs_property>-dtvencimentoliquido+0(4) )
                             ( stype = me->gc_koart-p count = 1 fnam = 'BSEG-ZLSCH'    fval = <fs_property>-Formapagamento )
                             ( stype = me->gc_koart-p count = 1 fnam = 'BSEG-HBKID'    fval = <fs_property>-bancoempresa ) ).



  ENDMETHOD.


  method SETUP_MESSAGES.
    CASE p_task.
      WHEN 'FI_POSTING_INTERFACE'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMFI_POSTING_INTERFACE'
         IMPORTING
           ev_subrc  = gv_subrc
           es_return = gs_return.

        gv_wait = abap_true.

      WHEN OTHERS.
    ENDCASE.
  endmethod.
ENDCLASS.
