
SELECT drug_strength.*
INTO map.drug_strength_single_ingredient
FROM (
    SELECT drug_concept_id
    FROM drug_strength
    GROUP BY drug_concept_id
    HAVING COUNT(*) = 1
) temp
LEFT JOIN drug_strength
    ON drug_strength.drug_concept_id = temp.drug_concept_id
;
