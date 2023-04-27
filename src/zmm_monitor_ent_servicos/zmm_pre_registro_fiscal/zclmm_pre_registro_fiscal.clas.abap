"!<p><h2>Pré-registro fiscal</h2></p>
"!<p><strong>Autor:</strong> Anderson Miazato</p>
"!<p><strong>Data:</strong> 12 de abril de 2022</p>
CLASS zclmm_pre_registro_fiscal DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      "! Campos chave da NF
      BEGIN OF ty_chave_nf,
        empresa TYPE ztmm_monit_cabec-empresa,
        filial  TYPE ztmm_monit_cabec-filial,
        lifnr   TYPE ztmm_monit_cabec-lifnr,
        nr_nf   TYPE ztmm_monit_cabec-nr_nf,
      END OF ty_chave_nf .
    TYPES:
          "! Range de empresas
      ty_r_empresa TYPE RANGE OF ztmm_monit_cabec-empresa .
    TYPES:
          "! Range de filiais
      ty_r_filial  TYPE RANGE OF  ztmm_monit_cabec-filial .
    TYPES:
          "! Range de fornecedores
      ty_r_lifnr   TYPE RANGE OF   ztmm_monit_cabec-lifnr .
    TYPES:
          "! Range de números de NF
      ty_r_nr_nf   TYPE RANGE OF   ztmm_monit_cabec-nr_nf .
    TYPES ty_cad_fisc TYPE zi_mm_cadastro_fiscal_cabec .

    "! Inicializa instância
    "! @parameter it_bukrs  | Empresa
    "! @parameter it_filial | Filial
    "! @parameter it_lifnr  | Fornecedor
    "! @parameter it_numnf  | Número NF
    METHODS constructor
      IMPORTING
        !it_bukrs  TYPE ty_r_empresa OPTIONAL
        !it_filial TYPE ty_r_filial OPTIONAL
        !it_lifnr  TYPE ty_r_lifnr OPTIONAL
        !it_numnf  TYPE ty_r_nr_nf OPTIONAL .
    "! Libera NF
    "! @parameter et_return   | Mensagens de retorno
    METHODS liberar_nf
      IMPORTING
        !is_cad_fiscal TYPE ty_cad_fisc
      EXPORTING
        !et_return     TYPE bapiret2_tab .
    "! Simula Cadastro Fiscal
    METHODS simular_cadastro
      EXPORTING
        !et_return TYPE bapiret2_tab .
    METHODS valida_dados
      IMPORTING
        !is_cad_fiscal TYPE ty_cad_fisc
      EXPORTING
        !et_return     TYPE bapiret2_tab .
  PROTECTED SECTION.
  PRIVATE SECTION.

    "! Range de empresas
    DATA gt_range_bukrs TYPE ty_r_empresa .
    "! Range de filiais
    DATA gt_range_filial TYPE ty_r_filial .
    "! Range de fornecedores
    DATA gt_range_lifnr TYPE ty_r_lifnr .
    "! Range de NF
    DATA gt_range_numnf TYPE ty_r_nr_nf .
    "! Tabela de mensagens
    DATA gt_return TYPE bapiret2_tab .
    "! Campos chave da NF
    DATA gs_chave_nf TYPE ty_chave_nf .
    CONSTANTS gc_msg_id TYPE syst-msgid VALUE 'ZMM_MONITOR_ENT_SERV' ##NO_TEXT.
    CONSTANTS gc_sucess TYPE syst-msgty VALUE 'S' ##NO_TEXT.
    CONSTANTS gc_error TYPE syst-msgty VALUE 'E' ##NO_TEXT.
    CONSTANTS gc_msg_009 TYPE syst-msgno VALUE '009' ##NO_TEXT.
    CONSTANTS gc_msg_010 TYPE syst-msgno VALUE '010' ##NO_TEXT.
    CONSTANTS gc_msg_011 TYPE syst-msgno VALUE '011' ##NO_TEXT.
    CONSTANTS gc_msg_012 TYPE syst-msgno VALUE '012' ##NO_TEXT.
    CONSTANTS gc_msg_013 TYPE syst-msgno VALUE '013' ##NO_TEXT.
    CONSTANTS gc_msg_014 TYPE syst-msgno VALUE '014' ##NO_TEXT.
    CONSTANTS gc_msg_015 TYPE syst-msgno VALUE '015' ##NO_TEXT.
    CONSTANTS gc_msg_016 TYPE syst-msgno VALUE '016' ##NO_TEXT.
    CONSTANTS gc_msg_017 TYPE syst-msgno VALUE '017' ##NO_TEXT.
    CONSTANTS gc_msg_018 TYPE syst-msgno VALUE '018' ##NO_TEXT.
    CONSTANTS gc_msg_019 TYPE syst-msgno VALUE '019' ##NO_TEXT.
    CONSTANTS gc_msg_020 TYPE syst-msgno VALUE '020' ##NO_TEXT.
    CONSTANTS gc_msg_021 TYPE syst-msgno VALUE '021' ##NO_TEXT.
    CONSTANTS gc_msg_022 TYPE syst-msgno VALUE '022' ##NO_TEXT.
    CONSTANTS gc_msg_023 TYPE syst-msgno VALUE '023' ##NO_TEXT.
