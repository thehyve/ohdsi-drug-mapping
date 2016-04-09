SELECT concept_class_id,
    COUNT(DISTINCT vnr)*100/4754,
    SUM(frequency)*100/1100146 -- Met dubbele tellingen voor drug component en drug form.
FROM _varenr_mapping
GROUP BY concept_class_id
-- ORDER BY concept_class_id÷
;
