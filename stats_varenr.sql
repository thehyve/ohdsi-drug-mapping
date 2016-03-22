/* Example data join on Drugid */
SELECT vnr, pname, auh_products.drugid, navn, ATCkode
FROM auh_products
LEFT JOIN auh_druglist ON auh_druglist.DRUGID = auh_products.DRUGID
ORDER BY RANDOM()
LIMIT 10;

SELECT 'Total varenr =',COUNT(*)
FROM AUH_PRODUCTS;

/* Availability of Drugid */
SELECT 'Of which missing drug ids =', COUNT(*)
FROM auh_products
WHERE drugid IS NULL;

SELECT 'ATC code NOT retrieved =', COUNT(*)
FROM auh_products
LEFT JOIN auh_druglist ON auh_druglist.DRUGID = auh_products.DRUGID
WHERE atckode IS NULL AND AUH_PRODUCTS.drugid IS NOT NULL
;

/* ATC code analysis. 8 letter codes are vetenarian */
SELECT char_length(atckode) as "Length ATC code", COUNT(*)
FROM auh_druglist
GROUP BY char_length(atckode)
ORDER BY char_length(atckode);
/* Conclusion: */
