/* Example data join on Drugid */
SELECT vnr, pname, z_auh_products_v1.drugid, navn, ATCkode
FROM z_auh_products_v1
LEFT JOIN z_auh_druglist ON z_auh_druglist.DRUGID = z_auh_products_v1.DRUGID
ORDER BY RANDOM()
LIMIT 10;

SELECT 'Total varenr =',COUNT(*)
FROM z_auh_products_v1;

/* Availability of Drugid */
SELECT 'Of which missing drug ids =', COUNT(*)
FROM z_auh_products_v1
WHERE drugid IS NULL;

SELECT 'ATC code NOT retrieved =', COUNT(*)
FROM z_auh_products_v1
LEFT JOIN z_auh_druglist ON z_auh_druglist.DRUGID = z_auh_products_v1.DRUGID
WHERE atckode IS NULL AND z_auh_products_v1.drugid IS NOT NULL
;

/* ATC code analysis. 8 letter codes are vetenarian */
SELECT char_length(atckode) as "Length ATC code", COUNT(*)
FROM z_auh_druglist
GROUP BY char_length(atckode)
ORDER BY char_length(atckode);
/* Conclusion: see mail to Marinel 21-03-2015*/
