SELECT 'Total', count(*), sum(frequency)::integer FROM (
    SELECT avg(frequency) as frequency, vnr FROM _varenr_to_clinical_strength GROUP BY vnr
) a
;

-- Failures
select 'Ingredient not matched                 ', count(*), sum(frequency) from _varenr_to_clinical_strength
where ingredient_concept_id is null
;

SELECT 'Ingredient matched, but not to Strength', count(*), sum(frequency) from _varenr_to_clinical_strength
WHERE ingredient_concept_id IS NOT NULL AND drug_concept_id IS NULL
;
