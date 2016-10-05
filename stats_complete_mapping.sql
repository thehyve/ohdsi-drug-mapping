SELECT concept_class_id,
    COUNT(DISTINCT vnr),
    ROUND( COUNT(DISTINCT vnr)*100/4754::decimal, 1) AS "Percentage based on Count",
    SUM(frequency),
    ROUND( SUM(frequency)*100/1093056::decimal, 1) AS "Percentage based on Frequency"
    -- Frequency is met dubbele tellingen voor drug component en drug form.
FROM map.varenr_mapping_curated
GROUP BY concept_class_id
-- ORDER BY concept_class_id
;

-- Manual mapping
SELECT concept_class,
    COUNT(DISTINCT map_manual_drug.vnr),
    SUM(frequency)
FROM auh.map_manual_drug
JOIN auh.frequencies on frequencies.vnr = map_manual_drug.vnr
GROUP BY concept_class
;
