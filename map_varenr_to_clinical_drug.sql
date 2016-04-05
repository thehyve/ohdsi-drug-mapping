/* 05-04-2016
   Mapping to clinical drug. Excluding anything that is not mapped.*/
SELECT
    -- count(*)
    v_t_i.vnr,
    v_t_i.ingredient_concept_id AS ingredient,
    drug.concept_id AS drug_concept_id,
    drug.concept_class_id,

    pname,
    auh_frequencies.frequency,
    auh_products.strnum,
    auh_products.strunut,
    auh_products.dosf_lt,

    drug.concept_name

INTO _varenr_to_clinical_drug

FROM auh_frequencies

LEFT JOIN auh_products
    ON auh_products.vnr = auh_frequencies.vnr

/* Hook mapping of ingredient, dose form,  to drugs */
LEFT JOIN _varenr_to_ingredient AS v_t_i
    ON auh_products.vnr = v_t_i.vnr

LEFT JOIN _dose_form_mapping_manual
    ON auh_products.dosf_lt = _dose_form_mapping_manual.dosf_lt

LEFT JOIN _unit_mapping_manual
    ON auh_products.strunut = _unit_mapping_manual.strunut

LEFT JOIN _drug_strength_single_ingredient AS drug_strength
    ON drug_strength.ingredient_concept_id = v_t_i.ingredient_concept_id

    AND (
        ( round(drug_strength.amount_value,2) =
          round(auh_products.strnum,2)
            AND drug_strength.amount_unit_concept_id = _unit_mapping_manual.num_unit_concept_id
        )
        OR
        ( round(drug_strength.numerator_value,2) =
          round(auh_products.strnum,2)
            AND drug_strength.numerator_unit_concept_id  = _unit_mapping_manual.num_unit_concept_id
            AND drug_strength.denominator_unit_concept_id = _unit_mapping_manual.denom_unit_concept_id
        )
    )

/* Add dose form concept_id to drug_concept_id*/
LEFT JOIN concept_relationship AS relation
    ON drug_strength.drug_concept_id = relation.concept_id_1
    -- AND relation.concept_id_1 IS NOT Null
    AND relation.relationship_id = 'RxNorm has dose form' -- Only dose form relations

LEFT JOIN concept dose_form
    ON relation.concept_id_2 = dose_form.concept_id

/* From drug_id to drug name */
LEFT JOIN concept drug
    ON drug.concept_id = drug_strength.drug_concept_id


WHERE (drug.concept_class_id LIKE 'Clinical%' OR drug.concept_class_id IS Null) -- Filter out o.a. branded
     -- Select correct dose form.
     AND _dose_form_mapping_manual.dose_concept_id = dose_form.concept_id

ORDER BY v_t_i.vnr, drug.concept_class_id, drug.concept_name
-- LIMIT 50
;
