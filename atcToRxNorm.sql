/* Maps from ATC to RxNorm ingredient */
/* 22-03-2016: map everything that directly maps
   from ATC to RxNorm ingredient.
	 This increases the mapping from 2840 to 3390.*/

SELECT
  COUNT(DISTINCT atc.concept_id)
	-- COUNT( DISTINCT to_char(atc.concept_id,'999999999') || to_char(ingredient.concept_id, '999999999') )
	-- atc.concept_code AS atc_concept_code,
	-- atc.concept_name AS atc_concept_name,
	-- atc.concept_id AS atc_concept_id,
	-- ingredient.concept_code AS ingredient_concept_code,
	-- ingredient.concept_name AS ingredient_concept_name,
	-- ingredient.concept_id  AS ingredient_concept_id,
	-- ingredient.standard_concept,
	-- relation.relationship_ids,
	-- relation.n_relationships
-- INTO _atc_to_ingredient_direct_2
FROM (
	/* Select all unique relations */
	SELECT 	concept_id_1,
			concept_id_2,
			string_agg(relationship_id,',') as relationship_ids,
			count(*) as n_relationships
	FROM concept_relationship AS relation
	WHERE
		/* Deselect invalidated relations */
		(relation.invalid_reason IS NULL
		OR relation.invalid_reason = '')
	GROUP BY relation.concept_id_1, relation.concept_id_2
  ) relation
INNER JOIN concept AS atc
	ON atc.concept_id = relation.concept_id_1
INNER JOIN concept AS ingredient
	ON ingredient.concept_id = relation.concept_id_2
WHERE atc.vocabulary_id = 'ATC'
	AND ingredient.vocabulary_id = 'RxNorm'
	AND ingredient.concept_class_id = 'Ingredient' -- The relationship_id 'ATC - RxNorm' also shows some clinical/branded drugs
	/* Only Standard Concepts that may be used as concept_id field. */
	--  AND ingredient.standard_concept = 'S'
;
