/* 9-04-2016
   Mapping to clinical form */
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

INTO map.varenr_to_drug_form

FROM auh.frequencies

LEFT JOIN auh.products
    ON auh.products.vnr = auh.frequencies.vnr

/* Hook mapping of ingredient, dose form,  to drugs */
LEFT JOIN map.varenr_to_ingredient AS v_t_i
    ON auh.products.vnr = v_t_i.vnr

LEFT JOIN auh.map_dose_form
    ON auh.products.dosf_lt = auh.map_dose_form.dosf_lt

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
     AND auh.map_dose_form.dose_concept_id = dose_form.concept_id
     AND drug.vocabulary_id = 'RxNorm'  -- 20-04-2016

ORDER BY v_t_i.vnr, drug.concept_class_id, drug.concept_name
-- LIMIT 50
;
