SELECT
    auh_frequencies.vnr,
    pname as "Danish name",
    substring( aktivesubstanser from 0 for 40 ) as "Active Substance",
    frequency,
    auh_products.drugid,
    ATCkode as ATCcode,
    ingredient_concept_code as RxNorm_id,
    ingredient_concept_id,
    a_t_i_d.ingredient_concept_name
-- INTO _varenr_to_concept_id
FROM auh_frequencies
LEFT JOIN auh_products ON auh_frequencies.vnr = auh_products.vnr
LEFT JOIN auh_druglist ON auh_products.DRUGID = auh_druglist.DRUGID
LEFT JOIN _atc_to_ingredient_direct_2 a_t_i_d ON ATCkode = a_t_i_d.atc_concept_code
-- WHERE ATCkode = 'C09DA06'
-- LIMIT 20
;

SELECT 'Not mapped to concept_id =', COUNT(*), SUM(frequency) as frequency
FROM auh_frequencies
LEFT JOIN auh_products ON auh_frequencies.vnr = auh_products.vnr
LEFT JOIN auh_druglist ON auh_druglist.DRUGID = auh_products.DRUGID
LEFT JOIN _atc_to_ingredient_direct_2 a_t_i_d ON ATCkode = a_t_i_d.atc_concept_code
WHERE ingredient_concept_id IS NULL
;

SELECT 'Mapped to concept_id =', COUNT(*), SUM(frequency) as frequency
FROM auh_frequencies
LEFT JOIN auh_products ON auh_frequencies.vnr = auh_products.vnr
LEFT JOIN auh_druglist ON auh_druglist.DRUGID = auh_products.DRUGID
LEFT JOIN _atc_to_ingredient_direct_2 a_t_i_d ON ATCkode = a_t_i_d.atc_concept_code
WHERE ingredient_concept_id IS NOT NULL
;
