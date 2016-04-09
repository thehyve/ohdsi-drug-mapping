/* 05-04-2016
   Mapping to clinical form */
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

INTO _varenr_to_drug_form

FROM auh_frequencies

LEFT JOIN auh_products
    ON auh_products.vnr = auh_frequencies.vnr

/* Hook mapping of ingredient, dose form,  to drugs */
LEFT JOIN _varenr_to_ingredient AS v_t_i
    ON auh_products.vnr = v_t_i.vnr

LEFT JOIN _dose_form_mapping_manual
    ON auh_products.dosf_lt = _dose_form_mapping_manual.dosf_lt

/* Search all drugs which have this ingredient */
LEFT JOIN concept_relationship AS relation_ing
    ON relation_ing.concept_id_1 = v_t_i.ingredient_concept_id
    AND relation_ing.relationship_id = 'RxNorm ing of' -- Only dose form relations

LEFT JOIN concept drug
    ON drug.concept_id = relation_ing.concept_id_2

/* Add dose form concept_id to drug_concept_id*/
LEFT JOIN concept_relationship AS relation_form
    ON drug.concept_id = relation_form.concept_id_1
    AND relation_form.relationship_id = 'RxNorm has dose form' -- Only dose form relations

LEFT JOIN concept dose_form
    ON relation_form.concept_id_2 = dose_form.concept_id

WHERE (drug.concept_class_id LIKE 'Clinical Drug Form') -- Filter out o.a. branded
     -- Select correct dose form.
     AND _dose_form_mapping_manual.dose_concept_id = dose_form.concept_id

ORDER BY v_t_i.vnr, drug.concept_class_id, drug.concept_name
-- LIMIT 50
;
