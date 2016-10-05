/* 20-04-2016 */
-- Note: if one to many mapping overridden in manual mapping, then this one to many stays in map.varenr_mapping.
SELECT  automap.vnr,
        -- If manual override, use this for concept_id, class and concept_name
        CASE WHEN manualmap.concept_id IS NOT NULL
        THEN manualmap.concept_id
        ELSE automap.drug_concept_id
        END AS drug_concept_id,

        CASE WHEN manualmap.concept_id IS NOT NULL
        THEN manualmap.concept_class
        ELSE automap.concept_class_id
        END AS concept_class_id,

        automap.pname,
        automap.frequency,
        automap.strnum,
        automap.strunut,
        automap.dosf_lt,

        CASE WHEN manualmap.concept_id IS NOT NULL
        THEN manualmap.concept_name
        ELSE automap.concept_name
        END AS concept_name,

        -- Make a note of manually mapped or not and the atc code if not mapped at all.
        CASE
        WHEN manualmap.concept_id IS NOT NULL
        THEN 'Manual mapping'
        WHEN  automap.drug_concept_id IS NULL
        THEN auh.products.atc
        ELSE ''
        END AS note
INTO map.varenr_mapping_curated

FROM map.varenr_mapping AS automap

LEFT JOIN auh.map_manual_drug AS manualmap
    ON manualmap.vnr = automap.vnr

JOIN auh.products
    ON automap.vnr = auh.products.vnr

-- WHERE manualmap.concept_id IS NOT NULL
ORDER BY frequency desc
;
