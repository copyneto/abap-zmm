@AbapCatalog.sqlViewName: 'ZVMODFCDPOS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Busca dados de modificações'
define view ZI_MM_GET_DATA_CDPOS
  as select distinct from cdpos
    left outer join       makt                                   on  makt.matnr = cdpos.objectid
                                                                 and makt.spras = $session.system_language

    left outer join       I_ChangeDocChangeIndT                  on  I_ChangeDocChangeIndT.Value    = cdpos.chngind
                                                                 and I_ChangeDocChangeIndT.Language = $session.system_language

    left outer join       dd03l                                  on  dd03l.tabname   = cdpos.tabname
                                                                 and dd03l.fieldname = cdpos.fname
                                                                 and dd03l.as4local  = 'A'
                                                                 and dd03l.as4vers   = '0000'

    left outer join       dd04t                                  on  dd04t.rollname   = dd03l.rollname
                                                                 and dd04t.ddlanguage = $session.system_language
                                                                 and dd04t.as4local   = 'A'
                                                                 and dd04t.as4vers    = '0000'

    left outer join       ZI_MM_TAB_TEXTS     as _TabTexts           on _TabTexts.tabname = cdpos.tabname

    inner join            cdhdr                                  on  cdhdr.objectclas = cdpos.objectclas
                                                                 and cdhdr.objectid   = cdpos.objectid
                                                                 and cdhdr.changenr   = cdpos.changenr

    inner join            mara                                   on mara.matnr = cdpos.objectid

    left outer join       ZI_MM_CONV_UNID_MED as _ConvUnidMedNew on  _ConvUnidMedNew.Language      = $session.system_language
                                                                 and _ConvUnidMedNew.UnitOfMeasure = cdpos.value_new
    
    left outer join       ZI_MM_CONV_UNID_MED as _ConvUnidMedOld on  _ConvUnidMedOld.Language      = $session.system_language
                                                                 and _ConvUnidMedOld.UnitOfMeasure = cdpos.value_old


{
  key cdpos.objectid             as matnr,
  key case when cdpos.tabname = 'DMKAL' or
                cdpos.tabname = 'DQMAT'
                then cast( substring(tabkey,1,4) as char4 )

           when cdpos.tabname = 'MARC'     or
                cdpos.tabname = 'MARD'     or
                cdpos.tabname = 'MATERIAL' or
                cdpos.tabname = 'MPOP'
                then cast( substring(tabkey,44,4) as char4 )

      else ''
      end                        as werks,

  key case when cdpos.tabname = 'MARD'
           then cast( substring(tabkey,48,4) as char4 )

      else ''
      end                        as lgort,

  key case when cdpos.tabname = 'MBEW'
           then cast( substring(tabkey,44,4) as char4 )

      else ''
      end                        as bwkey,

  key case when cdpos.tabname = 'MBEW'
           then cast( substring(tabkey,48,10) as char10 )

      else ''
      end                        as bwtar,

  key case when cdpos.tabname = 'MLGN'
           then cast( substring(tabkey,44,3) as char3 )

      else ''
      end                        as lgnum,

  key case when cdpos.tabname = 'MVKE'
           then cast( substring(tabkey,44,4) as char4 )

      else ''
      end                        as vkorg,

  key case when cdpos.tabname = 'MVKE'
           then cast( substring(tabkey,48,2) as char2 )

      else ''
      end                        as vtweg,
  key chngind,
      mara.mtart,
      mara.spart,
      cdhdr.udate,
      cdhdr.utime,
      cdhdr.username,
      cdpos.fname,

      case when fname = 'KEY' then _TabTexts.ddtext
           else dd04t.ddtext
      end                        as ddtext,

      case when value_new = '1' then '1'
      else
          case when _ConvUnidMedNew.UnitOfMeasureCommercialName is not initial then _ConvUnidMedNew.UnitOfMeasureCommercialName  
          else
              case fname
              when 'KEY' then
                  case when _ConvUnidMedNew.UnitOfMeasureCommercialName is not initial then _ConvUnidMedNew.UnitOfMeasureCommercialName
                  else
                    case when chngind = 'I' then tabkey
                    else value_new
                    end
                  end
              else value_new
              end
           end
      end                        as value_new,

      case when value_old = '1' then '1'
      else
          case when _ConvUnidMedOld.UnitOfMeasureCommercialName is not initial then _ConvUnidMedOld.UnitOfMeasureCommercialName
          else
              case fname
              when 'KEY' then
                  case when _ConvUnidMedOld.UnitOfMeasureCommercialName is not initial then _ConvUnidMedOld.UnitOfMeasureCommercialName
                  else
                    case when chngind <> 'I' then tabkey
                    else value_old
                    end
                  end
              else value_old
              end
          end
      end                        as value_old,

      makt.maktx,
      I_ChangeDocChangeIndT.Text as chngindtxt
}
where
  cdpos.objectclas = 'MATERIAL'

