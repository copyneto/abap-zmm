*&---------------------------------------------------------------------*
*& Report ZZRB_VBFA_NO_GI_DOC_5
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zzrb_vbfa_no_gi_doc_5 .

* This report deletes document flow entries for GI in delivery where
* no material document exsists on database. Afterwards, you have to run
* the report ZZDELSTA or RVDELSTA to correct the delivery status.

DATA:    BEGIN OF xvbfa OCCURS 0.
           INCLUDE STRUCTURE vbfavb.
DATA:    END OF xvbfa.
DATA:    xvbfa2 LIKE vbfavb.
DATA: update(1) TYPE c,
      lf_help1  LIKE sy-datum,
      lf_help2  LIKE sy-datum..

TABLES: mkpf,  lips, vbfa, vekp.

PARAMETERS: delivery LIKE lips-vbeln OBLIGATORY,  "delivery no.
            matdoc   LIKE mkpf-mblnr OBLIGATORY,    "material document no.
            matyear  LIKE mkpf-mjahr OBLIGATORY DEFAULT '2007',
            test     TYPE xfeld DEFAULT 'X'.         "Test or Update

CLEAR update.


lf_help1(4) = lf_help2(4) = matyear.
lf_help1+4  = '0101'.
lf_help2+4  = '1231'.

SELECT * INTO CORRESPONDING FIELDS OF TABLE xvbfa FROM vbfa
                                      WHERE vbeln   =  matdoc
                                      AND   vbtyp_n =  'R'
                                      AND   erdat   >= lf_help1
                                      AND   erdat   <= lf_help2.
IF NOT sy-subrc IS INITIAL.
  FORMAT COLOR COL_NEGATIVE.
  WRITE:/ 'No document flow items could be found!'.
  FORMAT RESET.
ELSE.
  SELECT SINGLE * FROM mkpf WHERE mblnr = matdoc
                                      AND   mjahr = matyear.
  IF sy-subrc IS INITIAL.
    FORMAT COLOR COL_NEGATIVE.
    WRITE:/ 'Material document exsists on database!'.
    FORMAT RESET.
  ELSE.
    LOOP AT xvbfa WHERE stufe    = '00'
                  AND   erdat(4) = matyear.
      IF NOT xvbfa-vbelv EQ delivery.
        WRITE:/ 'Please input correct delivery!'.
        EXIT.
      ENDIF.
      IF NOT test IS INITIAL.
        FORMAT RESET.
        FORMAT COLOR COL_POSITIVE.
        WRITE:/ 'Document flow item:',
                 xvbfa-vbelv,
                 xvbfa-posnv,
                 xvbfa-vbeln,
                 xvbfa-posnn,
                 xvbfa-vbtyp_n,
                'would be deleted!'.
        FORMAT RESET.
        IF update IS INITIAL.
          MOVE 'X' TO update.
        ENDIF.
      ELSE.  "Update database
        DELETE FROM vbfa WHERE vbelv   = xvbfa-vbelv
                         AND   posnv   = xvbfa-posnv
                         AND   vbeln   = xvbfa-vbeln
                         AND   posnn   = xvbfa-posnn
                         AND   vbtyp_n = xvbfa-vbtyp_n.
        IF update IS INITIAL AND sy-subrc IS INITIAL.
          MOVE 'X' TO update.
        ENDIF.
      ENDIF.
    ENDLOOP.
    IF NOT update IS INITIAL.
      LOOP AT xvbfa WHERE stufe    = '01'
                    AND   erdat(4) = matyear.
        IF NOT test IS INITIAL.
          FORMAT COLOR COL_POSITIVE.
          WRITE:/ 'Document flow item:',
                   xvbfa-vbelv,
                   xvbfa-posnv,
                   xvbfa-vbeln,
                   xvbfa-posnn,
                   xvbfa-vbtyp_n,
                  'would be deleted!'.
          FORMAT RESET.
        ELSE.  "Update database
          DELETE FROM vbfa WHERE vbelv   = xvbfa-vbelv
                           AND   posnv   = xvbfa-posnv
                           AND   vbeln   = xvbfa-vbeln
                           AND   posnn   = xvbfa-posnn
                           AND   vbtyp_n = xvbfa-vbtyp_n.
          IF update IS INITIAL AND sy-subrc IS INITIAL.
            MOVE 'X' TO update.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDIF.
