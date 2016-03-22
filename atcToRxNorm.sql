/* Maps from ATC to RxNorm ingredient */

SELECT
	-- COUNT( * )
	atc.concept_code AS source_code,
	atc.concept_name AS source_name,
	atc.concept_id AS source_concept_id,
	ingredient.concept_code AS target_code,
	ingredient.concept_name AS target_name,
	ingredient.concept_id AS target_concept_id,
	ingredient.domain_id,
	ingredient.vocabulary_id
-- INTO _atc_to_ingredient_direct
FROM concept_relationship AS relation
INNER JOIN concept AS atc
	ON atc.concept_id = relation.concept_id_1
INNER JOIN concept AS ingredient
	ON ingredient.concept_id = relation.concept_id_2

WHERE atc.vocabulary_id = 'ATC'
  /* Only Standard Concepts that may be used as concept_id field. */
	AND ingredient.standard_concept = 'S'
	AND ingredient.concept_class_id = 'Ingredient' -- The relationship_id ATC - RxNorm also shows some clinical/branded drugs
	AND relation.relationship_id = 'ATC - RxNorm' -- 'Maps to' works as well (only ingredients)

	/* Not invalidated relations */
	AND (relation.invalid_reason IS NULL
		   OR relation.invalid_reason = '')
;

/*
Export database.
COPY (
	SELECT source_code, source_name, target_concept_id, target_code as RxNorm_id, target_name
	FROM _atc_to_ingredient_direct
)
TO '/Users/Maxim/Documents/Drug_mapping_OHDSI/export_atc_to_ingredient_direct.csv' WITH CSV HEADER;
*/