ENDCLASS.



CLASS zclmm_pre_registro_fiscal IMPLEMENTATION.


  METHOD liberar_nf.

    me->valida_dados( EXPORTING is_cad_fiscal = is_cad_fiscal
                      IMPORTING et_return     = DATA(lt_return) ).

    IF lt_return IS NOT INITIAL.
      et_return = lt_return.
    ELSE.

      SELECT SINGLE *
        FROM ztmm_monit_cabec
       WHERE empresa = @is_cad_fiscal-empresa
         AND filial  = @is_cad_fiscal-filial
         AND lifnr   = @is_cad_fiscal-lifnr
         AND nr_nf   = @is_cad_fiscal-nrnf
        INTO @DATA(ls_cabec).

      IF sy-subrc IS INITIAL.
        ls_cabec-liberado = abap_true.
        MODIFY ztmm_monit_cabec FROM ls_cabec.

        et_return = VALUE #( BASE et_return ( id     = gc_msg_id
                                              type   = gc_sucess
                                              number = gc_msg_023 ) ).

      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD simular_cadastro.

    IF me->gt_return IS NOT INITIAL.
      et_return = me->gt_Return.
    ENDIF.

    RETURN.

  ENDMETHOD.


  METHOD constructor.

    me->gt_range_bukrs = it_bukrs.

    me->gt_range_filial = it_filial.

    me->gt_range_lifnr = it_lifnr.

    me->gt_range_numnf = it_numnf.

  ENDMETHOD.


  METHOD valida_dados.

    DATA: lv_total_sum  TYPE bseg-dmbtr,
          lv_cgc_number TYPE j_1bwfield-cgc_number,
          lv_branch     TYPE j_1bbranch-branch.
*
*    CHECK is_cad_fiscal IS NOT INITIAL.
*
*    SELECT ebeln,
*           ebelp,
*           netwr
*      FROM ekpo
*     WHERE ebeln = @is_cad_fiscal-pedido
*      INTO TABLE @DATA(lt_ekpo).
*
*    IF sy-subrc IS INITIAL.
*      SORT lt_ekpo BY ebeln.
*
*      LOOP AT lt_ekpo ASSIGNING FIELD-SYMBOL(<fs_ekpo>).
*        lv_netwr = lv_netwr + <fs_ekpo>-netwr.
*      ENDLOOP.
*
*      IF is_cad_fiscal-vltotnf NE lv_netwr.
*        et_return = VALUE #( BASE et_return ( id     = gc_msg_id
*                                              type   = gc_error
*                                              number = gc_msg_009 ) ).
*        et_return = VALUE #( BASE et_return ( id     = gc_msg_id
*                                              type   = gc_error
*                                              number = gc_msg_010 ) ).
*        et_return = VALUE #( BASE et_return ( id     = gc_msg_id
*                                              type   = gc_error
*                                              number = gc_msg_011 ) ).
*      ENDIF.
*    ENDIF.

