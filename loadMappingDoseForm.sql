-- Load data into new schema
CREATE TABLE IF NOT EXISTS _dose_form_mapping_manual (
   dosf_lt VARCHAR(255),
   frequency integer,
   dosf_lt_corrected VARCHAR(255),
   dosf_lt_en VARCHAR(255),
   dose_concept_id integer,
   RXNorm_term VARCHAR(255),
   NDFRT_ID integer,
   NDFRT_term VARCHAR(255),
   Other_options VARCHAR(255)
);

COPY _dose_form_mapping_manual
FROM '/Users/Maxim/Google Drive/Bedrijf/Projects/Janssen-OHDSI AUH/Execution/Drug_Mapping_Scripts/data_files/Mapping_dose_form_v0.2.csv' WITH HEADER CSV
;