CLASS zcl_mm_nf_ultimo_event DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.
    CLASS-METHODS:
      get_event FOR TABLE FUNCTION ZTB_MM_3C_NF_ULTIMO_EVENT.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_mm_nf_ultimo_event IMPLEMENTATION.

  METHOD get_event
    BY DATABASE FUNCTION
    FOR HDB LANGUAGE SQLSCRIPT
    OPTIONS READ-ONLY
    USING ZV_NF_EVENTS.

        rank_table =
            select
                event.mandt,
                event.guid,
                event.chnfe,
                event.tpevento,
                RANK() OVER (PARTITION BY event.guid ORDER BY event.dhevento DESC) AS rank
            from
                ZV_NF_EVENTS as event;

        return
        select
               mandt,
               guid,
               chnfe,
               tpevento,
               rank
        from :rank_table
        where rank = 1;

     ENDMETHOD.

ENDCLASS.