*    BREAK-POINT.
    NEW zclmm_lanc_servicos( )->simular_contabilizacao(
      EXPORTING
        is_key    = VALUE #(
            empresa = is_cad_fiscal-Empresa
            filial  = is_cad_fiscal-Filial
            lifnr   = is_cad_fiscal-Lifnr
            nrnf    = is_cad_fiscal-NrNf
        )
      IMPORTING
        et_accounting = DATA(lt_accounting)
        et_return     = DATA(lt_return)
    ).

    IF NOT line_exists( lt_return[ type = gc_error ] )."#EC CI_STDSEQ
      LOOP AT lt_accounting INTO DATA(ls_accounting) WHERE shkzg = 'S' AND bschl <> '83'."#EC CI_STDSEQ
        lv_total_sum = lv_total_sum + ls_accounting-dmbtr.
      ENDLOOP.

      IF ( is_cad_fiscal-vltotnf - is_cad_fiscal-VlTotImpostos ) NE lv_total_sum.
        et_return = VALUE #( BASE et_return ( id     = gc_msg_id
                                              type   = gc_error
                                              number = gc_msg_009 ) ).
        et_return = VALUE #( BASE et_return ( id     = gc_msg_id
                                              type   = gc_error
                                              number = gc_msg_010 ) ).
        et_return = VALUE #( BASE et_return ( id     = gc_msg_id
                                              type   = gc_error
                                              number = gc_msg_011 ) ).
      ENDIF.
    ELSE.
      APPEND LINES OF lt_return TO et_return.
    ENDIF.

    SELECT SINGLE ebeln,
                  frggr,
                  frgke,
                  lifnr
      FROM ekko
     WHERE ebeln = @is_cad_fiscal-pedido
      INTO @DATA(ls_ekko).

    IF sy-subrc IS INITIAL.
      IF ls_ekko-frgke EQ 'B'. " Bloqueado, modificável c/valor
        et_return = VALUE #( BASE et_return ( id     = gc_msg_id
                                              type   = gc_error
                                              number = gc_msg_012 ) ).
        et_return = VALUE #( BASE et_return ( id     = gc_msg_id
                                              type   = gc_error
                                              number = gc_msg_013 ) ).
      ENDIF.
    ENDIF.
*
*    SELECT ebeln,
*           ebelp,
*           webre,
*           txjcd,
*           j_1bnbm
*      FROM ekpo
*     WHERE ebeln = @is_cad_fiscal-pedido
*      INTO @DATA(ls_ekpo)
*        UP TO 1 ROWS.
*    ENDSELECT.
*    IF sy-subrc IS INITIAL.
*
*      IF ls_ekpo-webre       IS NOT INITIAL
*     AND is_cad_fiscal-lblni IS INITIAL.
*        et_return = VALUE #( BASE et_return ( id     = gc_msg_id
*                                              type   = gc_error
*                                              number = gc_msg_014 ) ).
*      ENDIF.

*      " Validar o Dom. FIscal do  Pedido X Dom. Fiscal do Monitor de Serviço
*      IF ls_ekpo-txjcd NE .
*        et_return = VALUE #( BASE et_return ( id     = gc_msg_id
*                                              type   = gc_error
*                                              number = gc_msg_020 ) ).
*        et_return = VALUE #( BASE et_return ( id     = gc_msg_id
*                                              type   = gc_error
*                                              number = gc_msg_021 ) ).
*        et_return = VALUE #( BASE et_return ( id     = gc_msg_id
*                                              type   = gc_error
*                                              number = gc_msg_022 ) ).
*      ENDIF.

*    ENDIF.

*    SELECT COUNT(*)
*      FROM ztmm_anexo_nf
*     WHERE nr_nf    = @is_cad_fiscal-nrnf
*       AND cnpj_cpf = @is_cad_fiscal-cnpjcpf.
*
*    IF sy-subrc IS INITIAL.
*      et_return = VALUE #( BASE et_return ( id     = gc_msg_id
*                                            type   = gc_error
*                                            number = gc_msg_015 ) ).
*    ENDIF.

    SELECT lifnr,
           stcd1
      FROM lfa1
     WHERE lifnr = @ls_ekko-lifnr
      INTO @DATA(ls_lfa1)
        UP TO 1 ROWS.
    ENDSELECT.

    IF sy-subrc IS INITIAL.
      IF ls_lfa1-stcd1 NE is_cad_fiscal-cnpjcpf.
        et_return = VALUE #( BASE et_return ( id     = gc_msg_id
                                              type   = gc_error
                                              number = gc_msg_016 ) ).
*        et_return = VALUE #( BASE et_return ( id     = gc_msg_id
*                                              type   = gc_error
*                                              number = gc_msg_017 ) ).
      ENDIF.
    ENDIF.
*
*    lv_branch = is_cad_fiscal-cnpjcpf.
*
*    CALL FUNCTION 'J_1BREAD_BRANCH_DATA'
*      EXPORTING
*        branch            = lv_branch
*        bukrs             = is_cad_fiscal-empresa
*      IMPORTING
*        cgc_number        = lv_cgc_number
*      EXCEPTIONS
*        branch_not_found  = 1
*        address_not_found = 2
*        company_not_found = 3
*        OTHERS            = 4.
*
*    IF sy-subrc IS INITIAL.
*      et_return = VALUE #( BASE et_return ( id     = gc_msg_id
*                                            type   = gc_error
*                                            number = gc_msg_018 ) ).
*      et_return = VALUE #( BASE et_return ( id     = gc_msg_id
*                                            type   = gc_error
*                                            number = gc_msg_019 ) ).
*    ENDIF.

  ENDMETHOD.
ENDCLASS.
