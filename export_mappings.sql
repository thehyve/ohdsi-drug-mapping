/*
Export ATC to RxNorm mapping
*/
COPY (
	SELECT *
	FROM _atc_to_ingredient_direct_2
    -- WHERE relationship_ids = 'Inferred class of'
    ORDER BY atc_concept_name
)
TO '/Users/Maxim/Documents/Drug_mapping_OHDSI/exports/atc_to_ingredient_concept_id.csv' WITH CSV HEADER;

/*
Export Varenr to RxNorm mapping
*/
COPY (
    SELECT *
    FROM _varenr_to_concept_id_2
    ORDER BY "Danish name"
)
TO '/Users/Maxim/Documents/Drug_mapping_OHDSI/exports/varenr_to_ingredient_concept_id.csv' WITH CSV HEADER;
