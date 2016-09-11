select * from crosstab(
  'SELECT extract(week from ) as week, extract(dow from time1) as dow, count(*) FROM timetest GROUP BY week, dow',
  'select m from generate_series(1,7) m'
) as (
 week int,
 sun int, mon int, tue int, wen int, thu int, fir int, sat int
);
