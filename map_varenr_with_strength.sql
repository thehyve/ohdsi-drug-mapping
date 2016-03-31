/* Input: Varenr
   Output: All clinical drugs associated with it, based on In and Streng
*/
SELECT --products.vnr,
    pname,
    ingredient_concept_name,
    streng,
    dosf_lt,

    --drug.concept_id AS drug_concept_id,
    drug.concept_name,
    drug.concept_class_id,
    -- amount_value,
    -- amount_unit_concept_id,

    dose_form.concept_id AS dose_concept_id,
    dose_form.concept_name AS dose_form

FROM
    (
        /* Parse float from streng input
           Don't trust the strnum input (comma and dot problems).
        */
        SELECT *,
            /* Regex pattern matching */
            CASE WHEN streng ~ '\d:\d'
            THEN
                /* Ratio. Assume 1:***. Keep last part. */
                CAST(
                    substring(streng, '1:(\d+)') -- Null if no match
                    AS decimal
                )
            ELSE
                /* Concentration.
                1) Get a float (either dot or comma as decimal sep.)
                2) Replace a comma by a dot.
                3) Cast to a decimal */
                CAST(
                    replace(
                        substring(streng, '\d+[,.]?\d*'),
                        ',', '.'
                    )
                    AS decimal
                )
            END AS streng_value
        FROM AUH_PRODUCTS
    ) products
LEFT JOIN _varenr_to_ingredient AS v_t_i
    ON products.vnr = v_t_i.vnr
LEFT JOIN _drug_strength_single_ingredient AS drug_strength
    ON drug_strength.ingredient_concept_id = v_t_i.ingredient_concept_id
    AND drug_strength.amount_value = products.streng_value
LEFT JOIN concept drug
    ON drug.concept_id = drug_strength.drug_concept_id
LEFT JOIN concept_relationship AS relation
    ON drug.concept_id = relation.concept_id_1
    AND relation.relationship_id = 'RxNorm has dose form' -- Only dose form relations
LEFT JOIN concept dose_form
    ON relation.concept_id_2 = dose_form.concept_id

WHERE drug.concept_class_id LIKE 'Clinical%'

    AND products.vnr = 192617

ORDER BY drug.concept_class_id, drug.concept_name
;
