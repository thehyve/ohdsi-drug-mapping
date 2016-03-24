COPY auh_doses
-- (
--     SELECT dosf_lt, COUNT(*)
--     FROM auh_products
--     GROUP BY dosf_lt
--     ORDER BY COUNT(*) DESC
-- )
TO '/Users/Maxim/Documents/Drug_mapping_OHDSI/dose_form_mapping/auh_dose_forms.csv' WITH HEADER CSV
;

COPY (
    SELECT concept_id, concept_name, vocabulary_id
    FROM concept
    WHERE concept_class_id = 'Dose Form' AND (invalid_reason IS NULL)
    ORDER BY concept_name
)
TO '/Users/Maxim/Documents/Drug_mapping_OHDSI/dose_form_mapping/omop_dose_forms.csv' WITH HEADER CSV
;

COPY (
SELECT  dosf_lt,
        dosf_lt_corrected,
        dosf_lt_en,
        frequency,
        concept_id,
        concept_name,
        lev_score
FROM
(
    SELECT  *,
            levenshtein(auh_doses.dosf_lt_en, omop_doses.concept_name) AS lev_score,
            ROW_NUMBER() OVER (PARTITION BY auh_doses.dosf_lt
                ORDER BY levenshtein(auh_doses.dosf_lt_en, omop_doses.concept_name)) AS Row_ID
    FROM auh_doses
    CROSS JOIN ( -- All against all
        SELECT concept_id, lower(concept_name) as concept_name, vocabulary_id
        FROM concept
        WHERE concept_class_id = 'Dose Form' AND (invalid_reason IS NULL)
              AND vocabulary_id = 'RxNorm'
    ) omop_doses
) AS temp
WHERE Row_ID < 10
ORDER BY frequency DESC,
        dosf_lt,
        lev_score,
        concept_name
)
TO '/Users/Maxim/Documents/Drug_mapping_OHDSI/dose_form_mapping/auh_dose_forms_with_suggestions.csv' WITH HEADER CSV
;
