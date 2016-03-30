/* Input: Varenr
   Output: All clinical and branded drugs associated with it
*/
SELECT products.vnr,
    pname,
    dosf_lt,
    streng,
    ingredient_concept_name,

    drug.concept_id,
    drug.concept_name,
    drug.concept_class_id,
    amount_value,
    amount_unit_concept_id

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
LEFT JOIN _drug_strength_single_ingredient as drug_strength
    ON drug_strength.ingredient_concept_id = v_t_i.ingredient_concept_id
    AND drug_strength.amount_value = products.streng_value
LEFT JOIN concept drug
    ON drug.concept_id = drug_strength.drug_concept_id

WHERE drug.concept_class_id LIKE 'Clinical%'

    AND products.vnr = 474718
;
