
CREATE TABLE IF NOT EXISTS _unit_mapping_manual (
   strunut VARCHAR(255),
   concept_id integer,
   concept_name VARCHAR(255),
   num_unit_concept_id integer,
   denom_unit_concept_id integer
);

COPY _unit_mapping_manual
FROM '/Users/Maxim/Google Drive/Bedrijf/Projects/Janssen-OHDSI AUH/Execution/Drug_Mapping_Scripts/unit_mapping/unit_mapping.csv' WITH HEADER CSV
;
