SELECT concept_class_id,
    COUNT(DISTINCT vnr)*100/4754 AS "Percentage based on Count",
    SUM(frequency)*100/1100146 AS "Percentage based on Frequency"
    -- Frequency is met dubbele tellingen voor drug component en drug form.
FROM map.varenr_mapping
GROUP BY concept_class_id
-- ORDER BY concept_class_id÷
;
