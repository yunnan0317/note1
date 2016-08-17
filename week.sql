select * from crosstab(
  'SELECT extract(week from starts) as week, extract(dow from starts) as dow, count(*) FROM events GROUP BY week, dow',
  'select m from generate_series(1,7) m'
) as (
 week int,
 sun int, mon int, tue int, wen int, thu int, fir int, sat int
);


select max(case dw when 2 then dm end) as mon,
       max(case dw when 3 then dm end) as tue,
       max(case dw when 4 then dm end) as wes,
       max(case dw when 5 then dm end) as thu,
       max(case dw when 6 then dm end) as fri,
       max(case dw when 7 then dm end) as sat,
       max(case dw when 1 then dm end) as sun
from (
     select *
     from (

          select cast (date_trunc('month', current_date) as date) + x.id,
                 to_char(cast(date_trunc('month', current_date)
                          as date)+x.id, 'iw') as wk,
                 to_char(cast(date_trunc('month', current_date)
                          as date)+x.id, 'dd') as dm,
                 cast( to_char(cast(date_trunc('month', current_date)
                                as date)+x.id, 'd') as integer) as dw,
                 to_char(cast(date_trunc('month', current_date)
                                as date)+x.id, 'mm') as curr_mth,
                 to_char(current_date, 'mm') as mth
          from generate_series(0, 31) x(id)
          ) x
     where mth =curr_mth
     ) y
group by wk
order by wk
;
