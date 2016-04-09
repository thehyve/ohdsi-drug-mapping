/*
Export vare naar clinical drug 07-04-2016
*/
COPY (
	SELECT vnr, drug_concept_id, pname, frequency, strnum, strunut, dosf_lt, concept_name
	FROM _varenr_to_clinical_drug
    -- WHERE relationship_ids = 'Inferred class of'
    ORDER BY frequency DESC, pname
)
TO '/Users/Maxim/Google Drive/Bedrijf/Projects/Janssen-OHDSI AUH/Execution/Drug_Mapping_Scripts/exports/varenr_to_clinical_drug.csv'
WITH CSV HEADER;
