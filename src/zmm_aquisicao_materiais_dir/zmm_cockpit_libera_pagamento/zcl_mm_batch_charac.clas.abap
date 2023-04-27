CLASS zcl_mm_batch_charac DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .

    CLASS-METHODS:
      get_gv_charac FOR TABLE FUNCTION ztb_mm_batch_characteristc.

  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_mm_batch_charac IMPLEMENTATION.

  METHOD get_gv_charac BY DATABASE FUNCTION FOR HDB
                           LANGUAGE SQLSCRIPT
                           OPTIONS READ-ONLY USING ausp cabn mch1.

    RETURN
        SELECT
      DISTINCT session_context( 'CLIENT' ) as mandt,
               m.cuobj_bm as objek, c.atnam as Characteristic,
               sum( CAST ( CASE when a.atwrt = '' then '0' ELSE a.atwrt end as dec ) ) as CharacteristicValue
          from ausp as a
         inner join cabn as c
            on a.atinn = c.atinn
         inner join mch1 as m
            on a.objek = m.cuobj_bm
         where c.atnam = 'YGV_QTD_KG'
         GROUP BY m.cuobj_bm, c.atnam union
         select
      distinct session_context( 'CLIENT' ) as mandt,
               m.cuobj_bm as objek, c.atnam as Characteristic,
               sum( CAST ( CASE when a.atwrt = '' then '0' ELSE a.atwrt end as dec ) ) as CharacteristicValue
          from ausp as a
         inner join cabn as c
            on a.atinn = c.atinn
         inner join mch1 as m
            on a.objek = m.cuobj_bm
         where c.atnam = 'YGV_QTD_SACAS'
         GROUP BY m.cuobj_bm, c.atnam union
         select
      distinct session_context( 'CLIENT' ) as mandt,
               m.cuobj_bm as objek, c.atnam as Characteristic,
               sum( CAST ( CASE when a.atwrt = '' then '0' ELSE a.atwrt end as dec ) ) as CharacteristicValue
          from ausp as a
         inner join cabn as c
            on a.atinn = c.atinn
         inner join mch1 as m
            on a.objek = m.cuobj_bm
         where c.atnam = 'YGV_QTD_BAG'
         GROUP BY m.cuobj_bm, c.atnam union
         select
      distinct session_context( 'CLIENT' ) as mandt,
               m.cuobj_bm as objek, c.atnam as Characteristic,
               AVG( CAST ( CASE when a.atwrt = '' then '0' ELSE a.atwrt end as dec ) ) as CharacteristicValue
          from ausp as a
         inner join cabn as c
            on a.atinn = c.atinn
         inner join mch1 as m
            on a.objek = m.cuobj_bm
         where c.atnam = 'YGV_P19'
         GROUP BY m.cuobj_bm, c.atnam union
         select
      distinct session_context( 'CLIENT' ) as mandt,
               m.cuobj_bm as objek, c.atnam as Characteristic,
               AVG( CAST ( CASE when a.atwrt = '' then '0' ELSE a.atwrt end as dec ) ) as CharacteristicValue
          from ausp as a
         inner join cabn as c
            on a.atinn = c.atinn
         inner join mch1 as m
            on a.objek = m.cuobj_bm
         where c.atnam = 'YGV_P18'
         GROUP BY m.cuobj_bm, c.atnam union
         select
      distinct session_context( 'CLIENT' ) as mandt,
               m.cuobj_bm as objek, c.atnam as Characteristic,
               AVG( CAST ( CASE when a.atwrt = '' then '0' ELSE a.atwrt end as dec ) ) as CharacteristicValue
          from ausp as a
         inner join cabn as c
            on a.atinn = c.atinn
         inner join mch1 as m
            on a.objek = m.cuobj_bm
         where c.atnam = 'YGV_P17'
         GROUP BY m.cuobj_bm, c.atnam union
         select
      distinct session_context( 'CLIENT' ) as mandt,
               m.cuobj_bm as objek, c.atnam as Characteristic,
               AVG( CAST ( CASE when a.atwrt = '' then '0' ELSE a.atwrt end as dec ) ) as CharacteristicValue
          from ausp as a
         inner join cabn as c
            on a.atinn = c.atinn
         inner join mch1 as m
            on a.objek = m.cuobj_bm
         where c.atnam = 'YGV_P16'
         GROUP BY m.cuobj_bm, c.atnam union
         select
      distinct session_context( 'CLIENT' ) as mandt,
               m.cuobj_bm as objek, c.atnam as Characteristic,
               AVG( CAST ( CASE when a.atwrt = '' then '0' ELSE a.atwrt end as dec ) ) as CharacteristicValue
          from ausp as a
         inner join cabn as c
            on a.atinn = c.atinn
         inner join mch1 as m
            on a.objek = m.cuobj_bm
         where c.atnam = 'YGV_P15'
         GROUP BY m.cuobj_bm, c.atnam union
         select
      distinct session_context( 'CLIENT' ) as mandt,
               m.cuobj_bm as objek, c.atnam as Characteristic,
               AVG( CAST ( CASE when a.atwrt = '' then '0' ELSE a.atwrt end as dec ) ) as CharacteristicValue
          from ausp as a
         inner join cabn as c
            on a.atinn = c.atinn
         inner join mch1 as m
            on a.objek = m.cuobj_bm
         where c.atnam = 'YGV_P14'
         GROUP BY m.cuobj_bm, c.atnam union
         select
      distinct session_context( 'CLIENT' ) as mandt,
               m.cuobj_bm as objek, c.atnam as Characteristic,
               AVG( CAST ( CASE when a.atwrt = '' then '0' ELSE a.atwrt end as dec ) ) as CharacteristicValue
          from ausp as a
         inner join cabn as c
            on a.atinn = c.atinn
         inner join mch1 as m
            on a.objek = m.cuobj_bm
         where c.atnam = 'YGV_P13'
         GROUP BY m.cuobj_bm, c.atnam union
         select
      distinct session_context( 'CLIENT' ) as mandt,
               m.cuobj_bm as objek, c.atnam as Characteristic,
               AVG( CAST ( CASE when a.atwrt = '' then '0' ELSE a.atwrt end as dec ) ) as CharacteristicValue
          from ausp as a
         inner join cabn as c
            on a.atinn = c.atinn
         inner join mch1 as m
            on a.objek = m.cuobj_bm
         where c.atnam = 'YGV_P12'
         GROUP BY m.cuobj_bm, c.atnam union
         select
      distinct session_context( 'CLIENT' ) as mandt,
               m.cuobj_bm as objek, c.atnam as Characteristic,
               AVG( CAST ( CASE when a.atwrt = '' then '0' ELSE a.atwrt end as dec ) ) as CharacteristicValue
          from ausp as a
         inner join cabn as c
            on a.atinn = c.atinn
         inner join mch1 as m
            on a.objek = m.cuobj_bm
         where c.atnam = 'YGV_P11'
         GROUP BY m.cuobj_bm, c.atnam union
         select
      distinct session_context( 'CLIENT' ) as mandt,
               m.cuobj_bm as objek, c.atnam as Characteristic,
               AVG( CAST ( CASE when a.atwrt = '' then '0' ELSE a.atwrt end as dec ) ) as CharacteristicValue
          from ausp as a
         inner join cabn as c
            on a.atinn = c.atinn
         inner join mch1 as m
            on a.objek = m.cuobj_bm
         where c.atnam = 'YGV_P10'
         GROUP BY m.cuobj_bm, c.atnam union
         select
      distinct session_context( 'CLIENT' ) as mandt,
               m.cuobj_bm as objek, c.atnam as Characteristic,
               SUM( CAST ( CASE when a.atwrt = '' then '0' ELSE a.atwrt end as dec ) ) as CharacteristicValue
          from ausp as a
         inner join cabn as c
            on a.atinn = c.atinn
         inner join mch1 as m
            on a.objek = m.cuobj_bm
         where c.atnam = 'YGV_DEFEITO'
         GROUP BY m.cuobj_bm, c.atnam union
         select
      distinct session_context( 'CLIENT' ) as mandt,
               m.cuobj_bm as objek, c.atnam as Characteristic,
               AVG( CAST ( CASE when a.atwrt = '' then '0' ELSE a.atwrt end as dec ) ) as CharacteristicValue
          from ausp as a
         inner join cabn as c
            on a.atinn = c.atinn
         inner join mch1 as m
            on a.objek = m.cuobj_bm
         where c.atnam = 'YGV_IMPUREZAS'
         GROUP BY m.cuobj_bm, c.atnam union
         select
      distinct session_context( 'CLIENT' ) as mandt,
               m.cuobj_bm as objek, c.atnam as Characteristic,
               SUM( CAST ( CASE when a.atwrt = '' then '0' ELSE a.atwrt end as dec ) ) as CharacteristicValue
          from ausp as a
         inner join cabn as c
            on a.atinn = c.atinn
         inner join mch1 as m
            on a.objek = m.cuobj_bm
         where c.atnam = 'YGV_MK10'
         GROUP BY m.cuobj_bm, c.atnam union
         select
      distinct session_context( 'CLIENT' ) as mandt,
               m.cuobj_bm as objek, c.atnam as Characteristic,
               AVG( CAST ( CASE when a.atwrt = '' then '0' ELSE a.atwrt end as dec ) ) as CharacteristicValue
          from ausp as a
         inner join cabn as c
            on a.atinn = c.atinn
         inner join mch1 as m
            on a.objek = m.cuobj_bm
         where c.atnam = 'YGV_FUNDO'
         GROUP BY m.cuobj_bm, c.atnam union
         select
      distinct session_context( 'CLIENT' ) as mandt,
               m.cuobj_bm as objek, c.atnam as Characteristic,
               AVG( CAST ( CASE when a.atwrt = '' then '0' ELSE a.atwrt end as dec ) ) as CharacteristicValue
          from ausp as a
         inner join cabn as c
            on a.atinn = c.atinn
         inner join mch1 as m
            on a.objek = m.cuobj_bm
         where c.atnam = 'YGV_VERDE'
         GROUP BY m.cuobj_bm, c.atnam union
         select
      distinct session_context( 'CLIENT' ) as mandt,
               m.cuobj_bm as objek, c.atnam as Characteristic,
               AVG( CAST ( CASE when a.atwrt = '' then '0' ELSE a.atwrt end as dec ) ) as CharacteristicValue
          from ausp as a
         inner join cabn as c
            on a.atinn = c.atinn
         inner join mch1 as m
            on a.objek = m.cuobj_bm
         where c.atnam = 'YGV_PRETO-ARDIDO'
         GROUP BY m.cuobj_bm, c.atnam union
         select
      distinct session_context( 'CLIENT' ) as mandt,
               m.cuobj_bm as objek, c.atnam as Characteristic,
               AVG( CAST ( CASE when a.atwrt = '' then '0' ELSE a.atwrt end as dec ) ) as CharacteristicValue
          from ausp as a
         inner join cabn as c
            on a.atinn = c.atinn
         inner join mch1 as m
            on a.objek = m.cuobj_bm
         where c.atnam = 'YGV_CATACAO'
         GROUP BY m.cuobj_bm, c.atnam union
         select
      distinct session_context( 'CLIENT' ) as mandt,
               m.cuobj_bm as objek, c.atnam as Characteristic,
               AVG( CAST ( CASE when a.atwrt = '' then '0' ELSE a.atwrt end as dec ) ) as CharacteristicValue
          from ausp as a
         inner join cabn as c
            on a.atinn = c.atinn
         inner join mch1 as m
            on a.objek = m.cuobj_bm
         where c.atnam = 'YGV_UMIDADE'
         GROUP BY m.cuobj_bm, c.atnam union
         select
      distinct session_context( 'CLIENT' ) as mandt,
               m.cuobj_bm as objek, c.atnam as Characteristic,
               sum( CAST ( CASE when a.atwrt = '' then '0' ELSE a.atwrt end as dec ) ) as CharacteristicValue
          from ausp as a
         inner join cabn as c
            on a.atinn = c.atinn
         inner join mch1 as m
            on a.objek = m.cuobj_bm
         where c.atnam = 'YGV_BROCADOS'
         GROUP BY m.cuobj_bm, c.atnam;

  endmethod.

ENDCLASS.
