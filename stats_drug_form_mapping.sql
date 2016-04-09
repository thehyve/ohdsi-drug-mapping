/* List of all drug form concepts */
-- SELECT concept_id, concept_name, vocabulary_id, count(*)
-- FROM concept
-- LEFT JOIN concept_relationship
--     ON concept_relationship.concept_id_1 = concept_id
-- WHERE concept_class_id = 'Dose Form' AND (concept.invalid_reason IS NULL) AND vocabulary_id = 'RxNorm'
-- GROUP BY concept_id
-- ORDER BY count(*) desc, concept_name
-- limit 10
-- ;
--
-- SELECT dosf_lt, COUNT(*)
-- FROM auh_products
-- GROUP BY dosf_lt
-- ORDER BY COUNT(*) DESC
-- limit 10
-- ;

-- COPY (
SELECT *
FROM (
    SELECT auh.dosf_lt,
            CASE WHEN auh.count IS NULL THEN 0 ELSE auh.count END
                AS auhcount,
            omop.concept_name,
            CASE WHEN omop.count IS NULL OR omop.count = 1 THEN 0 ELSE omop.count END
                AS omopcount
    FROM _dose_form_mapping_manual d_f_m
    RIGHT JOIN (
        SELECT dosf_lt, COUNT(*)
        FROM auh_products
        GROUP BY dosf_lt
    ) auh
        ON  auh.dosf_lt = d_f_m.dosf_lt
    FULL OUTER JOIN (
        SELECT concept_id, concept_name, COUNT(*)
        FROM concept
        LEFT JOIN concept_relationship
            ON concept_relationship.concept_id_1 = concept_id
        WHERE concept_class_id = 'Dose Form' AND (concept.invalid_reason IS NULL) AND vocabulary_id = 'RxNorm'
        GROUP BY concept_id
    ) omop
        ON  omop.concept_id = d_f_m.dose_concept_id
) temp
ORDER BY omopcount DESC, auhcount DESC
-- ) TO '/Users/Maxim/Google Drive/Bedrijf/Projects/Janssen-OHDSI AUH/Execution/Drug_Mapping_Scripts/exports/stats_dose_form_mapping.csv'
-- WITH HEADER CSV
;
