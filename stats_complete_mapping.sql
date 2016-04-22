SELECT concept_class_id,
    ROUND( COUNT(DISTINCT vnr)*100/4754::decimal, 1) AS "Percentage based on Count",
    ROUND( SUM(frequency)*100/1093056::decimal, 1) AS "Percentage based on Frequency"
    -- Frequency is met dubbele tellingen voor drug component en drug form.
FROM map.varenr_mapping_curated
GROUP BY concept_class_id
-- ORDER BY concept_class_id
;