union select distinct from mara

  inner join               inob                                on inob.objek = mara.matnr
                                                               and(
                                                                 klart       = '001'
                                                                 or klart    = '023'
                                                               )

  inner join               kssk                                on  kssk.objek = inob.cuobj
                                                               and kssk.klart = inob.klart
                                                               and kssk.mafid = 'O'

  inner join               cdpos                               on  cdpos.objectclas = 'CLASSIFY'
                                                               and cdpos.objectid   = concat(
    kssk.objek, kssk.mafid
  )

  left outer join          makt                                on  makt.matnr = cdpos.objectid
                                                               and makt.spras = $session.system_language

  left outer join          I_ChangeDocChangeIndT               on  I_ChangeDocChangeIndT.Value    = cdpos.chngind
                                                               and I_ChangeDocChangeIndT.Language = $session.system_language

  left outer join          dd03l                               on  dd03l.tabname   = cdpos.tabname
                                                               and dd03l.fieldname = cdpos.fname
                                                               and dd03l.as4local  = 'A'
                                                               and dd03l.as4vers   = '0000'

  left outer join          dd04t                               on  dd04t.rollname   = dd03l.rollname
                                                               and dd04t.ddlanguage = $session.system_language
                                                               and dd04t.as4local   = 'A'
                                                               and dd04t.as4vers    = '0000'

  left outer join          ZI_MM_TAB_TEXTS     as _TabTexts        on _TabTexts.tabname = cdpos.tabname

  inner join               cdhdr                               on  cdhdr.objectclas = cdpos.objectclas
                                                               and cdhdr.objectid   = cdpos.objectid
                                                               and cdhdr.changenr   = cdpos.changenr

    left outer join       ZI_MM_CONV_UNID_MED as _ConvUnidMedNew on  _ConvUnidMedNew.Language      = $session.system_language
                                                                 and _ConvUnidMedNew.UnitOfMeasure = cdpos.value_new
    
    left outer join       ZI_MM_CONV_UNID_MED as _ConvUnidMedOld on  _ConvUnidMedOld.Language      = $session.system_language
                                                                 and _ConvUnidMedOld.UnitOfMeasure = cdpos.value_old

{
  key mara.matnr,
  key case when cdpos.tabname = 'DMKAL' or
                cdpos.tabname = 'DQMAT'
                then cast( substring(tabkey,1,4) as char4 )

           when cdpos.tabname = 'MARC'     or
                cdpos.tabname = 'MARD'     or
                cdpos.tabname = 'MATERIAL' or
                cdpos.tabname = 'MPOP'
                then cast( substring(tabkey,44,4) as char4 )

      else ''
      end                        as werks,

  key case when cdpos.tabname = 'MARD'
           then cast( substring(tabkey,48,4) as char4 )

      else ''
      end                        as lgort,

  key case when cdpos.tabname = 'MBEW'
           then cast( substring(tabkey,44,4) as char4 )

      else ''
      end                        as bwkey,

  key case when cdpos.tabname = 'MBEW'
           then cast( substring(tabkey,48,10) as char10 )

      else ''
      end                        as bwtar,

  key case when cdpos.tabname = 'MLGN'
           then cast( substring(tabkey,44,3) as char3 )

      else ''
      end                        as lgnum,

  key case when cdpos.tabname = 'MVKE'
           then cast( substring(tabkey,44,4) as char4 )

      else ''
      end                        as vkorg,

  key case when cdpos.tabname = 'MVKE'
           then cast( substring(tabkey,48,2) as char2 )

      else ''
      end                        as vtweg,
  key chngind,
      mara.mtart,
      mara.spart,
      cdhdr.udate,
      cdhdr.utime,
      cdhdr.username,
      cdpos.fname,

      case when fname = 'KEY' then _TabTexts.ddtext
           else dd04t.ddtext
      end                        as ddtext,

      case when value_new = '1' then '1'
      else
          case when _ConvUnidMedNew.UnitOfMeasureCommercialName is not initial then _ConvUnidMedNew.UnitOfMeasureCommercialName
          else
              case fname
              when 'KEY' then
                  case when _ConvUnidMedNew.UnitOfMeasureCommercialName is not initial then _ConvUnidMedNew.UnitOfMeasureCommercialName
                  else
                    case when chngind = 'I' then tabkey
                    else value_new
                    end
                  end
              else value_new
              end
          end
      end                        as value_new,

      case when value_old = '1' then '1'
      else
          case when _ConvUnidMedOld.UnitOfMeasureCommercialName is not initial then _ConvUnidMedOld.UnitOfMeasureCommercialName
          else
              case fname
              when 'KEY' then
                  case when _ConvUnidMedOld.UnitOfMeasureCommercialName is not initial then _ConvUnidMedOld.UnitOfMeasureCommercialName
                  else
                    case when chngind <> 'I' then tabkey
                    else value_old
                    end
                  end
              else value_old
              end
          end
      end                        as value_old,

      makt.maktx,
      I_ChangeDocChangeIndT.Text as chngindtxt
}
where
  cdpos.objectclas = 'CLASSIFY'
