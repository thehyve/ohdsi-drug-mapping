/* Load manual mappings */

-- Dose form
CREATE TABLE IF NOT EXISTS auh_map_dose_form (
   dosf_lt VARCHAR(255),
   frequency integer,
   dosf_lt_en VARCHAR(255),
   dose_concept_id integer,
   rxnorm_term VARCHAR(255),
   other_options VARCHAR(255),
   remarks VARCHAR(255)
);

-- Units
CREATE TABLE IF NOT EXISTS auh_map_unit (
   strunut VARCHAR(255),
   concept_id integer,
   concept_name VARCHAR(255),
   num_unit_concept_id integer,
   denom_unit_concept_id integer
);


\COPY auh_map_dose_form
FROM '/manual_mappings/Mapping_dose_form_v0.2_enccopy_2.csv' WITH HEADER CSV;

\COPY auh_map_unit
FROM '/manual_mappings/unit_mapping.csv' WITH HEADER CSV;
