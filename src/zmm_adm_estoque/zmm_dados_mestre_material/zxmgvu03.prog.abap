*&---------------------------------------------------------------------*
*& Include          ZXMGVU03
*&---------------------------------------------------------------------*

TYPES: BEGIN OF ty_palet,
         werks   TYPE string,
         meinh   TYPE string,
         zlastro TYPE string,
         zaltura TYPE string,
       END OF ty_palet,

       BEGIN OF ty_maram,
         msgfn TYPE msgfn,
         matnr TYPE matnr18,
         ersda TYPE ersda,
         ernam TYPE ernam,
         laeda TYPE laeda,
         aenam TYPE aenam,
         pstat TYPE pstat_d,
         lvorm TYPE lvoma,
         mtart TYPE mtart,
         mbrsh TYPE mbrsh,
         matkl TYPE matkl,
         bismt TYPE bismt18,
         meins TYPE meins,
       END OF ty_maram.

DATA: ls_palet     TYPE ty_palet,
      lv_menor_um  TYPE meins,
      ls_maram     TYPE ty_maram,
      lv_qtd       TYPE bstmg,
      lv_sdata     TYPE edi_sdata,
      lv_nvezes    TYPE i,
      lv_meinh     TYPE string,
      lv_mseht     TYPE string,
      lv_numtp     TYPE string,
      lv_menge     TYPE string,
      lv_memory_id TYPE indx_srtfd,
      lv_werks     TYPE werks_d,
      lv_tcode     TYPE syst_tcode.

CONSTANTS: lc_marc  TYPE edilsegtyp VALUE 'E1MARCM',
           lc_maram TYPE edilsegtyp VALUE 'E1MARAM',
           lc_marm  TYPE edilsegtyp VALUE 'E1MARMM',
           lc_mbew  TYPE edilsegtyp VALUE 'E1MBEWM',
           lc_mm01  TYPE edilsegtyp VALUE 'MM01',
           lc_mm02  TYPE edilsegtyp VALUE 'MM02'.

TRY.

    INCLUDE zmmi_tributacao IF FOUND.
    INCLUDE zmmi_paletizacao IF FOUND.

    IF segment_name = lc_mbew.

      lv_memory_id = |{ f_mbew-matnr }{ sy-uname(4) }|.
      IMPORT lv_werks TO lv_werks FROM DATABASE indx(zp) ID lv_memory_id.
      " Export no método ZCLMM_ATUAL_MAT_PALETIZACAO~ATUALIZA_MAT

      IF sy-subrc IS INITIAL.
        DATA(lo_object) = NEW cl_abap_expimp_db( ).

        TRY.
            lo_object->delete( EXPORTING tabname          = 'INDX'
                                         client           = sy-mandt
                                         area             = 'ZP'
                                         id               = lv_memory_id
                                         client_specified = abap_true ).

          CATCH cx_sy_client.        " EXPORT/IMPORT: Wrong CLIENT Specification
          CATCH cx_sy_generic_key.   " EXPORT/IMPORT: Incorrect Use of GENERIC
          CATCH cx_sy_incorrect_key. " EXPORT/IMPORT: The Given Key Is not Properly Formed
        ENDTRY.
      ENDIF.
    ENDIF.

  CATCH cx_root.
ENDTRY.

INCLUDE zmmi_envio_e1mara1 IF FOUND.
