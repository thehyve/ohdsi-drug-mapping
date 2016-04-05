/* Input: Varenr
   Output: All clinical drugs associated with it, based on In and Streng
*/
-- DROP TABLE IF EXISTS _varenr_to_clinical_strength;

SELECT v_t_i.vnr,
    v_t_i.ingredient_concept_id,
    drug.concept_id AS drug_concept_id,
    drug.concept_class_id,
    '|' AS ma,

    pname,
    frequency,
    streng,
    strengToDecimal(streng),
    dosf_lt,

    '|' AS ao,

    drug.concept_name,
    ingredient_concept_name,
    amount_value,
    numerator_value,
    denominator_value,
    -- amount_unit_concept_id,

    dose_form.concept_id AS dose_concept_id
    -- dose_form.concept_name AS dose_form
-- INTO _varenr_to_clinical_strength

FROM _varenr_to_ingredient AS v_t_i

LEFT JOIN
    (
        /* Parse float from streng input
           Don't trust the strnum input (comma and dot problems).        */
        SELECT *,
               strengToDecimal(streng) AS streng_value
        FROM AUH_PRODUCTS
    ) products
    ON products.vnr = v_t_i.vnr
LEFT JOIN _drug_strength_single_ingredient AS drug_strength
    ON drug_strength.ingredient_concept_id = v_t_i.ingredient_concept_id
    AND (drug_strength.amount_value = products.streng_value
        OR drug_strength.numerator_value = products.streng_value)
LEFT JOIN concept drug
    ON drug.concept_id = drug_strength.drug_concept_id
LEFT JOIN concept_relationship AS relation
    ON drug.concept_id = relation.concept_id_1
    AND relation.concept_id_1 IS NOT Null
    AND relation.relationship_id = 'RxNorm has dose form' -- Only dose form relations
LEFT JOIN concept dose_form
    ON relation.concept_id_2 = dose_form.concept_id

WHERE (drug.concept_class_id LIKE 'Clinical%' OR drug.concept_class_id IS Null) -- Filter out o.a. branded
-- There are a few with clinical

    -- AND products.vnr = 192617

ORDER BY v_t_i.vnr, drug.concept_class_id, drug.concept_name
LIMIT 25;
;

/*
COPY _varenr_to_clinical_strength
TO '/Users/Maxim/Google Drive/Bedrijf/Projects/Janssen-OHDSI AUH/Execution/Drug_Mapping_Scripts/exports/varenr_to_clinical_strength.csv' WITH HEADER CSV;
*/
