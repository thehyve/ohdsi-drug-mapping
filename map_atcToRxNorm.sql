/* Maps from ATC to RxNorm ingredient */
/* 29-03-2016: maps everything via ATC - RxNorm.
This increases the mapping from 3390 to 2978.
Five ATC codes map to two RxNorm ingredients.*/

SELECT
-- atc.concept_id,
-- string_agg(to_char(ingredient.concept_id,'9999999999'),','),
-- string_agg(ingredient.standard_concept,','),
--   COUNT( atc.concept_id)
-- 	COUNT( DISTINCT to_char(atc.concept_id,'999999999') || to_char(ingredient.concept_id, '999999999') )
	atc.concept_code AS atc_concept_code,
	atc.concept_name AS atc_concept_name,
	atc.concept_id AS atc_concept_id,
	ingredient.concept_code AS ingredient_concept_code,
	ingredient.concept_name AS ingredient_concept_name,
	ingredient.concept_id  AS ingredient_concept_id,
	ingredient.standard_concept,
	relation.relationship_id
INTO map.atc_to_ingredient
FROM concept_relationship AS relation

INNER JOIN concept AS atc
	ON atc.concept_id = relation.concept_id_1
INNER JOIN concept AS ingredient
	ON ingredient.concept_id = relation.concept_id_2
WHERE atc.vocabulary_id = 'ATC'
	AND ingredient.vocabulary_id = 'RxNorm'
	AND ingredient.concept_class_id = 'Ingredient'
	AND relation.relationship_id = 'ATC - RxNorm'
-- GROUP BY atc.concept_id
-- ORDER BY count(*) desc
-- LIMIT 20
;
