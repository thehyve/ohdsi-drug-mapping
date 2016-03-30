/* Which ATC do map to clinical drug, not to ingredient?
TODO, this is a mess.
*/

SELECT
    concept_1.*,
    string_agg(concept_2.concept_class_id,','),
    COUNT(*)
    -- relationship.relationship_id,
    -- COUNT (concept_1.concept_id)

	-- substring(concept_1.concept_name from 0 for 15),
	-- concept_1.concept_class_id,
	-- concept_1.vocabulary_id,
	-- concept_1.concept_id,
	-- relationship.relationship_id,
	-- substring(concept_2.concept_name from 0 for 15),
	-- -- concept_2.concept_name,
	-- concept_2.concept_class_id,
	-- concept_2.vocabulary_id,
	-- concept_2.concept_id,
	-- relationship.invalid_reason

	-- concept_1.concept_class_id,
	-- concept_2.concept_class_id,
	-- count( DISTINCT concept_1.concept_id )

FROM (

)
FROM concept_relationship AS relationship
INNER JOIN concept AS concept_1
	ON concept_1.concept_id = relationship.concept_id_1
INNER JOIN concept AS concept_2
	ON concept_2.concept_id = relationship.concept_id_2

WHERE
		True
	AND	concept_1.concept_class_id = 'ATC 5th'
    AND concept_2.vocabulary_id = 'RxNorm'
    AND concept_2.concept_class_id != 'Ingredient'
    AND relationship.relationship_id = 'ATC - RxNorm'
	-- AND concept_1.concept_class_id = 'Clinical Drug'
	-- concept_1.concept_code = 'C09CA01'

GROUP BY
    concept_1.concept_id,
    concept_2.concept_class_id,
    -- relationship.relationship_id

HAVING COUNT(DISTINCT concept_2.concept_class_id) = 1

ORDER BY
	string_agg(concept_2.concept_class_id,',')
;
