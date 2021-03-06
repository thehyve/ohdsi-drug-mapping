/* 9-04-2016
   Map to component, using only ingredient and strength.*/
SELECT
    -- count(*)
    v_t_i.vnr,
    -- v_t_i.ingredient_concept_id AS ingredient,
    drug.concept_id AS drug_concept_id,
    drug.concept_class_id,

    auh.products.pname,
    auh.frequencies.frequency,
    auh.products.strnum,
    auh.products.strunut,
    auh.products.dosf_lt,

    drug.concept_name

INTO map.varenr_to_component

FROM auh.frequencies

LEFT JOIN auh.products
    ON auh.products.vnr = auh.frequencies.vnr

/* Hook mapping of ingredient, dose form,  to drugs */
LEFT JOIN map.varenr_to_ingredient AS v_t_i
    ON auh.products.vnr = v_t_i.vnr

LEFT JOIN auh.map_unit
    ON auh.products.strunut = auh.map_unit.strunut

LEFT JOIN map.drug_strength_single_ingredient AS drug_strength
    ON drug_strength.ingredient_concept_id = v_t_i.ingredient_concept_id

    AND (
        ( round(drug_strength.amount_value,2) =
          round(auh.products.strnum,2)
            AND drug_strength.amount_unit_concept_id = auh.map_unit.num_unit_concept_id
        )
        OR
        ( round(drug_strength.numerator_value,2) =
          round(auh.products.strnum,2)
            AND drug_strength.numerator_unit_concept_id  = auh.map_unit.num_unit_concept_id
            AND drug_strength.denominator_unit_concept_id = auh.map_unit.denom_unit_concept_id
        )
    )

/* From drug_id to drug name */
LEFT JOIN concept drug
    ON drug.concept_id = drug_strength.drug_concept_id


WHERE (drug.concept_class_id LIKE 'Clinical Drug Comp'
       AND drug.vocabulary_id = 'RxNorm' ) -- 20-04-2016: vocabulary DPD also has Clinical drug comp.

ORDER BY v_t_i.vnr, drug.concept_class_id, drug.concept_name
-- LIMIT 50
;
