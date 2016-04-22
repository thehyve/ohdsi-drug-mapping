-- 19-04-2016 use relative \copy
\copy (SELECT * FROM map.varenr_mapping_curated ORDER BY frequency DESC) TO 'exports/complete_varenr_RxNorm_mapping.csv' WITH HEADER csv
